<html>
<head>
<?php
if( !isset($_SESSION['login_user'])){

        echo "<script type='text/javascript'>alert('Please login to access this page');window.location.href = '/lin_administration/html/login.html'</script>";
 //     header("location: /lin_administration/html/login.html");

}



?>
</head>
<body>
</body>
</html>
