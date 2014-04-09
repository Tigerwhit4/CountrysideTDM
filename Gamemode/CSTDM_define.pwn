#include "../gamemodes/CSTDM_callbacks.pwn"
#include "../gamemodes/CSTDM_objects.pwn"

//Colors
#define COLOR_LIGHTRED 0xF69521AA
#define COLOR_ORANGE 0xFF4500AA
#define COLOR_GREY 0xAFAFAFAA
#define Grey 0xAFAFAFAA
#define COLOR_BLUE 0x0000FFFF
#define COLOR_RED 0xFF0000AA
#define COLOR_GREEN 0x008000FF
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_PURPLE 0xC2A2DAAA

//Gangzone Colors
#define RACE_ZONE 0xAFAFAFAA44
#define HOBO_ZONE 0xFF0000AA44
#define FARM_ZONE 0x008000FF44
#define HIPP_ZONE 0xFF4500AA

//Embeded colors
#define COL_WHITE          "{FFFFFF}"


//House Defines
#define MAX_HOUSES 90
#define MAX_BUNKERS 10
#define MAX_HOUSES_PER_PLAYER 2
#define databasename "Flake_336" //This was just a SqlLight Test

//Random Global Defines (Some are unneeded)
#undef MAX_PLAYERS
#define MAX_PLAYERS 30
#define SpamLimit (5000)

#define ResetMoneyBar ResetPlayerMoney
#define UpdateMoneyBar GivePlayerMoney
#define RWTime 60000*3
#define RC_ENTER_RANGE 8
#define DELAY 5

#define MAX_AMMO_CRATE 16

#define KILLBOX_TEXT	"~r~Killfeed:~n~~w~"
#define MAX_KB_LINES	5
#define MAX_KN_LINE_LEN	70
#define MAX_KB_LEN		(16 + (MAX_KB_LINES*MAX_KN_LINE_LEN))


//Some more custom Functions
#define mysql_fetch_float(%0,%1) mysql_fetch_field(%0,field); \
%1=floatstr(field)
#define mysql_fetch_string(%0,%1) mysql_fetch_field(%0,%1)
#define mysql_fetch_int(%0,%1) mysql_fetch_field(%0,field); \
%1=strval(field)
#define RGBToHex(%0,%1,%2,%3) %0 << 24 | %1 << 16 | %2 << 8 | %3

#define SendError(%1,%2) SendClientMessage(%1,COLOR_RED,"ERROR: " %2)
#define SendUsage(%1,%2) SendClientMessage(%1,COLOR_WHITE,"USAGE: " %2)

#define TODO:%0\10;%1 {}
#if !defined TODO
    #define TODO:%9\32;%0\10;%1 { new TODO; print("TODO: \"%0\""); }
#endif

#if !defined Loop
#define Loop(%0,%1) \
	for(new %0 = 0; %0 != %1; %0++)
#endif

#if !defined function
#define function%0(%1) \
	forward%0(%1); public%0(%1)
#endif

#if !defined TIME
#define TIME \
    180000
#endif

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))


//For the hiden object (Yes, it used to be called moneybag)
#define MoneyBagDelay(%1,%2,%3,%4) (%1*3600000)+(%2*60000)+(%3*1000)+%4
#define MoneyBagCash ((random(30)+20)*10000)
#define MB_DELAY MoneyBagDelay(0, 10, 0, 0) //10 mins


//Dialogs
//Staff shit
#define MAX_ADMIN_LEVEL 100
#define MAX_VIP_LEVEL 2
#define SETLEVEL_ADMIN 100

//Dialogs
#define DIALOG_AHELP 420 //im a fag
#define DIALOG_STATS 421
#define DIALOG_GUN 422
#define DIALOG_BANNED 423
#define DIALOG_EMAIL 424


//Team stuff
//Team Defines
#define TEAM_MECH 0
#define TEAM_HOBO 1
#define TEAM_FARM 2
#define TEAM_RACE 3
#define TEAM_HIPP 4
#define TEAM_POLL 5

#define TEAM_MECH_COL "COLOR_BLUE"
#define TEAM_HOBO_COL "COLOR_RED"
#define TEAM_FARM_COL "COLOR_GREEN"
#define TEAM_RACE_COL "COLOR_GREY"
#define TEAM_HIPP_COL "COLOR_ORANGE"
#define TEAM_POLL_COL "COLOR_PURPLE"


//Extra Zone (tabsize)
#define MAPICONDISTANCE         500.0
#define MAX_ZONES 10 //work in progress

#pragma tabsize 0

