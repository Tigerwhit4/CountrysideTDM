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
<li><a href="top.php">Top Players</a></li>
<li><a href="server.php">Online</a></li>
<li><a href="ban.php">Bans</a></li>
</ul>
</div></center>


<!-- All the info in the main website box -->
	<center><div id="mid"><ul>
	</br>

<table class="tftable" border="1">
<tr><th>Name</th><th>Reason</th><th>Banned By</th><th>Date</th><th>Status</th><th>IRC Ban</th></tr>
<tr><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 0,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['name'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 0,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['reason'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 0,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['bannedby'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 0,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['date'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 0,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['status'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 0,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['IRCBan'];
	
					}
					?></td></tr>
					
					
<tr><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 1,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['name'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 1,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['reason'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 1,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['bannedby'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 1,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['date'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 1,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['status'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 1,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['IRCBan'];
	
					}
					?></td></tr>
					
					
<tr><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 2,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['name'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 2,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['reason'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 2,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['bannedby'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 2,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['date'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 2,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['status'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 2,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['IRCBan'];
	
					}
					?></td></tr>
					
					
<tr><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 3,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['name'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 3,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['reason'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 3,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['bannedby'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 3,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['date'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 3,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['status'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 3,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['IRCBan'];
	
					}
					?></td></tr>
					
					
<tr><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 4,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['name'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 4,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['reason'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 4,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['bannedby'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 4,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['date'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 4,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['status'];
	
					}
					?></td><td><?php
						$sql = mysql_query("SELECT * FROM bans ORDER BY date DESC LIMIT 4,1"); 
						while ($data = mysql_fetch_array($sql))
					{
					echo $data['IRCBan'];
	
					}
					?></td></tr>
</table>
</br>
<center>Total Accounts Banned</br>
	<?php


$resultado = mysql_query("SELECT * FROM bans");
$número_filas = mysql_num_rows($resultado);

echo "$número_filas Banned\n";

?></center>
	<br></center></p></li></div></ul>


<!-- The footer thing  -->

	<center><div id="footer1">
	<ul>
	</br>
	<center><img src="http://forum.sa-mp.com/images/samp/logo_forum.gif" alt="Logothing"></center>
	<center><img src="http://www.volt-host.com/images/468.gif" alt="VoltLogo"></center>
	<p><center>Remember the SA:MP server is now running on 0.3z - If you don't have the RC client download it <a href="http://forum.sa-mp.com/showthread.php?t=487997">Here</a></center></p>
	</ul>
	</div></center></br>
