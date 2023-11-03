<?php
if( !isset($_SESSION['login_user'])){

        echo "<script type='text/javascript'>alert('Please login to access this page');window.location.href = '/tpp-portal/login.html'</script>";

}



?>
