<?php

include "config/configuration.php";

include "includes/database.php";

if (!$aGlobalConfig["settings"]["use_ini"])
{
	try
	{
		$iQuery = DB::getInstance();
	}
	catch (Exception $sException)
	{
		die($sException->getMessage());
	}
	
	if (isset($_GET["name"]) && $_GET["name"])
	{
		$iResult = $iQuery->prepare("SELECT `{$aGlobalConfig["rows"]["name"]}`, `{$aGlobalConfig["rows"]["cash"]}`, `{$aGlobalConfig["rows"]["score"]}`, `{$aGlobalConfig["rows"]["kills"]}`, `{$aGlobalConfig["rows"]["deaths"]}` FROM `{$aGlobalConfig["settings"]["user_table"]}` WHERE `{$aGlobalConfig["rows"]["name"]}` = ? LIMIT 0, 1;");
		if ($iResult->execute(array($_GET["name"])))
		{
			$aReturn = $iResult->fetchAll();
			
			if (count($aReturn) && $aReturn)
			{	
				if ($iImage = @imagecreatefrompng($aGlobalConfig["settings"]["image_loc"]))
				{
					
					header("Content-Type: image/png");
					flush();

					imagettftext($iImage, 15, 0, 120, 20, imagecolorallocate($iImage, 134, 144, 209), $aGlobalConfig["settings"]["font_loc"], "Name: ".$aReturn[0][$aGlobalConfig["rows"]["name"]]);
					imagettftext($iImage, 10, 0, 23, 35, imagecolorallocate($iImage,  192, 192, 192), $aGlobalConfig["settings"]["font_loc"], "Score:   ".$aReturn[0][$aGlobalConfig["rows"]["cash"]]);
					imagettftext($iImage, 10, 0, 23, 55, imagecolorallocate($iImage,  192, 192, 192), $aGlobalConfig["settings"]["font_loc"], "Deaths:   ".$aReturn[0][$aGlobalConfig["rows"]["score"]]);
					imagettftext($iImage, 10, 0, 23, 75, imagecolorallocate($iImage,  192, 192, 192), $aGlobalConfig["settings"]["font_loc"], "Money:   ".$aReturn[0][$aGlobalConfig["rows"]["kills"]]);
					imagettftext($iImage, 10, 0, 23, 95, imagecolorallocate($iImage,  192, 192, 192), $aGlobalConfig["settings"]["font_loc"], "VIP Level:   ".$aReturn[0][$aGlobalConfig["rows"]["deaths"]]);
			
					imagepng($iImage);
					imagedestroy($iImage);
					
				}
				else
				{
					echo "Oops! Failed to create image.".PHP_EOL;
				}
			}
			else
			{
				echo "No results found!".PHP_EOL;
			}
		}
		else
		{
			echo "Oops! Something went wrong...".PHP_EOL;
		}
	}
	else
	{
		echo "Please provide a valid username!".PHP_EOL;
	}
	
	unset($oReturn, $iResult, $iQuery);
}

?>
