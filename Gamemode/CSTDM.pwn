/*

								CountrySide Team Deathmatch
                             This server was made by Elliot(Flake)


                             Notes:
                             A player's health/armor will never go over 95, if it does they will be deemed a hacker
                             There are 5 IRC bots for debug/anticheat




*/

#include <a_samp>
#include <mysql>
#include <zcmd>
#include <sscanf2>
#include <data>
#include <streamer>
#include <foreach>
#include <irc>
#include <GeoIP_Plugin>
#include <a_http>
#include <regex>

#include "../gamemodes/CSTDM_callbacks.pwn"
#include "../gamemodes/CSTDM_objects.pwn"
#include "../gamemodes/CSTDM_define.pwn"
#include "../gamemodes/CSTDM_config.pwn"

//MISC
#define MAILER_URL "countrytdm.info/mailer.php" //Remember to change this to your domain
#include <mailer>


//Colors x2
#define COLOR_SAMP 0xA9C4E4FF


//Forwards
new LastEmail[MAX_PLAYERS];
forward EmailDelivered(index, response_code, data[]);
native WP_Hash(buffer[], len, const str[]);

main()
{
    print("CountrysideTDM ");
    print(" __________________________________");
    print("Version: "VER" Map: "MAP"");
    print("This script was made and founded by "OWNER"");
}


public OnGameModeInit()
{
    for(new i=0; i < sizeof(ZoneInfo); i++)
	{
    	ZoneID[i] = GangZoneCreate(ZoneInfo[i][zMinX], ZoneInfo[i][zMinY], ZoneInfo[i][zMaxX], ZoneInfo[i][zMaxY]);
	}
	
	lift = CreateDynamicObject(19277, -97.69370, -979.29138, 25.76870,   0.00000, 0.00000, 270.22531);
    CreateBunker(-388.6623, -832.9944, 28.7678, 1071.0731,-311.3062,74.0123);
    Timerr[0] = 1;
    AllowInteriorWeapons(0);

	LoadEditedVeh();
	DisableInteriorEnterExits();
	LoadObjectsFromFile();
	ShowNameTags(1);
	EnableStuntBonusForAll(1);


    //SetTimer("MySQL_Backup", 1000 * 60* TIMEE, true);
    SetTimer("MySQL_Backup", 1000 * 60* TIMEE, true); //Debug one
    SetTimer("ZoneTimer", 1000, true);
    SetTimer("OnDeerRespawn", 600000, true);
    SetTimer("MoneyTimer", 1000, true);
    SetTimer("LoadVeh",10000, false);
    SetTimer("RandomMessage",90000, true);
    SetTimer("LoadFunc",10000, false);
    SetTimer("Kicktime",2000, false);
    SetTimer("randomweather",500000, true);
    SetTimer("HideBar",7000, true);
    SetTimer("hideshit", 5000, true);
    pTimer = SetTimer("CheckPlayer", 1000, 1);
    xReactionTimer = SetTimer("xReactionTest", TIME, 1);
    Timerr[1] = SetTimer("MoneyBag", MB_DELAY, true);

    AddPlayerClass(0,-81.5415,-1170.1486,2.2024,69.7577,0,0,0,0,0,0); // Mechanics
	AddPlayerClass(0,-82.3147,-1571.7786,2.6107,226.5034,0,0,0,0,0,0); // Hobos
	AddPlayerClass(0,-379.8123,-1438.9305,25.7266,272.7950,0,0,0,0,0,0); // Farmers
	AddPlayerClass(0,-542.1455,-501.6932,25.5234,357.9531,0,0,0,0,0,0); // Racers
	AddPlayerClass(0,-1059.0146,-1205.4634,129.2188,273.8846,0,0,0,0,0,0); // Hippies
	AddPlayerClass(0,-1059.0146,-1205.4634,129.2188,273.8846,0,0,0,0,0,0); // Police

	#if defined JOIN
	botIDs[0] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_1_MAIN_NICKNAME, BOT_1_REALNAME, BOT_1_USERNAME);
	IRC_SetIntData(botIDs[0], E_IRC_CONNECT_DELAY, 5);

	botIDs[1] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_2_MAIN_NICKNAME, BOT_2_REALNAME, BOT_2_USERNAME);
	IRC_SetIntData(botIDs[1], E_IRC_CONNECT_DELAY, 7);

	botIDs[2] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_4_MAIN_NICKNAME, BOT_4_REALNAME, BOT_4_USERNAME);
	IRC_SetIntData(botIDs[2], E_IRC_CONNECT_DELAY, 7);

	botIDs[3] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_5_MAIN_NICKNAME, BOT_5_REALNAME, BOT_5_USERNAME);
	IRC_SetIntData(botIDs[3], E_IRC_CONNECT_DELAY, 7);

	HelpBot = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_3_MAIN_NICKNAME, BOT_3_REALNAME, BOT_3_USERNAME);
	IRC_SetIntData(HelpBot, E_IRC_CONNECT_DELAY, 7);
	groupID = IRC_CreateGroup();
	#endif
    SetGameModeText("CSTDM "VER"");
    SendRconCommand("mapname "MAP"");
    SendRconCommand("hostname "HOST"");
    UsePlayerPedAnims();
    EnableVehicleFriendlyFire();
	mysql = mysql_init(LOG_ALL); // Tells sql to log all mysql features used in the script
    new Connection = mysql_connect(mysql_host, mysql_user, mysql_password, mysql_database, mysql); // connects with the mysql database
    if(Connection) //checks if the database is successfully connected
    {
        new dest[200];
        mysql_stat(dest); // display the mysql database statistics.
        printf(dest);
        printf(">> MySQL connection successfully initialized"); // if it is connected it will display this line, if not then it wont display anything.
    }
    
    	//Stats shit
        StatsText0 = TextDrawCreate(200.000000, 110.000000, "New Textdraw");
        TextDrawBackgroundColor(StatsText0, 255);
        TextDrawFont(StatsText0, 1);
        TextDrawLetterSize(StatsText0, 0.000000, 11.899996);
        TextDrawColor(StatsText0, -1);
        TextDrawSetOutline(StatsText0, 0);
        TextDrawSetProportional(StatsText0, 1);
        TextDrawSetShadow(StatsText0, 1);
        TextDrawUseBox(StatsText0, 1);
        TextDrawBoxColor(StatsText0, 0x0000008B);
        TextDrawTextSize(StatsText0, 20.000000, 0.000000);

        StatsText1 = TextDrawCreate(112.000000, 116.000000, "Player Information");
        TextDrawAlignment(StatsText1, 2);
        TextDrawBackgroundColor(StatsText1, 255);
        TextDrawFont(StatsText1, 3);
        TextDrawLetterSize(StatsText1, 0.389999, 1.700000);
        TextDrawColor(StatsText1, 65535);
        TextDrawSetOutline(StatsText1, 0);
        TextDrawSetProportional(StatsText1, 1);
        TextDrawSetShadow(StatsText1, 1);

        StatsText2 = TextDrawCreate(110.000000, 136.000000, "Name:");
        TextDrawAlignment(StatsText2, 2);
        TextDrawBackgroundColor(StatsText2, 255);
        TextDrawFont(StatsText2, 1);
        TextDrawLetterSize(StatsText2, 0.219999, 1.000000);
        TextDrawColor(StatsText2, -65281);
        TextDrawSetOutline(StatsText2, 0);
        TextDrawSetProportional(StatsText2, 1);
        TextDrawSetShadow(StatsText2, 1);

        StatsText3 = TextDrawCreate(110.000000, 146.000000, "Kills:");
        TextDrawAlignment(StatsText3, 2);
        TextDrawBackgroundColor(StatsText3, 255);
        TextDrawFont(StatsText3, 1);
        TextDrawLetterSize(StatsText3, 0.219999, 1.000000);
        TextDrawColor(StatsText3, -65281);
        TextDrawSetOutline(StatsText3, 0);
        TextDrawSetProportional(StatsText3, 1);
        TextDrawSetShadow(StatsText3, 1);

        StatsText4 = TextDrawCreate(110.000000, 156.000000, "Deaths:");
        TextDrawAlignment(StatsText4, 2);
        TextDrawBackgroundColor(StatsText4, 255);
        TextDrawFont(StatsText4, 1);
        TextDrawLetterSize(StatsText4, 0.219999, 1.000000);
        TextDrawColor(StatsText4, -65281);
        TextDrawSetOutline(StatsText4, 0);
        TextDrawSetProportional(StatsText4, 1);
        TextDrawSetShadow(StatsText4, 1);

        StatsText5 = TextDrawCreate(112.000000, 173.000000, "General Information");
        TextDrawAlignment(StatsText5, 2);
        TextDrawBackgroundColor(StatsText5, 255);
        TextDrawFont(StatsText5, 2);
        TextDrawLetterSize(StatsText5, 0.219999, 1.000000);
        TextDrawColor(StatsText5, -1);
        TextDrawSetOutline(StatsText5, 0);
        TextDrawSetProportional(StatsText5, 1);
        TextDrawSetShadow(StatsText5, 1);

        StatsText6 = TextDrawCreate(110.000000, 186.000000, "Money:");
        TextDrawAlignment(StatsText6, 2);
        TextDrawBackgroundColor(StatsText6, 255);
        TextDrawFont(StatsText6, 1);
        TextDrawLetterSize(StatsText6, 0.219999, 1.000000);
        TextDrawColor(StatsText6, -16776961);
        TextDrawSetOutline(StatsText6, 0);
        TextDrawSetProportional(StatsText6, 1);
        TextDrawSetShadow(StatsText6, 1);

        StatsText7 = TextDrawCreate(110.000000, 196.000000, "Skin:");
        TextDrawAlignment(StatsText7, 2);
        TextDrawBackgroundColor(StatsText7, 255);
        TextDrawFont(StatsText7, 1);
        TextDrawLetterSize(StatsText7, 0.219999, 1.000000);
        TextDrawColor(StatsText7, -16776961);
        TextDrawSetOutline(StatsText7, 0);
        TextDrawSetProportional(StatsText7, 1);
        TextDrawSetShadow(StatsText7, 1);

        StatsText8 = TextDrawCreate(110.000000, 206.000000, "VIP:");
        TextDrawAlignment(StatsText8, 2);
        TextDrawBackgroundColor(StatsText8, 255);
        TextDrawFont(StatsText8, 1);
        TextDrawLetterSize(StatsText8, 0.219999, 1.000000);
        TextDrawColor(StatsText8, -16776961);
        TextDrawSetOutline(StatsText8, 0);
        TextDrawSetProportional(StatsText8, 1);
        TextDrawSetShadow(StatsText8, 1);

        StatsText9 = TextDrawCreate(62.000000, 233.000000, "Extra Information");
        TextDrawBackgroundColor(StatsText9, 255);
        TextDrawFont(StatsText9, 2);
        TextDrawLetterSize(StatsText9, 0.219999, 1.000000);
        TextDrawColor(StatsText9, -1);
        TextDrawSetOutline(StatsText9, 0);
        TextDrawSetProportional(StatsText9, 1);
        TextDrawSetShadow(StatsText9, 1);

        StatsText10 = TextDrawCreate(110.000000, 246.000000, "Muted:");
        TextDrawAlignment(StatsText10, 2);
        TextDrawBackgroundColor(StatsText10, 255);
        TextDrawFont(StatsText10, 1);
        TextDrawLetterSize(StatsText10, 0.219999, 1.000000);
        TextDrawColor(StatsText10, 16711935);
        TextDrawSetOutline(StatsText10, 0);
        TextDrawSetProportional(StatsText10, 1);
        TextDrawSetShadow(StatsText10, 1);

        StatsText11 = TextDrawCreate(110.000000, 256.000000, "Warnings:");
        TextDrawAlignment(StatsText11, 2);
        TextDrawBackgroundColor(StatsText11, 255);
        TextDrawFont(StatsText11, 1);
        TextDrawLetterSize(StatsText11, 0.219999, 1.000000);
        TextDrawColor(StatsText11, 16711935);
        TextDrawSetOutline(StatsText11, 0);
        TextDrawSetProportional(StatsText11, 1);
        TextDrawSetShadow(StatsText11, 1);

        StatsText13 = TextDrawCreate(111.000000, 314.000000, "~G~- ~Y~WIll be closed in 15 seconds");
        TextDrawAlignment(StatsText13, 2);
        TextDrawBackgroundColor(StatsText13, 255);
        TextDrawFont(StatsText13, 1);
        TextDrawLetterSize(StatsText13, 0.189999, 0.699998);
        TextDrawSetOutline(StatsText13, 0);
        TextDrawSetProportional(StatsText13, 1);
        TextDrawSetShadow(StatsText13, 1);
    
    
    	MainMenu[0] = TextDrawCreate(250.000000, 343.000000, "~n~~n~~n~~n~~n~~n~");
        TextDrawAlignment(MainMenu[0], 2);
        TextDrawBackgroundColor(MainMenu[0], 255);
        TextDrawFont(MainMenu[0], 1);
        TextDrawLetterSize(MainMenu[0], 1.000000, 2.000000);
        TextDrawColor(MainMenu[0], -16776961);
        TextDrawSetOutline(MainMenu[0], 1);
        TextDrawSetProportional(MainMenu[0], 1);
        TextDrawUseBox(MainMenu[0], 1);
        TextDrawBoxColor(MainMenu[0], 255);
        TextDrawTextSize(MainMenu[0], 90.000000, 803.000000);

        /* Top Bar */
        MainMenu[1] = TextDrawCreate(250.000000, -12.000000, "~n~~n~~n~~n~~n~~n~");
        TextDrawAlignment(MainMenu[1], 2);
        TextDrawBackgroundColor(MainMenu[1], 255);
        TextDrawFont(MainMenu[1], 1);
        TextDrawLetterSize(MainMenu[1], 1.000000, 2.000000);
        TextDrawColor(MainMenu[1], -16776961);
        TextDrawSetOutline(MainMenu[1], 1);
        TextDrawSetProportional(MainMenu[1], 1);
        TextDrawUseBox(MainMenu[1], 1);
        TextDrawBoxColor(MainMenu[1], 255);
        TextDrawTextSize(MainMenu[1], 90.000000, 918.000000);

        /* Top Colored Bar */
        MainMenu[2] = TextDrawCreate(729.000000, 99.000000, "_");
        TextDrawBackgroundColor(MainMenu[2], 255);
        TextDrawFont(MainMenu[2], 1);
        TextDrawLetterSize(MainMenu[2], 50.000000, 0.099999);
        TextDrawColor(MainMenu[2], -16776961);
        TextDrawSetOutline(MainMenu[2], 0);
        TextDrawSetProportional(MainMenu[2], 1);
        TextDrawSetShadow(MainMenu[2], 1);
        TextDrawUseBox(MainMenu[2], 1);
        TextDrawBoxColor(MainMenu[2], 255);
        TextDrawTextSize(MainMenu[2], -5.000000, 1031.000000);

        /* Bottom Colored Bar */
        MainMenu[3] = TextDrawCreate(729.000000, 340.000000, "_");
        TextDrawBackgroundColor(MainMenu[3], 255);
        TextDrawFont(MainMenu[3], 1);
        TextDrawLetterSize(MainMenu[3], 50.000000, 0.099999);
        TextDrawColor(MainMenu[3], -16776961);
        TextDrawSetOutline(MainMenu[3], 0);
        TextDrawSetProportional(MainMenu[3], 1);
        TextDrawSetShadow(MainMenu[3], 1);
        TextDrawUseBox(MainMenu[3], 1);
        TextDrawBoxColor(MainMenu[3], 255);
        TextDrawTextSize(MainMenu[3], -5.000000, 1031.000000);

        //mech
        logo = TextDrawCreate(320 ,10 , "Welcome to..."); //X = Left/Right || Y = UP/Down
		TextDrawFont(logo , 1);
		TextDrawLetterSize(logo , 0.6, 4);
		TextDrawColor(logo , 0xAFAFAFAA); //grey or smth
		TextDrawAlignment(logo, 2);
		TextDrawSetOutline(logo , true);
		TextDrawSetProportional(logo , true);
		TextDrawSetShadow(logo , 1);

		logo2 = TextDrawCreate(320 ,50 , "CountrySide Team Deathmatch"); //X = Left/Right || Y = UP/Down
		TextDrawFont(logo2 , 1);
		TextDrawLetterSize(logo2 , 0.4, 2);
		TextDrawColor(logo2 , 0xAFAFAFAA); //grey or smth
		TextDrawAlignment(logo2, 2);
		TextDrawSetOutline(logo2 , true);
		TextDrawSetProportional(logo2 , true);
		TextDrawSetShadow(logo2 , 1);

		Timer = TextDrawCreate(320, 380, "_");
		TextDrawFont(Timer, 1);
		TextDrawLetterSize(Timer, 0.500000, 1.000000);
        TextDrawColor(Timer , 0xAFAFAFAA);
		TextDrawSetProportional(Timer, 1);
		TimeM = 20;
		TimeS = 0;
		Time = SetTimer("UpdateTime", 1000, false);

		killname = TextDrawCreate(320 ,380 , "_"); //X = Left/Right || Y = UP/Down
		TextDrawFont(killname , 2);
		TextDrawLetterSize(killname , 0.4, 3);
		TextDrawColor(killname , 0xAFAFAFAA);
		TextDrawAlignment(killname, 2);
		TextDrawSetOutline(killname , true);
		TextDrawSetProportional(killname , true);
		TextDrawSetShadow(killname , 1);

  		dmginfo = TextDrawCreate(130 ,355 , "_"); //X = Left/Right || Y = UP/Down
		TextDrawFont(dmginfo , 1);
		TextDrawLetterSize(dmginfo , 0.5, 1.5);
		TextDrawColor(dmginfo , 0xAFAFAFAA);
		TextDrawAlignment(dmginfo, 2);
		TextDrawSetOutline(dmginfo , true);
		TextDrawSetProportional(dmginfo , true);
		TextDrawSetShadow(dmginfo , 1);

		killergun = TextDrawCreate(460, 380 , "Weapon:");
		TextDrawFont(killergun , 1);
		TextDrawLetterSize(killergun , 0.5, 1.5);
		TextDrawColor(killergun , 0xAFAFAFAA);
		TextDrawSetOutline(killergun , false);
		TextDrawSetProportional(killergun , true);
		TextDrawSetShadow(killergun , 1);

		killwep = TextDrawCreate(463, 400 , "_");
		TextDrawFont(killwep , 3);
		TextDrawLetterSize(killwep , 0.5, 1.5);
		TextDrawColor(killwep , 0xAFAFAFAA);
		TextDrawSetOutline(killwep , false);
		TextDrawSetProportional(killwep , true);
		TextDrawSetShadow(killwep , 1);

		killerinfo = TextDrawCreate(130 ,345 , "Info:"); //X = Left/Right || Y = UP/Down
		TextDrawFont(killerinfo , 1);
		TextDrawLetterSize(killerinfo , 0.5, 1.5);
		TextDrawColor(killerinfo , 0xAFAFAFAA);
		TextDrawAlignment(killerinfo, 2);
		TextDrawSetOutline(killerinfo , true);
		TextDrawSetProportional(killerinfo , true);
		TextDrawSetShadow(killerinfo , 1);

		test = TextDrawCreate(130 ,340 , "Class Skins"); //X = Left/Right || Y = UP/Down
		TextDrawFont(test , 1);
		TextDrawLetterSize(test , 0.5, 1.5);
		TextDrawColor(test , 0xAFAFAFAA);
		TextDrawAlignment(test, 2);
		TextDrawSetOutline(test , true);
		TextDrawSetProportional(test , true);
		TextDrawSetShadow(test , 1);

		mech = TextDrawCreate(320 ,335 , "Mechanic"); //X = Left/Right || Y = UP/Down
		TextDrawFont(mech , 2);
		TextDrawLetterSize(mech , 0.4, 3);
		TextDrawColor(mech , 0x0900ffFF);
		TextDrawAlignment(mech, 2);
		TextDrawSetOutline(mech , true);
		TextDrawSetProportional(mech , true);
		TextDrawSetShadow(mech , 1);

		hobo = TextDrawCreate(320 ,335 , "Hobo"); //X = Left/Right || Y = UP/Down
		TextDrawFont(hobo , 2);
		TextDrawLetterSize(hobo , 0.4, 3);
		TextDrawColor(hobo , 0xFF0000AA);
		TextDrawAlignment(hobo, 2);
		TextDrawSetOutline(hobo , true);
		TextDrawSetProportional(hobo , true);
		TextDrawSetShadow(hobo , 1);

		farmer = TextDrawCreate(320 ,335 , "Farmer"); //X = Left/Right || Y = UP/Down
		TextDrawFont(farmer , 2);
		TextDrawLetterSize(farmer , 0.4, 3);
		TextDrawColor(farmer , 0x008000FF);
		TextDrawAlignment(farmer, 2);
		TextDrawSetOutline(farmer , true);
		TextDrawSetProportional(farmer , true);
		TextDrawSetShadow(farmer , 1);

		race = TextDrawCreate(320 ,335 , "Racer"); //X = Left/Right || Y = UP/Down
		TextDrawFont(race , 2);
		TextDrawLetterSize(race , 0.4, 3);
		TextDrawColor(race , 0xAFAFAFAA);
		TextDrawAlignment(race, 2);
		TextDrawSetOutline(race , true);
		TextDrawSetProportional(race , true);
		TextDrawSetShadow(race , 1);

		hippy = TextDrawCreate(320 ,335 , "Hippy"); //X = Left/Right || Y = UP/Down
		TextDrawFont(hippy , 2);
		TextDrawLetterSize(hippy , 0.4, 3);
		TextDrawColor(hippy , 0xFF4500AA);
		TextDrawAlignment(hippy, 2);
		TextDrawSetOutline(hippy , true);
		TextDrawSetProportional(hippy , true);
		TextDrawSetShadow(hippy , 1);
		
		sherif = TextDrawCreate(320 ,335 , "Sheriff"); //X = Left/Right || Y = UP/Down
		TextDrawFont(sherif , 2);
		TextDrawLetterSize(sherif , 0.4, 3);
		TextDrawColor(sherif , COLOR_PURPLE);
		TextDrawAlignment(sherif, 2);
		TextDrawSetOutline(sherif , true);
		TextDrawSetProportional(sherif , true);
		TextDrawSetShadow(sherif , 1);

		rules[0] = TextDrawCreate(170 ,350 , "> No Hacking or cleo modifications");
		TextDrawFont(rules[0] , 1);
		TextDrawLetterSize(rules[0] , 0.4, 1);
		TextDrawColor(rules[0] , 0xFF0000AA);
		TextDrawSetOutline(rules[0] , false);
		TextDrawSetProportional(rules[1] , true);
		TextDrawSetShadow(rules[0] , 1);

		rules[1] = TextDrawCreate(170 ,365 , "> No spawnkilling / stay away from team spawns");
		TextDrawFont(rules[1] , 1);
		TextDrawLetterSize(rules[1] , 0.4, 1);
		TextDrawColor(rules[1] , 0xFF0000AA);
		TextDrawSetOutline(rules[1] , false);
		TextDrawSetProportional(rules[1] , true);
		TextDrawSetShadow(rules[1] , 1);

		rules[2] = TextDrawCreate(170 ,380 , "> Flaming and disrespect will not be tolerated");
		TextDrawFont(rules[2] , 1);
		TextDrawLetterSize(rules[2] , 0.4, 1);
		TextDrawColor(rules[2] , 0xFF0000AA);
		TextDrawSetOutline(rules[2] , false);
		TextDrawSetProportional(rules[2] , true);
		TextDrawSetShadow(rules[2] , 1);

		rules[3] = TextDrawCreate(170 ,395 , "> No spaming the chat with usuless requests");
		TextDrawFont(rules[3] , 1);
		TextDrawLetterSize(rules[3] , 0.4, 1);
		TextDrawColor(rules[3] , 0xFF0000AA);
		TextDrawSetOutline(rules[3] , false);
		TextDrawSetProportional(rules[3] , true);
		TextDrawSetShadow(rules[3] , 1);

		rules[4] = TextDrawCreate(170 ,410 , "> Don't be an asshat");
		TextDrawFont(rules[4] , 1);
		TextDrawLetterSize(rules[4] , 0.4, 1);
		TextDrawColor(rules[4] , 0xFF0000AA);
		TextDrawSetOutline(rules[4] , false);
		TextDrawSetProportional(rules[4] , true);
		TextDrawSetShadow(rules[4] , 1);

		pclass = TextDrawCreate(460, 340 , "Player Class");
		TextDrawFont(pclass , 1);
		TextDrawLetterSize(pclass , 0.5, 1.5);
		TextDrawColor(pclass , 0xAFAFAFAA);
		TextDrawSetOutline(pclass , false);
		TextDrawSetProportional(pclass , true);
		TextDrawSetShadow(pclass , 1);

		//Mechanic Guns
		gunlist1 = TextDrawCreate(480, 360 , "- Deagle");
		TextDrawFont(gunlist1 , 3);
		TextDrawLetterSize(gunlist1 , 0.3, 1.0);
		TextDrawColor(gunlist1 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist1 , true);

		gunlist2 = TextDrawCreate(480, 372 , "- Shotgun");
		TextDrawFont(gunlist2 , 3);
		TextDrawLetterSize(gunlist2 , 0.3, 1.0);
		TextDrawColor(gunlist2 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist2 , true);

		gunlist3 = TextDrawCreate(480, 384 , "- Sniper");
		TextDrawFont(gunlist3 , 3);
		TextDrawLetterSize(gunlist3 , 0.3, 1.0);
		TextDrawColor(gunlist3 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist3 , true);

		//HOBO guns
		gunlist4 = TextDrawCreate(480, 360 , "- Pistol");
		TextDrawFont(gunlist4 , 3);
		TextDrawLetterSize(gunlist4 , 0.3, 1.0);
		TextDrawColor(gunlist4 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist4 , true);

		gunlist5 = TextDrawCreate(480, 372 , "- Spas-12");
		TextDrawFont(gunlist5 , 3);
		TextDrawLetterSize(gunlist5 , 0.3, 1.0);
		TextDrawColor(gunlist5 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist5 , true);

		gunlist6 = TextDrawCreate(480, 384 , "- Rifle");
		TextDrawFont(gunlist6 , 3);
		TextDrawLetterSize(gunlist6 , 0.3, 1.0);
		TextDrawColor(gunlist6 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist6 , true);

		//Farmer Guns
		gunlist7 = TextDrawCreate(480, 360 , "- Deagle");
		TextDrawFont(gunlist7 , 3);
		TextDrawLetterSize(gunlist7 , 0.3, 1.0);
		TextDrawColor(gunlist7 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist7 , true);

		gunlist8 = TextDrawCreate(480, 372 , "- Mp5");
		TextDrawFont(gunlist8 , 3);
		TextDrawLetterSize(gunlist8 , 0.3, 1.0);
		TextDrawColor(gunlist8 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist8 , true);

		gunlist9 = TextDrawCreate(480, 384 , "- Rifle");
		TextDrawFont(gunlist9 , 3);
		TextDrawLetterSize(gunlist9 , 0.3, 1.0);
		TextDrawColor(gunlist9 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist9 , true);

		//Racer Guns
		gunlist10 = TextDrawCreate(480, 360 , "- Silenced Pistol");
		TextDrawFont(gunlist10 , 3);
		TextDrawLetterSize(gunlist10 , 0.3, 1.0);
		TextDrawColor(gunlist10 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist10 , true);

		gunlist11 = TextDrawCreate(480, 372 , "- Spas-12");
		TextDrawFont(gunlist11 , 3);
		TextDrawLetterSize(gunlist11 , 0.3, 1.0);
		TextDrawColor(gunlist11 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist11 , true);

		gunlist12 = TextDrawCreate(480, 384 , "- M4 Assult");
		TextDrawFont(gunlist12 , 3);
		TextDrawLetterSize(gunlist12 , 0.3, 1.0);
		TextDrawColor(gunlist12 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist12 , true);

		//Hippy Guns
		gunlist13 = TextDrawCreate(480, 360 , "- Deagle");
		TextDrawFont(gunlist13 , 3);
		TextDrawLetterSize(gunlist13 , 0.3, 1.0);
		TextDrawColor(gunlist13 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist13 , true);

		gunlist14 = TextDrawCreate(480, 372 , "- Spas-12");
		TextDrawFont(gunlist14 , 3);
		TextDrawLetterSize(gunlist14 , 0.3, 1.0);
		TextDrawColor(gunlist14 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist14 , true);

		gunlist15 = TextDrawCreate(480, 384 , "- AK-47 Assult");
		TextDrawFont(gunlist15 , 3);
		TextDrawLetterSize(gunlist15 , 0.3, 1.0);
		TextDrawColor(gunlist15 , 0xAFAFAFAA);
		TextDrawSetProportional(gunlist15 , true);

		return 1;
}

public OnGameModeExit()
{
    for(new i; i<=MaxDeer; i++)
    {
    	DestroyObject(DeerCreated[i]);
   	}
    DestroyTD();
    KillTimer(pTimer);
    foreach(Player, i)
    if(IsPlayerConnected(i) && IsPaused[i] == 1)
	DestroyDynamic3DTextLabel(pauseLaber[i]);
    IRC_Quit(botIDs[0], "Restart");
	IRC_Quit(botIDs[1], "Restart");
	IRC_Quit(botIDs[3], "Restart");
	IRC_Quit(botIDs[2], "Restart");
	KillTimer(xReactionTimer);
	IRC_DestroyGroup(groupID);
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
    if(pickupid == parachute)
	{
		GivePlayerWeapon(playerid, 46, 1);
	}
	if(pickupid == sniper)
	{
		GivePlayerWeapon(playerid, 34, 50);
	}
    if(pickupid == HouseInformation[bunkerid][Bunkerrrr][0])
	{
		//SetPlayerPos(playerid, 1071.0731,-311.3062,74.0123);
		SetPlayerPos(playerid, 1071.0731,-311.3062,74.0123);
	}
	if(pickupid == HouseInformation[bunkerid][Bunkerrrr][1])
	{
		SetPlayerPos(playerid, -388.6623, -832.9944, 28.7678);
  		SetPlayerInterior(playerid, 0); //Sets the player back to interior 0 (Outside)
    	SetPlayerVirtualWorld(playerid, 0);
	}
    if(pickupid == MoneyBagPickup)
	{
		new string[180], pname[24], money = MoneyBagCash, Query[500];
		GetPlayerName(playerid, pname, 24);
		format(string, sizeof(string), "** {99FFFF}%s Has found the Tiki! Containing %d it was at %s", pname, money, MoneyBagLocation);
        new ircMsg[256];
        format(ircMsg, sizeof(ircMsg), "%s Has found the Tiki Containing ($%d) - It was at %s", pname, money, MoneyBagLocation);
		IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
		MoneyBagFound = 1;
		SendClientMessageToAll(-1, string);
		DestroyPickup(MoneyBagPickup);
		SendClientMessage(playerid, COLOR_LIGHTRED, "You have found the Tiki!");
		GivePlayerMoney(playerid, money);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
		sInfo[playerid][TikisFound] ++;
		format(Query, 500, "UPDATE `ServerInfo` SET `TikisFound` = '%d' WHERE `Server` = 'CountryTDM' LIMIT 1",
	 	sInfo[playerid][TikisFound]);
	 	mysql_query(Query);
		Timerr[0] = 1;
	}
	if(pickupid == MechBunker)
    {
        	SetPlayerInterior(playerid, 8);
        	SetPlayerPos(playerid, 2819.5542, -1169.6241, 1025.5703);
       	 	SetPlayerVirtualWorld(playerid, 420);
       	 	SetTimer("InteriorEntered",2000,0);
       	 	SetTimerEx("FreezeTime", 2000, false, "i", playerid);
       	 	TogglePlayerControllable(playerid, 0);
   	}
    else if(pickupid == MechBunkerExit)
    {
        SetPlayerInterior(playerid, 0);
        SetPlayerPos(playerid, -86.5241, -1213.9993, 3.1278);
        SetPlayerVirtualWorld(playerid, 0);
        SetTimer("InteriorEntered",2000,0);
    }
    else if(pickupid == HPpickup)
    {
        SetPlayerHealth(playerid, 95);
    }
    else if(pickupid == FarmerBunker) //Farmer stuff
    {
        SetPlayerInterior(playerid, 8);
        SetPlayerPos(playerid, 2819.5542, -1169.6241, 1025.5703);
        SetPlayerVirtualWorld(playerid, 421);
        SetTimer("FreezeTime", 2000, false);
 	 	//TogglePlayerControllable(playerid, 0);
    }
    else if(pickupid == FarmerBunkerExit)
    {
        SetPlayerInterior(playerid, 0);
        SetPlayerPos(playerid, -392.4128,-1446.6879,26.1091);
        SetPlayerVirtualWorld(playerid, 0);
        SetTimer("InteriorEntered",2000,0);
    }
    else if(pickupid == RacerBunker) //racer stuff
    {
        //SetPlayerInterior(playerid, 1);
        SetPlayerPos(playerid, -553.4930,-527.7111,694.4922);
        SetPlayerVirtualWorld(playerid, 0);
        SetTimer("InteriorEntered",2000,0);
        SetTimer("FreezeTime", 2000, false);
 	 	TogglePlayerControllable(playerid, 0);
    }
    else if(pickupid == RacerBunkerExit)
    {
        SetPlayerPos(playerid, -512.6431, -539.9963, 25.5234);
        SetPlayerVirtualWorld(playerid, 0);
    }
    else if(pickupid == RacerAmmo)
    {
		SetPlayerAmmo(playerid, 23, 220);
		SetPlayerAmmo(playerid, 27, 220);
		SetPlayerAmmo(playerid, 31, 220);
		SetPlayerAmmo(playerid, 28, 220);
    }
    else if(pickupid == Ammo1)
    {
        SetPlayerPos(playerid, 296.919982,-108.071998,1001.515625);
        SetPlayerInterior(playerid, 6);
        SetTimer("InteriorEntered",2000,0);
    }
    else if(pickupid == Ammo2)
    {
        SetPlayerPos(playerid, 316.524993,-167.706985,999.593750);
        SetPlayerInterior(playerid, 6);
        SetTimer("InteriorEntered",2000,0);
    }
    else if(pickupid == Ammo1Exit)
    {
        SetPlayerPos(playerid, -381.5427, -1150.7982, 69.4410);
        SetPlayerInterior(playerid, 0);
        SetTimer("InteriorEntered",2000,0);
    }
    else if(pickupid == Ammo2Exit)
    {
        SetPlayerPos(playerid, -585.5237, -1054.3856, 23.5149);
        SetPlayerInterior(playerid, 0);
        SetTimer("InteriorEntered",2000,0);
    }
    return 1;
}
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    for(new x; x<houseid; x++) //Loops through all current house ids.
    {
        if(HouseInformation[x][checkpointidx][0] == checkpointid) //If the entry checkpoint is entry checkpoint.
        {
            if(InHouse[playerid] != -1)
            {
                InHouse[playerid] = -1; //Sets the player to outside the house.
                return 1;
            }
            InHouseCP[playerid] = x; //Sets the InHouseCP variable.
            new Pname[24]; //Pname variable.
            GetPlayerName(playerid, Pname, 24); //Gets the players name.
            if(HouseInformation[x][owner][0] != 0 && !strcmp(Pname, HouseInformation[x][owner][0]))
            //The line above checks that the owner string has something in it, then it
            //Will compare it to our current player.
            {
                SetPlayerPos(playerid, HouseInformation[x][TelePos][0], HouseInformation[x][TelePos][1], HouseInformation[x][TelePos][2]); //Sets players position where x = houseid.
                SetPlayerInterior(playerid, HouseInformation[x][interiors]); //Sets players interior
                SetPlayerVirtualWorld(playerid, 15500000 + x); //Sets the virtual world
                //This is used if you want multiple houses per interior.
                 //Sets the inhouse variable to the house he's in.
            }
            if(!HouseInformation[x][owner][0]) SendClientMessage(playerid, -1, "This house is for sale /buy to buy it!");
            //If there is no owner, it will send a message telling the player to buy it :).
            return 1;
            //We do this so the loop doesn't continue after or it tries to go for more checkpoints
            //We could alternitivly use break;
        }
        if(HouseInformation[x][checkpointidx][1] == checkpointid) //If the player enters the house exit.
        {
            if(InHouse[playerid] == -1)
            {
                InHouse[playerid] = x;
                return 1;
            }
            SetPlayerPos(playerid, HouseInformation[x][EnterPos][0], HouseInformation[x][EnterPos][1], HouseInformation[x][EnterPos][2]);
            SetPlayerInterior(playerid, 0); //Sets the player back to interior 0 (Outside)
            SetPlayerVirtualWorld(playerid, 0); //Sets the players Virtual world to 0.
            return 1;
            //We do this so the loop doesn't continue after or it tries to go for more checkpoints
            //We could alternitivly use break;
        }
	}
    if(checkpointid == MechanicTele) // This checks if our variable equals to 1, if so: it continues
    {
            SetPlayerInterior(playerid, 0);
        	SendClientMessage(playerid, 0xFFFFFFFF, "You have entered the Telescope. /Exit to go back.");
        	SetPlayerCameraPos(playerid, -116.2573, -1236.3292, 23.3212);
			SetPlayerCameraLookAt(playerid, -116.4609, -1235.3435, 23.0813);
			SetPlayerPos(playerid, -118.0731, -1230.5809, -11.9585);
			TogglePlayerControllable(playerid,0);
			SetPlayerVirtualWorld(playerid, 0);

	}
	if(checkpointid == FarmerTele) // This checks if our variable equals to 1, if so: it continues
    {
            SetPlayerInterior(playerid, 0);
        	SendClientMessage(playerid, 0xFFFFFFFF, "You have entered the Telescope. /Exit to go back.");
        	SetPlayerCameraPos(playerid, -367.7620, -1444.7732, 43.1534);
			SetPlayerCameraLookAt(playerid, -366.9767, -1444.1437, 42.8084);
			SetPlayerPos(playerid, -362.0396, -1448.6719, 8.5552);
			TogglePlayerControllable(playerid,0);
			SetPlayerVirtualWorld(playerid, 0);

	}
	if(checkpointid == GunMenu1) // This checks if our variable equals to 1, if so: it continues
    {
        	SendClientMessage(playerid, 0xFFFFFFFF, "You can now buy weapons, remember you can get in to negative money! Be carfull");
			ShowPlayerDialog(playerid, DIALOG_GUN, DIALOG_STYLE_LIST, "Select a Weapon", "M4 Assult Rifle - 20,000 \nPump Action Shotgun - 15,000 \nMp5 Fully Automatic - 10,000",
		 	"Buy", "Cancel");
	}
	if(checkpointid == GunMenu2) // This checks if our variable equals to 1, if so: it continues
    {
        	SendClientMessage(playerid, 0xFFFFFFFF, "You can now buy weapons, remember you can get in to negative money! Be carfull");
			ShowPlayerDialog(playerid, DIALOG_GUN, DIALOG_STYLE_LIST, "Select a Weapon", "M4 Assult Rifle - 20,000 \nPump Action Shotgun - 15,000 \nMp5 Fully Automatic - 10,000",
		 	"Buy", "Cancel");
	}
  	return 1;
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
    if(InHouseCP[playerid] != - 1) InHouseCP[playerid] = -1; //Sets the players InHouseCP variable to 0.
    return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    if(Bomb[playerid] == 1)
    {
        new currentveh;
		currentveh = GetPlayerVehicleID(playerid);
		GetVehiclePos(currentveh, xxxx, yyyy, zzzz);
    	SetTimer("BombBoom", 15000, false);
	}
    return 1;
}

forward BombBoom(playerid);
public BombBoom(playerid)
{
	SendClientMessage(playerid, COLOR_ORANGE, "BOOM!");
	CreateExplosion(xxxx,yyyy,zzzz,7,30.0);
	Bomb[playerid] = 0;
}
public OnPlayerRequestClass(playerid, classid)
{
    Spawned[playerid] = 0;
    TextDrawHideForAll(kbText[playerid]);
    TextDrawHideForAll(disconnect[playerid]);
    TogglePlayerKillBox(playerid, false); //Fixes some buggy TD's
    new Query[500];
    format(Query, 500, "UPDATE `playerdata` SET `ping` = '%d' WHERE `nick` = '%s' LIMIT 1",
        GetPlayerPing(playerid),
        pInfo[playerid][Nick]);
        mysql_query(Query);
    SetPVarInt(playerid, "spawned", 0);
    TextDrawHideForPlayer(playerid, killerinfo);
   	TextDrawHideForPlayer(playerid, killergun);
    TextDrawHideForPlayer(playerid, killname);
    SetPlayerWeather(playerid, 4); //make it rain on class selection
    SetPlayerTime(playerid,0,0); //Make it night at class selection
    for(new i=0; i<sizeof(MainMenu); i++)
	{
	    TextDrawShowForPlayer(playerid, pclass);
	    TextDrawShowForPlayer(playerid, MainMenu[i]);
	    TextDrawHideForPlayer(playerid, rules[i]); //remove the rules one from connect
	    PlayerTextDrawShow(playerid, deagle);
		switch(classid)
    	{
        case 0://done
        {
            PlayerTextDrawShow(playerid, skin0);
            PlayerTextDrawShow(playerid, skin1);
            PlayerTextDrawShow(playerid, skin2);
            PlayerTextDrawHide(playerid, skin3);
            PlayerTextDrawHide(playerid, skin4);
            PlayerTextDrawHide(playerid, skin5);
            PlayerTextDrawHide(playerid, skin6);
            PlayerTextDrawHide(playerid, skin7);
            PlayerTextDrawHide(playerid, skin8);
            TextDrawShowForPlayer(playerid, test);
            TextDrawShowForPlayer(playerid, gunlist1); //show
            TextDrawShowForPlayer(playerid, gunlist2);//show
            TextDrawShowForPlayer(playerid, gunlist3);//show
            TextDrawHideForPlayer(playerid, gunlist4);
    		TextDrawHideForPlayer(playerid, gunlist5);
    		TextDrawHideForPlayer(playerid, gunlist6);
    		TextDrawHideForPlayer(playerid, gunlist7);
    		TextDrawHideForPlayer(playerid, gunlist8);
    		TextDrawHideForPlayer(playerid, gunlist9);
    		TextDrawHideForPlayer(playerid, gunlist10);
    		TextDrawHideForPlayer(playerid, gunlist11);
    		TextDrawHideForPlayer(playerid, gunlist12);
    		TextDrawHideForPlayer(playerid, gunlist13);
    		TextDrawHideForPlayer(playerid, gunlist14);
    		TextDrawHideForPlayer(playerid, gunlist15);
            TextDrawHideForPlayer(playerid, race);
            TextDrawHideForPlayer(playerid, sherif);
            TextDrawHideForPlayer(playerid, farmer);
		   	TextDrawShowForPlayer(playerid, mech);
		   	TextDrawHideForPlayer(playerid, hobo);
		   	TextDrawHideForPlayer(playerid, hippy);
           	gTeam[playerid] = TEAM_MECH;
           	SetPlayerPos(playerid, -101.8532,-1164.3069,2.6918);
           	InterpolateCameraPos(playerid, -104.883636, -1142.983154, 5.064523, -113.198249, -1162.131103, 5.064523, 5000);
			InterpolateCameraLookAt(playerid, -100.425628, -1144.919067, 3.890434, -108.740242, -1164.067016, 3.890434, 5000);
		   	SetPlayerFacingAngle( playerid, 90);
		   	SetPlayerSkin(playerid, 42);
		   	SetPlayerFacingAngle( playerid, 90);
		   	ApplyAnimation(playerid,"PLAYIDLES","shift",4.1,1,1,1,1,1,1);
        }

        case 1://done
        {
       		PlayerTextDrawHide(playerid, skin9);
            PlayerTextDrawHide(playerid, skin10);
            PlayerTextDrawHide(playerid, skin11);
            PlayerTextDrawHide(playerid, skin0);
            PlayerTextDrawShow(playerid, skin3);
            PlayerTextDrawShow(playerid, skin4);
            PlayerTextDrawShow(playerid, skin5);
            PlayerTextDrawHide(playerid, skin1);
            PlayerTextDrawHide(playerid, skin2);
            PlayerTextDrawHide(playerid, skin6);
            PlayerTextDrawHide(playerid, skin7);
            PlayerTextDrawHide(playerid, skin8);
            PlayerTextDrawHide(playerid, skin15);
            PlayerTextDrawHide(playerid, skin16);
            PlayerTextDrawHide(playerid, skin17);
            TextDrawHideForPlayer(playerid, gunlist7);
    		TextDrawHideForPlayer(playerid, gunlist8);
    		TextDrawHideForPlayer(playerid, gunlist9);
        	TextDrawHideForPlayer(playerid, gunlist1);
    		TextDrawHideForPlayer(playerid, gunlist2);
    		TextDrawHideForPlayer(playerid, gunlist3);
    		TextDrawShowForPlayer(playerid, gunlist4); //show
            TextDrawShowForPlayer(playerid, gunlist5); //show
            TextDrawShowForPlayer(playerid, gunlist6); //show
            TextDrawHideForPlayer(playerid, gunlist10);
    		TextDrawHideForPlayer(playerid, gunlist11);
    		TextDrawHideForPlayer(playerid, gunlist12);
    		TextDrawHideForPlayer(playerid, gunlist13);
    		TextDrawHideForPlayer(playerid, gunlist14);
    		TextDrawHideForPlayer(playerid, gunlist15);
        	TextDrawHideForPlayer(playerid, race);
            TextDrawHideForPlayer(playerid, farmer);
           	TextDrawHideForPlayer(playerid, mech);
           	TextDrawShowForPlayer(playerid, hobo);
           	TextDrawHideForPlayer(playerid, sherif);
           	TextDrawHideForPlayer(playerid, hippy);
           	gTeam[playerid] = TEAM_HOBO;
           	SetPlayerPos(playerid, -60.9661, -1592.0226, 2.6107);
           	SetPlayerFacingAngle(playerid,223.3611);
           	InterpolateCameraPos(playerid, -61.397842, -1608.996215, 5.349866, -53.531688, -1600.880004, 5.349866, 2000);
			InterpolateCameraLookAt(playerid, -64.933143, -1605.570312, 4.475479, -57.066989, -1597.454101, 4.475479, 2000);
           	SetPlayerSkin(playerid, 79);
           	ApplyAnimation(playerid,"PLAYIDLES","shift",4.1,1,1,1,1,1,1);
           	SetPlayerFacingAngle( playerid, 90);

        }
        case 2://done
        {
       		PlayerTextDrawHide(playerid, skin9);
            PlayerTextDrawHide(playerid, skin10);
            PlayerTextDrawHide(playerid, skin11);
            PlayerTextDrawHide(playerid, skin0);
            PlayerTextDrawHide(playerid, skin4);
            PlayerTextDrawHide(playerid, skin5);
            PlayerTextDrawHide(playerid, skin3);
            PlayerTextDrawHide(playerid, skin1);
            PlayerTextDrawHide(playerid, skin2);
            PlayerTextDrawShow(playerid, skin6);
            PlayerTextDrawShow(playerid, skin7);
            PlayerTextDrawShow(playerid, skin8);
            PlayerTextDrawHide(playerid, skin15);
            PlayerTextDrawHide(playerid, skin16);
            PlayerTextDrawHide(playerid, skin17);
            TextDrawShowForPlayer(playerid, gunlist7); //show
            TextDrawShowForPlayer(playerid, gunlist8);//show
            TextDrawShowForPlayer(playerid, gunlist9);//show
            TextDrawHideForPlayer(playerid, gunlist1);
    		TextDrawHideForPlayer(playerid, gunlist2);
    		TextDrawHideForPlayer(playerid, gunlist3);
    		TextDrawHideForPlayer(playerid, gunlist4);
    		TextDrawHideForPlayer(playerid, gunlist5);
    		TextDrawHideForPlayer(playerid, gunlist6);
            TextDrawHideForPlayer(playerid, race);
            TextDrawShowForPlayer(playerid, farmer);
            TextDrawHideForPlayer(playerid, mech);
           	TextDrawHideForPlayer(playerid, hobo);
           	TextDrawHideForPlayer(playerid, hippy);
           	TextDrawHideForPlayer(playerid, gunlist10);
    		TextDrawHideForPlayer(playerid, gunlist11);
    		TextDrawHideForPlayer(playerid, gunlist12);
    		TextDrawHideForPlayer(playerid, gunlist13);
    		TextDrawHideForPlayer(playerid, gunlist14);
    		TextDrawHideForPlayer(playerid, sherif);
    		TextDrawHideForPlayer(playerid, gunlist15);
           	gTeam[playerid] = TEAM_FARM;
           	SetPlayerPos(playerid, -380.2577,-1441.5510,25.7266);
           	InterpolateCameraPos(playerid, -372.994781, -1455.148437, 26.490375, -371.752227, -1438.153320, 26.490375, 5000);
			InterpolateCameraLookAt(playerid, -377.976776, -1454.784179, 26.273256, -376.747833, -1438.242309, 26.300577, 5000);
           	SetPlayerSkin(playerid, 159);
           	ApplyAnimation(playerid,"PLAYIDLES","shift",4.1,1,1,1,1,1,1);
           	SetPlayerFacingAngle( playerid, 90);

        }
        case 3://done
        {

            PlayerTextDrawShow(playerid, skin9);
            PlayerTextDrawShow(playerid, skin10);
            PlayerTextDrawShow(playerid, skin11);
            PlayerTextDrawHide(playerid, skin6);
            PlayerTextDrawHide(playerid, skin7);
            PlayerTextDrawHide(playerid, skin8);
            PlayerTextDrawHide(playerid, skin0);
            PlayerTextDrawHide(playerid, skin4);
            PlayerTextDrawHide(playerid, skin5);
            PlayerTextDrawHide(playerid, skin3);
            PlayerTextDrawHide(playerid, skin1);
            PlayerTextDrawHide(playerid, skin2);
            PlayerTextDrawHide(playerid, skin15);
            PlayerTextDrawHide(playerid, skin16);
            PlayerTextDrawHide(playerid, skin17);
            TextDrawShowForPlayer(playerid, gunlist10);
    		TextDrawShowForPlayer(playerid, gunlist11);
    		TextDrawShowForPlayer(playerid, gunlist12);
            TextDrawHideForPlayer(playerid, gunlist7);
    		TextDrawHideForPlayer(playerid, gunlist8);
    		TextDrawHideForPlayer(playerid, gunlist9);
            TextDrawHideForPlayer(playerid, gunlist1);
    		TextDrawHideForPlayer(playerid, gunlist2);
    		TextDrawHideForPlayer(playerid, gunlist3);
    		TextDrawHideForPlayer(playerid, gunlist4);
    		TextDrawHideForPlayer(playerid, gunlist5);
    		TextDrawHideForPlayer(playerid, gunlist6);
    		TextDrawHideForPlayer(playerid, gunlist13);
    		TextDrawHideForPlayer(playerid, gunlist14);
    		TextDrawHideForPlayer(playerid, gunlist15);
            TextDrawShowForPlayer(playerid, race);
            TextDrawHideForPlayer(playerid, farmer);
            TextDrawHideForPlayer(playerid, mech);
            TextDrawHideForPlayer(playerid, hobo);
            TextDrawHideForPlayer(playerid, hippy);
            TextDrawHideForPlayer(playerid, sherif);
           	gTeam[playerid] = TEAM_RACE;
           	SetPlayerPos(playerid, -544.1219,-500.7929,25.5234);
           	InterpolateCameraPos(playerid, -522.194641, -491.045227, 27.906147, -539.361633, -490.803253, 27.906147, 2000);
			InterpolateCameraLookAt(playerid, -522.263427, -495.927520, 26.829795, -539.473022, -495.679992, 26.808443, 2000);
		   	SetPlayerSkin(playerid, 6);
		   	ApplyAnimation(playerid,"PLAYIDLES","shift",4.1,1,1,1,1,1,1);
		   	SetPlayerFacingAngle( playerid, 90);

        }
        case 4://done
        {
            PlayerTextDrawShow(playerid, skin12);
            PlayerTextDrawShow(playerid, skin13);
            PlayerTextDrawShow(playerid, skin14);
       		PlayerTextDrawHide(playerid, skin9);
            PlayerTextDrawHide(playerid, skin10);
            PlayerTextDrawHide(playerid, skin11);
            PlayerTextDrawHide(playerid, skin6);
            PlayerTextDrawHide(playerid, skin7);
            PlayerTextDrawHide(playerid, skin8);
            PlayerTextDrawHide(playerid, skin0);
            PlayerTextDrawHide(playerid, skin4);
            PlayerTextDrawHide(playerid, skin5);
            PlayerTextDrawHide(playerid, skin3);
            PlayerTextDrawHide(playerid, skin1);
            PlayerTextDrawHide(playerid, skin2);
            PlayerTextDrawHide(playerid, skin15);
            PlayerTextDrawHide(playerid, skin16);
            PlayerTextDrawHide(playerid, skin17);
            TextDrawHideForPlayer(playerid, gunlist7);
    		TextDrawHideForPlayer(playerid, gunlist8);
    		TextDrawHideForPlayer(playerid, gunlist9);
            TextDrawHideForPlayer(playerid, gunlist1);
    		TextDrawHideForPlayer(playerid, gunlist2);
    		TextDrawHideForPlayer(playerid, gunlist3);
    		TextDrawHideForPlayer(playerid, gunlist4);
    		TextDrawHideForPlayer(playerid, gunlist5);
    		TextDrawHideForPlayer(playerid, gunlist6);
     		TextDrawHideForPlayer(playerid, gunlist10);
    		TextDrawHideForPlayer(playerid, gunlist11);
    		TextDrawHideForPlayer(playerid, gunlist12);
    		TextDrawShowForPlayer(playerid, gunlist13);
    		TextDrawShowForPlayer(playerid, gunlist14);
    		TextDrawShowForPlayer(playerid, gunlist15);
            TextDrawShowForPlayer(playerid, hippy);
            TextDrawHideForPlayer(playerid, race);
            TextDrawHideForPlayer(playerid, farmer);
            TextDrawHideForPlayer(playerid, mech);
            TextDrawHideForPlayer(playerid, hobo);
            TextDrawHideForPlayer(playerid, sherif);
           	gTeam[playerid] = TEAM_HIPP;
           	SetPlayerPos(playerid, -1069.6833,-1205.6539,129.2188);
           	InterpolateCameraPos(playerid, -1077.537597, -1201.217773, 130.355514, -1077.146606, -1210.767211, 130.355514, 2000);
			InterpolateCameraLookAt(playerid, -1072.590087, -1201.630126, 129.762390, -1072.585693, -1208.772338, 129.887451, 2000);
		   	SetPlayerSkin(playerid, 1);
		   	ApplyAnimation(playerid,"PLAYIDLES","shift",4.1,1,1,1,1,1,1);
		   	SetPlayerFacingAngle( playerid, 90);
     	}
     	case 5://done
     	{
            PlayerTextDrawHide(playerid, skin12);
            PlayerTextDrawHide(playerid, skin13);
            PlayerTextDrawHide(playerid, skin14);
       		PlayerTextDrawHide(playerid, skin9);
            PlayerTextDrawHide(playerid, skin10);
            PlayerTextDrawHide(playerid, skin11);
            PlayerTextDrawHide(playerid, skin6);
            PlayerTextDrawHide(playerid, skin7);
            PlayerTextDrawHide(playerid, skin8);
            PlayerTextDrawHide(playerid, skin0);
            PlayerTextDrawHide(playerid, skin4);
            PlayerTextDrawHide(playerid, skin5);
            PlayerTextDrawHide(playerid, skin3);
            PlayerTextDrawHide(playerid, skin1);
            PlayerTextDrawHide(playerid, skin2);
			PlayerTextDrawShow(playerid, skin15);
            PlayerTextDrawShow(playerid, skin16);
            PlayerTextDrawShow(playerid, skin17);
            TextDrawHideForPlayer(playerid, gunlist7);
    		TextDrawHideForPlayer(playerid, gunlist8);
    		TextDrawHideForPlayer(playerid, gunlist9);
            TextDrawHideForPlayer(playerid, gunlist1);
    		TextDrawHideForPlayer(playerid, gunlist2);
    		TextDrawHideForPlayer(playerid, gunlist3);
    		TextDrawHideForPlayer(playerid, gunlist4);
    		TextDrawHideForPlayer(playerid, gunlist5);
    		TextDrawHideForPlayer(playerid, gunlist6);
     		TextDrawHideForPlayer(playerid, gunlist10);
    		TextDrawHideForPlayer(playerid, gunlist11);
    		TextDrawHideForPlayer(playerid, gunlist12);
    		TextDrawShowForPlayer(playerid, gunlist13);
    		TextDrawShowForPlayer(playerid, gunlist14);
    		TextDrawShowForPlayer(playerid, gunlist15);
            TextDrawHideForPlayer(playerid, hippy);
            TextDrawShowForPlayer(playerid, sherif);
            TextDrawHideForPlayer(playerid, race);
            TextDrawHideForPlayer(playerid, farmer);
            TextDrawHideForPlayer(playerid, mech);
            TextDrawHideForPlayer(playerid, hobo);
           	gTeam[playerid] = TEAM_POLL;
            SetPlayerPos(playerid, -623.4698,-1226.4026,20.9038);
			SetPlayerCameraPos(playerid, -610.8193, -1231.9003, 25.7319);
			SetPlayerCameraLookAt(playerid, -611.7386, -1231.4894, 25.4518);
		   	SetPlayerSkin(playerid, 283);
		   	ApplyAnimation(playerid,"PLAYIDLES","shift",4.1,1,1,1,1,1,1);
		   	SetPlayerFacingAngle( playerid, 240.5298);
        	}
		}
		SetPlayerToTeamColour(playerid); // calls the custom function
  		{
   	  }
    }
    return 1;
}
SetPlayerToTeamColour(playerid)
{
    if(gTeam[playerid] == TEAM_MECH)
    {
        SetPlayerColor(playerid, COLOR_BLUE);
    }
    else if(gTeam[playerid] == TEAM_HOBO)
    {
        SetPlayerColor(playerid, COLOR_RED);
    }
    else if(gTeam[playerid] == TEAM_FARM)
    {
        SetPlayerColor(playerid, COLOR_GREEN);
    }
    else if(gTeam[playerid] == TEAM_RACE)
    {
        SetPlayerColor(playerid, COLOR_GREY);
    }
    else if(gTeam[playerid] == TEAM_HIPP)
    {
        SetPlayerColor(playerid, COLOR_ORANGE);
    }
    else if(gTeam[playerid] == TEAM_POLL)
    {
        SetPlayerColor(playerid, COLOR_PURPLE);
    }

}

public OnPlayerConnect(playerid)
{
        new Query[900];
        //sInfo[playerid][TotalJoins] ++;
		//format(Query, 500, "UPDATE `ServerInfo` SET `TotalJoins` = '%d' WHERE `Server` = 'CountryTDM' LIMIT 1",
	 	//sInfo[playerid][TotalJoins]);
	 	//mysql_query(Query);
        CreateDynamic3DTextLabel("The Lift to the top of the tower\n/Lift", COLOR_BLUE, -97.69370, -979.29138, 25.76870, 20, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
        shotTime[playerid] = 0;
        shot[playerid] = 0;
        pInfo[playerid][Last] = -1;
		pInfo[playerid][NoPM] = 0;
		SetPlayerVirtualWorld(playerid, 0);
        SetTimer("BanChecka", 1000, true);
        Spawned[playerid] = 0;
        new namezor[MAX_PLAYER_NAME], country[MAX_COUNTRY_NAME], gmt;
	    GetPlayerName(playerid, namezor, sizeof(namezor));
	    country = GetPlayerCountryName(playerid);
	    gmt = GetPlayerGMT(playerid);
	    printf("[JOIN] %s (%s, GMT %d:00)", namezor, country, gmt);

        g_GotInvitedToDuel[playerid] = 0;
		g_HasInvitedToDuel[playerid] = 0;
		g_IsPlayerDueling[playerid]  = 0;
        InHouse[playerid] = -1;
    	InHouseCP[playerid] = -1;
        TogglePlayerKillBox(playerid, false);
		LoadTD(playerid);
		SetPlayerColor(playerid, COLOR_WHITE); //THe spawn color or w/e

        /*new namee[MAX_PLAYER_NAME];
    	GetPlayerName(playerid, namee, MAX_PLAYER_NAME);
    	format(newtextt, sizeof(newtextt), "~r~%s ~w~Has ~g~Joined [Connecting]", namee);
    	TextDrawSetString(kbText[playerid], newtextt);
    	TextDrawShowForAll(Text:kbText[playerid]);*/

    	
    	//GangZoneShowForAll(StaticMechanic,COLOR_BLUE);
    	SetPVarInt(playerid, "spawned", 0);
	    new joinMsg[128], name[MAX_PLAYER_NAME], AdminMsg[128];
		GetPlayerName(playerid, name, sizeof(name));
	 	new pip[32];
    	GetPlayerIp(playerid, pip, sizeof(pip));

		LoadRemovals(playerid);

		format(joinMsg, sizeof(joinMsg), "02[%d] 03*** %s has joined the server", playerid, name);
		IRC_GroupSay(groupID, IRC_CHANNEL, joinMsg);

		format(AdminMsg, sizeof(AdminMsg), "02[%d] 03*** %s has joined the server With the IP: %s", playerid, name, pip);
		IRC_GroupSay(groupID, IRC_ADMIN_CHANNEL, AdminMsg);

	    PlayerPlaySound(playerid, 1185, 0.0, 0.0, 10.0);
	    SendDeathMessage(INVALID_PLAYER_ID, playerid, 200);
    for(new i=0; i<sizeof(MainMenu); i++)
	{
	TextDrawShowForPlayer(playerid, logo);
	TextDrawShowForPlayer(playerid, logo2);
	TextDrawShowForPlayer(playerid, rules[i]);
    TextDrawShowForPlayer(playerid, MainMenu[i]);

	deagle = CreatePlayerTextDraw(playerid, 450, 348, "_");
	PlayerTextDrawFont(playerid, deagle, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, deagle, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, deagle, 348);

	//Mechanic skins
	skin0 = CreatePlayerTextDraw(playerid, 65, 358, "_");
	PlayerTextDrawFont(playerid, skin0, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin0, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin0, 8);

	skin1 = CreatePlayerTextDraw(playerid, 103, 358, "_");
	PlayerTextDrawFont(playerid, skin1, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin1, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin1, 42);

	skin2 = CreatePlayerTextDraw(playerid, 140, 358, "_");
	PlayerTextDrawFont(playerid, skin2, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin2, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin2, 6);

	//Hobo Skins
	skin3 = CreatePlayerTextDraw(playerid, 65, 358, "_");
	PlayerTextDrawFont(playerid, skin3, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin3, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin3, 79);

	skin4 = CreatePlayerTextDraw(playerid, 103, 358, "_");
	PlayerTextDrawFont(playerid, skin4, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin4, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin4, 77);

	skin5 = CreatePlayerTextDraw(playerid, 140, 358, "_");
	PlayerTextDrawFont(playerid, skin5, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin5, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin5, 78);

	//Farmer Skins
	skin6 = CreatePlayerTextDraw(playerid, 65, 358, "_");
	PlayerTextDrawFont(playerid, skin6, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin6, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin6, 158);

	skin7 = CreatePlayerTextDraw(playerid, 103, 358, "_");
	PlayerTextDrawFont(playerid, skin7, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin7, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin7, 159);

	skin8 = CreatePlayerTextDraw(playerid, 140, 358, "_");
	PlayerTextDrawFont(playerid, skin8, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin8, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin8, 160);

	//Racer Skins
	skin9 = CreatePlayerTextDraw(playerid, 65, 358, "_");
	PlayerTextDrawFont(playerid, skin9, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin9, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin9, 2);

	skin10 = CreatePlayerTextDraw(playerid, 103, 358, "_");
	PlayerTextDrawFont(playerid, skin10, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin10, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin10, 65);

	skin11 = CreatePlayerTextDraw(playerid, 140, 358, "_");
	PlayerTextDrawFont(playerid, skin11, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin11, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin11, 23);

	//Hippy Skins
	skin12 = CreatePlayerTextDraw(playerid, 65, 358, "_");
	PlayerTextDrawFont(playerid, skin12, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin12, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin12, 1);

	skin13 = CreatePlayerTextDraw(playerid, 103, 358, "_");
	PlayerTextDrawFont(playerid, skin13, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin13, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin13, 26);

	skin14 = CreatePlayerTextDraw(playerid, 140, 358, "_");
	PlayerTextDrawFont(playerid, skin14, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin14, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin14, 101);
	
	//Police Skins
	skin15 = CreatePlayerTextDraw(playerid, 65, 358, "_");
	PlayerTextDrawFont(playerid, skin15, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin15, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin15, 288);

	skin16 = CreatePlayerTextDraw(playerid, 103, 358, "_");
	PlayerTextDrawFont(playerid, skin16, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin16, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin16, 283);

	skin17 = CreatePlayerTextDraw(playerid, 140, 358, "_");
	PlayerTextDrawFont(playerid, skin17, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawTextSize(playerid, skin17, 50.0, 50.0);
	PlayerTextDrawSetPreviewModel(playerid, skin17, 282);

    GetPlayerName(playerid, pInfo[playerid][Nick], 24); //gets the player's name and stores it to to your enum pInfo[playerid][Nick]
    GetPlayerIp(playerid, pInfo[playerid][IP], 16); //Gets the IP of the player and stores it to pInfo[playerid][IP]
    mysql_real_escape_string(pInfo[playerid][Nick], pInfo[playerid][Nick]); // now we have to escape the name inorder to escape any mysql injections. ([url]http://en.wikipedia.org/wiki/SQL_injection[/url])
    format(Query, 500, "SELECT `nick` FROM `playerdata` WHERE `nick` COLLATE latin1_general_cs = '%s' LIMIT 1", pInfo[playerid][Nick]); // here we are selecting the name of the player who logged in from the database.
    mysql_query(Query); // we query the statement above
    mysql_store_result(); // next we store the result inorder for it to be used further ahead.
    if(mysql_num_rows() > 0) // if the  database has more then one table with the given name
    {
        ShowPlayerDialog(playerid, 1, DIALOG_STYLE_PASSWORD, "{FF0000}Countryside Account", "{FFFFFF}We have detected that this account name is already registered, if it is \nYours please login below. \n\n\nWebsite: {FF0000}"WEB"", "Login", "");
        InterpolateCameraPos(playerid, -355.689483, -1164.360473, 72.694404, -348.598754, -1054.949951, 63.588764, 5000);
		InterpolateCameraLookAt(playerid, -359.596557, -1161.244628, 72.533813, -348.340637, -1050.612915, 61.114135, 5000);
        SetPlayerPos(playerid, -365.5911,-1060.2081,59.2488);
	}
    else // else if the database found no tables with the given name
    {
        ShowPlayerDialog(playerid, 2, DIALOG_STYLE_PASSWORD, "{FF0000}Countryside Account", "{FFFFFF}Please register an account here on {FF0000}CountrySide Team Deathmatch{FFFFFF} so we \ncan track your stats and log them. \n\nWebsite: {FF0000}"WEB"", "Register", "");// show the register dialog and tell the player to register
       	InterpolateCameraPos(playerid, -355.689483, -1164.360473, 72.694404, -348.598754, -1054.949951, 63.588764, 5000);
		InterpolateCameraLookAt(playerid, -359.596557, -1161.244628, 72.533813, -348.340637, -1050.612915, 61.114135, 5000);
		SetPlayerPos(playerid, -365.5911,-1060.2081,59.2488);
	}
    mysql_free_result(); // here we free the result we stored in the beginning as we do not need it anymore.
    //You must always free the mysql result to avoid
    //there being massive memory usage.
    }
	return 1;
}
public OnPlayerUpdate(playerid)
{
    pTick[playerid] = GetTickCount();
    if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK) //will check if player is using Jetpack
    {
        if(JetPack[playerid] == 0) //if global variable JetPack is 0
        {
   			new Query[500], target, BanMsg[200];
   			new ircMsg[100];
        	format(Query, 500, "INSERT INTO bans (name, ip, reason, bannedby, date, status, IRCBan) VALUES('%s', '%s', 'Jetpack Hack', '"AntiCheat"', NOW(), '1', 'No')", pInfo[target][Nick], pInfo[target][IP]); //Format the query
       		mysql_query(Query);
       		Kick(target);
       		format(BanMsg, sizeof(BanMsg), "%s was Banned by admin "AntiCheat" for Jetpack Hacking!", pInfo[target][Nick]);
			SendClientMessageToAll(COLOR_RED, BanMsg);
    		format(ircMsg, sizeof(ircMsg), "0,4%s Has been banned by "AntiCheat" for hacking a Jetpack!", pInfo[playerid][Nick]);
			IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
   			IRC_GroupSay(groupID, IRC_ADMIN_CHANNEL, ircMsg);
        }
        else //if global variable JetPack is 1
            return 1; //will return 1;
    }
    else JetPack[playerid] = 0; //if player leaves the JetPack using Enter/F it will set the Global Variable JetPack to 0 again to avoid the problem in our command /jetpack

   return 1;
}



public OnPlayerDisconnect(playerid, reason)
{
    if(ireconnect[playerid] == 1)
    {
            new unbanningip[16], string[128];
            GetPVarString(playerid, "reconnect", unbanningip, 16);// Get the msg string from the PVar
            format(string,sizeof(string),"unbanip %s", unbanningip);
            SendRconCommand(string);
            printf(string);
            SendRconCommand("reloadbans");
            ireconnect[playerid] = 0;
    }
    pInfo[playerid][Last] = -1;
	pInfo[playerid][NoPM] = 0;
    if(playerid == g_DuelingID1 || playerid == g_DuelingID2)
	{
	    g_DuelInProgress = 0;
	}
    NameLabelsGone(playerid);
    	for(new i=0; i<sizeof(MainMenu); i++)
		{
		if(pInfo[i][Logged] == 1)
    	{
    		SaveAll(playerid);
   		}
 	}
		SendDeathMessage(INVALID_PLAYER_ID, playerid, 201);
		new leaveMsg[128], name[MAX_PLAYER_NAME], reasonMsg[8];
		switch(reason)
		{
			case 0: reasonMsg = "Timeout";
			case 1: reasonMsg = "Leaving";
			case 2: reasonMsg = "Kicked";
		}
			GetPlayerName(playerid, name, sizeof(name));
			format(leaveMsg, sizeof(leaveMsg), "02[%d] 03*** %s has left the server. (%s)", playerid, name, reasonMsg);
			IRC_GroupSay(groupID, IRC_CHANNEL, leaveMsg);

			/*new newtext1[100];
		   	format(newtext1, sizeof(newtext1), "~r~%s ~w~Has ~g~Left [%s]", name, reasonMsg);
		   	TextDrawSetString(disconnect[playerid], newtext1);
		   	TextDrawShowForAll(Text:disconnect[playerid]);*/

	if(IsBeingSpeced[playerid] == 1)//If the player being spectated, disconnects, then turn off the spec mode for the spectator.
    {
        foreach(Player,i)
        {
            if(spectatorid[i] == playerid)
            {
                TogglePlayerSpectating(i,false);// This justifies what's above, if it's not off then you'll be either spectating your connect screen, or somewhere in blueberry (I don't know why)
            }
        }
    }

	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    	if(newkeys & KEY_FIRE && ForbiddenWeap(playerid) && !IsPlayerAdmin(playerid))
        {
            new pname[MAX_PLAYER_NAME], ircMsg[256], Query[500];
            new string[124];
            GetPlayerName(playerid, pname, sizeof(pname));
            format(string, sizeof(string), "%s has been banned for pulling weapons of of his ass!", pname);
            SendClientMessageToAll(COLOR_RED, string);
            format(ircMsg, sizeof(ircMsg), "1,4%s(%d) has been banned for pulling wepaons out of his ass!",  pInfo[playerid][Nick], playerid);
			IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
			IRC_GroupSay(groupID, IRC_STAFF_CHANNEL, ircMsg);
			format(Query, 500, "INSERT INTO bans (name, ip, reason, bannedby, date, status, IRCBan) VALUES('%s', '%s', 'Jetpack Hack', '"AntiCheat"', NOW(), '1', 'No')", pInfo[playerid][Nick], pInfo[playerid][IP]); //Format the query
       		mysql_query(Query);
       		Kick(playerid);
            return 1;
   }
    return 0;
}


public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
        if(hittype == 3)
        {
        if(weaponid != 31 && 33)
		{
		        new string[256];
                format(string, sizeof(string), "Nice work %s, You've found the deer BUT you've got the wrong gun, try a hunting rifle or an m4", pInfo[playerid][Nick]);
                SendClientMessage(playerid, -1, string);
		}
       	else
		{
				new Float:X, Float:Y, Float:Z;
				new stringzor[256];
                GetObjectPos(hitid, X, Y, Z);
                SetObjectRot(hitid, 90, 0, 0);
                SetObjectPos(hitid, X, Y, Z-0.9);
                SetPlayerScore(playerid, GetPlayerScore(playerid) + 5);
                GivePlayerWeapon(playerid, 35, 10);
                SetTimer("deerkill", 60000, false);
                new Float:x, Float:y, Float:z;
    			GetPlayerPos(playerid, x, y, z);
    			format(stringzor, sizeof(stringzor), "%s Has found and killed the\n deer from here!", pInfo[playerid][Nick]);
                deerlabel = CreateDynamic3DTextLabel(stringzor, COLOR_BLUE, x,y,z, 20, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
                SendClientMessage(playerid, COLOR_BLUE, "Well done! You've won 5 score and an RPG with 10 rockets!");

		}
                return 1;
        }
        if(weaponid != 38)
        {
                if((GetTickCount() - shotTime[playerid]) < 1)
                {
                    shot[playerid]+=1;
                }
                else
                {
                    shot[playerid]=0;
                }
                if(shot[playerid] > 10)
                {
                    new string[256];
	                new ircMsg[256];
	                format(ircMsg, sizeof(ircMsg), "1,4%s(%d) Has been auto banned for using the rapidfire cleo mod!",  pInfo[playerid][Nick], playerid);
					IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	   				format(string, sizeof(string), "[ADMIN] - %s(%d) might be using rapid fire cleo!",  pInfo[playerid][Nick], playerid);
		    		SendMessageToAdmins(string);
	  				ACBan(playerid);
	                shotTime[playerid] = GetTickCount();
                }
   		     }
				return 1;
}

public OnPlayerSpawn(playerid)
{
        for(new i=0; i < sizeof(ZoneInfo); i++)
		{
		    GangZoneShowForPlayer(playerid, ZoneID[i], GetTeamZoneColor(ZoneInfo[i][zTeam]));
		    if(ZoneAttacker[i] != -1) GangZoneFlashForPlayer(playerid, ZoneID[i], GetTeamZoneColor(ZoneAttacker[i]));
		}
    	for(new i=0; i < sizeof(ZoneInfo); i++)
		{
    		GangZoneShowForPlayer(playerid, ZoneID[i], GetTeamZoneColor(ZoneInfo[i][zTeam]));
		}
        SetTimer("HHC",1000, false);
    	SetPlayerHealth(playerid, 95);
        SetTimerEx("FadeIn", DELAY, false, "id", playerid, 255);
    	SetPlayerInterior(playerid, 0);
  	 	SetPlayerVirtualWorld(playerid, 0);
    	SetPlayerTime(playerid,7,2); //noon
        //TextDrawHideForPlayer(playerid, Timer);
		TextDrawHideForPlayer(playerid, dmginfo);
        TextDrawHideForPlayer(playerid, killwep);
		TextDrawHideForPlayer(playerid, killerinfo);
    	TextDrawHideForPlayer(playerid, killergun);
        TextDrawHideForPlayer(playerid, killname);
        PlayerPlaySound(playerid, 1077 , 0.0, 0.0, 10.0);
        TextDrawHideForPlayer(playerid, MainMenu[0]);
        TextDrawHideForPlayer(playerid, MainMenu[1]);
        TextDrawHideForPlayer(playerid, MainMenu[2]);
        TextDrawHideForPlayer(playerid, MainMenu[3]);
        TextDrawHideForPlayer(playerid, sherif);

		for(new i=0; i<sizeof(MainMenu); i++)
		{
		TextDrawHideForPlayer(playerid, test);
	    TextDrawHideForPlayer(playerid, mech);
	    TextDrawHideForPlayer(playerid, logo2);
	    TextDrawHideForPlayer(playerid, hobo);
	    TextDrawHideForPlayer(playerid, farmer);
	    TextDrawHideForPlayer(playerid, race);
	    TextDrawHideForPlayer(playerid, logo);
	    TextDrawHideForPlayer(playerid, hippy);
	    TextDrawHideForPlayer(playerid, pclass);
	    PlayerTextDrawHide(playerid, deagle);
	    TextDrawHideForPlayer(playerid, gunlist1);
	    TextDrawHideForPlayer(playerid, gunlist2);
	    TextDrawHideForPlayer(playerid, gunlist3);
	    TextDrawHideForPlayer(playerid, gunlist4);
	    TextDrawHideForPlayer(playerid, gunlist5);
	    TextDrawHideForPlayer(playerid, gunlist6);
	    TextDrawHideForPlayer(playerid, gunlist7);
	    TextDrawHideForPlayer(playerid, gunlist8);
	    TextDrawHideForPlayer(playerid, gunlist9);
	   	TextDrawHideForPlayer(playerid, gunlist10);
		TextDrawHideForPlayer(playerid, gunlist11);
		TextDrawHideForPlayer(playerid, gunlist12);
		TextDrawHideForPlayer(playerid, gunlist13);
		TextDrawHideForPlayer(playerid, gunlist14);
		TextDrawHideForPlayer(playerid, gunlist15);
		PlayerTextDrawHide(playerid, skin0);
		PlayerTextDrawHide(playerid, skin1);
	 	PlayerTextDrawHide(playerid, skin2);
	 	PlayerTextDrawHide(playerid, skin3);
	 	PlayerTextDrawHide(playerid, skin4);
	 	PlayerTextDrawHide(playerid, skin5);
	 	PlayerTextDrawHide(playerid, skin6);
	  	PlayerTextDrawHide(playerid, skin7);
	  	PlayerTextDrawHide(playerid, skin8);
	  	PlayerTextDrawHide(playerid, skin9);
	 	PlayerTextDrawHide(playerid, skin10);
	  	PlayerTextDrawHide(playerid, skin11);
	  	PlayerTextDrawHide(playerid, skin12);
	  	PlayerTextDrawHide(playerid, skin13);
	  	PlayerTextDrawHide(playerid, skin14);
	  	PlayerTextDrawHide(playerid, skin15);
    	PlayerTextDrawHide(playerid, skin16);
     	PlayerTextDrawHide(playerid, skin17);
    	new Random = random(sizeof(MechSpawns));
		    switch(gTeam[playerid])
		     {
		          case TEAM_MECH:
		          {
		                SetPlayerPos(playerid, MechSpawns[Random][0], MechSpawns[Random][1], MechSpawns[Random][2]);
		    			SetPlayerFacingAngle(playerid, MechSpawns[Random][3]);
						GivePlayerWeapon(playerid, 24, 200);//Deagle/200
						GivePlayerWeapon(playerid, 25, 100);//Shotgun/200
						GivePlayerWeapon(playerid, 29, 200);//Mp5/200
						GivePlayerWeapon(playerid, 34, 100);//Sniper/200
						SetPlayerTeam(playerid, TEAM_MECH);
						SetPlayerSkin(playerid, MechSkins[random(3)]);
						SendClientMessage(playerid, COLOR_BLUE, "Your Team Perk is: Telescope in the bunker.");
						/*format(string,sizeof(string),"%s",pInfo[playerid][Nick]);
						Namee[playerid] = Create3DTextLabel(string, COLOR_BLUE, 0.0, 0.0, 0.0, 20.0, 0, 1);
						Attach3DTextLabelToPlayer(Namee[playerid], playerid, 0.0, 0.0, 0.3);*/
	        			return 1;
		                }
            	  case TEAM_HOBO:
		          {
					  SetPlayerPos(playerid, HoboSpawns[Random][0], HoboSpawns[Random][1], HoboSpawns[Random][2]);
		    			SetPlayerFacingAngle(playerid, HoboSpawns[Random][3]);
		    			GivePlayerWeapon(playerid, 22, 200);//pistol/200
						GivePlayerWeapon(playerid, 27, 100);//Copmbat/200
						GivePlayerWeapon(playerid, 33, 200);//Rifle/200
						GivePlayerWeapon(playerid, 16, 5);//Grnade/200
						SetPlayerTeam(playerid, TEAM_HOBO);
						SetPlayerSkin(playerid, HoboSkins[random(3)]);
						/*format(string,sizeof(string),"%s",pInfo[playerid][Nick]);
						HOBOLabel[playerid] = Create3DTextLabel(string, COLOR_RED, 0.0, 0.0, 0.0, 20.0, 0, 1);
						Attach3DTextLabelToPlayer(HOBOLabel[playerid], playerid, 0.0, 0.0, 0.3);*/
	        			return 1;
		                }
				  case TEAM_FARM:
    			  {
					  	SetPlayerPos(playerid, FarmerSpawns[Random][0], FarmerSpawns[Random][1], FarmerSpawns[Random][2]);
		    			SetPlayerFacingAngle(playerid, FarmerSpawns[Random][3]);
		    			GivePlayerWeapon(playerid, 24, 200);//Deagle/200
						GivePlayerWeapon(playerid, 29, 100);//Copmbat/200
						GivePlayerWeapon(playerid, 33, 200);//Rifle/200
						GivePlayerWeapon(playerid, 18, 5);//Molotov/200
						SetPlayerTeam(playerid, TEAM_FARM);
						SetPlayerSkin(playerid, FarmerSkins[random(3)]);
						SendClientMessage(playerid, COLOR_GREEN, "Your Team Perk is: Telescope in the bunker.");
						/*format(string,sizeof(string),"%s",pInfo[playerid][Nick]);
						FARMLabel[playerid] = Create3DTextLabel(string, COLOR_GREEN, 0.0, 0.0, 0.0, 20.0, 0, 1);
						Attach3DTextLabelToPlayer(FARMLabel[playerid], playerid, 0.0, 0.0, 0.3);*/
	        			return 1;
		                }
            	  case TEAM_RACE:
    			  {
					  	SetPlayerPos(playerid, RacerSpawns[Random][0], RacerSpawns[Random][1], RacerSpawns[Random][2]);
		    			SetPlayerFacingAngle(playerid, RacerSpawns[Random][3]);
		    			GivePlayerWeapon(playerid, 23, 200);//SD Pistol/200
						GivePlayerWeapon(playerid, 27, 100);//Copmbat/200
						GivePlayerWeapon(playerid, 31, 200);//AK/200
						GivePlayerWeapon(playerid, 28, 300);//Tec9/200
						SetPlayerTeam(playerid, TEAM_RACE);
						SetPlayerSkin(playerid, RacerSkins[random(3)]);
						SendClientMessage(playerid, COLOR_GREY, "Your Team Perk is: Ammo and Armored vehicle in bunker.");

                        /*format(string,sizeof(string),"%s",pInfo[playerid][Nick]);
						RACELabel[playerid] = Create3DTextLabel(string, COLOR_GREY, 0.0, 0.0, 0.0, 20.0, 0, 1);
						Attach3DTextLabelToPlayer(RACELabel[playerid], playerid, 0.0, 0.0, 0.3);*/
						return 1;
            	  }
       		      case TEAM_HIPP:
    			  {
					  	SetPlayerPos(playerid, HippySpawns[Random][0], HippySpawns[Random][1], HippySpawns[Random][2]);
		    			SetPlayerFacingAngle(playerid, HippySpawns[Random][3]);
		    			GivePlayerWeapon(playerid, 24, 200);//Deagle/200
						GivePlayerWeapon(playerid, 27, 100);//Copmbat/200
						GivePlayerWeapon(playerid, 30, 200);//AK/200
						GivePlayerWeapon(playerid, 39, 10);//Sachle/200
						SetPlayerTeam(playerid, TEAM_HIPP);
						SetPlayerSkin(playerid, HippySkins[random(3)]);
						/*format(string,sizeof(string),"%s",pInfo[playerid][Nick]);
						HIPPLabel[playerid] = Create3DTextLabel(string, COLOR_ORANGE, 0.0, 0.0, 0.0, 20.0, 0, 1);
						Attach3DTextLabelToPlayer(HIPPLabel[playerid], playerid, 0.0, 0.0, 0.3);*/
	        			return 1;
        		  }
        		  case TEAM_POLL:
    			  {
					  	SetPlayerPos(playerid, PolSpawns[Random][0], PolSpawns[Random][1], PolSpawns[Random][2]);
		    			SetPlayerFacingAngle(playerid, PolSpawns[Random][3]);
		    			GivePlayerWeapon(playerid, 24, 200);//Deagle/200
						GivePlayerWeapon(playerid, 27, 100);//Copmbat/200
						GivePlayerWeapon(playerid, 30, 200);//AK/200
						GivePlayerWeapon(playerid, 39, 10);//Sachle/200
						SetPlayerTeam(playerid, TEAM_POLL);
						SetPlayerSkin(playerid, PolSkins[random(3)]);
						/*format(string,sizeof(string),"%s",pInfo[playerid][Nick]);
						HIPPLabel[playerid] = Create3DTextLabel(string, COLOR_ORANGE, 0.0, 0.0, 0.0, 20.0, 0, 1);
						Attach3DTextLabelToPlayer(HIPPLabel[playerid], playerid, 0.0, 0.0, 0.3);*/
	        			return 1;
            		  }
		          }
	    	}
			return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new Query1[500];
    if(killerid != INVALID_PLAYER_ID) SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
    pInfo[playerid][pDeaths] ++;
    Spawned[playerid] = 0;
    SendDeathMessage(killerid, playerid, reason);
    new
	 	sString[128],
	   	pName[MAX_PLAYER_NAME],
	   	zName[MAX_PLAYER_NAME],
	   	Float:Health,
	   	Float:Armor;
	   	

	if(g_IsPlayerDueling[playerid] == 1 && g_IsPlayerDueling[killerid] == 1)
	{
	    SetPlayerTeam(playerid, 255);
		GetPlayerHealth(killerid, Health);
	  	GetPlayerArmour(killerid, Armor);

		GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	  	GetPlayerName(killerid, zName, MAX_PLAYER_NAME);

		if(Health > 90.0 && Armor > 90.0)
	  	{
	    	format(sString, sizeof(sString),""DuelNews" %s has OWNED %s in the duel and has %.2f health and %.2f armor left!", zName,pName,Health,Armor);
	      	SendClientMessageToAll(COLOR_ORANGE, sString);

            SpawnPlayer(killerid);

			g_GotInvitedToDuel[playerid] = 0;g_HasInvitedToDuel[playerid] = 0;g_IsPlayerDueling[playerid]  = 0;
	   		g_GotInvitedToDuel[killerid] = 0;g_HasInvitedToDuel[killerid] = 0;g_IsPlayerDueling[killerid]  = 0;
	      	g_DuelInProgress = 0;
			return 1;
	   	}
	   	else
	   	{
    		format(sString, sizeof(sString),""DuelNews" %s has won the duel from %s and has %.2f health and %.2f armor left!", zName,pName,Health,Armor);
	       	SendClientMessageToAll(COLOR_ORANGE, sString);

	       	SpawnPlayer(killerid);

			g_GotInvitedToDuel[playerid] = 0;g_HasInvitedToDuel[playerid] = 0;g_IsPlayerDueling[playerid]  = 0;
	   		g_GotInvitedToDuel[killerid] = 0;g_HasInvitedToDuel[killerid] = 0;g_IsPlayerDueling[killerid]  = 0;
			g_DuelInProgress = 0;
			return 1;
	   }
   	}
	new pname[24];
    GetPlayerName(playerid, pname, 24);
    GivePlayerMoney(killerid, 200);
    DestroyDynamic3DTextLabel(killstreak[playerid]);
    NameLabelsGone(playerid);
    for(new i=0; i<MAX_PLAYER_ATTACHED_OBJECTS; i++)
        {
            if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
        }
    SetPVarInt(playerid, "spawned", 0);
    //UpdateAcc(playerid);
    new msg[128], killerName[MAX_PLAYER_NAME], reasonMsg[32];
	GetPlayerName(killerid, killerName, sizeof(killerName));
 	SaveAll(playerid);

	if (killerid != INVALID_PLAYER_ID)
	{
		switch (reason)
		{
			case 0: reasonMsg = "Unarmed";
			case 1: reasonMsg = "Brass Knuckles";
			case 2: reasonMsg = "Golf Club";
			case 3: reasonMsg = "Night Stick";
			case 4: reasonMsg = "Knife";
			case 5: reasonMsg = "Baseball Bat";
			case 6: reasonMsg = "Shovel";
			case 7: reasonMsg = "Pool Cue";
			case 8: reasonMsg = "Katana";
			case 9: reasonMsg = "Chainsaw";
			case 10: reasonMsg = "Dildo";
			case 11: reasonMsg = "Dildo";
			case 12: reasonMsg = "Vibrator";
			case 13: reasonMsg = "Vibrator";
			case 14: reasonMsg = "Flowers";
			case 15: reasonMsg = "Cane";
			case 22: reasonMsg = "Pistol";
			case 23: reasonMsg = "Silenced Pistol";
			case 24: reasonMsg = "Desert Eagle";
			case 25: reasonMsg = "Shotgun";
			case 26: reasonMsg = "Sawn-off Shotgun";
			case 27: reasonMsg = "Combat Shotgun";
			case 28: reasonMsg = "MAC-10";
			case 29: reasonMsg = "MP5";
			case 30: reasonMsg = "AK-47";
			case 31: reasonMsg = "M4";
			case 32: reasonMsg = "TEC-9";
			case 33: reasonMsg = "Country Rifle";
			case 34: reasonMsg = "Sniper Rifle";
			case 37: reasonMsg = "Fire";
			case 38: reasonMsg = "Minigun";
			case 41: reasonMsg = "Spray Can";
			case 42: reasonMsg = "Fire Extinguisher";
			case 49: reasonMsg = "Vehicle Collision";
			case 50: reasonMsg = "Vehicle Collision";
			case 51: reasonMsg = "Explosion";
			default: reasonMsg = "Unknown";
		}
		format(msg, sizeof(msg), "04*** %s killed %s . (%s)", killerName, pname, reasonMsg);
	}
	else
	{
		switch (reason)
		{
			case 53: format(msg, sizeof(msg), "04*** %s died. (Drowned)", pInfo[playerid][Nick]);
			case 54: format(msg, sizeof(msg), "04*** %s died. (Collision)", pInfo[playerid][Nick]);

		}
	}
	IRC_GroupSay(groupID, IRC_CHANNEL, msg);
    DropPlayerWeapons(playerid);

    for(new i=0; i<sizeof(MainMenu); i++)
	{
	new newtext[42];
	new killergunz[42]; //lol gg
    TextDrawShowForPlayer(playerid, MainMenu[0]);
    //TextDrawShowForPlayer(playerid, MainMenu[1]);

    format(newtext, sizeof(newtext), "%s", killerName);
    TextDrawSetString(killname, newtext);

    format(killergunz, sizeof(killergunz), "%s", reasonMsg);
    TextDrawSetString(killwep, killergunz);
    
    new Float:healthh;
    new Float:armourr;
    GetPlayerHealth(killerid,healthh);
	GetPlayerArmour(killerid, armourr);
    
    format(Query1, 500, "INSERT INTO lastkills (player, killer, killerteam, playerteam, health, armor, weapon, date) VALUES('%s', '%s', '%s', '%s', '%.2f', '%.2f', '%s', NOW())",
   	pInfo[playerid][Nick],
 	pInfo[killerid][Nick],
 	GetTeamName(GetPlayerTeam(killerid)),
 	GetTeamName(GetPlayerTeam(playerid)),
 	healthh,
 	armourr,
 	reasonMsg);
	mysql_query(Query1);
	print(Query1);

    //TextDrawShowForPlayer(playerid, Timer);
    TextDrawShowForPlayer(playerid, killname);
    //TextDrawShowForPlayer(playerid, killerinfo);
    TextDrawShowForPlayer(playerid, killergun);
    TextDrawShowForPlayer(playerid, killwep);
    TextDrawShowForPlayer(playerid, dmginfo);


    if(killerid != INVALID_PLAYER_ID)
    {
            TogglePlayerSpectating(playerid, 1);
            PlayerSpectatePlayer(playerid, killerid);
            SetTimerEx("deathspec", 10000, false, "i", playerid);
    	}
    }
    Streak[playerid] = 0;
    if(IsPlayerConnected(killerid))
    {
        Streak[killerid]++;
        switch(Streak[killerid])
        {
            case 5:
   			{
				SendClientMessage(playerid, COLOR_GREEN,"You're on a 5 Kill streak!");
				Create3DTextLabel("I'm on a 5 Killstreak!", 0x008080FF, 30.0, 40.0, 50.0, 40.0, 0);
    			Attach3DTextLabelToPlayer(killstreak[playerid], playerid, 0.0, 0.0, 0.7);
			}
            case 10: GameTextForPlayer(killerid,"~g~You are on a 10 killstreak!",5000,5);
            case 15: GameTextForPlayer(killerid,"~g~You are on a 15 killstreak!",5000,5);
            case 20: GameTextForPlayer(killerid,"~g~You are on a 20 killstreak!",5000,5);
            case 25: GameTextForPlayer(killerid,"~g~You are on a 25 killstreak!",5000,5);

			}

    	}
		if(IsPlayerConnected(killerid) && GetPlayerTeam(playerid) != GetPlayerTeam(killerid)) // not a suicide or team kill
		{
		    new zoneid = GetPlayerZone(playerid);
		    if(zoneid != -1 && ZoneInfo[zoneid][zTeam] == GetPlayerTeam(playerid)) // zone member has been killed in the zone
		    {
		        ZoneDeaths[zoneid]++;
		        if(ZoneDeaths[zoneid] == MIN_DEATHS_TO_START_WAR)
		        {
		            ZoneDeaths[zoneid] = 0;
		            ZoneAttacker[zoneid] = GetPlayerTeam(killerid);
		            ZoneAttackTime[zoneid] = 0;
		            GangZoneFlashForAll(ZoneID[zoneid], GetTeamZoneColor(ZoneAttacker[zoneid]));
      		}
  		}
	}
	return 1;
}
forward deathspec(playerid);
public deathspec(playerid)
{
   TogglePlayerSpectating(playerid, 0);
   return 1;

}
public OnPlayerText(playerid, text[])
{
     	new TCount, KMessage[128];
        TCount = GetPVarInt(playerid, "TextSpamCount");

        TCount++;

        SetPVarInt(playerid, "TextSpamCount", TCount);

        if(TCount == 4) {
            SendClientMessage(playerid, 0xFFFFFF, "[Anti-Spam]: Warning you are one message away from being kicked!");
        }
        else if(TCount == 5) {
            new msg[256];
            GetPlayerName(playerid, KMessage, sizeof(KMessage));
            format(KMessage, sizeof(KMessage), "[Anti-Spam]: %s has been kicked for chat spamming.", KMessage);
            SendClientMessageToAll(COLOR_YELLOW, KMessage);
            format(msg, sizeof(msg), "1,8[Anti-Spam]: %s has been kicked for chat spamming.", KMessage);
			IRC_GroupSay(groupID, IRC_CHANNEL, msg);
            Kick(playerid);
        }

        SetTimerEx("ResetCount", SpamLimit, false, "i", playerid);
    	if(text[0] == '!')
    	{
		    new string[128];
		    GetPlayerName(playerid, string, sizeof(string));
	    	format(string, sizeof(string), "[Team]{FFFFFF} %s: %s", string, text[1]);
    	for(new i = 0; i < MAX_PLAYERS; i++)
    	{
    		if(IsPlayerConnected(i) && GetPlayerTeam(i) == GetPlayerTeam(playerid)) SendClientMessage(i, GetPlayerColor(playerid), string);
	}
    return 0;
    }
    switch(xTestBusy)
	{
	    case true:
	    {
			if(!strcmp(xChars, text, false))
			{
			    new
			        string[128],
			        msg[128],
			        pName[MAX_PLAYER_NAME];
                new rando = random(sizeof(wepsid));
				GetPlayerName(playerid, pName, sizeof(pName));
				format(string, sizeof(string), "{99FFFF}"Game" %s has won the reaction test.", pName);
			    SendClientMessageToAll(-1, string);
			    format(string, sizeof(string), "{99FFFF}"Game" You have earned $%d, %d Score and a random weapon", xCash, xScore);
			    SendClientMessage(playerid, -1, string);
			    format(msg, sizeof(msg), "4%s has won the reaction test and gained $%d, %d Score and a random weapon", pName, xCash, xScore);
 				IRC_GroupSay(groupID, IRC_CHANNEL, msg);
			    GivePlayerMoney(playerid, xCash);
				GivePlayerWeapon(playerid,wepsid[rando][0],wepsid[rando][1]);
				SetPlayerScore(playerid, GetPlayerScore(playerid) + xScore);
				xReactionTimer = SetTimer("xReactionTest", TIME, 1);
			    xTestBusy = false;
			}
		}
	}
    if(text[0] == '@' && pInfo[playerid][pAdmin] > 1)
	{
		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
	    new string[128]; GetPlayerName(playerid,string,sizeof(string));
	   	format(string,sizeof(string),"Admin Chat: %s:{FFFFFF} %s",string,text[1]); SendMessageToAdmins(string);
    return 0;
    }
    
    if(text[0] == '#' && pInfo[playerid][pTP] > 1)
	{
		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
	    new string[128]; GetPlayerName(playerid,string,sizeof(string));
	   	format(string,sizeof(string),"TP Chat: %s:{FFFFFF} %s",string,text[1]); SendMessageToTPS(string);
    return 0;
    }
    
    if(text[0] == '$' && pInfo[playerid][pVip] > 1)
	{
		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
	    new string[128]; GetPlayerName(playerid,string,sizeof(string));
	   	format(string,sizeof(string),"VIP Chat: %s:{FFFFFF} %s",string,text[1]); SendMessageToVIPS(string);
    return 0;
    }
		new name[MAX_PLAYER_NAME], ircMsg[256];
		GetPlayerName(playerid, name, sizeof(name));
		format(ircMsg, sizeof(ircMsg), "02[%d] 07%s: %s", playerid, name, text);
		IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
		new msg[128];
    	format(msg, sizeof(msg), "%d> %s", playerid, text);

	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 2) //If Dialog is our register dialog
    {
        if(response) //If they click the button register
        {
            if(!strlen(inputtext) || strlen(inputtext) > 68)  //checks if password is more then 68 characters or nothing.
            {
                SendClientMessage(playerid, 0xFF0000, "You must insert a password between 1-68 characters!");
				ShowPlayerDialog(playerid, 2, DIALOG_STYLE_PASSWORD, "{FF0000}Countryside Account", "This account not registered yet! Please register:", "Register", "");// show the register dialog again.
                SetPlayerCameraPos(playerid, -348.7502, -1063.9343, 62.0577);
				SetPlayerCameraLookAt(playerid, -348.6922, -1062.9286, 61.8977);
				SetPlayerPos(playerid, -365.5911,-1060.2081,59.2488);
			}
            else if(strlen(inputtext) > 0 && strlen(inputtext) < 68) // if the password is in between 1 - 68 characters
            {
                new HashPass[129];
			    WP_Hash(HashPass, sizeof(HashPass), inputtext);
			    pause(playerid);
			    new Query[500];
			    mysql_real_escape_string(pInfo[playerid][Nick], pInfo[playerid][Nick]);
			    // escaping the name of the player to avoid sql_injections.
			    mysql_real_escape_string(pInfo[playerid][IP], pInfo[playerid][IP]);
			    // escaping the IP of the player to avoid sql_injections.
			    // as you might've seen we haven't escaped the password here because it was already escaped in our register dialog
			    format(Query, sizeof(Query), "INSERT INTO `playerdata` (`nick`, `password`, `ip`) VALUES('%s', '%s', '%s')", pInfo[playerid][Nick], HashPass, pInfo[playerid][IP]); // Here we use the INSERT option and insert the name, password, and ip of the player in the database.
			    // we don't insert the score, admin, or any other variable because its automatically 0.
			    mysql_query(Query);

			    SendClientMessage(playerid, COLOR_SAMP, "You have now been  successfully registered on CountrySide TeamDeathmatch!");
			    pInfo[playerid][Logged] = 1;
			    pInfo[playerid][IsRegistered] = 1; // sets the registered variable to 1. meaning registered.
			    sInfo[playerid][Accounts] ++;
				format(Query, 500, "UPDATE `ServerInfo` SET `Accounts` = '%d' WHERE `Server` = 'CountryTDM' LIMIT 1",
				sInfo[playerid][Accounts]);
				mysql_query(Query);
				ShowPlayerDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT, "{FFFFFF}Countryside E-Mail", "{0FA0D1}Please enter your VALID email adress for countryside TDM \n\nYour Live player signature will be emailed as soon as you register so check your emails!", "Confirm", "");
			    SetPlayerCameraPos(playerid, -148.5026, -1404.0883, 5.6294);
				SetPlayerCameraLookAt(playerid, -148.1931, -1405.0458, 5.6094);
				SetPlayerPos(playerid, -148.1931, -1405.0458, 1.6094); // Here we are going to another function to register the player.
            }
        }
        if(!response)
        {
            SendClientMessage(playerid, 0xFF0000, "You must register before you can login!");
            ShowPlayerDialog(playerid, 2, DIALOG_STYLE_PASSWORD, "{0FA0D1}Countryside Account", "This account not registered yet! Please register:", "Register", "");// show the register dialog again.
            SetPlayerCameraPos(playerid, -348.7502, -1063.9343, 62.0577);
			SetPlayerCameraLookAt(playerid, -348.6922, -1062.9286, 61.8977);
			SetPlayerPos(playerid, -365.5911,-1060.2081,59.2488);
		}
    }
    if(dialogid == 1) //Dialog login
    {
        if(response) // if he clicked the first button in our case LOGIN
        {
            new HashPass[129]; // creating a variable to store get the hashed password from his file
//			new string[256];
			WP_Hash(HashPass, sizeof(HashPass), inputtext); // hashing the text he entered under the login dialog
            if(!strcmp(HashPass, pInfo[playerid][Password])) // comparing it to the text in his file if it is true
            {
                mysql_real_escape_string(pInfo[playerid][Nick], pInfo[playerid][Nick]); // escapeing ^^
	            new Query[500];
	            format(Query, 500, "SELECT * FROM `playerdata` WHERE `nick` COLLATE latin1_general_cs = '%s' AND `password` = '%s'", pInfo[playerid][Nick], HashPass); // now here check the database if the player has given the proper password.HTTP
	            mysql_query(Query);
	            mysql_store_result();
	            if(mysql_num_rows() > 0)
				{
	            	MySQL_Login(playerid);
            }
            else
            {
                SendClientMessage(playerid, -1, "wrong password entered try again"); // if the password doesn't match the one in his file then tell him that it is incorrect
                ShowPlayerDialog(playerid, 1, DIALOG_STYLE_PASSWORD, "Login", "Please Login By Writing Your Password Below", "Login", "Leave"); // and re-show the login dialog
            }
        }
    }
    }
    if(dialogid == DIALOG_EMAIL)
    {
	        if(!response)
	        {
	            ShowPlayerDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT, "Countryside E-Mail", "{FFFFFF}Please enter your VALID email adress for countryside TDM \n\nYour Live player signature will be emailed as soon as you register so check your emails!", "Confirm", "");
				SendClientMessage(playerid, COLOR_RED, "Please fill in your email adress to continue!");
	        }
        	if(response)
        	{
        	    if(!IsValidEmailEx(inputtext))
	        	{
	            	ShowPlayerDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT, "Countryside E-Mail", "{FFFFFF}Enter a VALID E-mail adress in the box \n\nFor Example: {0FA0D1}Jim_Bob@gmail.com", "Confirm", "");
					SendClientMessage(playerid, COLOR_RED, "You haven't provided a VALID email adress, if you want to play you'll have to.");
	        	}
					new Query[500], ircMsg[256], string[500], body[500];
     				format(LastEmail,sizeof(LastEmail), inputtext);
		            format(Query, 500, "UPDATE `playerdata` SET `email` = '%s' WHERE `nick` = '%s' LIMIT 1", LastEmail[playerid], pInfo[playerid][Nick]); //Format the query
					mysql_query(Query);
					
			        format(ircMsg, sizeof(ircMsg), "%s Has registed with the Email: %s", pInfo[playerid][Nick], LastEmail[playerid]);
					IRC_GroupSay(groupID, IRC_STAFF_CHANNEL, ircMsg);
					format(string,sizeof(string),"%s", LastEmail[playerid]);
	                format(body,sizeof(body),"Welcome to Countryside TDM %s \n\n Helpfull Links\n http://www.countrytdm.info/signature.php?name=%s - Your Stats\n[IMG]http://www.countrytdm.info/signature.php?name=%s[/IMG]\n www.Flinttdm.Countrytdm.info - Forums",
					pInfo[playerid][Nick],
					pInfo[playerid][Nick],
					pInfo[playerid][Nick]);

					SendMail(string, "Server@CountryTDM.info", "CountryTDM", "Welcome to Countryside TDM!", body);
	                SendClientMessage(playerid, COLOR_SAMP, "Thank you for registering! Check your E-Mails if you want your stats banner!");

			}
        return 1; // We handled a dialog, so return 1. Just like OnPlayerCommandText.
    }
    if(response)
	{
    	switch(dialogid)
    	{
      		case DIALOG_GUN:
      		{
         		switch(listitem)
         		{
            		case 0:
            		{

                  		GivePlayerWeapon(playerid, 31, 100);
                  		GivePlayerMoney(playerid, -20000);

		            }
		            case 1:
		            {

						  GivePlayerWeapon(playerid, 25, 100);
						  GivePlayerMoney(playerid, -15000);

		            }
		            case 2:
		            {

		                  GivePlayerWeapon(playerid, 29, 300);
		                  GivePlayerMoney(playerid, -10000);

		            }


		         }
		      }
		    }
		}
    	return 1;
}
public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
     if(issuerid != INVALID_PLAYER_ID && weaponid == 34 && bodypart == 9)
    {
        new Float:HP;
    	GetPlayerHealth(playerid, HP);
        SetPlayerHealth(playerid, HP-50);
    }
    new Float:HP;
    GetPlayerHealth(playerid, HP);
    if(weaponid == 23) SetPlayerHealth(playerid, HP-25);
    if(weaponid == 25) SetPlayerHealth(playerid, HP-46);

    if(issuerid != INVALID_PLAYER_ID) // If not self-inflicted
    {
        new
            weaponName[24],
            victimName[MAX_PLAYER_NAME],
            attackerName[MAX_PLAYER_NAME],
            weppstuff[42];

        GetPlayerName(playerid, victimName, sizeof (victimName));
        GetPlayerName(issuerid, attackerName, sizeof (attackerName));

        GetWeaponName(weaponid, weaponName, sizeof (weaponName));

        //format(infoString, sizeof(infoString), "%s has made %.0f damage to %s, weapon: %s", attackerName, amount, victimName, weaponName);
        //SendClientMessageToAll(-1, infoString); Debug
        //new string[MAX_PLAYER_NAME];
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		//SetTimer("remdamlbl", 3000, true);
		//format(string, sizeof(string), "%s \n %.0f", weaponName, amount);
  		//damlabel = CreateDynamic3DTextLabel(string, COLOR_RED, x,y,z, 20, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);

        new weapons[13][2];

		for (new i = 0; i < 13; i++)
		{
    		GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
    		format(weppstuff, sizeof(weppstuff), "%i %s %s", i, weapons[i][0], weapons[i][1]);
    		TextDrawSetString(dmginfo, weppstuff);
		}

    }
    return 1;
}
public OnPlayerGiveDamage(playerid,damagedid,Float:amount,weaponid)
{
            PlayerPlaySound(playerid,17802,0.0,0.0,0.0);
	        if(IsPaused[damagedid] == 1 && damagedid != INVALID_PLAYER_ID && GetPlayerTeam(playerid) != GetPlayerTeam(damagedid) && amount > 5 && pKilled[damagedid]== 0){
		    pKilled[damagedid]=1;
		    SendDeathMessage( playerid,damagedid, weaponid);
		    SetPlayerScore(playerid,GetPlayerScore(playerid)+1); //Remove this you aren't using a score system
		    SetPlayerVirtualWorld(damagedid,107);
		    SpawnPlayer(damagedid);
    	}
        return 1;
}

public IRC_OnConnect(botid, ip[], port) //XD
{
	printf("*** IRC_OnConnect: Bot ID %d connected to %s:%d", botid, ip, port);
	IRC_JoinChannel(botid, IRC_CHANNEL);
	IRC_JoinChannel(botid, IRC_ADMIN_CHANNEL);
	IRC_JoinChannel(botid, IRC_STAFF_CHANNEL);
	IRC_AddToGroup(groupID, botid);
	return 1;
}
public IRC_OnDisconnect(botid, ip[], port, reason[])
{
	printf("*** IRC_OnDisconnect: Bot ID %d disconnected from %s:%d (%s)", botid, ip, port, reason);
	IRC_RemoveFromGroup(groupID, botid);
	return 1;
}
public IRC_OnConnectAttempt(botid, ip[], port)
{
	printf("*** IRC_OnConnectAttempt: Bot ID %d attempting to connect to %s:%d...", botid, ip, port);
	return 1;
}
public IRC_OnConnectAttemptFail(botid, ip[], port, reason[])
{
	printf("*** IRC_OnConnectAttemptFail: Bot ID %d failed to connect to %s:%d (%s)", botid, ip, port, reason);
	return 1;
}
public IRC_OnJoinChannel(botid, channel[])
{
	printf("*** IRC_OnJoinChannel: Bot ID %d joined channel %s", botid, channel);
	return 1;
}
public IRC_OnLeaveChannel(botid, channel[], message[])
{
	printf("*** IRC_OnLeaveChannel: Bot ID %d left channel %s (%s)", botid, channel, message);
	return 1;
}
public IRC_OnInvitedToChannel(botid, channel[], invitinguser[], invitinghost[])
{
	printf("*** IRC_OnInvitedToChannel: Bot ID %d invited to channel %s by %s (%s)", botid, channel, invitinguser, invitinghost);
	IRC_JoinChannel(botid, channel);
	return 1;
}
public IRC_OnKickedFromChannel(botid, channel[], oppeduser[], oppedhost[], message[])
{
	printf("*** IRC_OnKickedFromChannel: Bot ID %d kicked by %s (%s) from channel %s (%s)", botid, oppeduser, oppedhost, channel, message);
	IRC_JoinChannel(botid, channel);
	return 1;
}

public IRC_OnUserDisconnect(botid, user[], host[], message[])
{
	printf("*** IRC_OnUserDisconnect (Bot ID %d): User %s (%s) disconnected (%s)", botid, user, host, message);
	return 1;
}

public IRC_OnUserJoinChannel(botid, channel[], user[], host[])
{
	printf("*** IRC_OnUserJoinChannel (Bot ID %d): User %s (%s) joined channel %s", botid, user, host, channel);
	return 1;
}

public IRC_OnUserLeaveChannel(botid, channel[], user[], host[], message[])
{
	printf("*** IRC_OnUserLeaveChannel (Bot ID %d): User %s (%s) left channel %s (%s)", botid, user, host, channel, message);
	return 1;
}

public IRC_OnUserKickedFromChannel(botid, channel[], kickeduser[], oppeduser[], oppedhost[], message[])
{
	printf("*** IRC_OnUserKickedFromChannel (Bot ID %d): User %s kicked by %s (%s) from channel %s (%s)", botid, kickeduser, oppeduser, oppedhost, channel, message);
}

public IRC_OnUserNickChange(botid, oldnick[], newnick[], host[])
{
	printf("*** IRC_OnUserNickChange (Bot ID %d): User %s (%s) changed his/her nick to %s", botid, oldnick, host, newnick);
	return 1;
}

public IRC_OnUserSetChannelMode(botid, channel[], user[], host[], mode[])
{
	printf("*** IRC_OnUserSetChannelMode (Bot ID %d): User %s (%s) on %s set mode: %s", botid, user, host, channel, mode);
	return 1;
}

public IRC_OnUserSetChannelTopic(botid, channel[], user[], host[], topic[])
{
	printf("*** IRC_OnUserSetChannelTopic (Bot ID %d): User %s (%s) on %s set topic: %s", botid, user, host, channel, topic);
	return 1;
}

public IRC_OnUserSay(botid, recipient[], user[], host[], message[])
{
	printf("*** IRC_OnUserSay (Bot ID %d): User %s (%s) sent message to %s: %s", botid, user, host, recipient, message);
	// Someone sent the bot a private message
	if (!strcmp(recipient, BOT_1_MAIN_NICKNAME) || !strcmp(recipient, BOT_2_MAIN_NICKNAME))
	{
		IRC_Say(botid, user, "You sent me a PM!");
	}
	return 1;
}

public IRC_OnUserNotice(botid, recipient[], user[], host[], message[])
{
	printf("*** IRC_OnUserNotice (Bot ID %d): User %s (%s) sent notice to %s: %s", botid, user, host, recipient, message);
	// Someone sent the bot a notice (probably a network service)
	if (!strcmp(recipient, BOT_1_MAIN_NICKNAME) || !strcmp(recipient, BOT_2_MAIN_NICKNAME))
	{
		IRC_Notice(botid, user, "You sent me a notice!");
	}
	return 1;
}

public IRC_OnUserRequestCTCP(botid, user[], host[], message[])
{
	printf("*** IRC_OnUserRequestCTCP (Bot ID %d): User %s (%s) sent CTCP request: %s", botid, user, host, message);
	// Someone sent a CTCP VERSION request
	if (!strcmp(message, "VERSION"))
	{
		IRC_ReplyCTCP(botid, user, "VERSION SA-MP IRC Plugin v" #PLUGIN_VERSION "");
	}
	return 1;
}

public IRC_OnUserReplyCTCP(botid, user[], host[], message[])
{
	printf("*** IRC_OnUserReplyCTCP (Bot ID %d): User %s (%s) sent CTCP reply: %s", botid, user, host, message);
	return 1;
}

public IRC_OnReceiveNumeric(botid, numeric, message[])
{
	// Check if the numeric is an error defined by RFC 1459/2812
	if (numeric >= 400 && numeric <= 599)
	{
		const ERR_NICKNAMEINUSE = 433;
		if (numeric == ERR_NICKNAMEINUSE)
		{
			// Check if the nickname is already in use
			if (botid == botIDs[0])
			{
				IRC_ChangeNick(botid, BOT_1_ALTERNATE_NICKNAME);
			}
			else if (botid == botIDs[1])
			{
				IRC_ChangeNick(botid, BOT_2_ALTERNATE_NICKNAME);
			}
		}
		printf("*** IRC_OnReceiveNumeric (Bot ID %d): %d (%s)", botid, numeric, message);
	}
	return 1;
}

/*
	This callback is useful for logging, debugging, or catching error messages
	sent by the IRC server.
*/

public IRC_OnReceiveRaw(botid, message[])
{
	new File:file;
	if (!fexist("irc_log.txt"))
	{
		file = fopen("irc_log.txt", io_write);
	}
	else
	{
		file = fopen("irc_log.txt", io_append);
	}
	if (file)
	{
		fwrite(file, message);
		fwrite(file, "\r\n");
		fclose(file);
	}
	return 1;
}

IRCCMD:cookie(botid, channel[], user[], host[], params[])
{
	if(IRC_IsOp(botid, channel, user))
	{
        new PID, msg[256], msg2[256], ircMsg[256], query[500], playerid;
        if (sscanf(params, "d", PID))
        {
            IRC_GroupSay(groupID,channel,"!Cookie [ID]");
            return 1;
        }
        
        if (IsPlayerConnected(PID))
		{

	        format(msg, sizeof(msg), "IRC Admin %s has given you a cookie! [Total Cookies: %d]",
			pInfo[playerid][Nick],
			Cookie[PID]);

	        format(msg2, sizeof(msg2), "You've given a cookie to %s", pInfo[PID][Nick]);
	        format(ircMsg, sizeof(ircMsg), "Admin(IRC) %s just given a cookie to %s",
			pInfo[playerid][Nick],
			pInfo[PID][Nick]);

	        format(query,sizeof(query),"UPDATE `playerdata` SET `cookies` = '%d' WHERE `nick` = '%s' LIMIT 1",
			Cookie[PID],
			pInfo[PID][Nick]);

			PlayerPlaySound(PID, 1057, 0.0, 0.0, 10.0);
			IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	        IRC_GroupSay(groupID, channel, msg2);
	        SendClientMessage(PID, 0xD9E916FF, msg);
        	mysql_query(query);
	        Cookie[PID] ++;
		}
	}
	return 1;
}

IRCCMD:activebans(botid, channel[], user[], host[], params[])
{
	    new name[128];
	    new msg2[128];
	    new playerid;
	    new plrIP[50];
        GetPlayerIp(playerid, plrIP, sizeof(plrIP));
        if (sscanf(params, "s[128]",name))
        {
            format(msg2, sizeof(msg2), "Usage: !ActiveBans [PlayerName]", name);
        IRC_GroupSay(groupID, channel, msg2);
            return 1;
        }
        new query[256], msg[256];
        format(query, sizeof(query), "SELECT * FROM `bans` WHERE `name` = '%s'", name);
    	mysql_query(query);
        mysql_store_result();
        if(!mysql_num_rows()){ IRC_GroupSay(groupID,channel,"Player is NOT banned."); mysql_free_result(); return 1;}

		mysql_fetch_int("status", BInfo[playerid][pReason]);
		mysql_fetch_int("bannedby", BInfo[playerid][pBannedBy]);
		mysql_fetch_int("ip", BInfo[playerid][pIPp]);

		format(msg, sizeof(msg), "12Active Bans matching %s(Active: %d) - Banned by: %s - IP: %s",
		name,
		BInfo[playerid][pReason],
		BInfo[playerid][pBannedBy],
		BInfo[playerid][pIPp]);


        IRC_GroupSay(groupID, channel, msg);

	return 1;
}

IRCCMD:email(botid, channel[], user[], host[], params[])
{
    new name[128];
    new msg2[128];
    new msg3[128];
    new string[500];
 	if (sscanf(params, "s[128]s[500]",name, string))
  	{
   		format(msg2, sizeof(msg2), "Usage: !Email [Email Adress] [Text]", name, string);
		IRC_GroupSay(groupID, channel, msg2);
   		return 1;
   }
  		format(string,sizeof(string),"%s", string);
		SendMail(name, "IRC@CountryTDM.info", "CountryTDM IRC", "Email from Countryside IRC", string);
		format(msg3, sizeof(msg3), "0,10You've sent an e-mail to: %s saying: %s", name, string);
 		IRC_GroupSay(groupID, channel, msg3);
		return 1;
}

IRCCMD:stats(botid, channel[], user[], host[], params[])
{
    new name[128];
    new msg2[128];
    new playerid;
        if (sscanf(params, "s[128]",name))
        {
            format(msg2, sizeof(msg2), "Usage: !Stats [PlayerName]", name);
        IRC_GroupSay(groupID, channel, msg2);
            return 1;
        }
        new query[256], msg[256], msg3[256];
        format(query, sizeof(query), "SELECT * FROM `playerdata` WHERE `nick` = '%s'", name);
    	mysql_query(query);
        mysql_store_result();
        if(!mysql_num_rows()){ IRC_GroupSay(groupID,channel,"Player doesn't exist.."); mysql_free_result(); return 1;}
        mysql_fetch_int("money", pInfo[playerid][pMoney]);
        mysql_fetch_int("id", pInfo[playerid][ID]);
        mysql_fetch_int("score", pInfo[playerid][pScore]);
        mysql_fetch_int("deaths", pInfo[playerid][pDeaths]);
        mysql_fetch_int("ping", pInfo[playerid][pPing]);
        mysql_fetch_int("admin", pInfo[playerid][pAdmin]);
        mysql_fetch_int("vip", pInfo[playerid][pVip]);
        mysql_fetch_int("TP", pInfo[playerid][pTP]);
        mysql_fetch_int("cookies", Cookie[playerid]);
		format(msg, sizeof(msg), "12%s Is registered(Acc ID: %d), Money: $%d, Score: %d",
		name,
		pInfo[playerid][ID],
		pInfo[playerid][pMoney],
		pInfo[playerid][pScore]);
		
		format(msg3, sizeof(msg3), "12Deaths: %d, Last Ping: %d Admin: %d, VIP: %d, Trusted Player: %d, Cookies: %d",
        pInfo[playerid][pDeaths],
		pInfo[playerid][pPing],
		pInfo[playerid][pAdmin],
		pInfo[playerid][pVip],
		pInfo[playerid][pTP],
		Cookie[playerid]);
		
        IRC_GroupSay(groupID, channel, msg);
        IRC_GroupSay(groupID, channel, msg3);

	return 1;
}


/*IRCCMD:isbanned(botid, channel[], user[], host[], params[])
{
  		new playerid;
        new plrIP[50];
        new msgg[256];
        new name[128];
        GetPlayerIp(playerid, plrIP, sizeof(plrIP));
        if (sscanf(params, "s[128]",name))
        {
            format(msgg, sizeof(msgg), "0,7Usage: !IsBanned [IP]");
 			IRC_GroupSay(groupID, channel, msgg);
            return 1;
        }
	        new query[256], msg[256];
	        format(query, sizeof(query), "SELECT * FROM `playerdata` WHERE (`nick` = '%s' OR `IP` = '%s')  AND `status` = 1 LIMIT 1", name, plrIP);
		    mysql_query(query);
		    mysql_store_result();
		    while(mysql_fetch_row(query))
		    {
					mysql_fetch_int("money", pInfo[playerid][pMoney]);
			}
					format(msg, sizeof(msg), "%s Is Registered, Account id: %d", name, pInfo[playerid][pMoney]);
			   		IRC_GroupSay(groupID, channel, msg);

	        return 1;
}
*/
//IRC CMDS GetServerTickRate
IRCCMD:lag(botid, channel[], user[], host[], params[])
{
	new msg[200];
	if(GetServerTickRate() > 160)
	{
		format(msg, sizeof(msg), "0,7The server is running at %d Ticks. (GOOD STANDING 0%% Packet Loss)", GetServerTickRate());
 		IRC_GroupSay(groupID, channel, msg);
 	}
 	else
 	{
 	    format(msg, sizeof(msg), "0,7The server is running at %d Ticks. (Could be having MySQL lag issues)", GetServerTickRate());
 		IRC_GroupSay(groupID, channel, msg);
 	}
}

IRCCMD:admins(conn, channel[], user[], params[]) // this will only show RCON admin you need to edit it with your Admin levels with your Gamemode
{
	new count,lolz1[200];
	new playerid;
    for (new giveid; giveid != GetMaxPlayers(); giveid ++)
    {
        if (!IsPlayerConnected(giveid)) continue;
        if(pInfo[giveid][pAdmin] > 1)
		{
            if (count == 0) IRC_GroupSay(groupID,channel,"3Current Administrators Online1");
            GetPlayerName(giveid,lolz1,32);
            format(lolz1,200,"0,10Admin %s (ID: %d) [Level: %d]",lolz1, giveid, pInfo[playerid][pAdmin]);
            IRC_GroupSay(groupID,channel,lolz1);
            count++;
        }
    }
    if (count == 0) return IRC_GroupSay(groupID,channel,"0,10There are no admins online");
    #pragma unused params,user,conn
	return true;
}

IRCCMD:god(botid, channel[], user[], host[], params[])
{
 	IRC_GroupSay(groupID,channel,"Flake is the all mighty server god");
}

IRCCMD:cmds(botid, channel[], user[], host[], params[])
{
 	IRC_GroupSay(groupID,channel,"12!Track !TP !Kick !Ban !Say !accounts !bans !Server !Info !lag !Admins !System");
    IRC_GroupSay(groupID,channel,"12!Email !Stats !Cookie");
}

IRCCMD:system(conn, channel[], user[], params[])
{
    if (IRC_IsOp(conn, channel, user))
	{
		new lolz1[256],lolz2[256], lolz3[256], hour,minute,second,year,month,day;
		new playerid;
		gettime(hour,minute,second);
		getdate(year,month,day);
		IRC_GroupSay(groupID,channel,"3Requesting the server statistics from ("mysql_database")..");
		format(lolz1,256,"3Day: %02d/%02d/%02d Hour: %02d:%02d:%02d",day,month,year,hour,minute,second);
		format(lolz2,256,"*** Day: %02d/%02d/%02d Hour: %02d:%02d:%02d",day,month,year,hour,minute,second);

		format(lolz3,256,"3Server: CountryTDM || Total Connections: %d || Tikis Found: %d || Bans Added: %d || Accounts Registered: %d || Bombs Planted: %d",
		sInfo[playerid][TotalJoins],
		sInfo[playerid][TikisFound],
		sInfo[playerid][Bans],
		sInfo[playerid][Accounts],
		sInfo[playerid][Bombs]);

		SendClientMessageToAll(green,lolz2);
		IRC_GroupSay(groupID,channel,lolz1);
		IRC_GroupSay(groupID,channel,lolz3);
		IRC_GroupSay(groupID,channel,"All data is being displayed from last restart.. (Older stats archived)");
	    #pragma unused conn,params,user
    }
    else IRC_GroupSay(groupID,channel,"3You're not an IRC Admin!");
	return true;
}

IRCCMD:info(botid, channel[], user[], host[], params[])
{
    new msg[128], accs, bans, cars, icons;
    mysql_query("SELECT * FROM `mapicons`");
	mysql_store_result();
    icons = mysql_num_rows();
    mysql_query("SELECT * FROM `dynamicvehicles`");
	mysql_store_result();
    cars = mysql_num_rows();
    mysql_query("SELECT * FROM `playerdata`");
	mysql_store_result();
    accs = mysql_num_rows();
    mysql_query("SELECT * FROM `bans`");
	mysql_store_result();
    bans = mysql_num_rows();
 	format(msg, sizeof(msg), "0,7There are Currently %d Account(s) - %d Users Banned - %d Dynamic cars and %d Map icons", accs, bans, cars, icons);
 	IRC_GroupSay(groupID, channel, msg);
}

IRCCMD:accounts(botid, channel[], user[], host[], params[])
{
    new msg[128], accs;
    mysql_query("SELECT * FROM `playerdata`");
	mysql_store_result();
    accs = mysql_num_rows();
 	format(msg, sizeof(msg), "0,7There are Currently %d Account(s) Registered", accs);
 	IRC_GroupSay(groupID, channel, msg);
}

IRCCMD:bans(botid, channel[], user[], host[], params[])
{
    new msg[128], bans;
    mysql_query("SELECT * FROM `bans`");
	mysql_store_result();
    bans = mysql_num_rows();
 	format(msg, sizeof(msg), "0,4There are Currently %d Account(s) Banned", bans);
 	IRC_GroupSay(groupID, channel, msg);
}

IRCCMD:server(botid, channel[], user[], host[], params[])
{
    new hour, minute, second, month, year, day, stats[512];
	gettime(hour, minute, second);
	getdate(year, month, day);
    new msg[128];
    GetNetworkStats(stats, sizeof(stats));
 	format(msg, sizeof(msg), "1,9The date is %s %i, %i - The server is ONLINE!", Months[month], day, year, hour, minute, second);
 	IRC_GroupSay(groupID, channel, msg);
}

IRCCMD:say(botid, channel[], user[], host[], params[])
    {
            if (IRC_IsOwner(botid, channel, user))
            {
                    // Check if the user entered any text
            if (!isnull(params))
                    {
                            new msg[128];
                            // Echo the formatted message
                            format(msg, sizeof(msg), "12Server Owner %s on IRC: %s", user, params);
                            IRC_GroupSay(groupID, channel, msg);
                            IRC_GroupSay(HelpBot, IRC_ADMIN_CHANNEL, msg);
                            format(msg, sizeof(msg), "Server Owner %s on IRC:{FFFFFF} %s", user, params);
                            SendClientMessageToAll(0x00CCCCFF, msg);

                    }
            }
            else if (IRC_IsAdmin(botid, channel, user))
            {
                    // Check if the user entered any text
            if (!isnull(params))
                    {
                            new msg[128];
                            // Echo the formatted message
                            format(msg, sizeof(msg), "12Server Management %s on IRC: %s", user, params);
                            IRC_GroupSay(groupID, channel, msg);
                            format(msg, sizeof(msg), "Server Management %s on IRC:{FFFFFF} %s", user, params);
                            SendClientMessageToAll(0x00CCCCFF, msg);
                    }
            }
            else if (IRC_IsOp(botid, channel, user))
            {
                    // Check if the user entered any text
                    if (!isnull(params))
                    {
                            new msg[128];
                            // Echo the formatted message
                            format(msg, sizeof(msg), "12Server Admin %s on IRC: %s", user, params);
                            IRC_GroupSay(groupID, channel, msg);
                            format(msg, sizeof(msg), "Server Admin %s on IRC:{FFFFFF} %s", user, params);
                            SendClientMessageToAll(0x00CCCCFF, msg);
                    }
            }
            else if (IRC_IsHalfop(botid, channel, user))
            {
                    // Check if the user entered any text
                    if (!isnull(params))
                    {
                            new msg[128];
                            // Echo the formatted message
                            format(msg, sizeof(msg), "12Level 2 Admin: %s on IRC: %s", user, params);
                            IRC_GroupSay(groupID, channel, msg);
                            format(msg, sizeof(msg), "Level 2 Admin: %s on IRC:{FFFFFF} %s", user, params);
                            SendClientMessageToAll(0x00CCCCFF, msg);
                    }
            }
            else if (IRC_IsVoice(botid, channel, user))
            {
                    // Check if the user entered any text
                    if (!isnull(params))
                    {
                            new msg[128];
                            // Echo the formatted message
                            format(msg, sizeof(msg), "11Server Player %s on IRC: %s", user, params);
                            IRC_GroupSay(groupID, channel, msg);
                            IRC_GroupSay(HelpBot, IRC_ADMIN_CHANNEL, msg);
                            format(msg, sizeof(msg), "Server Player %s on IRC:{FFFFFF} %s", user, params);
                            SendClientMessageToAll(0x00CCCCFF, msg);
                    }
            }

            else if (!isnull(params))
            {
                    new msg[128];
                            // Echo the formatted message
                    format(msg, sizeof(msg), "02***Server Guest %s on IRC: %s", user, params);
                    IRC_GroupSay(groupID, channel, msg);
                    format(msg, sizeof(msg), "***Server Guest %s on IRC:{FFFFFF} %s", user, params);
                    SendClientMessageToAll(0x00CCCCFF, msg);
            }
            return 1;
    }

IRCCMD:kick(botid, channel[], user[], host[], params[])
{
	// Check if the user is at least a halfop in the channel
	if (IRC_IsHalfop(botid, channel, user))
	{
		new playerid, reason[64], Query[500];
		// Check if the user at least entered a player ID
		if (sscanf(params, "dS(No reason)[64]", playerid, reason))
		{
			return 1;
		}
		// Check if the player is connected
		if (IsPlayerConnected(playerid))
		{
			// Echo the formatted message
			new msg[128], name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "02*** %s has been kicked by %s on IRC. (%s)", name, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been kicked by %s on IRC. (%s)", name, user, reason);
			SendClientMessageToAll(0x0000FFFF, msg);
			
			format(Query, 500, "INSERT INTO adminlogs (command, admin, usedon, reason, date) VALUES('IRC Kick', '%s', '%s', '%s', NOW())", name, user, reason);
       		mysql_query(Query);
			// Kick the player
			Kick(playerid);
		}
	}
	return 1;
}
IRCCMD:track(botid, channel[], user[], host[], params[])
{
            new playerid, pIP[128], Float:health, Float:armour;
            //Playerid


            if (sscanf(params, "d", playerid))
            {
                    return 1;
            }
            if (IRC_IsHalfop(botid, channel, user))
            {
            if(IsPlayerConnected(playerid))
            {
                    new msg[128], pname[MAX_PLAYER_NAME];
                    GetPlayerName(playerid, pname, sizeof(pname));
                    GetPlayerIp(playerid, pIP, 128);
                    GetPlayerHealth(playerid, health);
                    GetPlayerArmour(playerid, armour);
                    new Float:x, Float:y, Float:z;
                    GetPlayerPos(playerid, x, y, z);
                    new ping;
                    ping = GetPlayerPing(playerid);
                    new skin;
                    skin = GetPlayerSkin(playerid);
                    format(msg, sizeof(msg), "**[IRC]* %s's info: IP: %s | Health: %d | Armour: %d | Ping: %d | Skin ID: %d | Player Position: %d, %d, %d", pname, pIP, floatround(health), floatround(armour), ping, skin, x, y, z);
                    IRC_GroupSay(groupID, channel, msg);
            }
            }
            return 1;
    }
IRCCMD:tp( botid, channel[], user[], host[], params[] )
    {
        new tempstr[128], string[200], count, name[24];
        for( new i ,slots = GetMaxPlayers(); i < slots; i++ )
        {
            if(IsPlayerConnected(i))
            {
                count++;
                GetPlayerName(i, name, sizeof(name));
                format(tempstr, sizeof(tempstr), "%s , %s", tempstr, name);
            }
        }
        if(count)
        {
            format(string, sizeof(string), "7,1There are currently %d Players connected [%d Slots]", count, GetMaxPlayers());
            IRC_Say(botid, channel, string);
        } else IRC_Say(botid, channel, "7,1No players are online.");
        return 1;
}

IRCCMD:ban(botid, channel[], user[], host[], params[])
{
	// Check if the user is at least an op in the channel
	if (IRC_IsOp(botid, channel, user))
	{
		new playerid, reason[64];
		// Check if the user at least entered a player ID
		if (sscanf(params, "dS(No reason)[64]", playerid, reason))
		{
			return 1;
		}
		// Check if the player is connected
		if (IsPlayerConnected(playerid))
		{
			// Echo the formatted message
			new msg[128], name[MAX_PLAYER_NAME];
			new Query[500];
			new target;
			GetPlayerName(playerid, name, sizeof(name));
			format(msg, sizeof(msg), "02*** %s has been banned by %s on IRC. (%s)", name, user, reason);
			IRC_GroupSay(groupID, channel, msg);
			format(msg, sizeof(msg), "*** %s has been banned by %s on IRC. (%s)", name, user, reason);
			SendClientMessageToAll(0x0000FFFF, msg);
			// Ban the player
		 	format(Query, 500, "INSERT INTO bans (name, ip, reason, bannedby, date, status, IRCBan) VALUES('%s', '%s', '%s', '%s', NOW(), '1', 'Yes')", pInfo[target][Nick], pInfo[target][IP], reason, pInfo[playerid][Nick]); //Format the query
       		mysql_query(Query);
       		Kick(target);
 		 	sInfo[playerid][Bans] ++;
			format(Query, 500, "UPDATE `ServerInfo` SET `Bans` = '%d' WHERE `Server` = 'CountryTDM' LIMIT 1",
		 	sInfo[playerid][Bans]);
		 	mysql_query(Query);

		}
	}
	return 1;
}

IRCCMD:rcon(botid, channel[], user[], host[], params[])
{
	// Check if the user is at least an op in the channel
	if (IRC_IsOp(botid, channel, user))
	{
		// Check if the user entered any text
		if (!isnull(params))
		{
			// Check if the user did not enter any invalid commands
			if (strcmp(params, "exit", true) != 0 && strfind(params, "loadfs irc", true) == -1)
			{
				// Echo the formatted message
				new msg[128];
				format(msg, sizeof(msg), "RCON command %s has been executed.", params);
				IRC_GroupSay(groupID, channel, msg);
				// Send the command
				SendRconCommand(params);
			}
		}
	}
	return 1;
}
stock MySQL_Register(playerid)
{
    new HashPass[129];
    WP_Hash(HashPass, sizeof(HashPass), inputtext);
    pause(playerid);
    new Query[500];
    mysql_real_escape_string(pInfo[playerid][Nick], pInfo[playerid][Nick]);
    // escaping the name of the player to avoid sql_injections.
    mysql_real_escape_string(pInfo[playerid][IP], pInfo[playerid][IP]);
    // escaping the IP of the player to avoid sql_injections.
    // as you might've seen we haven't escaped the password here because it was already escaped in our register dialog
    format(Query, sizeof(Query), "INSERT INTO `playerdata` (`nick`, `password`, `ip`) VALUES('%s', '%s', '%s')", pInfo[playerid][Nick], HashPass, pInfo[playerid][IP]); // Here we use the INSERT option and insert the name, password, and ip of the player in the database.
    // we don't insert the score, admin, or any other variable because its automatically 0.
    mysql_query(Query);
    // here we do not need to mysql_store_result or mysql_free_result
    // because we are only inserting data in the database not selecting it
    //next we set the players logged variable to 1.
    //and the isregistered variable to 1 aswell.
    SendClientMessage(playerid, COLOR_SAMP, "You have now been  successfully registered on CountrySide TeamDeathmatch!");
    pInfo[playerid][Logged] = 1;
    pInfo[playerid][IsRegistered] = 1; // sets the registered variable to 1. meaning registered.
    sInfo[playerid][Accounts] ++;
	format(Query, 500, "UPDATE `ServerInfo` SET `Accounts` = '%d' WHERE `Server` = 'CountryTDM' LIMIT 1",
	sInfo[playerid][Accounts]);
	mysql_query(Query);
	ShowPlayerDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT, "{FFFFFF}Countryside E-Mail", "{0FA0D1}Please enter your VALID email adress for countryside TDM \n\nYour Live player signature will be emailed as soon as you register so check your emails!", "Confirm", "");
    SetPlayerCameraPos(playerid, -148.5026, -1404.0883, 5.6294);
	SetPlayerCameraLookAt(playerid, -148.1931, -1405.0458, 5.6094);
	SetPlayerPos(playerid, -148.1931, -1405.0458, 1.6094);
	return 1;
}

stock MySQL_Login(playerid)
{
    SetPlayerCameraPos(playerid, -148.5026, -1404.0883, 5.6294);
	SetPlayerCameraLookAt(playerid, -148.1931, -1405.0458, 5.6094);
	SetPlayerPos(playerid, -148.1931, -1405.0458, 1.6094);
   	pause(playerid);
    new Query[500], ircMsg[256];
    mysql_real_escape_string(pInfo[playerid][Nick], pInfo[playerid][Nick]); // escaping the name of the player to avoid sql_injections.
    format(Query, sizeof(Query), "SELECT * FROM `playerdata` WHERE `nick` COLLATE latin1_general_cs = '%s' LIMIT 1", pInfo[playerid][Nick]);
    mysql_query(Query);
    // here we select all of the user's data in the database and store it
    mysql_store_result();
    while(mysql_fetch_row(Query))
    // here after the server has selected the user
    //from the database and stored its data we extract that data onto our enums.
    {
        mysql_fetch_int("id", pInfo[playerid][ID]);
        // the special identifier of a user called "id"
        mysql_fetch_int("admin", pInfo[playerid][pAdmin]);
        // the admin level of the player
        mysql_fetch_int("score", pInfo[playerid][pScore]); SetPlayerScore(playerid, pInfo[playerid][pScore]);
        // here we fetch the score and save it to the enum and also save it to the server by using setplayerscore
        mysql_fetch_int("money", pInfo[playerid][pMoney]); GivePlayerMoney(playerid, pInfo[playerid][pMoney]);
        // here we fetch the score and save it to the enum and also save it to the server by using setplayerscore
        mysql_fetch_int("vip", pInfo[playerid][pVip]);
        mysql_fetch_int("TP", pInfo[playerid][pTP]);
        mysql_fetch_int("deaths", pInfo[playerid][pDeaths]);
        mysql_fetch_int("cookies", Cookie[playerid]);
        // the amount of deaths a player has
        //
        // the way to fetch a users stats from the database is:
        //mysql_fetch_int("table_name", variable_to_store_in);  remember the "table_name" is case sensitive!
    }
    new stringa[256];
    mysql_free_result();
    // here we free our result and end the SELECT process.  Remember this is very important otherwise you may receive high amount of lag in your server!
    pInfo[playerid][Logged] = 1; // sets the logged variable to 1 meaning logged in.
    format(ircMsg, sizeof(ircMsg), "3%s Has Logged in to his account (Account ID: %d)", pInfo[playerid][Nick], pInfo[playerid][ID]);
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	new query1[500];
	format(query1, sizeof(query1), "SELECT `message` FROM `news` LIMIT 3");
    mysql_query(query1); // No query line
    mysql_store_result();
    new rows = mysql_num_rows();
    if(rows > 0)
    {
        new message[256];
        mysql_fetch_row(message);
        format(stringa, sizeof(stringa), "MOTD: {00FF00}%s", message);
        SendClientMessage(playerid, -1, stringa);
    }
    if(pInfo[playerid][pAdmin] > 1) //should be fixed
	{
	    new query3[500];
		format(query3, sizeof(query3), "SELECT `message` FROM `adminmsg` LIMIT 3");
	    mysql_query(query3); // No query line
	    mysql_store_result();
	    new rowss = mysql_num_rows();
	    if(rowss > 0)
	    {
	        new amessage[256];
	        mysql_fetch_row(amessage);
	        format(stringa, sizeof(stringa), "Admin MOTD: {00FF00}%s", amessage);
	        SendClientMessage(playerid, -1, stringa);
	    }
	}
    return 1;
}

CMD:pausers(playerid)
{
	return cmd_afklist(playerid);
}

CMD:nos(playerid)
{
    if(pInfo[playerid][pVip] < 1) //should be fixed
	{
		return SendClientMessage(playerid,COLOR_GREY,"You're NOT Vip");
	}
	if(!IsPlayerInAnyVehicle(playerid))
  	{
   		return SendClientMessage(playerid,COLOR_GREY,"   You are not in a car!");
  	}
  		new tempid = GetPlayerVehicleID(playerid);
  		if(IsValidNosVehicle(tempid))
  	{
  		AddVehicleComponent(tempid, 1009);
  		SendClientMessage(playerid, COLOR_GREY, "Nos Added!");
  		return 1;
  	}
  		SendClientMessage(playerid, COLOR_GREY,"You can't mod this vehicle!");
  		return 1;
}


CMD:label(playerid, params[])
{
    if(pInfo[playerid][pTP] >= 1)
	{
	    new
	        string[256],
	        Query[500],
	        action[100],
			ircMsg[256];
    if(sscanf(params, "s[100]", action))
    {
        SendClientMessage(playerid, -1, "USAGE: /label [text]");
        return 1;
    }
    else
    {
        format(stringlol, sizeof(stringlol), "%s", action);
        labelz[playerid] = Create3DTextLabel(string, COLOR_BLUE, 0.0, 0.0, 0.0, 20.0, 0, 1);
		Attach3DTextLabelToPlayer(labelz[playerid], playerid, 0.0, 0.0, 0.3);
		format(Query, 500, "UPDATE `playerdata` SET `label` = '%s' WHERE `nick` = '%s' LIMIT 1", stringlol[playerid], pInfo[playerid][Nick]); //Format the query
        mysql_query(Query);
        format(ircMsg, sizeof(ircMsg), "3%s Has updated his label to: %s", pInfo[playerid][Nick], stringlol[playerid]);
		IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
    	}
    }
    else SendClientMessage(playerid, COLOR_RED, "You're NOT a Trusted Player!");
    return 1;
}
CMD:announce(playerid, params[])
{
    new text[64], time, style, ircMsg[100];
    if(pInfo[playerid][pAdmin] < 3) return SendClientMessage(playerid,COLOR_RED,""EServ"");
    else if (sscanf(params, "iis[64]", style, time, text)) return SendClientMessage(playerid,COLOR_RED,"Usage: /announce <style[0-6]> <time in ms> <text>");
    else if (strlen(text) > 64) return SendClientMessage(playerid,COLOR_RED,"Message too long, please make it with less than 64 letters!");
    else if (style == 2) return SendClientMessage(playerid,COLOR_RED,"Bug with style 2! Do not use it!");
    else if (style < 0 || style > 6) return SendClientMessage(playerid,0x854900FF,"Invalid style");
    else if (time > 20*1000) return SendClientMessage(playerid, COLOR_RED,"No longer than 20 seconds");
    else {
        GameTextForAll(text, time, style);
        format(ircMsg, sizeof(ircMsg), "0,2Admin %s Has announced %s for %d with style %s", pInfo[playerid][Nick], text, time, style);
		IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
    }
    return 1;
}
CMD:head(playerid, params[])
{
	if(pInfo[playerid][pTP] >= 1) //18963
	{
	    new ircMsg[100];
   		SetPlayerAttachedObject( playerid, 0, 18963, 2, 0.067110, 0.021042, -0.002412, 0.000000, 85.268745, 93.973075, 1.302817, 1.174986, 1.489552 );
        format(ircMsg, sizeof(ircMsg), "0,2%s Has attached his VIP head toy (/Head)", pInfo[playerid][Nick]);
		IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	}
	else SendClientMessage(playerid, COLOR_RED, "You're NOT a Trusted Player!");
	return 1;
}


CMD:afklist(playerid)
{
    new count=0;
	new string[256],temp[50],Name[MAX_PLAYER_NAME];
	strcat(string, "{33FF00}");
	foreach(Player, i){
	   if (IsPlayerConnected(i)){
	      if(IsPaused[i] == 1){
              GetPlayerName(i,Name,sizeof(Name));
	          format(temp, 60, "%s(Id:%i)\n",Name,i);
			  strcat(string, temp);
			  count++;
          }
	   }
	}
	format(temp, 60, "{00FFE6}AFK players, count: %d",count);
	if (count > 0)ShowPlayerDialog(playerid,3221,DIALOG_STYLE_MSGBOX,temp,string ,"OK","");
	else ShowPlayerDialog(playerid,3222,DIALOG_STYLE_MSGBOX,"{00FFE6}Paused Players","{FF0000}No one is tabbed" ,"OK","");
	return 1;
}
CMD:exit(playerid, params[])
{
    	if(IsPlayerInRangeOfPoint(playerid, 2.0, -118.0731, -1230.5809, -11.9585))
    	{
        	SetPlayerInterior(playerid, 8);
    		SetPlayerPos(playerid, 2815.2527,-1166.7867,1025.5778);
    		SetCameraBehindPlayer(playerid);
    		SetPlayerVirtualWorld(playerid, 420);
        	TogglePlayerControllable(playerid, 1);
  		}
        else
        {
      		if(IsPlayerInRangeOfPoint(playerid, 5.0, -362.0396, -1448.6719, 8.5552))
      		{
        		SetPlayerInterior(playerid, 8);
    			SetPlayerPos(playerid, 2815.2527,-1166.7867,1025.5778);
    			SetCameraBehindPlayer(playerid);
    			SetPlayerVirtualWorld(playerid, 421);
        		TogglePlayerControllable(playerid, 1);
			}
  		}
		return 1;
}


CMD:mapicon(playerid, params[])
{
    if(IsPlayerAdmin(playerid) || pInfo[playerid][pAdmin] >= 5)
	{
		new MType, Float:MX, Float:MY, Float:MZ, MColor;
		if(unformat(params, "ih", MType, MColor)) return SendClientMessage(playerid, COLOR_RED,"* Usage: /AddIcon < Icon ID > < Icon Color >");
		GetPlayerPos(playerid, MX, MY, MZ);

		AddMapIconToFile(MX, MY, MZ, MType, MColor);

		CreateDynamicMapIcon(MX, MY, MZ, MType, MColor, -1, -1, -1, 100.0);
		format(Msg, sizeof(Msg),"A new map icon Has beed dynamically added. Model: (%d) Color: (%d).",MType, MColor);
		new ircMsg[100];
		format(ircMsg, sizeof(ircMsg), "1,8Admin %s has created a new map icon [Model: %d Color: %d]", pInfo[playerid][Nick], MType, MColor);
		IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
  	}
	return SendClientMessage(playerid, COLOR_GREEN, Msg);

}

CMD:cleanup(playerid, params[])
{
    if(pInfo[playerid][pAdmin] > 2)
	{
	new Float:vPos[3], Float:Radius;
	if(!IsPlayerAdmin(playerid)) return 0;
	if(sscanf(params, "f", Radius)) SendClientMessage(playerid, COLOR_GREEN, "USAGE: /cleanup [range]");

	for(new c = 1; c < MAX_VEHICLES; ++c)
	{
		GetVehiclePos(c, vPos[0], vPos[1], vPos[2]);
	}

	if(IsPlayerInRangeOfPoint(playerid, Radius, vPos[0], vPos[1], vPos[2]))
	{
	    for(new i = 1; i < MAX_VEHICLES; ++i)
	{
			SetVehicleToRespawn(i);
			new ircMsg[100];
			format(ircMsg, sizeof(ircMsg), "1,7Admin %s has Respawned Vehicles around him [Radius: %d]", pInfo[playerid][Nick], Radius);
			IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
			}
		}
	}
	else SendClientMessage(playerid, COLOR_GREEN, ""EServ"");
	return 1;
}
CMD:savecar(playerid, params[])
{
	if(pInfo[playerid][pAdmin] >= 5)
	{
	    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	    {
	        new Float:x, Float:y, Float:z, Float:a, mod = GetVehicleModel(GetPlayerVehicleID(playerid)), col1, col2, pl[9], vehicleid = GetPlayerVehicleID(playerid), string[128];
	        if(sscanf(params, "iis[8]", col1, col2, pl))return SendClientMessage(playerid, -1, "Usage: /savecar [colour 1] [colour 2] [plate]");
	        {
	            if(strlen(pl) > 8)return SendClientMessage(playerid, -1, "The vehicles plate must be less than 8 characters long.");
	            GetVehiclePos(vehicleid, x, y, z);
	            GetVehicleZAngle(vehicleid, a);
	            SaveDynamicVehicle(x, y, z, a, mod, col1, col2, pl);
	            SetVehicleNumberPlate(vehicleid, pl);
				SetVehicleToRespawn(vehicleid);
				SetVehiclePos(vehicleid, x, y, z);
				SetVehicleZAngle(vehicleid, a);
				ChangeVehicleColor(vehicleid, col1, col2);
				format(string, sizeof(string), "You have saved this %s to the database. Colours: %s and %s, license: %s.", GetVehicleName(vehicleid), GetVehicleColorName(col1), GetVehicleColorName(col2), pl);
				SendClientMessage(playerid, -1, string);
				new ircMsg[256];
				format(ircMsg, sizeof(ircMsg), "0,7Level 5 Admin %s has saved a new vehicle to the database [%s Colors %s %s, License plate: %s]", pInfo[playerid][Nick], GetVehicleName(vehicleid), GetVehicleColorName(col1), GetVehicleColorName(col2), pl);
				IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	        }
	    }
	    else return SendClientMessage(playerid, -1, "You must be the driver of this vehicle to save it to the database.");
	}
	else return SendClientMessage(playerid, -1, "You must be inside of a vehicle to save it to the database.");
	return 1;
}
CMD:debug(playerid, params[])
{
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 100);
    return 1;
}

CMD:kill(playerid, params[])
{
	SetPlayerHealth(playerid, 0);
	new ircMsg[100];
	format(ircMsg, sizeof(ircMsg), "14,0%s has used /Kill", pInfo[playerid][Nick]);
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
    return 1;
}

CMD:help(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREY, "CountrySide Deathmatch InGame Help System:");
	SendClientMessage(playerid, COLOR_GREEN, "/Kill || /VIPinfo || /Tips || /report || /Pausers || /Spec || /SpecOff || /TPInfo || /me");
	SendClientMessage(playerid, COLOR_GREEN, "/Stats || /duel || /resetduel || /AcceptDuel || /Tutorial || /EndTut || /Pm || /R || /Paint");
	SendClientMessage(playerid, COLOR_GREEN, "/ChangeName || /MyCookies");
	return 1;
}
CMD:gmx(playerid, params[])
{
	if(pInfo[playerid][pAdmin] >= 5)
	{
 		SetTimer("GMX",10000, false);
		GameTextForAll( "Server Restarting ~n~in 10 Seconds", 10000, 6 );
		new ircMsg[100];
    	format(ircMsg, sizeof(ircMsg), "1,8Admin %s has initiated a GameMode Restart in 10 seconds.", pInfo[playerid][Nick]);
		IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
		//SaveAll(playerid);
	}
		else SendClientMessage(playerid, COLOR_GREEN, ""EServ"");
    	return 1;
}

CMD:bring(playerid,params[])
{
    if(pInfo[playerid][pAdmin] > 2)
	{
	    new id;
	    new targetid, Float:x, Float:y, Float:z;//defines floats and [U]targetid(same which we did as id above)[/U]
	    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREEN, "USAGE: /gethere [id]");//checks if there is something written after /gethere if no sends the usage error
	    if(!IsPlayerConnected(id) || id == playerid) return SendClientMessage(playerid, 0xFF0000FF, "This player is offline or it is yourself");//checks if the player is conneted or not and also checks that we are not teleporting ourselves to our self :P if we are it sends error
	    GetPlayerPos(playerid, x, y, z);//gets player pos PLAYER POS not targetid
	    SetPlayerPos(targetid, x+1, y+1, z);//gets the TARGETID player to the PLAYERID x+1,y+1 and z remains same as it defines height
 	}
	return 1;
}

CMD:ban(playerid, params[])
    {
        if(pInfo[playerid][pAdmin] > 3)
		{
            new PID; //define the playerid we wanna ban
            new Query[500];
            new reason[64]; //the reason, put into a string
            new str[128]; //a new message string
            new target;
            new Playername[MAX_PLAYER_NAME], Adminname[MAX_PLAYER_NAME]; //defines the function with the playername we wanna get
            GetPlayerName(playerid, Adminname, sizeof(Adminname)); //defines the function with the adminname we wanna get
            GetPlayerName(PID, Playername, sizeof(Playername));
            if(sscanf(params, "us[64]", PID,reason)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /Ban [playerid] [reason]"); //tell sscanf if the parameters/the syntax is written wrong to return a message (PID and the reason used here)

            if(!IsPlayerConnected(PID)) // if the ID is wrong or not connected, return a message! (PID used here)
                return SendClientMessage(playerid, COLOR_GREY, "Player is not connected!");

            format(str, sizeof(str), "'%s' has been banned by administrator '%s'. Reason: %s ", Playername, Adminname, reason); //format the string we've defined to send the message, playername and adminname are used to receive the information about the names
        	SendClientMessageToAll(COLOR_RED, str); //send that message to all
        	format(Query, 500, "INSERT INTO bans (name, ip, reason, bannedby, date, status, IRCBan) VALUES('%s', '%s', '%s', '%s', NOW(), '1', 'No')", pInfo[target][Nick], pInfo[target][IP], reason, pInfo[playerid][Nick]); //Format the query
       		mysql_query(Query);
       		sInfo[playerid][Bans] ++;
			format(Query, 500, "UPDATE `ServerInfo` SET `Bans` = '%d' WHERE `Server` = 'CountryTDM' LIMIT 1",
		 	sInfo[playerid][Bans]);
		 	mysql_query(Query);
       		Kick(target);


        }
        else //if he has not got the permissions
        {
            SendClientMessage(playerid, COLOR_GREY, "You have to be level 3 to use that command!"); //return this message
        }
        return 1;
    }
CMD:spec(playerid, params[])
{
    new id;// This will hold the ID of the player you are going to be spectating.
    if(sscanf(params,"u", id))return SendClientMessage(playerid, Grey, "Usage: /spec [id]");// Now this is where we use sscanf to check if the params were filled, if not we'll ask you to fill them
    if(id == playerid)return SendClientMessage(playerid,Grey,"You cannot spec yourself.");// Just making sure.
    if(id == INVALID_PLAYER_ID)return SendClientMessage(playerid, Grey, "Player not found!");// This is to ensure that you don't fill the param with an invalid player id.
    if(IsSpecing[playerid] == 1)return SendClientMessage(playerid,Grey,"You are already specing someone.");// This will make you not automatically spec someone else by mistake.
    GetPlayerPos(playerid,SpecX[playerid],SpecY[playerid],SpecZ[playerid]);// This is getting and saving the player's position in a variable so they'll respawn at the same place they typed '/spec'
    Inter[playerid] = GetPlayerInterior(playerid);// Getting and saving the interior.
    vWorld[playerid] = GetPlayerVirtualWorld(playerid);//Getting and saving the virtual world.
    TogglePlayerSpectating(playerid, true);// Now before we use any of the 3 functions listed above, we need to use this one. It turns the spectating mode on.
    if(IsPlayerInAnyVehicle(id))//Checking if the player is in a vehicle.
    {
        if(GetPlayerInterior(id) > 0)//If the player's interior is more than 0 (the default) then.....
        {
            SetPlayerInterior(playerid,GetPlayerInterior(id));//.....set the spectator's interior to that of the player being spectated.
        }
        if(GetPlayerVirtualWorld(id) > 0)//If the player's virtual world is more than 0 (the default) then.....
        {
            SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));//.....set the spectator's virtual world to that of the player being spectated.
        }
        PlayerSpectateVehicle(playerid,GetPlayerVehicleID(id));// Now remember we checked if the player is in a vehicle, well if they're in a vehicle then we'll spec the vehicle.
    }
    else// If they're not in a vehicle, then we'll spec the player.
    {
        if(GetPlayerInterior(id) > 0)
        {
            SetPlayerInterior(playerid,GetPlayerInterior(id));
        }
        if(GetPlayerVirtualWorld(id) > 0)
        {
            SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
        }
        PlayerSpectatePlayer(playerid,id);// Letting the spectator spec the person and not a vehicle.
    }
	new Name[MAX_PLAYER_NAME], String[256];
    GetPlayerName(id, Name, sizeof(Name));//Getting the name of the player being spectated.
    format(String, sizeof(String),"You have started to spectate %s.",Name);// Formatting a string to send to the spectator.
    SendClientMessage(playerid,0x0080C0FF,String);//Sending the formatted message to the spectator.
    IsSpecing[playerid] = 1;// Just saying that the spectator has begun to spectate someone.
    IsBeingSpeced[id] = 1;// Just saying that a player is being spectated (You'll see where this comes in)
    spectatorid[playerid] = id;// Saving the spectator's id into this variable.
    return 1;// Returning 1 - saying that the command has been sent.
}

CMD:specoff(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))return 0;// This checks if the player is logged into RCON, if not it will return 0; (Showing "SERVER: Unknown Command")
    if(IsSpecing[playerid] == 0)return SendClientMessage(playerid,Grey,"You are not spectating anyone.");
    TogglePlayerSpectating(playerid, 0);//Toggling spectate mode, off. Note: Once this is called, the player will be spawned, there we'll need to reset their positions, virtual world and interior to where they typed '/spec'
    return 1;
}

CMD:stats(playerid, params[])
{
    SetTimer("ExitStat", 15000, false);
	new string[256];
	new Float:health;
	GetPlayerHealth(playerid,health);
	format(string,sizeof(string),"~G~- ~Y~Name: %s",pInfo[playerid][Nick]);
	TextDrawSetString(Text:StatsText2,string);

	format(string,sizeof(string),"~G~- ~Y~Kills: %d",pInfo[playerid][pScore]);
	TextDrawSetString(Text:StatsText3,string);

	format(string,sizeof(string),"~G~- ~Y~Deaths: %d",pInfo[playerid][pDeaths]);
	TextDrawSetString(Text:StatsText4,string);

	format(string,sizeof(string),"~G~- ~Y~Money: %d", pInfo[playerid][pMoney]);
	TextDrawSetString(Text:StatsText6,string);

	format(string,sizeof(string),"~G~- ~Y~Health: %d", floatround(health));
	TextDrawSetString(Text:StatsText7,string);
	
	format(string,sizeof(string),"~G~- ~Y~Last Ping: %d", GetPlayerPing(playerid));
	TextDrawSetString(Text:StatsText8,string);
	
	format(string,sizeof(string),"~G~- ~Y~Team: %s", GetPlayerTeam(playerid));
	TextDrawSetString(Text:StatsText10,string);
	
	format(string,sizeof(string),"~G~- ~Y~Account ID: %d", pInfo[playerid][ID]);
	TextDrawSetString(Text:StatsText11,string);
	
	TextDrawShowForPlayer(playerid, StatsText0);
	TextDrawShowForPlayer(playerid, StatsText1);
	TextDrawShowForPlayer(playerid, StatsText2);
	TextDrawShowForPlayer(playerid, StatsText3);
	TextDrawShowForPlayer(playerid, StatsText4);
	TextDrawShowForPlayer(playerid, StatsText5);
	TextDrawShowForPlayer(playerid, StatsText6);
	TextDrawShowForPlayer(playerid, StatsText7);
	TextDrawShowForPlayer(playerid, StatsText8);
	TextDrawShowForPlayer(playerid, StatsText9);
	TextDrawShowForPlayer(playerid, StatsText10);
	TextDrawShowForPlayer(playerid, StatsText11);
	TextDrawShowForPlayer(playerid, StatsText13);
	return 1;
}

CMD:me(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, "USAGE: /me [action]");
	new string[128];
	format(string, sizeof(string), "* %s %s", pInfo[playerid][Nick], params);
	SendClientMessage(playerid, COLOR_PURPLE, string);
	return 1;
}

CMD:showkb(playerid, params[])
{
	TogglePlayerKillBox(playerid, true);
	return 1;
}

CMD:resetduel(playerid, params[])
{
	#pragma unused params

	if(g_HasInvitedToDuel[playerid] == 0)
		return SendClientMessage(playerid, COLOR_RED, "You havent invited anyone to duel, you don't need to do this");

	SendClientMessage(playerid, COLOR_YELLOW, "You have reset your duel invite, you can now use /duel [playerid] again.");
	g_HasInvitedToDuel[playerid] = 0;
	return 1;
}

CMD:acceptduel(playerid, params[])
{
	if(params[0] == '\0' || !IsNumeric(params))
	    return SendUsage(playerid, "/AcceptDuel [playerid]");

	if(g_DuelInProgress == 1)
		return SendError(playerid, "Another duel is in progress at the moment, wait till that duel is finished!");

    new
		DuelID = strvalEx(params),
		pName[MAX_PLAYER_NAME],
		zName[MAX_PLAYER_NAME],
		tString[128];

    if(DuelID != g_GotInvitedToDuel[playerid])
    	return SendError(playerid, "That player did not invite you to a duel!");

	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	GetPlayerName(DuelID, zName, MAX_PLAYER_NAME);

 	format(tString, sizeof(tString), "You accepted the duel with %s (ID:%d), duel will start in 10 seconds..",zName,DuelID);
 	SendClientMessage(playerid, COLOR_YELLOW, tString);

 	format(tString, sizeof(tString), "%s (ID:%d), accepted the duel with you, duel will start in 10 seconds..",pName,playerid);
 	SendClientMessage(DuelID, COLOR_YELLOW, tString);

 	format(tString, sizeof(tString), ""DuelNews" Duel between %s and %s will start in 10 seconds",pName,zName);
 	SendClientMessageToAll(COLOR_ORANGE, tString);

 	InitializeDuel(playerid);
 	InitializeDuelEx( DuelID);

 	g_IsPlayerDueling[playerid] = 1;
 	g_IsPlayerDueling[DuelID] = 1;

  	g_DuelingID1 = playerid;
    g_DuelingID2 = DuelID;

	g_DuelInProgress = 1;
	SetPlayerPos(DuelID, 76.632553,-301.156829,1.578125);
	SetPlayerInterior(DuelID, 0);

	SetPlayerPos(playerid, 34.7980, -320.6344, 2.1274);
	SetPlayerInterior(playerid, 0);
	return 1;
}

CMD:duel(playerid, params[])
{
	if(params[0] == '\0' || !IsNumeric(params))
	    return SendUsage(playerid, "/duel [Name]");

	if(g_HasInvitedToDuel[playerid] == 1)
		return SendError(playerid, "You already invited someone to a duel! (Type, /resetduel to reset your invite)");

	new
		DuelID = strvalEx(params),
		pName[MAX_PLAYER_NAME],
		zName[MAX_PLAYER_NAME],
		tString[128];

	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	GetPlayerName(DuelID, zName, MAX_PLAYER_NAME);

	if (!IsPlayerConnected(DuelID))
	    return SendError(playerid, "Player is not connected.");

 	if(	g_HasInvitedToDuel[DuelID] == 1)
 		return SendError(playerid, "That player is already invited to a duel!");

	if(	DuelID  == playerid)
 		return SendError(playerid, "You can not duel yourself!");

 	format(tString, sizeof(tString), "You invited %s (ID:%d) to a 1 on 1 duel, wait till %s accepts your invite.",zName, DuelID, zName);
 	SendClientMessage(playerid, COLOR_YELLOW, tString);

 	format(tString, sizeof(tString), "You got invited by %s (ID:%d) to a 1 on 1 duel, type /AcceptDuel [playerid] to accept and start the duel. ",pName, playerid);
 	SendClientMessage(DuelID, COLOR_YELLOW, tString);

 	g_GotInvitedToDuel[DuelID] = playerid;
	g_HasInvitedToDuel[playerid] = 1;

	return 1;
}

CMD:kbadd(playerid, params[])
{
	UpdateKillBox(0, 1, 34);
	return 1;
}

CMD:buy(playerid, params)
{
    if(InHouseCP[playerid] == -1) return SendClientMessage(playerid, 0xFF0000, "You are not in any house checkpoints!");
    if(HouseInformation[InHouseCP[playerid]][owner][0] != 0) return SendClientMessage(playerid, 0xFF0000, "This house has a owner");
    if(GetPlayerMoney(playerid) < HouseInformation[InHouseCP[playerid]][costprice]) return SendClientMessage(playerid, 0xFF0000, "You don't have enough money!"); //Player has a lack of cash!
    new PlayerNamee[24];
	new msg[256];
    GetPlayerName(playerid, PlayerNamee, 24);
    //format(Query, 500, "UPDATE `houseowner` FROM `HOUSEINFO` WHERE `houseowner` = '%s'", PlayerName);
    //mysql_query(Query);
    format(fquery, sizeof(fquery), "SELECT `houseowner` FROM `HOUSEINFO` WHERE `houseowner` = '%s'", PlayerNamee); //Formats the SELECT query
    queryresult = db_query(database, fquery); //Query result variable has been used to query the string above.
    if(db_num_rows(queryresult) == MAX_HOUSES_PER_PLAYER) return SendClientMessage(playerid, 0xFF0000, "You already have the max amount of houses"); //If the player has the max houses
    db_free_result(queryresult);
    //This is the point where the player can buy the house
    SetOwner(HouseInformation[InHouseCP[playerid]][Hname], PlayerNamee, InHouseCP[playerid]);
    //SetOwner(HouseName[], ownername[], houseids)
    SetPlayerPos(playerid, HouseInformation[InHouseCP[playerid]][TelePos][0], HouseInformation[InHouseCP[playerid]][TelePos][1], HouseInformation[InHouseCP[playerid]][TelePos][2]); //Sets players position where InHouseCP[playerid] = houseid.
    SetPlayerInterior(playerid, HouseInformation[InHouseCP[playerid]][interiors]); //Sets players interior
    SetPlayerVirtualWorld(playerid, 15500000 + InHouseCP[playerid]); //Sets the virtual world
    GivePlayerMoney(playerid, - HouseInformation[InHouseCP[playerid]][costprice]);
    GameTextForPlayer(playerid, "House ~r~Purchased!", 3000, 3); //Tells them they have purchased a house
    SendClientMessage(playerid, 0xFF0000, "TIP: This house will only last untill the server restarts, this is to keep the owners fresh!");
    format(msg, sizeof(msg), "0,2%s(%d) Has bought a house! The player will now get his paycheck.", pInfo[playerid][Nick], playerid);
	IRC_GroupSay(groupID, IRC_CHANNEL, msg);
	return 1;
}

CMD:sell(playerid, params)
{
    if(InHouse[playerid] == -1) return SendClientMessage(playerid, 0xFF0000, "You have to be inside your house to sell it!");
    new Pname[24];
    GetPlayerName(playerid, Pname, 24);
    if(strcmp(HouseInformation[InHouse[playerid]][owner], Pname) != 0) return SendClientMessage(playerid, 0xFF0000, "This is not your house!");
    //This is the point where the player can sell the house
    DeleteOwner(HouseInformation[InHouse[playerid]][Hname], InHouse[playerid]);
    //DeleteOwner(HouseName[], houseids)
    GivePlayerMoney(playerid, HouseInformation[InHouse[playerid]][sellprice]);
    SetPlayerPos(playerid, HouseInformation[InHouse[playerid]][EnterPos][0], HouseInformation[InHouse[playerid]][EnterPos][1], HouseInformation[InHouse[playerid]][EnterPos][2]);
    SetPlayerInterior(playerid, 0); //Sets the player back to interior 0 (Outside)
    SetPlayerVirtualWorld(playerid, 0); //Sets the players Virtual world to 0.
    InHouseCP[playerid] = InHouse[playerid];
    GameTextForPlayer(playerid, "House ~g~sold!", 3000, 3); //Tells them they have sold a house
    return 1;
}

CMD:rehash(playerid, params[])
{
	if(pInfo[playerid][pAdmin] > 4)
	{
	    new updatemmsg[100];
	    format(updatemmsg, sizeof(updatemmsg), "Admin %s has forcefully re-hashed the server", pInfo[playerid][Nick]);
    	SendClientMessageToAll(COLOR_RED, updatemmsg);
    	SendClientMessage(playerid, COLOR_RED, "You've Sucsesfully re-hashed the server (Re-setting all of the houses)");
        LoadHouses();
	}
    return 1;
}

CMD:gotoobj(playerid, params[])
{
	if(pInfo[playerid][pAdmin] > 2)
	{
    	SetPlayerPos(playerid, MoneyBagPos[0], MoneyBagPos[1] +3, MoneyBagPos[2]);
	}
    return 1;
}

CMD:kick(playerid, params[])
    {
        if(pInfo[playerid][pAdmin] > 2)
		{
            new PID; //define the playerid we wanna kick
            new reason[64]; //the reason, put into a string
            new str[128]; //a new message string
            new name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
            new Playername[MAX_PLAYER_NAME], Adminname[MAX_PLAYER_NAME]; //defines the function with the playername we wanna get
            GetPlayerName(playerid, Adminname, sizeof(Adminname)); //defines the function with the adminname we wanna get
            GetPlayerName(PID, Playername, sizeof(Playername));
            if(sscanf(params, "us[64]", PID,reason)) return SendClientMessage(playerid, COLOR_LIGHTRED, "USAGE: /kick [playerid] [reason]"); //tell sscanf if the parameters/the syntax is written wrong to return a message (PID and the reason used here)

            if(!IsPlayerConnected(PID)) // if the ID is wrong or not connected, return a message! (PID used here)
                return SendClientMessage(playerid, COLOR_LIGHTRED, "Player is not connected!");

            format(str, sizeof(str), "'%s' has been kicked by administrator '%s'. Reason: %s ", name, Adminname, reason); //format the string we've defined to send the message, playername and adminname are used to receive the information about the names
	        SendClientMessageToAll(COLOR_RED, str); //send that message to all
	        
			new Query[500];
	        format(Query, 500, "INSERT INTO adminlogs (command, admin, usedon, reason, date) VALUES('Game Kick', '%s', '%s', '%s', NOW())", name, Adminname, reason);
			mysql_query(Query);
            Kick(PID);
        }
        else //if he has not got the permissions
        {
            SendClientMessage(playerid, COLOR_RED, "You have to be level 2 to use that command!"); //return this message
        }
        return 1;
}

CMD:lift(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 7.0, -97.69370, -979.29138, 25.76870))
    {
		MoveDynamicObject(lift, -97.69370, -979.29138, 120.76870, 5, -1000.0, -1000.0, -1000.0);
		SendClientMessage(playerid, COLOR_LIGHTRED,"Keep all hands and feet in the lift at all times!");//This will send an message announcing the gate Stats!
		SetTimer("GateClose", 55000, false);
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED,"You're not at the lift; It's located at the big red tower!");
	}
    return 1;
}



CMD:tutorial(playerid, params[])
{
    new ircMsg[256];
    PlayerPlaySound(playerid, 1062, 0.0, 0.0, 10.0);
    TogglePlayerControllable(playerid,0); // This will Make player freeze.
	SetPlayerCameraPos(playerid, -359.2895, -1908.9608, 30.6976);
	SetPlayerCameraLookAt(playerid, -359.0217, -1907.9891, 30.5826);
	SetPlayerPos(playerid, -359.2895, -1908.9608, 10.6976);
	SendClientMessage(playerid, -1, "You can cut the tutorial short at any time by using /EndTut");
	//SetTimer("TutorialStart",1000,0); // This Timer will start the Tutorial, here 1000 is 1 second.
	SetTimerEx("TutorialStart", 1000, false, "i", playerid);
 	format(ircMsg, sizeof(ircMsg), "0,12%s Has entered the tutorial (/Tutorial)", pInfo[playerid][Nick]);
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
    return 1;
}

CMD:endtut(playerid, params[])
{
	TutorialEnd(playerid);
	return 1;
}

CMD:setbounty(playerid,params[])
{
     new bid;
     new bountyvalue;
     if(sscanf(params,"ui",bid,bountyvalue)) return SendClientMessage(playerid, 0xFF0000FF, "Usage: /setbounty [playerid] [bounty]");
    SetPlayerBounty(bid,bountyvalue);
   //Other message functions here.

   return 1;
}
CMD:pm(playerid,params[])
{

	new pID, text[128], string[128];
	if(sscanf(params, "us", pID, text)) return SendClientMessage(playerid, COLOR_RED, "USAGE: /pm (nick/id) (message) - Enter a valid Nick / ID");
	if(!IsPlayerConnected(pID)) return SendClientMessage(playerid, COLOR_RED, "Player is not connected.");
	if(pID == playerid) return SendClientMessage(playerid, COLOR_RED, "You cannot PM yourself.");
	format(string, sizeof(string), "%s (%d) is not accepting private messages at the moment.", PlayerNameee(pID), pID);
	if(pInfo[pID][NoPM] == 1) return SendClientMessage(playerid, COLOR_RED, string);
	format(string, sizeof(string), "PM to %s: %s", PlayerNameee(pID), text);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "PM from %s: %s", PlayerNameee(playerid), text);
	SendClientMessage(pID, COLOR_YELLOW, string);
	pInfo[pID][Last] = playerid;
   	return 1;
}

CMD:r(playerid,params[])
{

	new text[128], string[128];
	if(sscanf(params, "s", text)) return SendClientMessage(playerid, COLOR_RED, "USAGE: /reply (message) - Enter your message");
	new pID = pInfo[playerid][Last];
	if(!IsPlayerConnected(pID)) return SendClientMessage(playerid, COLOR_RED, "Player is not connected.");
	if(pID == playerid) return SendClientMessage(playerid, COLOR_RED, "You cannot PM yourself.");
	format(string, sizeof(string), "%s (%d) is not accepting private messages at the moment.", PlayerNameee(pID), pID);
	if(pInfo[pID][NoPM] == 1) return SendClientMessage(playerid, COLOR_RED, string);
	format(string, sizeof(string), "PM to %s: %s", PlayerNameee(pID), text);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "PM from %s: %s", PlayerNameee(playerid), text);
	SendClientMessage(pID, COLOR_YELLOW, string);
	pInfo[pID][Last] = playerid;
   	return 1;
}

CMD:blockpm(playerid,params[])
{
	#pragma unused params
	if(pInfo[playerid][NoPM] == 0)
	{
	    pInfo[playerid][NoPM] = 1;
	    SendClientMessage(playerid, COLOR_YELLOW, "You are no longer accepting private messages.");
	}
	else
	{
	    pInfo[playerid][NoPM] = 0;
	    SendClientMessage(playerid, COLOR_YELLOW, "You are now accepting private messages.");
	}
   return 1;
}

CMD:paint(playerid, params[])
{
    new color1,color2;
    if(sscanf(params, "ii", color1, color2)) return SendClientMessage(playerid, COLOR_RED, "Usage: /paint [color1] [color2]");
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, Grey, "You are not in a vehicle.");
    ChangeVehicleColor(GetPlayerVehicleID(playerid),color1,color2);
    SendClientMessage(playerid,COLOR_ORANGE,"You have changed your vehicle's color.");
    return 1;
}

CMD:war(playerid, params[])
{
	if(pInfo[playerid][pAdmin] >= 5)
	{
		new string[256], ircMsg[256];
 		SendClientMessage(playerid,COLOR_ORANGE,"You have enabled WAR! [Active for "XPTime"");
 		format(string, sizeof(string), "{F81414}Admin {FFFFFF}%s {F81414}has acticated WAR for {FFFFFF}"XPTime"", pInfo[playerid][Nick]);
		SendClientMessageToAll( -1, string);
	    	
		format(ircMsg, sizeof(ircMsg), "0,5Admin %s has just endabled WAR MODE!", pInfo[playerid][Nick]);
		IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
		IRC_GroupSay(groupID, IRC_ADMIN_CHANNEL, ircMsg);
		
		SetTimer("WarEnd", 3600000, false);
		SendRconCommand("hostname "WARHOST"");
 		for(new i = 0; i < MAX_PLAYERS; i++)
		{
	    	SetWeather(19);
	    	SetWorldTime(12);
 	    	PlayAudioStreamForPlayer(i, "http://puu.sh/7pMGP.mp3");
		}
	}
else SendClientMessage(playerid, COLOR_RED, ""EServ"");
return 1;
}

CMD:reconnect(playerid, params[])
{
    new pid;
    if(sscanf(params, "us", pid, params[2])) return SendClientMessage(playerid, 0xFF0000AA, "Command Usage: /reconnect [playerid] [reason]");
    if(pInfo[playerid][pAdmin] >= 2)
    {
        if(!IsPlayerConnected(pid)) return SendClientMessage(playerid, red, "ERROR: That player is not online.");
        new adminname[MAX_PLAYER_NAME], paramname[MAX_PLAYER_NAME], string[180];
        new ip[16], ircMsg[256];
        GetPlayerIp(pid, ip, sizeof(ip));
        GetPlayerName(pid, paramname, sizeof(paramname));
        GetPlayerName(playerid, adminname, sizeof(adminname));
        format(string, sizeof(string), "Administrator %s has forced %s to reconnect. [Reason: %s]", adminname, paramname, params[2]);
        SendClientMessageToAll(red, string);
        format(ircMsg, sizeof(ircMsg), "0,4Admin %s has forced %s to reconnect. [Reason: %s]", adminname, paramname, params[2]);
		IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
		IRC_GroupSay(groupID, IRC_ADMIN_CHANNEL, ircMsg);
        print(string);
        format(string, sizeof(string), "banip %s", ip);
        SetPVarString(pid,"reconnect",ip);
        ireconnect[pid] = 1;
        SendRconCommand(string);
    }
    else SendClientMessage(playerid, red, ""EServ"");
    return 1;
}

CMD:hello(playerid, params[])
{
	new Query[500];
	Bomb[playerid] = 1;
	sInfo[playerid][Bombs] ++;
	format(Query, 500, "UPDATE `ServerInfo` SET `Bombs` = '%d' WHERE `Server` = 'CountryTDM' LIMIT 1",
 	sInfo[playerid][Bombs]);
 	mysql_query(Query);
 	print(Query);
	return 1;
}

CMD:bomb(playerid, params[])
{
    if(Bomb[playerid] == 1) return SendClientMessage(playerid, COLOR_RED, "You've already planted a bomb!");//Swat Team
	{
		if(GetPlayerTeam(playerid) == 5) //swat
		{
			if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "You need to be in a vehicle");
	  		{
	    		new VID = GetPlayerVehicleID(playerid);
	    		new BombObject[MAX_VEHICLES], ircMsg[256], Query[500];
		    	SendClientMessage(playerid, COLOR_ORANGE, "You've planted a bomb on your vehicle; It will explode in 15 Seconds (After exited vehicle)");
	            BombObject[VID] = CreateObject(1654, 10.0, 10.0, 10.0, 0, 0, 0);
	            AttachObjectToVehicle(BombObject[VID], VID, 0.0, 3.75, 0.275, 0.0, 0.1, 0.0);
	            format(ircMsg, sizeof(ircMsg), "1,8Player %s has planted a car bomb in vehicle id %d (%s)", pInfo[playerid][Nick], GetPlayerVehicleID(playerid), GetVehicleName(VID));
				IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
				Bomb[playerid] = 1;
				Bomb[playerid] ++;
				format(Query, 500, "UPDATE `ServerInfo` SET `Bombs` = '%d' WHERE `Server` = 'CountryTDM' LIMIT 1",
			 	sInfo[playerid][Bombs]);
			 	mysql_query(Query);
			}
  		}
 	}
    return 1;
}

CMD:ipbanned(playerid,params[])
{
	if(pInfo[playerid][pAdmin] > 2)
	{
        new plrIP[50];
        new reason[256];
        GetPlayerIp(playerid, plrIP, sizeof(plrIP));
        if (sscanf(params, "s[50]",plrIP))
        {
            SendClientMessage(playerid, -1,"* Usage /IpBanned [IP]");
            return 1;
        }
        new query[256], msg[256];
        format(query, sizeof(query), "SELECT `IP` FROM `bans` WHERE `IP` = '%s'", plrIP);
    	mysql_query(query);
        mysql_store_result();
        if(!mysql_num_rows()){ SendClientMessage(playerid, COLOR_RED," That player isn't banned"); mysql_free_result(); return 1;}

        format(query, sizeof(query), "SELECT `reason` FROM `bans` WHERE `name` = '%s'", reason);
    	mysql_query(query);
    	mysql_store_result();

		format(msg, sizeof(msg), "%s Is banned! for %s", plrIP, reason);
        SendClientMessage(playerid, 0xD9E916FF, msg);
	 }
        return 1;
}

CMD:isbanned(playerid,params[])
{
	if(pInfo[playerid][pAdmin] > 2)
	{
        new name[128];
        if (sscanf(params, "s[128]",name))
        {
            SendClientMessage(playerid, -1,"* Usage /IsBanned [Name]");
            return 1;
        }
        new query[256], msg[256];
        format(query, sizeof(query), "SELECT `name`,`reason` FROM `bans` WHERE `name` = '%s'", name);
    	mysql_query(query);
        mysql_store_result();
        if(!mysql_num_rows()){ SendClientMessage(playerid, COLOR_RED," That player isn't banned"); mysql_free_result(); return 1;}
        format(msg, sizeof(msg), "%s Is banned!", name);
        SendClientMessage(playerid, 0xD9E916FF, msg);
	 }
        return 1;
}

CMD:unban(playerid,params[])
{
	if(pInfo[playerid][pAdmin] > 2)
	{
        new name[128];
        if (sscanf(params, "s[128]",name))
        {
            SendClientMessage(playerid, -1,"* Usage /unban [Name]");
            return 1;
        }
        new query[256], msg[256], msg2[256], msg3[256];
        format(query,sizeof(query),"SELECT `name` FROM `bans` WHERE `name`='%s' LIMIT 1",name);
        mysql_query(query);
        mysql_store_result();
        if(!mysql_num_rows()){ SendClientMessage(playerid, COLOR_RED," That player isn't banned"); mysql_free_result(); return 1;}

        format(query,sizeof(query),"DELETE FROM `bans` WHERE `name`='%s' LIMIT 1",name);
        mysql_query(query);

        format(msg, sizeof(msg), "%s has been unbanned!", name);
        SendClientMessage(playerid, 0xD9E916FF, msg);

        format(msg2, sizeof(msg2), "%s has just unbanned %s", pInfo[playerid][Nick], name);
        SendMessageToAdmins(msg2);

        format(msg3, sizeof(msg3), "Admin %s has just unbanned %s", pInfo[playerid][Nick], name);
        IRC_GroupSay(groupID, IRC_CHANNEL, msg3);
        IRC_GroupSay(groupID, IRC_ADMIN_CHANNEL, msg3);
        IRC_GroupSay(groupID, IRC_STAFF_CHANNEL, msg3);
	 }
        return 1;
}


CMD:cookie(playerid,params[])
{
	if(pInfo[playerid][pAdmin] >= 2)
	{
        new PID, msg[256], msg2[256], ircMsg[256], query[500];
        if (sscanf(params, "d", PID))
        {
            SendClientMessage(playerid, COLOR_RED,"* Usage /Cookie [ID]");
            return 1;
        }
        
	        format(msg, sizeof(msg), "Admin %s has given you a cookie! [Total Cookies: %d]",
			pInfo[playerid][Nick],
			Cookie[PID]);
			
	        format(msg2, sizeof(msg2), "You've given a cookie to %s", pInfo[PID][Nick]);
	        format(ircMsg, sizeof(ircMsg), "6Admin %s just given a cookie to %s [His total cookies are %d]",
			pInfo[playerid][Nick],
			pInfo[PID][Nick],
			Cookie[PID]);
	        
	        format(query,sizeof(query),"UPDATE `playerdata` SET `cookies` = '%d' WHERE `nick` = '%s' LIMIT 1",
			Cookie[PID],
			pInfo[PID][Nick]);
			
			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 10.0);
			PlayerPlaySound(PID, 1057, 0.0, 0.0, 10.0);
			IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	        SendClientMessage(playerid, 0xD9E916FF, msg2);
	        SendClientMessage(PID, 0xD9E916FF, msg);
        	mysql_query(query);
	        Cookie[PID] ++;
	        
	}
	else SendClientMessage(playerid, COLOR_RED,""EServ"");
	return 1;
}

CMD:changename(playerid, params[])
{
    new newname[24], pname[24], mystring[256], string2[256], string3[256];
    if(sscanf(params, "s[24]",newname))return SendClientMessage(playerid,COLOR_LIGHTBLUE,"USAGE: {FFFFFF}/changename [New Name]");

    GetPlayerName(playerid,pname,24);
    new query1[256],escapename[24];
    mysql_real_escape_string(newname, escapename);
    format(query1, sizeof(query1), "SELECT `nick` FROM `playerdata` WHERE `nick` = '%s'", escapename);
    mysql_query(query1);
    mysql_store_result();
    new rows = mysql_num_rows();
    if(!rows)
    {
        new query[256];
        format(query, sizeof(query), "UPDATE `playerdata` SET `nick`= '%s' WHERE `nick` ='%s'",escapename,pname);
        mysql_query(query);
        SetPlayerName(playerid , newname);
        format(mystring, sizeof(mystring),"%s Has changed his name to %s", pname, newname);
        SendMessageToAdmins(mystring);
        
        format(string2, sizeof(string2),"You've changed your name from %s to %s", pname, newname);
        SendClientMessage(playerid, COLOR_ORANGE, string2);
        
        format(string3, sizeof(string3),"4%s Has changed his name to %s", pname, newname);
        IRC_GroupSay(groupID, IRC_CHANNEL, string3);
        IRC_GroupSay(groupID, IRC_ADMIN_CHANNEL, string3);
        IRC_GroupSay(groupID, IRC_STAFF_CHANNEL, string3);
    }
    else if(rows == 1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "This name already exists!");
    }
    mysql_free_result();
    return 1;
}

CMD:goto(playerid, params[])
{
	if(pInfo[playerid][pAdmin] >= 2)
	{
		new plid, string[256];
		if (!strlen(params)) return SendClientMessage(playerid, COLOR_ORANGE, "Usage: /goto <id>");
		plid = strval(params);
		if (!IsPlayerConnected(plid)) return SendClientMessage(playerid, COLOR_RED, "Player Not Connected!");
		format(string, sizeof(string), "You have teleported to {FFFFFF}%s(%d)", pInfo[plid][Nick], plid);
		SendClientMessage(playerid, 0x66FF33, string);
		SendPlayerToAnother(playerid, plid);
	}
	else SendClientMessage(playerid, COLOR_RED, ""EServ"");
	return 1;
}

CMD:email(playerid, params[])
{
	new idx, string[256];
	if(pInfo[playerid][pAdmin] >= 2)
	{
		new text[128];
        GetStringText(params,idx,text);//Custom function to get whole text after first blank space
        if(!strlen(text)) { SendClientMessage(playerid,COLOR_SAMP," /email [Text]"); return 1; }//We dont want send empty email so we add usage
        for(new i; i < strlen(text); i ++)//Scan the text line to add some symbol because URL cant contain blank spaces
        {
            if(strfind(text[i]," ", true) == 0)//If scan process found blank space its gets replaced with "-" in my case, you can use any other symbol
            {
                text[i] = '-';//Result is Hello-World-!
            }
        }
	        format(string,sizeof(string), "c-roleplay.com/test.php?code=44514&msg=%s",text);//Format request URL to PHP file we made before
			//As you can see url contains code which is used later in PHP file we made
	        HTTP(playerid, HTTP_GET,string, " ", "EmailDelivered");//Sends a request to test.php file
        }
        return 1;
}

CMD:motd(playerid, params[])
{
	if(pInfo[playerid][pAdmin] >= 4)
	{
	    new motd[256], Query[500], str[256];
	    if(sscanf(params, "s[256]",motd))return SendClientMessage(playerid,COLOR_LIGHTBLUE,"USAGE: {FFFFFF}/MOTD [New MOTD]");

        format(Query, 500, "UPDATE `news` SET `message` = '%s'", motd);
        mysql_query(Query);
        print(Query);
        
        format(str, 256, "You've updated the server MOTD to: {FFFFFF}%s", motd);
        SendClientMessage(playerid, COLOR_ORANGE, str);
        
	}
	else SendClientMessage(playerid, COLOR_RED, ""EServ"");
    return 1;
}


CMD:ah(playerid, params[])
{
	if(pInfo[playerid][pAdmin] >= 2)
	{
	    new string[900];

		strcat(string, "Level 2:\n/pEmail [ID] - Shows a players email \n/Cookie [ID] - Gives the player a cookie\n/Cleanup [Radius] - Respawns cars within a distance of you.");
		strcat(string, "\n/Kick [ID] [Reason] - Kicks a player from the server \n/Reconnect [ID] [Reason] - Reconnects a Player \n\n\nLevel 3:\n/Goto [ID] - TP's you to a player \n/Unban [Name] - Unbans a player\n/Bring [PlayerID]\n/ForceUpdate [Forcfully Updates all accounts] \n/Announce [Style] [Time] [Text] \n/Ban [Bans a player] \n\n\nLevel 5\n/ReHash\n/Setlevel [ID] [Level] - Gives a player admin.\n");
        strcat(string, "/SetVIP [ID] [Level] - Gives a player VIP \nSaveCar [Color] [Color] [Plate] \n/MapIcon [Icon ID] [Color] \n/War [Enables War mode!]\n/MOTD [New Motd] - Updates the global MOTD");
		ShowPlayerDialog(playerid, DIALOG_AHELP, DIALOG_STYLE_MSGBOX, "{0FA0D1}CountSide TDM Admin Help - (@Text Admin Chat)", string, "Hide", "");
	}
    return 1;
}

CMD:myteam(playerid, params[])
{
	new string2[256];
	format(string2, sizeof(string2),"Your team is %s", GetTeamName(GetPlayerTeam(playerid)));
 	SendClientMessage(playerid, COLOR_ORANGE, string2);
    return 1;
}

CMD:pemail(playerid, params[])
{
    if(pInfo[playerid][pAdmin] >= 2)
	{
		new target, string2[256];
	    if(sscanf(params, "u", target)) return SendClientMessage(playerid, COLOR_SAMP, "/pEmail [ID]");
		format(string2, sizeof(string2),"%s's email is:{FFFFFF} %s", pInfo[target][Nick], LastEmail[target]);
	 	SendClientMessage(playerid, COLOR_ORANGE, string2);
	}
	else SendClientMessage(playerid, COLOR_RED, ""EServ"");
    return 1;
}


CMD:tpinfo(playerid, params[])
{
	    new string[500];
		strcat(string, "Welcome to the Trusted Player Informational center! \n At the moment the commads for Trusted Players are limited, we only have \nSeveral things abalible for them, more will be added very soon \nIf you have any suggestions for things to add be sure to tell and admin or even request \n");
        strcat(string, "it on the forums, we will check it out ASAP! \n\n/Head - This adds a large CJ head on your skin.");
		ShowPlayerDialog(playerid, DIALOG_AHELP, DIALOG_STYLE_MSGBOX, "{0FA0D1}CountSide TDM Trusted Player info", string, "Hide", "");
    	return 1;
}

CMD:vipinfo(playerid, params[])
{
	    new string[500];
		strcat(string, "Welcome to the VIP Informational center! \nThere are two levels of VIP on this server both giving you great upgrades \ningame, on the forum and also on IRC. \n\nLevel 1: VIP - Cost $3\n\nThis will get you Forum Title");
        strcat(string, "\nIRC voice \nAcess to fly the hydra and more! \n\nLevel 2: VIP - Cost $5 \n\nIRC moderator\nLarge chance of getting level 2 Admin \nExtra weapons at the gun store");
		ShowPlayerDialog(playerid, DIALOG_AHELP, DIALOG_STYLE_MSGBOX, "{0FA0D1}CountSide TDM VIP info", string, "Hide", "");
		return 1;
}
CMD:tips(playerid, params[])
{

	    new string[500];
		strcat(string, "Welcome to the Tips Center: \n\nThere are 5 Teams on the server each with their own weapons, class and colors, the objective is to \nKill the other teams, you can do so in several diffrent ways \nincluding using weapoised vehicles \n");
        strcat(string, "at this stage of the server there arent to many commands, if you wish to suggest some please do so at "WEB" \n\nAlso, if you would like to check out your live stats or even make a signiture with your stats checkout CountryTDM.info");
		ShowPlayerDialog(playerid, DIALOG_AHELP, DIALOG_STYLE_MSGBOX, "{0FA0D1}CountSide TDM VIP info", string, "Hide", "");

    return 1;
}

CMD:report(playerid, params[])
{
    new id;
    new reason[128], ircMsg[200];
    if(sscanf(params, "us[128]", id, reason)) return SendClientMessage(playerid, COLOR_RED, "USAGE: /report [ID] [REASON]");
    new string[150], sender[MAX_PLAYER_NAME], receiver[MAX_PLAYER_NAME];
    GetPlayerName(playerid, sender, sizeof(sender));
    GetPlayerName(id, receiver, sizeof(receiver));
    format(string, sizeof(string), "[ADMIN] - %s(%d) has reported %s(%d)", sender, playerid, receiver, id);
    SendMessageToAdmins(string);
    format(string, sizeof(string), "[ADMIN] - Reason: %s", reason);
    SendMessageToAdmins(string);
    format(ircMsg, sizeof(ircMsg), "1,7%s Has reported %s(%d) For %s", sender, receiver, id, reason);
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	IRC_GroupSay(groupID, IRC_ADMIN_CHANNEL, ircMsg);
    format(string, sizeof(string), "You have reported %s for %s. It has been sent to all online admins!", receiver, reason);
    SendClientMessage(playerid, COLOR_RED, string);
	return 1;
}

CMD:forceupdate(playerid, params[])
{
	if(pInfo[playerid][pAdmin] > 3)
	{
	    new updatemmsg[100];
	    format(updatemmsg, sizeof(updatemmsg), "Admin %s has forcefully updated all player accounts.", pInfo[playerid][Nick]);
    	SendClientMessageToAll(COLOR_RED, updatemmsg);
		SendClientMessage(playerid, COLOR_GREEN, "You have sucsesfully updated all player accounts!");
		SaveAll(playerid);
	}
    return 1;
}


CMD:setlevel(playerid, params[])
{
    if(IsPlayerAdmin(playerid) || pInfo[playerid][pAdmin] >= 100)
    // if the player is an rcon admin or the players admin level is greater or equal
    // to the defined admin level of that command
    {//then
        new level, target;
        //here we create 2 variable which we will use
        if(sscanf(params, "ui", target, level)) return SendClientMessage(playerid, red, "[*] Usage: /setadmin [playerid/name] [level]");
        //if the player hasnt entered a target id or level then it will return that msg
        if(target == INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "[*] Enter a valid player ID/name!");
        // if the target player is not a valid player then it will return that msg
        new string[128], Query[500], str2[50];
        if(level < 0 || level > MAX_ADMIN_LEVEL) // here we check if the level the player entered is more then the max admin level defined or 0
        {
            format(string, sizeof(string), "Enter a level between 0 and 5");
            SendClientMessage(playerid, red,string); // if it is then we send the message and stop the command from processing
            return 1;
        }
        format(Query, 500, "UPDATE `playerdata` SET `admin` = '%d' WHERE `nick` = '%s' LIMIT 1", level, pInfo[target][Nick]); //Format the query
        mysql_query(Query);
        // here we use the UPDATE option again and tell the database to update the player we specified's admin level to what we have set.
        pInfo[target][pAdmin] = level;
        //UpdateAcc(playerid);
        // here we set the target's var to what we defined
        format(string, 256, "You have set %s's admin level to %d.", pInfo[target][Nick], level);
        SendClientMessage(playerid, green, string);
        format(string, 256, "Admin %s has set your admin level to %d.", pInfo[playerid][Nick], level);
        SendClientMessage(target, yellow, string);
        
        new Query1[500];
        format(Query1, 500, "INSERT INTO adminlogs (command, admin, usedon, reason, date) VALUES('Setlevel', '%s', '%s', 'N/A', NOW())", pInfo[playerid][Nick], pInfo[target][Nick]);
		mysql_query(Query1);
        for (new i=0; i<MAX_PLAYERS; i++)
        {
            if(pInfo[i][Logged] == 1 && pInfo[i][pAdmin])
            {
                format(str2, sizeof(str2), "Admin %s[%d] has used the following command: Setlevel", pInfo[playerid][Nick], playerid);
                SendClientMessage(i,COLOR_SPRINGGREEN,string);
            }
        }
        // here we send the message to the admins
        PlayerPlaySound(target,1057,0.0,0.0,0.0);
        // play the sound for the target notifying him of this command.
    }
    else return ErrorMessage(playerid); // if it wasnt a rcon admin or his admin level wasnt greater then the max level
    //then we send the error message
    return 1;
}
CMD:setvip(playerid, params[])
{
    if(IsPlayerAdmin(playerid) || pInfo[playerid][pAdmin] >= 5)
    // if the player is an rcon admin or the players admin level is greater or equal
    // to the defined admin level of that command
    {//then
        new level, target;
        //here we create 2 variable which we will use
        if(sscanf(params, "ui", target, level)) return SendClientMessage(playerid, red, "[*] Usage: /SetVIP [playerid/name] [level]");
        //if the player hasnt entered a target id or level then it will return that msg
        if(target == INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "[*] Enter a valid player ID/name!");
        // if the target player is not a valid player then it will return that msg
        new string[128], Query[500];
        if(level < 0 || level > MAX_VIP_LEVEL) // here we check if the level the player entered is more then the max admin level defined or 0
        {
            format(string, sizeof(string), "Enter a level between 0 and %d!", MAX_VIP_LEVEL);
            SendClientMessage(playerid, red,string); // if it is then we send the message and stop the command from processing
            return 1;
        }
	        format(Query, 500, "UPDATE `playerdata` SET `vip` = '%d' WHERE `nick` = '%s' LIMIT 1", level, pInfo[target][Nick]); //Format the query
	        mysql_query(Query);
	        // here we use the UPDATE option again and tell the database to update the player we specified's admin level to what we have set.
	        pInfo[target][pVip] = level;
	        // here we set the target's var to what we defined
	        format(string, 256, "You have set %s[%d]'s VIP level to %d.", pInfo[target][Nick], target, level);
	        SendClientMessage(playerid, green, string);
	        format(string, 256, "Admin %s has set your VIP level to %d.", pInfo[playerid][Nick], level);
	        SendClientMessage(target, yellow, string);
	        new Query1[500];
	        format(Query1, 500, "INSERT INTO adminlogs (command, admin, usedon, reason, date) VALUES('SetVIP', '%s', '%s', 'N/A', NOW())", pInfo[playerid][Nick], pInfo[target][Nick]);
			mysql_query(Query1);
	        for (new i=0; i<MAX_PLAYERS; i++)
        {
            if(pInfo[i][Logged] == 1 && pInfo[i][pAdmin])
            {
                //format(str2, sizeof(str2), "%s Has set %s's VIP level to %d", pInfo[playerid][Nick], playerid, pInfo[target][Nick], level);
                //SendMessageToAdmins(str2);
            }
        }
        // here we send the message to the admins
        PlayerPlaySound(target,1057,0.0,0.0,0.0);
        // play the sound for the target notifying him of this command.
    }
    else return ErrorMessage(playerid); // if it wasnt a rcon admin or his admin level wasnt greater then the max level
    //then we send the error message
    return 1;
}

CMD:givetp(playerid, params[])
{
    if(IsPlayerAdmin(playerid) || pInfo[playerid][pAdmin] >= 5)
    // if the player is an rcon admin or the players admin level is greater or equal
    // to the defined admin level of that command
    {//then
        new level, target;
        //here we create 2 variable which we will use
        if(sscanf(params, "ui", target, level)) return SendClientMessage(playerid, red, "[*] Usage: /GiveTP [playerid/name] [level]");
        //if the player hasnt entered a target id or level then it will return that msg
        if(target == INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "[*] Enter a valid player ID/name!");
        // if the target player is not a valid player then it will return that msg
        new string[128], Query[500], str2[50];
        if(level < 0 || level > MAX_VIP_LEVEL) // here we check if the level the player entered is more then the max admin level defined or 0
        {
            format(string, sizeof(string), "Enter a level between 0 and %d!", MAX_VIP_LEVEL);
            SendClientMessage(playerid, red,string); // if it is then we send the message and stop the command from processing
            return 1;
        }
        format(Query, 500, "UPDATE `playerdata` SET `TP` = '%d' WHERE `nick` = '%s' LIMIT 1", level, pInfo[target][Nick]); //Format the query
        mysql_query(Query);
        // here we use the UPDATE option again and tell the database to update the player we specified's admin level to what we have set.
        pInfo[target][pTP] = level;
        // here we set the target's var to what we defined
        format(string, 256, "You have set %s[%d]'s Trusted Player level to %d.", pInfo[target][Nick], target, level);
        SendClientMessage(playerid, green, string);
        format(string, 256, "Admin %s has set your Trusted Player level to %d.", pInfo[playerid][Nick], level);
        SendClientMessage(target, yellow, string);
        new Query1[500];
        format(Query1, 500, "INSERT INTO adminlogs (command, admin, usedon, reason, date) VALUES('GiveTP', '%s', '%s', 'N/A', NOW())", pInfo[playerid][Nick], pInfo[target][Nick]);
		mysql_query(Query1);
        for (new i=0; i<MAX_PLAYERS; i++)
        {
            if(pInfo[i][Logged] == 1 && pInfo[i][pAdmin])
            {
                format(str2, sizeof(str2), "%s Has set %s's TP level to %d", pInfo[playerid][Nick], playerid, pInfo[target][Nick], level);
                SendMessageToAdmins(str2);
            }
        }
        // here we send the message to the admins
        PlayerPlaySound(target,1057,0.0,0.0,0.0);
        // play the sound for the target notifying him of this command.
    }
    else return ErrorMessage(playerid); // if it wasnt a rcon admin or his admin level wasnt greater then the max level
    //then we send the error message
    return 1;
}


stock SaveDynamicVehicle(Float:x, Float:y, Float:z, Float:a, mod, c1, c2, plate[])
{
    	new
		Query[512];

	format(Query, sizeof(Query), "INSERT INTO `dynamicvehicles` (model, x, y, z, a, c1, c2, plate) VALUES(%d, %f, %f, %f, %f, %i, %i, '%s')",
	mod, x, y, z, a, c1, c2, plate);

	mysql_query(Query);
	mysql_free_result();
	/*new
		Query[512];
	format(Query, 500, "INSERT INFO `dynamicvehicles` (model, x, y, z, a, c1, c2, plate) VALUES(%d, %f, %f, %f, %f, %i, %i, '%s ", mod, x, y, z, a, c1, c2, plate); //Format the query
 	mysql_query(Query);
	mysql_free_result();*/
	return 1;
}
stock GetVehicleName(vehicleid)
{
	new String[28];
    format(String,sizeof(String),"%s",VehicleNames[GetVehicleModel(vehicleid) - 400]);
    return String;
}

stock GetTeamName ( TeamID )
{
    new
        tName [ 64 ];
            // We probably don't even need 64 cells for this, but we will just in case.

    switch( TeamID )
    {
        case TEAM_MECH:
        {
            tName = "Mechanic";
            // If their Team ID is TEAM_ONE, then GetTeamName will return "Attackers"
        }

        case TEAM_HOBO:
        {
            tName = "Hobo";
            // If their Team ID is TEAM_TWO, then GetTeamName will return "Defenders"
        }
        case TEAM_FARM:
        {
            tName = "Farmer";
            // If their Team ID is TEAM_TWO, then GetTeamName will return "Defenders"
        }
        case TEAM_RACE:
        {
            tName = "Racer";
            // If their Team ID is TEAM_TWO, then GetTeamName will return "Defenders"
        }
        case TEAM_HIPP:
        {
            tName = "Hippy";
            // If their Team ID is TEAM_TWO, then GetTeamName will return "Defenders"
        }
        case TEAM_POLL:
        {
            tName = "Sheriff";
            // If their Team ID is TEAM_TWO, then GetTeamName will return "Defenders"
        }

        default: // Anything but TEAM_ONE or TEAM_TWO.
        {
            tName = "Duel";
            // If it's unknown ( I'm not sure how this would happen, but I'm sure it's possible.. )
        }
    }
    return tName;
}

stock GetVehicleColorName(color)
{
    new clr[32];
    switch(color)
    {
        case 0: clr ="Black";
        case 1: clr ="White";
        case 2: clr ="Blue";
        case 3: clr ="Red";
        case 4: clr ="Grey-Green";
        case 5: clr ="Purple";
        case 6: clr ="Yellow";
        case 7: clr ="Blue";
        case 8: clr ="Silver";
        case 9: clr ="Dark sGrey";
        case 10: clr ="Midnight Blue";
        case 11: clr ="Dark Grey";
        case 12: clr ="Teal";
        case 13: clr ="Dark Grey";
        case 14: clr ="Light Grey";
        case 15: clr ="Silver";
        case 16: clr ="Dark Green";
        case 17: clr ="Dark Red";
        case 18: clr ="Dark Red";
        case 19: clr ="Grey";
        case 20: clr ="Royal Blue";
        case 21: clr ="Rich Maroon";
        case 22: clr ="Rich Maroon";
        case 23: clr ="Grey";
        case 24: clr ="Dark Grey";
        case 25: clr ="Dark Grey";
        case 26: clr ="Light Grey";
        case 27: clr ="Grey";
        case 28: clr ="Midnight Blue";
        case 29: clr ="Light Grey";
        case 30: clr ="Dark Maroon";
        case 31: clr ="Red";
        case 32: clr ="Baby Blue";
        case 33: clr ="Grey";
        case 34: clr ="Grey";
        case 35: clr ="Dark Grey";
        case 36: clr ="Dark Grey";
        case 37: clr ="";
        case 38: clr ="Tea Green";
        case 39: clr ="Steel blue";
        case 40: clr ="Black";
        case 41: clr ="Light Brown";
        case 42: clr ="Bright Maroon";
        case 43: clr ="Maroon";
        case 44: clr ="Myrtle Green";
        case 45: clr ="Maroon";
        case 46: clr ="Olive Green";
        case 47: clr ="Olive";
        case 48: clr ="Khaki Brown";
        case 49: clr ="Light Grey";
        case 50: clr ="Silver Grey";
        case 51: clr ="Dark Green";
        case 52: clr ="Dark Teal";
        case 53: clr ="Navy Blue";
        case 54: clr ="Navy Blue";
        case 55: clr ="Brown";
        case 56: clr ="Light Grey";
        case 57: clr ="Beige";
        case 58: clr ="Maroon";
        case 59: clr ="Grey-Blue";
        case 60: clr ="Grey";
        case 61: clr ="Old Gold";
        case 62: clr ="Maroon";
        case 63: clr ="Grey";
        case 64: clr ="Grey";
        case 65: clr ="Old Gold";
        case 66: clr ="Dark Brown";
        case 67: clr ="Light Blue";
        case 68: clr ="Light Khaki";
        case 69: clr ="Light Pink";
        case 70: clr ="Bright Maroon";
        case 71: clr ="Light Blue";
        case 72: clr ="Grey";
        case 73: clr ="Tea Green";
        case 74: clr ="Dark Maroon";
        case 75: clr ="Dark Blue";
        case 76: clr ="Light Brown";
        case 77: clr ="Ecru Brown";
        case 78: clr ="Maroon";
        case 79: clr ="Royal Blue";
        case 80: clr ="Rich Maroon";
        case 81: clr ="Light Brown";
        case 82: clr ="Bright Maroon";
        case 83: clr ="Dark Teal Green";
        case 84: clr ="Brown";
        case 85: clr ="Rich Maroon";
        case 86: clr ="Green";
        case 87: clr ="Blue ";
        case 88: clr ="Maroon";
        case 89: clr ="Beige";
        case 90: clr ="Grey";
        case 91: clr ="Dark Blue";
        case 92: clr ="Grey";
        case 93: clr ="Sky Blue";
        case 94: clr ="Blue";
        case 95: clr ="Navy Blue";
        case 96: clr ="Silver";
        case 97: clr ="Light Blue";
        case 98: clr ="Grey";
        case 99: clr ="Light Brown ";
        case 100: clr ="Blue";
        case 101: clr ="Dark Blue";
        case 102: clr ="Light Brown";
        case 103: clr ="Blue";
        case 104: clr ="Brown";
        case 105: clr ="Dark Grey";
        case 106: clr ="Blue";
        case 107: clr ="Light Brown";
        case 108: clr ="Yale Blue";
        case 109: clr ="Dark Grey";
        case 110: clr ="Brown";
        case 111: clr ="Light Grey";
        case 112: clr ="Blue";
        case 113: clr ="Brown";
        case 114: clr ="Dark Grey";
        case 115: clr ="Dark Red";
        case 116: clr ="Navy Blue";
        case 117: clr ="Dark Maroon";
        case 118: clr ="Light Blue";
        case 119: clr ="Brown";
        case 120: clr ="Light Brown";
        case 121: clr ="Dark Maroon";
        case 122: clr ="Grey";
        case 123: clr ="Brown";
        case 124: clr ="Rich Maroon";
        case 125: clr ="Dark Blue";
        case 126: clr ="Pink";
    }
    return clr;
}
stock LoadDynamicVehicles()
{
	new Str[128], VehicleID, VehicleModel, Float:VehicleX, Float:VehicleY, Float:VehicleZ, Float:VehicleA, Col1, Col2, vehPlate[10], i = 0;

    mysql_query("SELECT * FROM `dynamicvehicles`");
    mysql_store_result();
    if(mysql_num_rows() != 0)
    {
        while(mysql_fetch_row(Str))
        {
            sscanf(Str, "p<|>iiffffiis[10]", VehicleID, VehicleModel, VehicleX, VehicleY, VehicleZ, VehicleA, Col1, Col2, vehPlate);

            AddStaticVehicleEx ( VehicleModel, VehicleX, VehicleY, VehicleZ, VehicleA, Col1, Col2, 60 );

			SetVehicleNumberPlate(i, vehPlate);

            SetVehicleToRespawn(i);

            DynamicCarID[i] = VehicleID;
            DynamicCarCol[i][1] = Col1;
            DynamicCarCol[i][2] = Col2;
			DynamicCar[i] = 1;
            i++;
		}
    }
    new ircMsg[100];
    mysql_free_result();
    printf("--- %i vehicles loaded from the MySQL Database. ---", i);
    format(ircMsg, sizeof(ircMsg), "05--- %i vehicles loaded from the MySQL Database. ---", i);
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
 format(ircMsg, sizeof(ircMsg), "05--- %i Mapped objects where loaded from the script ---", CountDynamicObjects());
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	return 1;
}

public GMX()
{
	SendRconCommand("gmx");
}

public LoadVeh(playerid)
{

    mysql_fetch_int("Bombs", sInfo[playerid][Bombs]);
	AddMapIconFromFile();
	LoadDynamicVehicles();
	LoadLabels();
    LoadPickups();
    LoadCPs();
    StartLoading();
    LoadHouses();
    LoadDeer();
}
stock AddMapIconFromFile() //HEREE
{
	new Str[67], MType, Float:MX, Float:MY, Float:MZ, MColor, Icons;
	mysql_query("SELECT * FROM `mapicons`");
	mysql_store_result();
    Icons = mysql_num_rows();
    if(Icons > 0)
    {
        while(mysql_fetch_row(Str))
        {
		    sscanf(Str, "p<|>fffii", MX, MY, MZ, MType, MColor);
		    CreateDynamicMapIcon(MX, MY, MZ, MType, MColor, -1, -1, -1, MAPICONDISTANCE);
		}
	}
	mysql_free_result();
	printf("--- %i Map Markers where loaded from the MySQL Database ---", Icons);
    new ircMsg[100];
    format(ircMsg, sizeof(ircMsg), "05--- %i Map Markers where loaded from the MySQL Database ---", Icons);
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	return 1;
}
public DropPlayerWeapons(playerid)
{
    new playerweapons[13][2];
    new Float:x,Float:y,Float:z;
    GetPlayerPos(playerid, x, y, z);//here gets your position..!

    for(new i=0; i<13; i++)
    {
        GetPlayerWeaponData(playerid, i, playerweapons[i][0], playerweapons[i][1]);
        new model = GetWeaponType(playerweapons[i][0]);// this to get, what weapons are you using in the moment !
        new times = floatround(playerweapons[i][1]/10.0001);
        new Float:X = x + (random(3) - random(3));
        new Float:Y = y + (random(3) - random(3));
        if(playerweapons[i][1] != 0 && model != -1)
        {
            if(times > DropLimit) times = DropLimit;
            for(new a=0; a<times; a++)
            {
                new pickupid = CreatePickup(model, 3, X, Y, z);//this is the place where you die, there you will drop your weapons !
                SetTimerEx("DeletePickup", DeleteTime*1000, false, "d", pickupid);//there you may change the time 1 *1000 to *19283718293712 whatever...!
				SetTimer("remdgunlbl", 1000, false);
				//debugg = CreateDynamic3DTextLabel("Random Weapon Drops!", COLOR_ORANGE, x, y, z, 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
			}
        }
    }
    return 1;
}

public DeletePickup(pickupid)
{
    DestroyPickup(pickupid);
    return 1;
}
GetWeaponType(weaponid) //explainin'
{
    switch(weaponid)
    {
        case 1: return 331; case 2: return 333; case 3: return 334; // this is to define the weapons
        case 4: return 335; case 5: return 336; case 6: return 337;
        case 7: return 338; case 8: return 339; case 9: return 341;
        case 10: return 321; case 11: return 322; case 12: return 323;
        case 13: return 324; case 14: return 325; case 15: return 326;
        case 16: return 342; case 17: return 343; case 18: return 344;
        case 22: return 346; case 23: return 347; case 24: return 348;
        case 25: return 349; case 26: return 350; case 27: return 351;
        case 28: return 352; case 29: return 353; case 30: return 355;
        case 31: return 356; case 32: return 372; case 33: return 357;
        case 34: return 358; case 35: return 359; case 36: return 360;
        case 37: return 361; case 38: return 362; case 39: return 363;
        case 41: return 365; case 42: return 366; case 46: return 371; //example, this case is the id 46 is the parachute, we will drop the parachute, that's if  you got one
    }
    return -1;
}
stock AddMapIconToFile(Float:MX, Float:MY, Float:MZ, MType, MColor)
{
	new Query[200];

	format(Query, sizeof(Query), "INSERT INTO `mapicons` (MapIconX, MapIconY, MapIconZ, MapIconType, MapIconColor) VALUES(%f, %f, %f, %d, %d)",
	MX, MY, MZ, MType, MColor);

	mysql_query(Query);
	mysql_free_result();
	return 1;
}


stock IsVehicleRCVehicle(vehicleid)
{
        for(new v; v < 6; v++)
        {
            if(GetVehicleModel(vehicleid) == RCVehicles[v]) return 1;
        }
        return 0;
}

public LoadFunc()
{
	printf("--- All functions have been loaded from Funcs.pwn ---");
	new ircMsg[100];
    format(ircMsg, sizeof(ircMsg), "05--- All defines and Functions have been loaded ---");
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
}
forward UpdateTime();
public UpdateTime()
{
  new Str[34];
  TimeS --;
  if(TimeS == 0)
  {
    KillTimer(Time);
  }
  if(TimeS == -1)
  {
    TimeM--;
    TimeS = 10;
  }
  format(Str, sizeof(Str), "%d", TimeS);
  TextDrawSetString(Timer, Str);
  return 1;
}
forward Kicktime(playerid);
public Kicktime(playerid)
{
Kick(playerid);
}
public InteriorEntered(playerid) return TogglePlayerControllable(playerid, true); //test

stock LoadLabels()
{
    new ircMsg[200];
    Create3DTextLabel("Ari's Shack", COLOR_BLUE, -348.0237, -1046.4175, 59.8045, 20.0, 0, 0);
    Create3DTextLabel("Mechanic Room", COLOR_BLUE, -85.0882, -1214.6743, 3.1278, 20.0, 0, 0);
    Create3DTextLabel("Racer Room", COLOR_GREY, -516.1523, -539.6647, 25.5234, 20.0, 0, 0);
    Create3DTextLabel("Garage Exit", COLOR_GREY, -563.7273,-546.7153,694.4821, 25.0, 0, 0);
    Create3DTextLabel("x2 Ammo \n1Use/Spawn", COLOR_GREY, -544.1939, -537.2751, 698.3587, 25.0, 0, 0);
    Create3DTextLabel("Farmer Room", COLOR_GREEN, -392.4128,-1446.6879,26.1091, 20.0, 0, 0);
    Create3DTextLabel("Full Health \nRespawn Delay", COLOR_BLUE, 2815.3242, -1173.4314, 1025.5703, 20.0, -1, 0);
    Create3DTextLabel("Mechanic Telescope", COLOR_BLUE, 2817.3940, -1167.1050, 1025.5778, 5.0, 420, 0);
    Create3DTextLabel("Farmer Telescope", COLOR_GREEN, 2817.3940, -1167.1050, 1025.5778, 5.0, 421, 0);
    Create3DTextLabel("Ammunation", COLOR_GREY, -380.4290, -1147.5038, 69.3471, 5.0, 0, 0);
    Create3DTextLabel("Ammunation", COLOR_GREY, -585.0076, -1051.8682, 23.5283, 5.0, 0, 0);
    format(ircMsg, sizeof(ircMsg), "05--- %d Server Labels where loaded from the script ---", CountDynamic3DTextLabels());
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
    return 1;
}

stock LoadDeer()
{
	for(new i; i<=MaxDeer; i++)
    {
    	DeerCreated[i] = CreateObject(Deer, -212.1197,-1022.2452,18.0943, 0.0, 0.0, 0.0);
    	print("loaded DEER");
    }
    SetTimer("OnDeerRespawn", 600000, true);
}
stock LoadCPs()
{
    new ircMsg[200];
   	MechanicTele = CreateDynamicCP(2817.3940, -1167.1293, 1025.5778, 0.5, 420, -1, -1, 100.0);
	FarmerTele = CreateDynamicCP(2817.3940, -1167.1293, 1025.5778, 0.5, 421, -1, -1, 100.0);
	GunMenu1 = CreateDynamicCP(312.2480, -165.7422, 999.6010, 0.6, -1, -1, -1, 100.0);
	GunMenu2 = CreateDynamicCP(290.3207, -109.5045, 1001.5156, 0.6, -1, -1, -1, 100.0);
    format(ircMsg, sizeof(ircMsg), "05--- %i Server Checkpoints where loaded from the script ---", CountDynamicCPs());
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
    return 1;
}
stock LoadPickups()
{
	new ircMsg[200];
	Ammo1 = CreateDynamicPickup(1242, 1, -380.4290, -1147.5038, 69.3471, -1, -1, -1, 100.0);
	parachute = CreateDynamicPickup(371, 3, -96.1510, -971.9083, 123.3061, -1, -1, -1, 100.0);
	sniper = CreateDynamicPickup(358, 3, -90.3852,-983.3844,123.3061, -1, -1, -1, 100.0);
	Ammo2 = CreateDynamicPickup(1242, 1, -585.0076, -1051.8682, 23.5283, -1, -1, -1, 100.0);
	Ammo1Exit = CreateDynamicPickup(1314, 1, 297.8041, -111.2916, 1001.5156, -1, -1, -1, 100.0);
	Ammo2Exit = CreateDynamicPickup(1314, 1, 316.2773,-170.2969,999.5938, -1, -1, -1, 100.0);
    RacerBunker = CreateDynamicPickup(1314, 1, -516.1523, -539.6647, 25.5234, -1, -1, -1, 100.0);
	RacerBunkerExit = CreateDynamicPickup(1314, 1, -563.7273,-546.7153,694.4821, -1, -1, -1, 100.0);
	RacerAmmo = CreateDynamicPickup(3082, 22, -544.1939, -537.2751, 698.3587, -1, -1, -1, 100.0);
    FarmerBunker = CreateDynamicPickup(1314, 1, -392.4128,-1446.6879,26.1091, -1, -1, -1, 100.0);
    FarmerBunkerExit = CreateDynamicPickup(1314, 1, 2819.8979, -1172.9331, 1025.5703, 421, -1, -1, 100.0);
    HPpickup = CreateDynamicPickup(1240, 2, 2815.3242, -1173.4314, 1025.5703, -1, -1, -1, 100.0);
	MechBunker = CreateDynamicPickup(1314, 1, -85.0882, -1214.6743, 3.1278, -1, -1, -1, 100.0);
	MechBunkerExit = CreateDynamicPickup(1314, 1, 2819.8979, -1172.9331, 1025.5703, 420, -1, -1, 100.0);
	format(ircMsg, sizeof(ircMsg), "05--- %i Server Pickups where loaded from the script ---", CountDynamicPickups());
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	return 1;
}

SaveAll(playerid)
{
        new country[MAX_COUNTRY_NAME];
	    country = GetPlayerCountryName(playerid);
        pInfo[playerid][pScore] = GetPlayerScore(playerid);
        pInfo[playerid][pMoney] = GetPlayerMoney(playerid);
        new Query[900];
        format(Query, 500, "UPDATE `playerdata` SET `admin` = '%d', `score` = '%d', `money` = '%d', `cookies` = '%d', `deaths` = '%d', `country` = '%s' WHERE `nick` = '%s' LIMIT 1",
        pInfo[playerid][pAdmin],
        pInfo[playerid][pScore],
        pInfo[playerid][pMoney],
        Cookie[playerid],
        pInfo[playerid][pDeaths],
        country,
        pInfo[playerid][Nick]);
        mysql_query(Query);
		return 1;
}


public randomweather()
{

            Weather = random(20);
            SetWeather(Weather);
}

/*public randommessage(playerid)
{
	new ircMsg[256];
	format(ircMsg, sizeof(ircMsg), "!say hi");
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
}*/
public CheckPlayer()
{
    foreach(Player, i){
        if(!IsPlayerConnected(i)) continue;
        if(GetTickCount() - pTick[i] > 1500 ){
            if(IsPaused[i] == 0 && GetPVarInt(i, "spawned") == 1){
			pauseLaber[i] = CreateDynamic3DTextLabel("AFK, i'm pausing", 0xFB0404C8, 0, 0, 0, 25, i,INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
			IsPaused[i] = 1;
			pKilled[i]=0;
			}
        }
        else{
            if(IsPaused[i] == 1) DestroyDynamic3DTextLabel(pauseLaber[i]);
            if(IsPunished[i] == 1) SetPlayerVirtualWorld(i,GetPVarInt(i, "world"));
            IsPaused[i] = 0;
            IsPunished[i] = 0;
        }
        if(GetTickCount() - pTick[i] > 8000 && GetPVarInt(i, "spawned") == 1){
            if(IsPunished[i] == 0){
            IsPunished[i] = 1;
            SetPVarInt(i, "world", GetPlayerVirtualWorld(i));
            SetPlayerVirtualWorld(i,107);
            }
        }
    }
    return 1;
}
public RandomMessage()
{
		IRC_GroupSay(groupID, IRC_ADMIN_CHANNEL, RandomMessages[random(sizeof(RandomMessages))]);
        return 1;
}

stock StartLoading()
{
    #if defined AntiCheat
 	new ircMsg[256];
    format(ircMsg, sizeof(ircMsg), "05--- "AntiCheat" Anticheat Bot is loaded ---");
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	#endif
    format(ircMsg, sizeof(ircMsg), "05--- IRC "PLUGIN_VERSION" is loaded ---");
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	format(ircMsg, sizeof(ircMsg), "05--- "HOST" 14On Version 05"VER" 14MapName 05"MAP" 14Website @ 05"WEB" ---");
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
    return 1;
}

stock SendMessageToTPS(text[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(pInfo[i][pTP] > 1)
        {
            new ircMsg[256];
            SendClientMessage(i, COLOR_ORANGE, text);
            format(ircMsg, sizeof(ircMsg), "%s", text);
			IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
        }
    }
}

stock SendMessageToVIPS(text[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(pInfo[i][pVip] > 1)
        {
            new ircMsg[256];
            SendClientMessage(i, COLOR_ORANGE, text);
            format(ircMsg, sizeof(ircMsg), "%s", text);
			IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
        }
    }
}

stock SendMessageToAdmins(text[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(pInfo[i][pAdmin] > 1)
        {
            new ircMsg[256];
            SendClientMessage(i, COLOR_RED, text);
            format(ircMsg, sizeof(ircMsg), "%s", text);
			IRC_GroupSay(groupID, IRC_ADMIN_CHANNEL, ircMsg);
        }
    }
}
stock IsValidNosVehicle(vehicleid)
{
    if(IsAPlane(vehicleid)) return 0;
    switch(GetVehicleModel(vehicleid))
    {
        case 581,523,462,521,463,522,461,448,468,586,
                         509,481,510,472,473,493,595,484,430,453,
                         452,446,454,590,569,537,538,570,449: return 0;
    }
    return 1;
}

stock IsAPlane(vehicleid)
{
    switch(GetVehicleModel(vehicleid))
    {
        case 460,464,476,511,512,513,519,520,553,577,592,593: return 1;
    }
    return 0;
}

stock NameLabelsGone(playerid)
{
	Delete3DTextLabel(Namee[playerid]);
	Delete3DTextLabel(FARMLabel[playerid]);
	Delete3DTextLabel(HOBOLabel[playerid]);
	Delete3DTextLabel(RACELabel[playerid]);
	Delete3DTextLabel(HIPPLabel[playerid]);
}

public DestroyDamage(playerid)
{
	Delete3DTextLabel(PlayerLabel[playerid]);
}

stock BanChecker(playerid)
{
    new Year, Month, Day;
	getdate(Year, Month, Day);
    new query[128], player_ip[16], ircMsg[256], bool:banned = false;
    GetPlayerIp(playerid, player_ip, sizeof(player_ip));
    format(query, sizeof(query), "SELECT * FROM `bans` WHERE `name` = '%s'", pInfo[playerid][Nick]);
    mysql_query(query);
    mysql_store_result();
    if(mysql_num_rows() > 0)
	{
	    SendClientMessage(playerid, COLOR_RED, "He's banned");
    	mysql_free_result();
    }
    return banned;
}

stock IsPlayerBanned(playerid)
{
    new Year, Month, Day;
	getdate(Year, Month, Day);
    new query[128], player_ip[16], ircMsg[256];
    GetPlayerIp(playerid, player_ip, sizeof(player_ip));
    format(query, sizeof(query), "SELECT * FROM `bans` WHERE `name` = '%s'", pInfo[playerid][Nick]);
    mysql_query(query);
    mysql_store_result();
    if(mysql_num_rows() > 0)
 	{
 	    mysql_fetch_int("IRCBan", BInfo[playerid][pDate]);
	    SendClientMessage(playerid, COLOR_RED, ""PServ"We've detected your account is BANNED, if you would like to appeal it do so at "WEB"");
	    ShowPlayerDialog(playerid, DIALOG_BANNED, DIALOG_STYLE_MSGBOX, "BANNED", "We've detected that you're account is BANNED!\n\nIf you wish to appeal this do so on the forums \nwww.CountryTDM.info", "Close", "");
    	SetTimer("BanHim", 100, false);
    	format(ircMsg, sizeof(ircMsg), "0,4%s May be attempting to ban evade (Account is banned) Current IP is %s - Matching an account that was banned by (%s) Please review the ban!", pInfo[playerid][Nick], player_ip, BInfo[playerid][pDate]);
		IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
		mysql_free_result();
	}
}

stock GivePlayerCash(playerid, money)
{
    Cash[playerid] += money;
    ResetMoneyBar(playerid);//Resets the money in the original moneybar, Do not remove!
    UpdateMoneyBar(playerid,Cash[playerid]);//Sets the money in the moneybar to the serverside cash, Do not remove!
    return Cash[playerid];
}
stock SetPlayerCash(playerid, money)
{
    Cash[playerid] = money;
    ResetMoneyBar(playerid);//Resets the money in the original moneybar, Do not remove!
    UpdateMoneyBar(playerid,Cash[playerid]);//Sets the money in the moneybar to the serverside cash, Do not remove!
    return Cash[playerid];
}
stock ResetPlayerCash(playerid)
{
    Cash[playerid] = 0;
    ResetMoneyBar(playerid);//Resets the money in the original moneybar, Do not remove!
    UpdateMoneyBar(playerid,Cash[playerid]);//Sets the money in the moneybar to the serverside cash, Do not remove!
    return Cash[playerid];
}
stock GetPlayerCash(playerid)
{
    return Cash[playerid];
}


LoadTD(playerid)
{
	kbBack = TextDrawCreate(485.000000, 400.000000, "~n~~n~~n~~n~~n~~n~");
	TextDrawBackgroundColor(kbBack, 255);
	TextDrawFont(kbBack, 1);
	TextDrawLetterSize(kbBack, 0.300000, 1.399999);
	TextDrawColor(kbBack, -1);
	TextDrawSetOutline(kbBack, 0);
	TextDrawSetProportional(kbBack, 1);
	TextDrawSetShadow(kbBack, 1);
	TextDrawUseBox(kbBack, 1);
	TextDrawBoxColor(kbBack, 100);
	TextDrawTextSize(kbBack, 630.000000, 0.000000);

	kbText[playerid] = TextDrawCreate(485.000000, 400.000000, "_");
	TextDrawBackgroundColor(kbText[playerid], 255);
	TextDrawFont(kbText[playerid], 1);
	TextDrawLetterSize(kbText[playerid], 0.260000, 1.399999);
	TextDrawColor(kbText[playerid], -1);
	TextDrawSetOutline(kbText[playerid], 0);
	TextDrawSetProportional(kbText[playerid], 1);
	TextDrawSetShadow(kbText[playerid], 1);

	disconnect[playerid] = TextDrawCreate(485.000000, 430.000000, "_");
	TextDrawBackgroundColor(disconnect[playerid], 255);
	TextDrawFont(disconnect[playerid], 1);
	TextDrawLetterSize(disconnect[playerid], 0.260000, 1.399999);
	TextDrawColor(disconnect[playerid], -1);
	TextDrawSetOutline(disconnect[playerid], 0);
	TextDrawSetProportional(disconnect[playerid], 1);
	TextDrawSetShadow(disconnect[playerid], 1);

	Background[playerid] = CreatePlayerTextDraw(playerid, 320, 0, "_");
 	PlayerTextDrawUseBox(playerid, Background[playerid], 1);
  	PlayerTextDrawLetterSize(playerid, Background[playerid], 1.0, 49.6);
   	PlayerTextDrawTextSize(playerid, Background[playerid], 1.0, 640);
   	PlayerTextDrawBoxColor(playerid, Background[playerid], 0x00000000);
   	PlayerTextDrawAlignment(playerid, Background[playerid], 2);


}
DestroyTD()
{
	TextDrawDestroy(kbBack);
}
UpdateKillBox(killer, victim, weapon)
{
	new
	    killerName[MAX_PLAYER_NAME],
	    victimName[MAX_PLAYER_NAME],
	    tmpWepName[17],
		tmpLine[70],
		iLoop,
		iChar = 16,
		len,
		tmpPos;

	// Format the new line to insert at the top of the kill list.
	GetPlayerName(killer, killerName, MAX_PLAYER_NAME);
	GetPlayerName(victim, victimName, MAX_PLAYER_NAME);
	GetWeaponName(weapon, tmpWepName, 17);
	format(tmpLine, 70, "%s %s %s~n~", killerName, tmpWepName, victimName);

	// Insert the new line at the top of the list,
	// This is after the heading of the killfeed.
	strins(szKbString, tmpLine, strlen(KILLBOX_TEXT), 70);

	// This next part will remove any unwanted newline characters
	// Because we only want 5 (Or whatever you set MAX_KB_LINES to)
	// lines after the heading

	len = strlen(szKbString);

	// Loop through the text while the number of found lines is below the max
	// and while the looping character cell is within the string.
	while(iLoop < MAX_KB_LINES && iChar < len)
	{
	    // Look for the nextline character
	    tmpPos = strfind(szKbString, "~n~", .pos=iChar);
	    // If one is found
		if(tmpPos != -1)
		{
		    iChar = tmpPos; // Set the char to the pos
			iLoop++; // Increase the number of lines found
		}
		iChar++; // Increase the char index for the next strfind
	}
	// If there are more than 5 lines found,
	// Set the 6th newline character to EOS (end of string)
	// I use -1 because the last iteration of the loop performs 'iChar++'
	if(iLoop >= 5)szKbString[iChar-1] = EOS;

	// Now the string has any overhang newlines removed, update it.
	//TextDrawSetString(deathbox[playerid], szKbString);
}
TogglePlayerKillBox(playerid, bool:toggle)
{
	if(toggle)
	{
	    TextDrawShowForPlayer(playerid, kbBack);
	    TextDrawShowForPlayer(playerid, kbText[playerid]);
	}
	else
	{
	    TextDrawHideForPlayer(playerid, kbBack);
	    TextDrawHideForPlayer(playerid, kbText[playerid]);
	}
}

public HideBar(playerid) //Unused
{
    TextDrawHideForPlayer(playerid, kbText[playerid]);
    TextDrawHideForPlayer(playerid, disconnect[playerid]);
}

public hideshit(playerid)
{
    TextDrawHideForAll(kbText[playerid]);
    TextDrawHideForAll(disconnect[playerid]);
}
stock pause(playerid)
{
	new String[100];
    format(String, 70, "Welcome Back %s (Loading the Game...)", pInfo[playerid][Nick]);
    SendClientMessage(playerid, -1, String);
  	SetPlayerCameraPos(playerid, -348.7502, -1063.9343, 62.0577);
	SetPlayerCameraLookAt(playerid, -348.6922, -1062.9286, 61.8977);
	SetPlayerPos(playerid, -365.5911,-1060.2081,59.2488);
}

public FadeOut(playerid, A)
{
        PlayerTextDrawBoxColor(playerid, Background[playerid], RGBToHex(0,0,0,A));
        PlayerTextDrawShow(playerid, Background[playerid]);
        if (A < 255) SetTimerEx("FadeOut", DELAY, false, "id", playerid, A+1);
}

public FadeIn(playerid, A)
{
        PlayerTextDrawBoxColor(playerid, Background[playerid], RGBToHex(0,0,0,A));
        PlayerTextDrawShow(playerid, Background[playerid]);
        if (A) SetTimerEx("FadeIn", DELAY, false, "id", playerid, A-1); else PlayerTextDrawHide(playerid, Background[playerid]);
}

forward MoneyBag();
public MoneyBag()
{
    new string[175];
	if(!MoneyBagFound)
	{
	    format(string, sizeof(string), "The Tiki is still at large! It's located around %s", MoneyBagLocation);
		SendClientMessageToAll(COLOR_LIGHTRED, string);
	}
	else if(MoneyBagFound)
	{
	    MoneyBagFound = 0;
	    new randombag = random(sizeof(MBSPAWN));
	    MoneyBagPos[0] = MBSPAWN[randombag][XPOS];
	    MoneyBagPos[1] = MBSPAWN[randombag][YPOS];
	    MoneyBagPos[2] = MBSPAWN[randombag][ZPOS];
	    format(MoneyBagLocation, sizeof(MoneyBagLocation), "%s", MBSPAWN[randombag][Position]);
		format(string, sizeof(string), "Money bag as been hidden around %s", MoneyBagLocation);
        SendClientMessageToAll(-1, string);
		MoneyBagPickup = CreateDynamicPickup(1276, 3, MoneyBagPos[0], MoneyBagPos[1], MoneyBagPos[2], -1, -1, -1, 100);
	}
	return 1;
}

stock CreateBunker(Float:EnterrX, Float:EnterrY, Float:EnterrZ, Float:TeleX, Float:TeleY, Float:TeleZ)
{
    //HouseInformation[bunkerid][checkpointidx][1] = CreateDynamicCP(EnterX, EnterY, EnterZ, 1.0, 15500000+houseid, Interiorx);
	HouseInformation[bunkerid][Bunkerrrr][0] = CreateDynamicPickup(1272, 1, EnterrX, EnterrY,  EnterrZ, -1, -1, -1, 100.0);
	HouseInformation[bunkerid][Bunkerrrr][1] = CreateDynamicPickup(1272, 1, TeleX, TeleY, TeleZ, -1, -1, -1, 100.0);
    format(fquery, sizeof(fquery), "Secret Weapon Bunker");
	HouseInformation[houseid][textid] = CreateDynamic3DTextLabel(fquery, COLOR_RED, EnterrX, EnterrY, EnterrZ + 0.5, 50.0);
	return 1;
}

stock CreateHouse(HouseName[], CostP, Float:EnterX, Float:EnterY, Float:EnterZ, Float:TeleX, Float:TeleY, Float:TeleZ, Interiorx, SellP)
{
	//new Query[500];
    format(HouseInformation[houseid][Hname], 100, "%s", HouseName);
    HouseInformation[houseid][costprice] = CostP;
    HouseInformation[houseid][EnterPos][0] = EnterX;
    HouseInformation[houseid][EnterPos][1] = EnterY;
    HouseInformation[houseid][EnterPos][2] = EnterZ;


    HouseInformation[houseid][TelePos][0] = TeleX;
    HouseInformation[houseid][TelePos][1] = TeleY;
    HouseInformation[houseid][TelePos][2] = TeleZ;
    HouseInformation[houseid][sellprice] = SellP;
    HouseInformation[houseid][interiors] = Interiorx;
    format(fquery, sizeof(fquery), "SELECT houseowner FROM HOUSEINFO WHERE housename = '%s'", HouseName); //Formats the SELECT query
    //format(fquery, 500, "SELECT houseowner FROM HOUSEINFO WHERE housename = '%s'", HouseName);
    //mysql_query(fquery);
	queryresult = db_query(database, fquery); //Query result variable has been used to query the string above.
    if(db_num_rows(queryresult) != 0) db_get_field_assoc(queryresult, "houseowner", HouseInformation[houseid][owner], 24); //Fetches the field information  db_free_result(queryresult);
    HouseInformation[houseid][checkpointidx][0] = CreateDynamicCP(EnterX, EnterY, EnterZ, 1.0);
    //CreateDynamicCP(Float:x, Float:y, Float:z, Float:size);
    HouseInformation[houseid][checkpointidx][1] = CreateDynamicCP(TeleX, TeleY, TeleZ, 1.0, 15500000+houseid, Interiorx);
    //CreateDynamicCP(Float:x, Float:y, Float:z, Float:size, worldid, interiorid);
    if(!HouseInformation[houseid][owner][0]) format(fquery, sizeof(fquery), "House Name: %s \n House Price:$%d \n Sell Price: $%d", HouseName, CostP, SellP);
    //If there is nothing in the owners variable, we check if the first cell doesn't have a character.
    else if(HouseInformation[houseid][owner][0] != 0) format(fquery, sizeof(fquery), "House Name: %s \n Owner: %s", HouseName, HouseInformation[houseid][owner]);
    //If there is something in the owners variable we check if the first cell has a character.
    HouseInformation[houseid][textid] = CreateDynamic3DTextLabel(fquery, COLOR_ORANGE, EnterX, EnterY, EnterZ + 0.5, 50.0);
    //CreateDynamic3DTextLabel(const text[], color, Float:x, Float:y, Float:z, Float:drawdistance, attachedplayer = INVALID_PLAYER_ID, attachedvehicle = INVALID_VEHICLE_ID, testlos = 0, worldid = -1, interiorid = -1, playerid = -1, Float:distance = 100.0);
    houseid ++; //We go to the next free slot in our variable.
    return 1;
}

stock SetOwner(HouseName[], ownername[], houseids)
{
	new Query[500];
    format(Query, 500, "INSERT INTO `HOUSEINFO` (`housename`, `houseowner`)  VALUES('%s', '%s')", HouseName, ownername);
    mysql_query(Query);
    format(HouseInformation[houseids][owner], 24, "%s", ownername);
    format(fquery, sizeof(fquery), "House Name: %s \n Owner: %s", HouseName, HouseInformation[houseids][owner]);
    UpdateDynamic3DTextLabelText(HouseInformation[houseids][textid], 0xFFFFFF, fquery); //Updates the text label.
    //SetTimer("MoneyCash", 600000, true);
    return 1;
}

stock DeleteOwner(HouseName[], houseids)
{
    format(HouseInformation[houseids][owner], 24, "%s", "\0");
    format(fquery, sizeof(fquery), "DELETE FROM `HOUSEINFO` WHERE `housename` = '%s'", HouseName);
    db_query(database, fquery); //Queries the SQLite database.
    format(fquery, sizeof(fquery), "House Name: %s \n House Price:$%d \n Sell Price: $%d", HouseName, HouseInformation[houseids][costprice], HouseInformation[houseids][sellprice]);
    UpdateDynamic3DTextLabelText(HouseInformation[houseids][textid], 0xFFFFFF, fquery); //Updates the text label.
    return 1;
}

stock LoadHouses()
{
    CreateHouse("The Bunker", 10000, -187.0936, -1182.1552, 6.5679, 266.857757, 305.001586, 999.148437, 2, 7000);
	CreateHouse("Big Trailer", 10000, -91.0862, -1201.9924, 3.1278, 266.857757, 305.001586, 999.148437, 2, 7000);
	CreateHouse("Aris Shack", 10000, -347.9714, -1046.1002, 59.8125, 266.857757, 305.001586, 999.148437, 2, 7000);
	CreateHouse("Flakes Hut", 10000, -418.6954, -1759.4845, 6.2188, 266.857757, 305.001586, 999.148437, 2, 7000);
}

public MoneyCash(playerid)
{
	SendClientMessage(playerid, -1, "You've earned $10,000 from your house! Next payment is in 10 Mins");
    GivePlayerMoney(playerid, 10000);
}

forward InitializeDuel(playerid);
public InitializeDuel(playerid)
{
    g_DuelTimer[playerid]  = SetTimerEx("DuelCountDown", 500, 1, "i", playerid);

	SetPlayerHealth(playerid, 95);
	SetPlayerArmour(playerid, 95);

	//SetPlayerPos(playerid, X, Y, Z); // da1
	//SetPlayerFacingAngle(playerid, A);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, 0);
    g_DuelCountDown[playerid] = 11;

	return 1;
}

forward InitializeDuelEx(playerid);
public InitializeDuelEx(playerid)
{
    g_DuelTimer[playerid]  = SetTimerEx("DuelCountDown", 500, 1, "i", playerid);
	SetPlayerHealth(playerid, 95);
	SetPlayerArmour(playerid, 95);
    //SetPlayerPos(playerid, X, Y, Z);
    //SetPlayerFacingAngle(playerid, A);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, 0);
    g_DuelCountDown[playerid] = 11;

	return 1;
}

forward DuelCountDown(playerid);
public DuelCountDown(playerid)
{
	new
		tString[128] ;

	g_DuelCountDown[playerid] --;

	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);

	format(tString, sizeof(tString), "~w~%d", g_DuelCountDown[playerid]);
	GameTextForPlayer(playerid, tString, 900, 3);

    if(g_DuelCountDown[playerid] == 0)
    {
        KillTimer(g_DuelTimer[playerid]);
        TogglePlayerControllable(playerid, 1);
        GameTextForPlayer(playerid,"~g~GO GO GO", 900, 3);
        return 1;
    }

	return 1;
}

strvalEx(xxx[])
{
	if(strlen(xxx) > 9)
	return 0;
	return strval(xxx);
}

IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return false;
	}
	return true;
}

function xReactionProgress()
{
    switch(xTestBusy)
	{
	    case true:
	    {
		    new
		        string[128]
			;
			format(string, sizeof(string), "No-one won the reaction-test. New one starting in %d minutes.", (TIME/60000));
		    SendClientMessageToAll(COLOR_LIGHTRED, string);
	        xReactionTimer = SetTimer("xReactionTest", TIME, 1);
        }
	}
	return 1;
}

function xReactionTest()
{
	new
		xLength = (random(8) + 2),
		string[128]
	;
	xCash = (random(10000) + 20000);
	xScore = (random(2)+1);
	format(xChars, sizeof(xChars), "");
	Loop(x, xLength) format(xChars, sizeof(xChars), "%s%s", xChars, xCharacters[random(sizeof(xCharacters))][0]);
	format(string, sizeof(string), "Who first types %s wins $%d + %d score points.", xChars, xCash, xScore);
	SendClientMessageToAll(COLOR_LIGHTRED, string);
	KillTimer(xReactionTimer);
	xTestBusy = true;
	SetTimer("xReactionProgress", 30000, 0);
	return 1;
}

forward HHC(playerid);
public HHC(playerid)
{
	Spawned[playerid] = 1;
}

forward BanHim(playerid);
public BanHim(playerid)
{
	Kick(playerid);
}

stock ACBan(playerid)
{
	new Query[500];
	SaveAll(playerid);
	format(Query, 500, "INSERT INTO bans (name, ip, reason, bannedby, date, status, IRCBan) VALUES('%s', '%s', 'RapidFire', '"AntiCheat"', NOW(), '1', 'No')", pInfo[playerid][Nick], pInfo[playerid][IP]); //Format the query
	mysql_query(Query);
	SetTimer("BanHim", 1000, false);
}

forward BanChecka(playerid);
public BanChecka(playerid)
{
	IsPlayerBanned(playerid);
}

public LoginDialog(playerid)
{
    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_PASSWORD, "{00C0FF}Countryside Account", "{FFFFFF}We have detected that this account name is already registered, if it is \nYours please login below. \n\nWebsite: {00C0FF}CountryTDM.net", "Login", ""); // show the login dialog and tell the player to login.
}

forward ResetCount(playerid);
public ResetCount(playerid)
{
        SetPVarInt(playerid, "TextSpamCount", 0);
}

forward FreezeTime(playerid);
public FreezeTime(playerid)
{
        TogglePlayerControllable(playerid, 1);
}

forward GateClose(playerid);
public GateClose(playerid)
{
      MoveDynamicObject(lift, -97.69370, -979.29138, 25.76870, 5, -1000.0, -1000.0, -1000.0);
      PlayerPlaySound(playerid, 1153, -97.69370, -979.29138, 25.76870);
      return 1;
}

forward OnDeerRespawn();
public OnDeerRespawn()
{
    new ran = random(sizeof(positions));
    for(new i; i<=MaxDeer; i++)
        {
            SetObjectPos(DeerCreated[i], positions[ran][0], positions[ran][1], positions[ran][2]);
        }
        return 1;
}

forward deerkill();
public deerkill()
{
	DestroyDynamic3DTextLabel(Text3D:deerlabel);
}

forward remdamlbl();
public remdamlbl()
{
	DestroyDynamic3DTextLabel(Text3D:damlabel);
}

stock GetTeamZoneColor(teamid)
{
    switch(teamid)
    {
        case TEAM_MECH: return 0x0000FFF44;
        case TEAM_HOBO: return HOBO_ZONE;
        case TEAM_FARM: return FARM_ZONE;
        case TEAM_RACE: return RACE_ZONE;
        case TEAM_HIPP: return HIPP_ZONE;
    }
    return -1;
}

stock IsPlayerInZone(playerid, zoneid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    return (x > ZoneInfo[zoneid][zMinX] && x < ZoneInfo[zoneid][zMaxX] && y > ZoneInfo[zoneid][zMinY] && y < ZoneInfo[zoneid][zMaxY]);
}

stock GetPlayersInZone(zoneid, teamid)
{
    new count;
    for(new i=0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && GetPlayerTeam(i) == teamid && IsPlayerInZone(i, zoneid))
        {
            count++;
        }
    }
    return count;
}

forward ZoneTimer();
public ZoneTimer()
{
    for(new i=0; i < sizeof(ZoneInfo); i++) // loop all zones
    {
        if(ZoneAttacker[i] != -1) // zone is being attacked
        {
            if(GetPlayersInZone(i, ZoneAttacker[i]) >= MIN_MEMBERS_TO_START_WAR) // team has enough members in the zone
            {
                ZoneAttackTime[i]++;
                if(ZoneAttackTime[i] == TAKEOVER_TIME) // zone has been under attack for enough time and attackers take over the zone
                {
                    GangZoneStopFlashForAll(ZoneID[i]);
                    ZoneInfo[i][zTeam] = ZoneAttacker[i];
                    GangZoneShowForAll(ZoneID[i], GetTeamZoneColor(ZoneInfo[i][zTeam])); // update the zone color for new team
                    ZoneAttacker[i] = -1;
                }
            }
            else // attackers failed to take over the zone
            {
                GangZoneStopFlashForAll(ZoneID[i]);
                ZoneAttacker[i] = -1;
            }
        }
        else // check if somebody is attacking
        {
            for(new t=0; t < sizeof(Teams); t++) // loop all teams
            {
                if(Teams[t] != ZoneInfo[i][zTeam] && GetPlayersInZone(i, Teams[t]) >= MIN_MEMBERS_TO_START_WAR) // if there are enough enemies in the zone
                {
                    ZoneAttacker[i] = Teams[t];
                    ZoneAttackTime[i] = 0;
                    GangZoneFlashForAll(ZoneID[i], GetTeamZoneColor(ZoneAttacker[i]));
                }
            }
        }
    }
}

stock GetPlayerZone(playerid)
{
    for(new i=0; i < sizeof(ZoneInfo); i++)
    {
        if(IsPlayerInZone(playerid, i))
        {
            return i;
        }
    }
    return -1;
}

//Tutorial Code:
public TutorialStart(playerid)
{
   SendClientMessage(playerid, 0xFFFF00AA,"Countryside TDM Tutorial:");
   SendClientMessage(playerid, 0xFFFFE0FF,"This is a team deathmatch server meaning you work as a team."); // This can also be edited on your choice.
   SendClientMessage(playerid, 0xFFFFE0FF,"There are 5 Teams, all located around the Flint countryside"); // Same.
   SetPlayerCameraPos(playerid, -142.8441, -1025.7900, 11.5805);
   SetPlayerCameraLookAt(playerid, -143.7681, -1026.1930, 11.6405);
   SetPlayerVirtualWorld(playerid, 2);
   SetPlayerPos(playerid, -142.8441, -1025.7900, 4.5805);
   SetTimer("TutorialPart1", 4000,0); // This is the SetTimer function as we did before., Here 8000 is 8 seconds.
}

public TutorialPart1(playerid)
{
   SetPlayerCameraPos(playerid, 2324.3757,-2337.7393,13.3828);
   SetPlayerCameraLookAt(playerid, 2322.9180,-2308.8950,13.5469);
   SendClientMessage(playerid, 0xFFFF00AA,"Teams:");
   SendClientMessage(playerid, 0xFFFFE0FF,"Each Team has their own weapon set.");
   SendClientMessage(playerid, 0xFFFFE0FF,"And some teams have special perks, making them more usefull.");
   SendClientMessage(playerid, 0xFFFFE0FF,"You can change team by using F4 + /kill");
   SetPlayerCameraPos(playerid, -215.2123, -1223.8495, 11.5062);
   SetPlayerCameraLookAt(playerid, -216.1347, -1224.2561, 11.3112);
   SetPlayerPos(playerid, -215.2123, -1223.8495, 4.5062);
   SetTimer("TutorialPart2",5000,0);
   SetPlayerVirtualWorld(playerid, 2);
}

public TutorialPart2(playerid)
{
   SetPlayerCameraPos(playerid, 1509.7393,-1610.2775,14.0469);
   SetPlayerCameraLookAt(playerid, 1542.6451,-1648.0046,13.9816);
   SendClientMessage(playerid, 0xFFFF00AA,"Objective:");
   SendClientMessage(playerid, 0xFFFFE0FF,"As a whole your objective is to get kills and not to get killed, in the prosess you will earn cash.");
   SendClientMessage(playerid, 0xFFFFE0FF,"With cash you can buy houses they earn you money every 10 mins.");
   SetTimer("TutorialEnd",5000,0);
   SetPlayerVirtualWorld(playerid, 2);
   SetPlayerCameraPos(playerid, -399.1769, -1454.2751, 26.1506);
   SetPlayerCameraLookAt(playerid, -398.6238, -1453.4321, 26.1406);
   SetPlayerPos(playerid, -399.1769, -1454.2751, 10.1506);
}

public TutorialEnd(playerid)
{
   TogglePlayerControllable(playerid,1); // Will make Player Unfreeze.
   SpawnPlayer(playerid); // Will Spawn Player.
   SendClientMessage(playerid, 0xFFFF00AA,"You have been now spawned, Tutorial is Over.");
   SetPlayerVirtualWorld(playerid, 0);
   PlayerPlaySound(playerid, 1063, 0.0, 0.0, 10.0);
}

stock SetPlayerBounty(playerid,bounty)
{
   return pInfo[playerid][pBounty] = bounty;
}

stock escstring(stri[])
{
	new escstr[200];
	mysql_real_escape_string(stri, escstr);
	return escstr;
}
stock PlayerNameee(playerid)
{
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, sizeof(pName));
	return pName;
}

forward ExitStat(playerid);
public ExitStat(playerid)
{
	TextDrawHideForPlayer(playerid,StatsText0);
	TextDrawHideForPlayer(playerid,StatsText1);
	TextDrawHideForPlayer(playerid,StatsText2);
	TextDrawHideForPlayer(playerid,StatsText3);
	TextDrawHideForPlayer(playerid,StatsText4);
	TextDrawHideForPlayer(playerid,StatsText5);
	TextDrawHideForPlayer(playerid,StatsText6);
	TextDrawHideForPlayer(playerid,StatsText7);
	TextDrawHideForPlayer(playerid,StatsText8);
	TextDrawHideForPlayer(playerid,StatsText9);
	TextDrawHideForPlayer(playerid,StatsText10);
	TextDrawHideForPlayer(playerid,StatsText11);
	TextDrawHideForPlayer(playerid,StatsText13);
}

stock escpname(playerid)
{
	new escname[24];
	new Pname[24];
    GetPlayerName(playerid, Pname, 24);
	mysql_real_escape_string(Pname, escname);
	return escname;
}

forward MySQL_Backup(playerid);
public MySQL_Backup(playerid)
{
	new ircMsg[256], ircMsg2[256], Query[500];
	format(ircMsg, sizeof(ircMsg), "It's been 24 hours! All old Kill/Death history is being force backed up and dropped..");
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	IRC_GroupSay(groupID, IRC_STAFF_CHANNEL, ircMsg);
	IRC_GroupSay(groupID, IRC_ADMIN_CHANNEL, ircMsg);
	
	format(ircMsg2, sizeof(ircMsg2), "Complete!");
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg2);
	IRC_GroupSay(groupID, IRC_STAFF_CHANNEL, ircMsg2);
	IRC_GroupSay(groupID, IRC_ADMIN_CHANNEL, ircMsg2);
	
	format(Query, 500, "DELETE * FROM `lastkills`");
	mysql_query(Query);
	print(Query);
	return 1;
}

forward WarEnd(playerid);
public WarEnd(playerid)
{
	new ircMsg[256], string[256];
	SendRconCommand("hostname "HOST"");
	format(ircMsg, sizeof(ircMsg), "War Mode has been automaticly turned off");
	IRC_GroupSay(groupID, IRC_CHANNEL, ircMsg);
	IRC_GroupSay(groupID, IRC_ADMIN_CHANNEL, ircMsg);
	
	format(string, sizeof(string), "{F81414}War Mode has ended! All the vehicles have cleared out.. Good work everyone!");
	SendClientMessageToAll( -1, string);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
    	SetWeather(Weather);
    	StopAudioStreamForPlayer(i);
	}
		return 1;
}

stock SendPlayerToAnother(sendingplayer, receivingplayer)
{
	GetPlayerPos(receivingplayer, posxx[0], posxx[1], posxx[2]);
	SetPlayerPos(sendingplayer, posxx[0], posxx[1]+2, posxx[2]);
	SetPlayerVirtualWorld(sendingplayer, GetPlayerVirtualWorld(receivingplayer));
	SetPlayerInterior(sendingplayer, GetPlayerInterior(receivingplayer));
	return 1;
}

public EmailDelivered(index, response_code, data[])//data[] Will contain "Email delivered" see in PHP file
{
    new buffer[128];
    if(response_code == 200)
    {
        format(buffer, sizeof(buffer), "Status: %s", data);//In game will print Status: Email delivered
        SendClientMessage(index, COLOR_SAMP, buffer);
    }
    else
    {
        format(buffer, sizeof(buffer), "Status: Undelivered Response Code: %d", response_code);//Else will print error code, see reference
        SendClientMessage(index, COLOR_SAMP, buffer);
    }
    return 1;
}

stock GetStringText(const string[],idx,text[128])
{
    new length = strlen(string);
    while ((idx < length) && (string[idx] <= ' ')) { idx++; }
    new offset = idx; new result[128];
    while ((idx < length) && ((idx - offset) < (sizeof(result) - 1))) { result[idx - offset] = string[idx]; idx++; }
    result[idx - offset] = EOS;
    text = result;
    return result;
}

stock IsValidEmailEx(const string[])
{
    static
        RegEx:rEmail
    ;

    if ( !rEmail )
    {
        rEmail = regex_build("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
    }

    return regex_match_exid(string, rEmail);
}

stock ForbiddenWeap(playerid)
{
    new weap = GetPlayerWeapon(playerid);
    if( weap == 36 || weap == 38 || weap == 41 || weap == 42 || weap == 43 || weap == 44 || weap == 45 )
    {
    	return true;
    }
    return false;
}
