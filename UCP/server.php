<!-- 

All the HTML/PHP script was made by Elliot


 -->
 <?php
include 'Connect.php';

 
 ?>
 
<head>
<link href="Style.css" rel="stylesheet"> 

</head>

<!-- Top nav bar thing -->
<center><img src="images/TopLogo.png" alt="TopLogo" width="750" height="140"></center>
<center><div id="menu">
<ul>
<li><a href="index.php">Home</a></li>
<li><a href="http://forum.countrytdm.info/index.php?action=forum">Forums</a></li>
<li><a href="irc.php">IRC</a></li>
<li><a href="top.php">Server/Player Stats</a></li>
<li><a href="server.php">Live Players</a></li>
</ul>
</div></center>


<!-- All the info in the main website box -->
	<center><div id="mid"><ul>
	</br>
	<center>Copy this code and replace the 'YOURNAME' with your ingame name</center>
		<center><a id="show_id" onclick="document.getElementById('spoiler_id').style.display=''; document.getElementById('show_id').style.display='none';" class="link">[Show]</a><span id="spoiler_id" style="display: none"><a onclick="document.getElementById('spoiler_id').style.display='none'; document.getElementById('show_id').style.display='';" class="link">[Hide]</a><br>[IMG]http://CountryTDM.info/signature.php?name=YOURNAME[/IMG]</span></center>
	</br>
	<center>To Preview your banner type your name below.</center>
	</br>
	
	<form action="signature.php?">
	<center>Name: </br><input type="text" name="name"><br>
  <input type="submit" value="Submit">
</form></center>
	<?php 


require "SampQueryAPI.php"; 
$query = new SampQueryAPI('37.59.28.180', '8112'); 


if($query->isOnline()) 
{ 
    $aInformation = $query->getInfo(); 
    $aServerRules = $query->getRules(); 

    ?> 
    <center>

    <br /> 
    <b>Players Online Right now!</br> 
    <?php 

    $aPlayers = $query->getDetailedPlayers(); 

    if(!is_array($aPlayers) || count($aPlayers) == 0) 
    { 
        echo '<br /><i>Server is Empty!</i>'; 
    } 
    else 
    { 
        ?> 
        <table width="400"> 
            <tr> 
                <td><b>Player ID</b></td> 
                <td><b>Nickname</b></td> 
                <td><b>Score</b></td> 
                <td><b>Ping</b></td> 
            </tr></center>
        <?php 
        foreach($aPlayers as $sValue) 
        { 
            ?> 
            <tr> 
                <td><?= $sValue['playerid'] ?></td> 
                <td><?= htmlentities($sValue['nickname']) ?></td> 
                <td><?= $sValue['score'] ?></td> 
                <td><?= $sValue['ping'] ?></td> 
            </tr> 
            <?php 
        } 

        echo '</table>'; 
    } 
} 
?>

	</div></ul>


<!-- The footer thing  -->

	<center><div id="footer1">
	<ul>
	</br>
	<center><img src="http://forum.sa-mp.com/images/samp/logo_forum.gif" alt="Logothing"></center>
	<center><img src="http://www.volt-host.com/images/468.gif" alt="VoltLogo"></center>
	<p><center>Remember the SA:MP server is now running on 0.3z - If you don't have the RC client download it <a href="http://forum.sa-mp.com/showthread.php?t=487997">Here</a></center></p>
	</ul>
	</div></center></br>
