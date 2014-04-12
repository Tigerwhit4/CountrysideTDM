#define MAX_KB_LEN		(16 + (MAX_KB_LINES*MAX_KN_LINE_LEN))
#define KILLBOX_TEXT	"~r~Killfeed:~n~~w~"
#define MAX_KB_LINES	5
#define MAX_KN_LINE_LEN	70

#define WEB "CountryTDM.info"
#include "../gamemodes/CSTDM_config.pwn"
#include "../gamemodes/CSTDM_define.pwn"
enum PlayerInfo
{
    ID, // id of the player
    Nick[24], // name of the player
    Password[129],
    wdata[500],
    pAdmin, // admin level of the player
    pMoney, //money of the player
    pKills, // Kills of the player
    pDeaths, // deaths of the player
    pPing, //last ping
    pVip, //VIP?
    pBanned, //Unused
    pEmail,
    pTP,
    pLabel,
    pScore, // score of the player
    IP[16], // Storing the ip of the player
    Logged, // Players logged in or not variable
    IsRegistered, //checks if the player is registered or not.
    Last,
	NoPM,
    pBounty,
    pCountry
};

enum BanInfo
{

	pBannedBy,
	pReason,
	pIPp,
	pDate

};
new BInfo[MAX_PLAYERS][BanInfo];

forward public DestroyTD();
forward LoadFunc();
forward GMX();
forward LoadVeh(playerid);
forward DropPlayerWeapons(playerid);
forward DeletePickup(pickupid);
forward spawn(playerid);
forward stopgod(playerid);
forward RandomMessage();
forward randomweather();
forward InteriorEntered(playerid);
forward DestroyDamage(playerid);
forward CheckPlayer();
forward HideBar(playerid);
forward MoneyCash(playerid);
forward FadeIn(playerid, A);
forward FadeOut(playerid, A);
forward hideshit(playerid);
forward LoginDialog(playerid);
forward TutorialStart(playerid);
forward TutorialPart1(playerid);
forward TutorialPart2(playerid);
forward TutorialEnd(playerid);
//forward Updating(playerid);


new Text3D:damlabel;
new Text3D:deerlabel;
new botIDs[MAX_BOTS], groupID;
new Spawned[MAX_PLAYERS];
new Bomb[MAX_PLAYERS];
new stringlol[MAX_PLAYERS];
new shotTime[MAX_PLAYERS];
new shot[MAX_PLAYERS];
new Cookie[MAX_PLAYERS];
new lift; //for the moving obj
new parachute;
new sniper;
new DeerCreated[MaxDeer];
new Text:sherif;
new ireconnect[MAX_PLAYERS];
new Text:StatsText0; //All the textdraws we need to make the actual screen
new Text:StatsText1;
new Text:StatsText2;
new Text:StatsText3;
new Text:StatsText4;
new Text:StatsText5;
new Text:StatsText6;
new Text:StatsText7;
new Text:StatsText8;
new Text:StatsText9;
new Text:StatsText10;
new Text:StatsText11;
new Text:StatsText13;
new Text3D:labelz[MAX_PLAYERS];
new Float:posxx[3];
new MySQL:mysql;
new field[128];
new Text:MainMenu[4];
new pInfo[MAX_PLAYERS][PlayerInfo];
new gTeam[MAX_PLAYERS];
new Text:mech;
new Text:hobo;
new Text:logo;
new Text:logo2;
new Text:test;
new Text:farmer;
new Text:race;
new Text:hippy;
new Text:pclass;
new Text:gunlist1;
new Text:gunlist2;
new Text:gunlist3;
new Text:gunlist4;
new Text:gunlist5;
new Text:gunlist6;
new Text:gunlist7;
new Text:gunlist8;
new Text:gunlist9;
new Text:gunlist10;
new Text:gunlist11;
new Text:gunlist12;
new Text:gunlist13;
new Text:gunlist14;
new Text:gunlist15;
new Text:rules[5];
new PlayerText:deagle;
new PlayerText:skin0;
new PlayerText:skin1;
new PlayerText:skin2;
new PlayerText:skin3;
new PlayerText:skin4;
new PlayerText:skin5;
new PlayerText:skin6;
new PlayerText:skin7;
new PlayerText:skin8;
new PlayerText:skin9;
new PlayerText:skin10;
new PlayerText:skin11;
new PlayerText:skin12;
new PlayerText:skin13;
new PlayerText:skin14;
new PlayerText:skin15;
new PlayerText:skin16;
new PlayerText:skin17;
new DynamicCarID[MAX_VEHICLES], DynamicCar[MAX_VEHICLES], DynamicCarCol[MAX_VEHICLES][3];
new DropLimit = 4; // above
new DeleteTime = 20; //above
new Msg[128];
new Text:killname;
new Text:killergun;
new Text:killerinfo;
new Text:killwep;
new Text:dmginfo;
new MechBunker, MechBunkerExit, HPpickup;
new MechanicTele, FarmerTele;
new FarmerBunker, FarmerBunkerExit;
new RacerBunker, RacerBunkerExit, RacerAmmo;
new Time, TimeM, TimeS;
new Text:Timer;
new JetPack[MAX_PLAYERS];
new HelpBot;
new Ammo1, Ammo2;
new Ammo1Exit, Ammo2Exit;
new GunMenu1, GunMenu2;
new Weather;
new IsPaused[MAX_PLAYERS], pTick[MAX_PLAYERS], IsPunished[MAX_PLAYERS];
new Text3D:pauseLaber[MAX_PLAYERS],pKilled[MAX_PLAYERS],pTimer;
new Float:SpecX[MAX_PLAYERS], Float:SpecY[MAX_PLAYERS], Float:SpecZ[MAX_PLAYERS], vWorld[MAX_PLAYERS], Inter[MAX_PLAYERS];
new IsSpecing[MAX_PLAYERS], IsBeingSpeced[MAX_PLAYERS],spectatorid[MAX_PLAYERS];
//new StaticMechanic;
new Text3D:PlayerLabel[MAX_PLAYERS];
new Cash[MAX_PLAYERS];
new Text3D:killstreak[MAX_PLAYERS];
new Text3D:HOBOLabel[MAX_PLAYERS];
new Text3D:FARMLabel[MAX_PLAYERS];
new Text3D:RACELabel[MAX_PLAYERS];
new Text3D:HIPPLabel[MAX_PLAYERS];
new Text3D:Namee[MAX_PLAYERS];
new Streak[MAX_PLAYERS];
new PlayerText:Background[MAX_PLAYERS];
//new newtextt[41];
new Float:MoneyBagPos[3], MoneyBagFound=1, MoneyBagLocation[50], MoneyBagPickup, Timerr[2];
new DB:database, DBResult:queryresult, fquery[300];
new Text:disconnect[MAX_PLAYERS];

new
	Text:kbBack,
	Text:kbText[MAX_PLAYERS],
	szKbString[MAX_KB_LEN] = {KILLBOX_TEXT};
	


new Float:MechSpawns[][] =
{
    {-81.6258, -1187.8304, 1.7500,165.5365}, // Randomspawn
    {-88.8041, -1201.3079, 2.8906, 165.9352}, // Randomspawn
    {-101.8532, -1164.3069, 2.6918, 90.9353} // Randomspawn
};

new Float:HoboSpawns[][] =
{
    {-75.6375, -1599.4106, 2.6172,152.8265}, // Randomspawn
    {-45.1771, -1564.5219, 2.5998,142.8196}, // Randomspawn
    {-82.3147, -1571.7786, 2.6107,226.5034} // Randomspawn
};

new Float:FarmerSpawns[][] =
{
    {-368.3624, -1425.5347, 25.7266, 178.4807}, // Randomspawn
    {-380.6219, -1426.3855, 25.7273, 256.2309}, // Randomspawn
    {-379.8123, -1438.9305, 25.7266, 272.7950} // Randomspawn
};

new Float:RacerSpawns[][] =
{
    {-576.9739, -504.3003, 25.5234, 358.5798}, // Randomspawn
    {-539.5463, -542.1099, 25.5234, 174.0760}, // Randomspawn
    {-542.1455, -501.6932, 25.5234, 357.9531} // Randomspawn
};

new Float:HippySpawns[][] =
{
    {-1058.8104, -1195.4045, 129.2188, 265.9688}, // Randomspawn
    {-1072.1332, -1170.0247, 129.6406, 267.5157}, // Randomspawn
    {-1059.0146, -1205.4634, 129.2188, 273.8846} // Randomspawn
};

new Float:PolSpawns[][] =
{
    {-643.5573, -1249.2760, 21.1474,248.7955}, // Randomspawn
    {-623.5544, -1268.3947, 20.6264,301.6527}, // Randomspawn
    {-624.1276, -1225.5552, 21.0691,247.9861} // Randomspawn
};

new MechSkins[] = {
	8,
	42,
 	6
};
new HoboSkins[] = {
	79,
	78,
  	77
};
new FarmerSkins[] = {
	158,
	159,
   	160
};
new RacerSkins[] = {
	2,
	65,
	23
};
new HippySkins[] = {
	1,
	101,
 	26
};
new PolSkins[] = {
	282,
	283,
	288
};
new RCVehicles[] = {
        441,
        464,
        465,
        501,
        564,
        594
};
new VehicleNames[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
    "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
    "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection",
    "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
    "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
    "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
    "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
    "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van",
    "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale",
    "Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
    "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
    "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
    "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
    "Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin",
    "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
    "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt",
    "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
    "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
    "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
    "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
    "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
    "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
    "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratium",
    "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper",
    "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
    "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Cruiser",
    "SFPD Cruiser", "LVPD Cruiser", "Police Ranger", "Picador", "S.W.A.T", "Alpha",
    "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville",
    "Tiller", "Utility Trailer"
};

new Float:positions[][4] =
{
        {-212.1197,-1022.2452,18.0943},
		{-349.1795,-1053.2701,59.3168},
		{-427.1470,-1267.8674,33.1565}
};

new
	xCharacters[][] =
	{
	    "AbIf", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
		"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
	    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
		"n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
	    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
	},
 	xChars[16] = "",
	xReactionTimer,
	xCash,
	xScore,
	bool: xTestBusy
;


new RandomMessages[][] =
{
    "!say Like the server? Why not checkout the website at "WEB"",
    "!say If you're new to the server checkout /Tips for more help!",
    "!say Want more benifits ingame? Checkout /VIPInfo",
    "!say Want to duel one of your friend? /Duel <ID>",
    "!say For TeamChat use '!' (!Hi Team)"
};

new wepsid[5][2] =
{
   {31 , 100},
   {35 , 5},
   {34 , 100},
   {39 , 10},
   {9 , 100}
};

new Months[13][] =
{
{"Invalid"},
{"January"},
{"February"},
{"March"},
{"April"},
{"May"},
{"June"},
{"July"},
{"August"},
{"September"},
{"October"},
{"November"},
{"December"}
};

enum hinfo
{
    owner[24],
    Hname[100],
    costprice,
    Float:EnterPos[3],
    Float:TelePos[3],
    sellprice,
    interiors,
    Text3D:textid,
    checkpointidx[2],
    Bunkerrrr[2],
    Float:EnterPoss[3],
    Float:TelePoss[3]
};

enum mbinfo
{
	Float:XPOS,
	Float:YPOS,
	Float:ZPOS,
	Position[50]
};

new Float:MBSPAWN[][mbinfo] =
{
    {-178.2193, -1110.1606, 4.1871, "Near Mechanic HQ"},
    {-253.9756, -1197.3557, 8.7369, "Near Mechanic HQ"},
	{-244.3928, -1230.2262, 6.2295, "Close to Farmers"},
	{-333.1948, -1272.5564, 28.2884, "Close to Farmers"},
	{-331.9725, -1292.1147, 18.0099, "Hobo Spawn"},
	{-257.2722, -1632.9957, 5.4756, "Near the bridge"},
	{-99.0294, -1426.1067, 7.2124, "Hobo Spawn"},
	{-14.1647, -1354.1184, 4.0039, "Near the bridge"},
	{-64.7405, -1184.6450, 2.1071, "Behind Mechanics"}

};

enum ServerInfo
{
    TotalJoins,
    TikisFound,
    Bans,
    Accounts,
    Bombs
};

new sInfo[MAX_PLAYERS][ServerInfo];

new Teams[] = {
    TEAM_MECH,
    TEAM_HOBO,
    TEAM_FARM,
    TEAM_RACE,
    TEAM_HIPP,
    TEAM_POLL
};

enum eZone
{
    Float:zMinX,
    Float:zMinY,
    Float:zMaxX,
    Float:zMaxY,
    zTeam
}


new ZoneInfo[][eZone] = {

	{-120.0, -1137.0, -22.0, -1055.0,TEAM_MECH},
	{-122.0, -1209.0, -53.0, -1118.0,TEAM_MECH}

};


//Extra defines
new ZoneID[sizeof(ZoneInfo)];
new ZoneAttacker[sizeof(ZoneInfo)] = {-1, ...};
new ZoneAttackTime[sizeof(ZoneInfo)];
new ZoneDeaths[sizeof(ZoneInfo)];
new HouseInformation[MAX_HOUSES][hinfo], houseid;
new bunkerid;
new InHouse[MAX_PLAYERS], InHouseCP[MAX_PLAYERS];


//Stock Function (Needs to be here for sorting issues)

stock
	g_GotInvitedToDuel[MAX_PLAYERS],
	g_HasInvitedToDuel[MAX_PLAYERS],
	g_IsPlayerDueling[MAX_PLAYERS],
	g_DuelCountDown[MAX_PLAYERS],
	g_DuelTimer[MAX_PLAYERS],
	g_DuelInProgress,
	g_DuelingID1,
	g_DuelingID2;
