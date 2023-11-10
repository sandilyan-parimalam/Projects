<?php
session_start();
$username=$_GET["username"];
$output = shell_exec("../shell/AppendLog.sh $username logged out");
if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]
    );
}

session_destroy();
echo "<script type='text/javascript'>window.location.href = '/lin_administration/html/login.html';</script>";

?>
