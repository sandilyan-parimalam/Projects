import subprocess
import datetime
import sys
import os
import time



# Add error messages to exclude auto remediation
errors_to_exclude_restart = [
    "java.lang.RuntimeException: Couldn't find table",
    "error!:  Data truncation: Incorrect datetime value",
    "error!:  Subquery return"
]

search_duration_minutes = 10
script_name = "start-maxwell.sh"
log_file = "maxwell.log"
script_start_time = datetime.datetime.now()



# Add instances with home directory and config file path.
instances = {
    "b2b-syncer": {
        "home_directory": "/opt/testcorp/b2b-syncer",
        "config_file": "/opt/testcorp/b2b-syncer/maxwell-cprt/configurations/qa/b2b_syncer_config.properties",
    },    
    "lot_uk_transformer_rn": {
        "home_directory": "/opt/testcorp/solr-transformer-lot-uk",
        "config_file": "/opt/testcorp/solr-transformer-lot-uk/maxwell-cprt/configurations/prod_rn/transformer_lot_uk_config.properties"
    },
    "lot_us_transformer_rn": {
        "home_directory": "/opt/testcorp/solr-transformer-lot-us",
        "config_file": "/opt/testcorp/solr-transformer-lot-us/maxwell-cprt/configurations/prod_rn/transformer_lot_us_config.properties"
    },
    "member_bids_us_transformer_rn": {
        "home_directory": "/opt/testcorp/solr-transformer-member-bids-us",
        "config_file": "/opt/testcorp/solr-transformer-member-bids-us/maxwell-cprt/configurations/prod_rn/transformer_member_bids_us_config.properties"
    },
    "so_uk_transformer_rn": {
        "home_directory": "/opt/testcorp/solr-transformer-serviceorder-UK",
        "config_file": "/opt/testcorp/solr-transformer-serviceorder-UK/maxwell-cprt/configurations/prod_rn/transformer_serviceorder_uk_config.properties"
    },
    "so_us_transformer_rn": {
        "home_directory": "/opt/testcorp/solr-transformer-serviceorder-us",
        "config_file": "/opt/testcorp/solr-transformer-serviceorder-us/maxwell-cprt/configurations/prod_rn/syncer_config_archived_lots_solr8_a.properties"
    },
    "solr8_archived_lot_solr_syncer_rn": {
        "home_directory": "/opt/testcorp/solr8-archived-lot-solr-syncer",
        "config_file": "/opt/testcorp/solr8-archived-lot-solr-syncer/maxwell-cprt/configurations/prod_rn/syncer_config_archived_lots_solr8_a.properties"
    },
    "solr8_lot_solr_syncer_uk_rn": {
        "home_directory": "/opt/testcorp/solr8-lot-solr-syncer-uk",
        "config_file": "/opt/testcorp/solr8-lot-solr-syncer-uk/maxwell-cprt/configurations/prod_rn/syncer_config_uk_lots_solr8_a.properties"
    },
    "solr8_lot_solr_syncer_us_rn": {
        "home_directory": "/opt/testcorp/solr8-lot-solr-syncer-us",
        "config_file": "/opt/testcorp/solr8-lot-solr-syncer-us/maxwell-cprt/configurations/prod_rn/syncer_config_us_lots_solr8_a.properties"
    },
    "member_lots_us_syncer_rn": {
        "home_directory": "/opt/testcorp/solr8-syncer-member-lots",
        "config_file": "/opt/testcorp/solr8-syncer-member-lots/maxwell-cprt/configurations/prod_rn/syncer_config_member_lots_solr8.properties"
    },
    "solr8_onsale_lot_syncer_rn": {
        "home_directory": "/opt/testcorp/solr8-syncer-onsale-lots",
        "config_file": "/opt/testcorp/solr8-syncer-onsale-lots/maxwell-cprt/configurations/prod_rn/syncer_config_onsale_solr8_a.properties"
    },
    "solr8_searchtrend_syncer_rn": {
        "home_directory": "/opt/testcorp/solr8-syncer-searchtrends",
        "config_file": "/opt/testcorp/solr8-syncer-searchtrends/maxwell-cprt/configurations/prod_rn/syncer_config_searchtrends_solr8_a.properties "
    },
    "bid_limit_events_transformer_rn": {
        "home_directory": "/opt/testcorp/datapipeline-bidlimit-us-transformer",
        "config_file": "/opt/testcorp/datapipeline-bidlimit-us-transformer/maxwell-cprt/configurations/prod_rn/transformer_bid_limit_events_config.properties"
    },
    "facility_events_transformer_rn": {
        "home_directory": "/opt/testcorp/datapipeline_facility_events_transformer",
        "config_file": "/opt/testcorp/datapipeline_facility_events_transformer/maxwell-cprt/configurations/prod_rn/transformer_facility_events_config.properties"
    },
    "lot_events_uk_transformer_rn": {
        "home_directory": "/opt/testcorp/datapipeline-lot-events-uk-transformer",
        "config_file": "/opt/testcorp/datapipeline-lot-events-uk-transformer/maxwell-cprt/configurations/prod_rn/transformer_lot_events_uk_config.properties"
    },
    "lot_events_us_transformer_rn": {
        "home_directory": "/opt/testcorp/datapipeline-lot-events-us-transformer",
        "config_file": "/opt/testcorp/datapipeline-lot-events-us-transformer/maxwell-cprt/configurations/prod_rn/transformer_lot_events_us_config.properties"
    },
    "serviceorder_events_transformer_uk_rn": {
        "home_directory": "/opt/testcorp/datapipeline-serviceorder-events-uk-transformer",
        "config_file": "/opt/testcorp/datapipeline-serviceorder-events-uk-transformer/maxwell-cprt/configurations/prod_rn/transformer_serviceorder_events_uk_config.properties"
    },
    "serviceorder_events_transformer_us_rn": {
        "home_directory": "/opt/testcorp/datapipeline-serviceorder-events-us-transformer",
        "config_file": "/opt/testcorp/datapipeline-serviceorder-events-us-transformer/maxwell-cprt/configurations/prod_rn/transformer_serviceorder_events_us_config.properties"
    },
    "seller_settings_events_transformer_rn": {
        "home_directory": "/opt/testcorp/datapipeline_sellersettings_events_transformer",
        "config_file": "/opt/testcorp/datapipeline_sellersettings_events_transformer/maxwell-cprt/configurations/prod_rn/transformer_seller_events_config.properties"
    },
    "titledirect_events_transformer_rn": {
        "home_directory": "/opt/testcorp/datapipeline_titledirect_events_transformer",
        "config_file": "/opt/testcorp/datapipeline_titledirect_events_transformer/maxwell-cprt/configurations/prod_rn/transformer_titledirect_events_config.properties"
    },
    "bid_limits_events_syncer_rn": {
        "home_directory": "/opt/testcorp/datapipeline-bidlimit-us-syncer",
        "config_file": "/opt/testcorp/datapipeline-bidlimit-us-syncer/maxwell-cprt/configurations/prod_rn/syncer_bid_limits_events_config.properties"
    },
    "facility_events_syncer_rn": {
        "home_directory": "/opt/testcorp/datapipeline_facility_events_syncer",
        "config_file": "/opt/testcorp/datapipeline_facility_events_syncer/maxwell-cprt/configurations/prod_rn/syncer_facility_events_config.properties"
    },
    "lot_events_uk_syncer_rn": {
        "home_directory": "/opt/testcorp/datapipeline-lot-events-uk-syncer",
        "config_file": "/opt/testcorp/datapipeline-lot-events-uk-syncer/maxwell-cprt/configurations/prod_rn/syncer_lot_events_uk_config_confluent.properties"
    },
    "lot_events_us_syncer_rn": {
        "home_directory": "/opt/testcorp/datapipeline-lot-events-us-syncer",
        "config_file": "/opt/testcorp/datapipeline-lot-events-us-syncer/maxwell-cprt/configurations/prod_rn/syncer_lot_events_us_config_confluent.properties"
    },
    "serviceorder_events_syncer_uk_rn": {
        "home_directory": "/opt/testcorp/datapipeline-lot-serviceorder-events-uk-syncer",
        "config_file": "/opt/testcorp/datapipeline-lot-serviceorder-events-uk-syncer/maxwell-cprt/configurations/prod_rn/syncer_lot_serviceorder_events_uk_config.properties"
    },
    "serviceorder_events_syncer_us_rn": {
        "home_directory": "/opt/testcorp/datapipeline-lot-serviceorder-events-us-syncer",
        "config_file": "/opt/testcorp/datapipeline-lot-serviceorder-events-us-syncer/maxwell-cprt/configurations/prod_rn/syncer_lot_serviceorder_events_us_config.properties"
    },
    "seller_settings_events_syncer_rn": {
        "home_directory": "/opt/testcorp/datapipeline_sellersettings_events_syncer",
        "config_file": "/opt/testcorp/datapipeline_sellersettings_events_syncer/maxwell-cprt/configurations/prod_rn/syncer_seller_events_config.properties"
    },
    "title_direct_events_syncer_rn": {
        "home_directory": "/opt/testcorp/datapipeline_titledirect_events_syncer",
        "config_file": "/opt/testcorp/datapipeline_titledirect_events_syncer/maxwell-cprt/configurations/prod_rn/syncer_config_titledirect_kafka_events.properties"
    },
    "kafka_producer_rn": {
        "home_directory": "/opt/testcorp/maxwell-kafka-producer",
        "config_file": "/opt/testcorp/maxwell-kafka-producer/maxwell-cprt/configurations/prod_rn/kafka_config.properties"
    },
    "b2b_syncer_rn": {
        "home_directory": "/opt/testcorp/b2b-syncer",
        "config_file": "/opt/testcorp/b2b-syncer/maxwell-cprt/configurations/prod_rn/b2b_syncer_config.properties"
    },
    "buildsheet_syncer_rn": {
        "home_directory": "/opt/testcorp/buildsheet-syncer",
        "config_file": "/opt/testcorp/buildsheet-syncer/maxwell-cprt/configurations/prod_rn/buildsheet_syncer_config.properties"
    },
    "lot_uk_transformer_lv": {
        "home_directory": "/opt/testcorp/solr-transformer-lot-uk",
        "config_file": "/opt/testcorp/solr-transformer-lot-uk/maxwell-cprt/configurations/prod_lv/transformer_lot_uk_config.properties"
    },
    "lot_us_transformer_lv": {
        "home_directory": "/opt/testcorp/solr-transformer-lot-us",
        "config_file": "/opt/testcorp/solr-transformer-lot-us/maxwell-cprt/configurations/prod_lv/transformer_lot_us_config.properties"
    },
    "member_bids_us_transformer_lv": {
        "home_directory": "/opt/testcorp/solr-transformer-member-bids-us",
        "config_file": "/opt/testcorp/solr-transformer-member-bids-us/maxwell-cprt/configurations/prod_lv/transformer_member_bids_us_config.properties"
    },
    "so_uk_transformer_lv": {
        "home_directory": "/opt/testcorp/solr-transformer-serviceorder-UK",
        "config_file": "/opt/testcorp/solr-transformer-serviceorder-UK/maxwell-cprt/configurations/prod_lv/transformer_serviceorder_uk_config.properties"
    },
    "so_us_transformer_lv": {
        "home_directory": "/opt/testcorp/solr-transformer-serviceorder-us",
        "config_file": "/opt/testcorp/solr-transformer-serviceorder-us/maxwell-cprt/configurations/prod_lv/transformer_serviceorder_us_config.properties"
    },
    "solr8_archived_lot_syncer_lv": {
        "home_directory": "/opt/testcorp/solr8-archived-lot-solr-syncer",
        "config_file": "/opt/testcorp/solr8-archived-lot-solr-syncer/maxwell-cprt/configurations/prod_lv/syncer_config_archived_lots_solr8_a.properties"
    },
    "solr8_lot_solr_syncer_uk_lv": {
        "home_directory": "/opt/testcorp/solr8-lot-solr-syncer-us",
        "config_file": "/opt/testcorp/solr8-lot-solr-syncer-us/maxwell-cprt/configurations/prod_lv/syncer_config_us_lots_solr8_a.properties"
    },
    "solr8_onsale_lot_syncer_lv": {
        "home_directory": "/opt/testcorp/solr8-syncer-onsale-lots",
        "config_file": "/opt/testcorp/solr8-syncer-onsale-lots/maxwell-cprt/configurations/prod_lv/syncer_config_onsale_solr8_a.properties"
    },
    "solr8_searchtrend_syncer_lv": {
        "home_directory": "/opt/testcorp/solr8-syncer-searchtrends",
        "config_file": "/opt/testcorp/solr8-syncer-searchtrends/maxwell-cprt/configurations/prod_lv/syncer_config_searchtrends_solr8_a.properties"
    },
    "bid_limit_events_transformer_lv": {
        "home_directory": "/opt/testcorp/datapipeline-bidlimit-us-transformer",
        "config_file": "/opt/testcorp/datapipeline-bidlimit-us-transformer/maxwell-cprt/configurations/prod_lv/transformer_bid_limit_events_config.properties"
    },
    "facility_events_transformer_lv": {
        "home_directory": "/opt/testcorp/datapipeline_facility_events_transformer",
        "config_file": "/opt/testcorp/datapipeline_facility_events_transformer/maxwell-cprt/configurations/prod_lv/transformer_facility_events_config.properties"
    },
    "lot_events_uk_transformer_lv": {
        "home_directory": "/opt/testcorp/datapipeline-lot-events-uk-transformer",
        "config_file": "/opt/testcorp/datapipeline-lot-events-uk-transformer/maxwell-cprt/configurations/prod_lv/transformer_lot_events_uk_config.properties"
    },
    "lot_events_us_transformer_lv": {
        "home_directory": "/opt/testcorp/datapipeline-lot-events-us-transformer",
        "config_file": "/opt/testcorp/datapipeline-lot-events-us-transformer/maxwell-cprt/configurations/prod_lv/transformer_lot_events_us_config.properties"
    },
    "serviceorder_events_transformer_uk_lv": {
        "home_directory": "/opt/testcorp/datapipeline-serviceorder-events-uk-transformer",
        "config_file": "/opt/testcorp/datapipeline-serviceorder-events-uk-transformer/maxwell-cprt/configurations/prod_lv/transformer_serviceorder_events_uk_config.properties"
    },
    "serviceorder_events_transformer_us_lv": {
        "home_directory": "/opt/testcorp/datapipeline-serviceorder-events-us-transformer",
        "config_file": "/opt/testcorp/datapipeline-serviceorder-events-us-transformer/maxwell-cprt/configurations/prod_lv/transformer_serviceorder_events_us_config.properties"
    },
    "seller_settings_events_transformer_lv": {
        "home_directory": "/opt/testcorp/datapipeline_sellersettings_events_transformer",
        "config_file": "/opt/testcorp/datapipeline_sellersettings_events_transformer/maxwell-cprt/configurations/prod_lv/transformer_seller_events_config.properties"
    }
}






def search_log_file():
    search_time = datetime.datetime.now() - datetime.timedelta(minutes=search_duration_minutes)
    current_time = datetime.datetime.now()
    print(f"[{current_time}] Checking log for predefined issues...")
    error_found = False
    error_message = ""
    log_connected = False  # Flag to track if the "BinlogConnectorLifecycleListener - Binlog connected." string is found
    with open(log_path, 'r') as file:
        for line in file:
            try:
                log_time = line[:23]  # Extract the log entry timestamp
                log_datetime = datetime.datetime.strptime(log_time, "%Y-%b-%d %H:%M:%S,%f")
                if search_time <= log_datetime <= current_time:
                    for error_to_exclude_restart in errors_to_exclude_restart:
                        if error_to_exclude_restart in line:
                            error_found = True
                            error_message = error_to_exclude_restart
                            break
                    if "BinlogConnectorLifecycleListener - Binlog connected." in line:
                        log_connected = True
                        break
                if error_found:
                    break
            except ValueError:
                # Skip the line if the timestamp format does not match
                continue

    return error_found, error_message, log_connected


def search_log_file_after_search(script_start_time):
    current_time = datetime.datetime.now()
    print(f"[{current_time}] Checking log for predefined issues since script started...")
    error_found = False
    error_message = ""
    log_connected = False  # Flag to track if the "BinlogConnectorLifecycleListener - Binlog connected." string is found
    with open(log_path, 'r') as file:
        for line in file:
            try:
                log_time = line[:23]  # Extract the log entry timestamp
                log_datetime = datetime.datetime.strptime(log_time, "%Y-%b-%d %H:%M:%S,%f")
                if script_start_time <= log_datetime <= current_time:
                    for error_to_exclude_restart in errors_to_exclude_restart:
                        if error_to_exclude_restart in line:
                            error_found = True
                            error_message = error_to_exclude_restart
                            break
                    if "BinlogConnectorLifecycleListener - Binlog connected." in line:
                        log_connected = True
                        break
                if error_found:
                    break
            except ValueError:
                # Skip the line if the timestamp format does not match
                continue

    return error_found, error_message, log_connected


def check_log_connected(start_time):
    while datetime.datetime.now() < start_time + datetime.timedelta(seconds=60):
        print(f"[{datetime.datetime.now()}] Checking log for Binlog connection...")
        error_found, error_message, log_connected = search_log_file_after_search(script_start_time)
        if log_connected:
            print(f"[{datetime.datetime.now()}] {instance_name}: Instance connected successfully. Auto remediation successful.")
            sys.exit(0)
        time.sleep(2)

        if not is_instance_running():
          print(f"[{datetime.datetime.now()}] Error: {instance_name}: Instance started but went down again. Auto remediation failed.")
          sys.exit(1)
        if error_found:
          print(f"[{datetime.datetime.now()}] Predefined errors found in the log file after starting up the instance")
          print(f"[{datetime.datetime.now()}] Predefined Error: {error_message}")
          print(f"[{datetime.datetime.now()}] Auto remediation aborted. DevOps team needs to analyze these errors and start the instance manually.")
          sys.exit(1)



    if is_instance_running():
        print(f"[{datetime.datetime.now()}] Error: {instance_name}: Instance started but did not connect successfully.")
        sys.exit(1)
    else:
        print(f"[{datetime.datetime.now()}] Error: {instance_name}: Instance started but went down again. Auto remediation failed.")
        sys.exit(1)

def start_instance():
    script_file = os.path.join(script_path, script_name)
    print(f"[{datetime.datetime.now()}] NO predefined issues found. Starting {instance_name}.")
    if not os.path.isfile(script_file):
        print(f"[{datetime.datetime.now()}] Error: Auto remediation aborted. Script file not found: {script_file}")
        print(f"[{datetime.datetime.now()}] DevOps team needs to check this issue.")
        sys.exit(1)
    subprocess.run(f"sudo su - maxwell -c '{script_file} {config_file}'", shell=True)

def is_instance_running():
    print(f"[{datetime.datetime.now()}] Checking {instance_name} status")
    command = f"sudo lsof -u maxwell -c java -a -Fp {log_path} | awk -F'p' '/^p/{{print $2}}'"
    result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    output = result.stdout.strip()
    if output:
        print(f"[{datetime.datetime.now()}] {instance_name} is UP")
        return True
    else:
        print(f"[{datetime.datetime.now()}] {instance_name} is DOWN")
        return False

def check_binlog_connected():
    print(f"[{datetime.datetime.now()}] Waiting for 'BinlogConnectorLifecycleListener - Binlog connected.' in the log file...")
    start_time = datetime.datetime.now()
    check_log_connected(start_time)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Please provide the instance name as an argument.")
        print("Example: python3 maxwell_auto_remediation.py <instance_name>")
        sys.exit(1)

    instance_name = sys.argv[1].lower()
    instance = instances.get(instance_name)

    if instance is None:
        print(f"Error: Invalid instance name '{instance_name}'.")
        sys.exit(1)

    home_directory = instance.get("home_directory")
    config_file = instance.get("config_file")

    log_path = os.path.join(home_directory, "maxwell-cprt", "logs", log_file)
    script_path = os.path.join(home_directory, "maxwell-cprt")
    pid_file = os.path.join(home_directory, "maxwell-cprt", "process.pid")

    if not os.path.isfile(log_path):
        print(f"[{datetime.datetime.now()}] Error: Log file not found for instance '{instance_name}'")
        print(f"[{datetime.datetime.now()}] Log Path: {log_path}")
        sys.exit(1)

    if not os.path.isfile(config_file):
        print(f"[{datetime.datetime.now()}] Error: Config file not found for instance '{instance_name}'")
        print(f"[{datetime.datetime.now()}] Config File: {config_file}")
        sys.exit(1)

    if is_instance_running():
        print(f"[{datetime.datetime.now()}] Error: {instance_name}: Instance is already running. DevOps team needs to check this.")
        sys.exit(0)
    else:
        error_found, error_message, _ = search_log_file()
        if error_found:
            print(f"[{datetime.datetime.now()}] Predefined errors found in the log file with the last {search_duration_minutes} minutes")
            print(f"[{datetime.datetime.now()}] Predefined Error: {error_message}")
            print(f"[{datetime.datetime.now()}] Auto remediation aborted. DevOps team needs to analyze these errors and start the instance manually.")
            sys.exit(1)
        else:
            start_instance()
            check_binlog_connected()
