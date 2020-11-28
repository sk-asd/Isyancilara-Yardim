#include <store>
#include <cstrike>
#include <sdktools>
#include <sourcemod>
#pragma semicolon 1
#pragma newdecls required
ConVar kredi, zirh, flash, wh, armorvalue;
int kullan;
public Plugin myinfo =  {
	name = "İsyancılara Yardım", 
	author = "phiso", 
	description = "Komudu kullanan kişiye belirlediğiniz eşyaları belirlediğiniz krediye verir.", 
	version = "1.0", 
	url = "phiso#3331"
};
public void OnMapStart()
{
	char map[512];
	GetCurrentMap(map, sizeof(map));
	if (StrContains(map, "jb_", false) != 0 && StrContains(map, "jail_", false) != 0 && StrContains(map, "ba_jail", false) != 0)
	{
		SetFailState("[SM] Bu eklenti sadece jailbrek haritalarinda calismaktadir.");
	}
}
public void OnPluginStart()
{
	kredi = CreateConVar("sm_yardim_kredi", "31", "Komutu kullanmak için gerekli kredi", 0, true, 0.0);
	zirh = CreateConVar("sm_yardim_zirh", "1", "Zırh aktif olsun mu?", 0, true, 0.0, true, 1.0);
	flash = CreateConVar("sm_yardim_flash", "1", "Flashbang aktif olsun mu?", 0, true, 0.0, true, 1.0);
	wh = CreateConVar("sm_yardim_wh", "1", "Wallhack bombası aktif olsunmu?", 0, true, 0.0, true, 1.0);
	armorvalue = CreateConVar("sm_yardim_armorvalue", "100", "Ne kadar zırh versin", 0, true, 0.0, true, 100.0);
	AutoExecConfig(true, "Yardim", "phiso");
	RegConsoleCmd("sm_yardim", Command_Yardim);
}
public Action Command_Yardim(int client, int args)
{
	if (Store_GetClientCredits(client) >= kredi.IntValue)
	{
		if (GetClientTeam(client) == CS_TEAM_T)
		{
			if (kullan != 3)
			{
				if (zirh.BoolValue)
				{
					SetEntProp(client, Prop_Data, "m_ArmorValue", armorvalue.IntValue, 1);
				}
				if (flash.BoolValue)
				{
					GivePlayerItem(client, "weapon_flashbang");
				}
				if (wh.BoolValue)
				{
					GivePlayerItem(client, "weapon_tagrenade");
				}
				PrintToChat(client, "[SM] \x02Yardım \x04komutunu kullandığın için senden \x02%d \x04kredi alındı!", kredi.IntValue);
				kullan++;
			}
			else
			{
				PrintToChat(client, "[SM] \x04Senden önce başka kişiler yardım almış.");
			}
		}
		else
		{
			PrintToChat(client, "[SM] \x04Bu komutu kullanmak için \x02Mahkum takımında \x04olmalısın.");
		}
	}
	else
	{
		PrintToChat(client, "[SM] \x02Yardım \x04almak için yeterli \x02kredin \x04yok -_-");
	}
} 
