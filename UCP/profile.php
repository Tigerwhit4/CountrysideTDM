<?php 

include("config.php"); //including our config.php 
session_start(); //starting session 
error_reporting(0); 

if(isset($_SESSION['username'])) //if session is set, so if user is logged in... 
{ 
    $username = $_SESSION['username']; //setting variable username as one from session 
    $query = mysql_query("SELECT * FROM playerdata WHERE nick = '$username'");  //selecting all from table users where username is name that your is loged in 
    echo "Welcome ".$_SESSION['username']; //saying welcome to user! 
    while($row = mysql_fetch_assoc($query)) //looping thousgt table to get informations 
    { 
        $name = $row['nick']; //selecting user name, change 'username' to your field name 
        $money = $row['money']; //selecting user money, change 'money' to your field name 
        $score = $row['score']; //selecting user score, change 'score' to your field name 
        $kills = $row['kills']; //selecting user kills, change 'kills' to your field name 
        $deaths = $row['deaths']; //selecting user deaths, change 'deaths' to your field name 
    } 
    echo "<br><br>Name: ".$name."<br> Money: ".$money."<br> Score: ".$score."<br> Kills: ".$kills."<br> Deaths: ".$deaths; 
} 
else header('location: login.php'); //if user isn't loged in it will redirect him on login.php 

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Basic UCP</title>
</head>
</html>