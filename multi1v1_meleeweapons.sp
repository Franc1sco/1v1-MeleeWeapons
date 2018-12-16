/*  CS:GO Multi1v1: Melee Weapons round addon
 *
 *  Copyright (C) 2018 Francisco 'Franc1sco' García
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */
 
 
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <multi1v1>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
  name = "CS:GO Multi1v1: Melee Weapons round addon",
  author = "Franc1sco franug",
  description = "Adds unranked Melee weapons round-type",
  version = "1.0",
  url = "http://steamcommunity.com/id/franug"
};

public void Multi1v1_OnRoundTypesAdded() 
{
	// Add the custom rounds
	Multi1v1_AddRoundType("Fists battle", "fists", FistsHandler, true, false, "", true);
	Multi1v1_AddRoundType("Axe battle", "axe", AxeHandler, true, false, "", true);
	Multi1v1_AddRoundType("Hammer battle", "hammer", HammerHandler, true, false, "", true);
	Multi1v1_AddRoundType("Spanner battle", "spanner", SpannerHandler, true, false, "", true);
}

public void FistsHandler(int iClient) 
{
	// Start the custom round
	int iMelee = GivePlayerItem(iClient, "weapon_fists");
	EquipPlayerWeapon(iClient, iMelee);
	
	SetEntityHealth(iClient, 100);
	
	// Remove armor 
	SetEntProp(iClient, Prop_Data, "m_ArmorValue", 0);
}

public void AxeHandler(int iClient) 
{
	// Start the custom round
	GivePlayerItem(iClient, "weapon_axe");
	
	SetEntityHealth(iClient, 100);
	
	// Remove armor 
	SetEntProp(iClient, Prop_Data, "m_ArmorValue", 0);
}

public void HammerHandler(int iClient) 
{
	// Start the custom round
	GivePlayerItem(iClient, "weapon_hammer");
	
	SetEntityHealth(iClient, 100);
	
	// Remove armor 
	SetEntProp(iClient, Prop_Data, "m_ArmorValue", 0);
}

public void SpannerHandler(int iClient) 
{
	// Start the custom round
	GivePlayerItem(iClient, "weapon_spanner");
	
	SetEntityHealth(iClient, 100);
	
	// Remove armor 
	SetEntProp(iClient, Prop_Data, "m_ArmorValue", 0);
}


// code from https://forums.alliedmods.net/showthread.php?t=312611
public void OnPluginStart()
{
	//Lateload
	for (int i = 1; i <= MaxClients; i++) if (IsClientInGame(i)) OnClientPutInServer(i);
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_WeaponCanUse, Hook_WeaponCanUse);
}

public Action Hook_WeaponCanUse(int client, int weapon)
{
	char classname[64];
	GetEntityClassname(weapon, classname, sizeof classname);
	
	if (StrEqual(classname, "weapon_melee") && !(HasWeapon(client, "weapon_melee") || HasWeapon(client, "weapon_knife")))
		EquipPlayerWeapon(client, weapon);
}


stock bool HasWeapon(int client, const char[] classname)
{
	int index;
	int weapon;
	char sName[64];
	
	while((weapon = GetNextWeapon(client, index)) != -1)
	{
		GetEdictClassname(weapon, sName, sizeof(sName));
		if (StrEqual(sName, classname))
			return true;
	}
	return false;
}

stock int GetNextWeapon(int client, int &weaponIndex)
{
	static int weaponsOffset = -1;
	if (weaponsOffset == -1)
		weaponsOffset = FindDataMapInfo(client, "m_hMyWeapons");
	
	int offset = weaponsOffset + (weaponIndex * 4);
	
	int weapon;
	while (weaponIndex < 48) 
	{
		weaponIndex++;
		
		weapon = GetEntDataEnt2(client, offset);
		
		if (IsValidEdict(weapon)) 
			return weapon;
		
		offset += 4;
	}
	
	return -1;
}