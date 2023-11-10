import re
import socket
import smtplib
import paramiko
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from st2common.runners.base_action import Action
import ast
import subprocess

class newrelicReformatPayload(Action):
    # Email configuration
    smtp_server = "msgsmtp.testcorp.com"
    smtp_port = 25
    from_email = 'autoremediation@testcorp.com'
    #to_email = "glenn.rangel@testcorp.com, sandilyan.parimalam@testcorp.com"
    to_email = 'dl.tech.infra.sre@testcorp.com, techinfradevops@testcorp.com, search@testcorp.com, b0ce6c6b.testcorpO365.onmicrosoft.com@amer.teams.ms'

    # Local and Remote Script Paths
    worker_script_local_path = "/opt/stackstorm/packs/st2autoremediation/actions/maxwell_auto_remediation_worker.py"
    worker_script_remote_path = "/tmp/maxwell_auto_remediation_worker.py"

    def send_email(self, subject, body):
        # Create a MIMEText object with the email content
        msg = MIMEMultipart()
        msg["From"] = self.from_email
        msg["To"] = self.to_email
        msg["Subject"] = subject

        # Attach the body to the email
        body = MIMEText(body, "plain")
        msg.attach(body)

        # Connect to the SMTP server and send the email
        try:
            server = smtplib.SMTP(self.smtp_server, self.smtp_port)
            server.sendmail(msg["From"], msg["To"].split(', '), msg.as_string())
            server.quit()
            print("Email sent successfully")
        except smtplib.SMTPException as e:
            print(f"Error sending email: {str(e)}")

    def remove_unwanted_text(self, ssh_output_script):
        # Pattern to match the unwanted text sections
        pattern1 = r"Warning: Permanently added.*?This Server is moved to SSO\. Please use your AD credentials to login\."
        pattern2 = r"\s*#\s*"

        # Use Regex to remove the unwanted text sections
        ssh_output_script = re.sub(pattern1, '', ssh_output_script, flags=re.DOTALL)
        ssh_output_script = re.sub(pattern2, '', ssh_output_script, flags=re.MULTILINE)

        return ssh_output_script

    def copy_script_to_remote(self, hostname, local_path, remote_path):
        try:
            ssh_command_script = f"scp {local_path} {hostname}:{remote_path}"
            subprocess.check_output(ssh_command_script, shell=True, stderr=subprocess.STDOUT)
            return True
        except subprocess.CalledProcessError as e:
            self.logger.error(f"Error copying script to remote server: {str(e)}")
            return False

    def check_file_exists(self, hostname, script_name):
        ssh_command_script = f"ssh -o StrictHostKeyChecking=no {hostname} [ -e {script_name} ] && echo \"File exists\" || echo \"File not found\""

        try:
            ssh_output_script = subprocess.check_output(ssh_command_script, shell=True, stderr=subprocess.STDOUT)
            ssh_output_script = ssh_output_script.decode().strip()
            return "File exists" in ssh_output_script
        except subprocess.CalledProcessError as e:
            self.logger.error(f"Error checking file existence: {str(e)}")
            return False

    def run(self, payload, send_email_notification=True):
        self.logger.debug('Attempting to reformat the new relic data')
        my_payload = ast.literal_eval(payload)

        instance_name = my_payload['body'].get('impactedEntities', [''])[0].split(" ")[0]
        hostname = my_payload['body'].get('impactedEntities', [''])[0].split(" ")[-1]        
        
        try:
            resolved_ip = socket.gethostbyname(hostname)
        except socket.gaierror:
            result = {
                "rc": 1,
                "error": "Auto remediation failed due to Hostname resolution failure.",
                "message": "Auto remediation failed due to Hostname resolution failure. Server name: " + hostname
            }
            if send_email_notification:
                subject = f"CRITICAL: Auto Remediation Failed for {instance_name} Maxwell on {hostname}"
                body = result["message"]
                self.send_email(subject, body)
            return False, result

        # Copy the script to the remote server
        if not self.copy_script_to_remote(hostname, self.worker_script_local_path, self.worker_script_remote_path):
            result = {
                "rc": 1,
                "error": "Auto remediation failed because the script file could not be copied to the remote server.",
                "message": "Auto remediation failed because the script file could not be copied to the remote server.",
                "hostname": hostname,
                "instance_name": instance_name
            }
            if send_email_notification:
                subject = f"CRITICAL: Auto Remediation Failed for {instance_name} Maxwell on {hostname}"
                body = f"Auto remediation failed because the script file could not be copied to the remote server."
                self.send_email(subject, body)
            return False, result

        # Check if the script file exists on the remote server
        if not self.check_file_exists(hostname, self.worker_script_remote_path):
            result = {
                "rc": 1,
                "error": "Auto remediation failed because the script file is not present on the remote server.",
                "message": "Auto remediation failed because the script file is not present on the remote server.",
                "hostname": hostname,
                "instance_name": instance_name
            }
            if send_email_notification:
                subject = f"CRITICAL: Auto Remediation Failed for {instance_name} Maxwell on {hostname}"
                body = f"Auto remediation failed because the script file is not present on the remote server."
                self.send_email(subject, body)
            return False, result

        ssh_command_script = f"ssh -o StrictHostKeyChecking=no {hostname} sudo python3 {self.worker_script_remote_path} {instance_name}"

        try:
            ssh_output_script = subprocess.check_output(ssh_command_script, shell=True, stderr=subprocess.STDOUT)
            ssh_output_script = ssh_output_script.decode().strip()

            ssh_output_script = self.remove_unwanted_text(ssh_output_script)

            if re.search(r'error', ssh_output_script, re.IGNORECASE):
                # Auto remediation failed
                result = {
                    "rc": 1,
                    "error": "Auto remediation failed.",
                    "message": "The script execution returned an error.",
                    "hostname": hostname,
                    "instance_name": instance_name,
                    "ssh_output_script": ssh_output_script
                }
                if send_email_notification:
                    subject = f"CRITICAL: Auto Remediation Failed for {instance_name} Maxwell on {hostname}"
                    body = f"Auto remediation failed.\n\nHostname: {hostname}\nInstance Name: {instance_name}\n\nSSH Output:\n{ssh_output_script}"
                    self.send_email(subject, body)
            else:
                # Auto remediation successful
                result = {
                    "rc": 0,
                    "error": "none",
                    "message": "Auto remediation successful.",
                    "hostname": hostname,
                    "instance_name": instance_name,
                    "ssh_output_script": ssh_output_script
                }
                if send_email_notification:
                    subject = f"Auto Remediation Successful for {instance_name} Maxwell on {hostname}"
                    body = f"Auto remediation successful.\n\nHostname: {hostname}\nInstance Name: {instance_name}\n\nSSH Output:\n{ssh_output_script}"
                    self.send_email(subject, body)
        except subprocess.CalledProcessError as e:
            error_output = e.output.decode().strip()
            result = {
                "rc": 1,
                "error": "Auto remediation failed due to autoremediation script unable to complete the remediation successfully.",
                "message": "Failed to execute the SSH command on the remote host to run the script: " + str(e),
                "hostname": hostname,
                "instance_name": instance_name
            }
            if send_email_notification:
                subject = f"CRITICAL: Auto Remediation Failed for {instance_name} Maxwell on {hostname}"
                body = f"Auto remediation failed due to SSH command execution failure.\n\nError Output:\n{error_output}"
                self.send_email(subject, body)

        return result
