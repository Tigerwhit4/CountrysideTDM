<?php
$host=""; //localhost
$usernamehost=""; //name
$passwordhost=""; //pass
$db_name=""; //Database name

mysql_connect("$host", "$usernamehost", "$passwordhost") or die ("cannot connect");
mysql_select_db("$db_name") or die ("cannot select DB");


//For connecting to the SA:MP server etc..
require "samp_query.php";

$serverIP = "37.59.28.180"; //Connecting to the server
$serverPort = 8112; //Server port, duh


?>