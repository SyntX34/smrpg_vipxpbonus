#include <sourcemod>
#include <vip_core>
#include <smrpg>
#include <multicolors>

public Plugin:myinfo =
{
    name = "VIP RPG Rewards",
    author = "+SyntX",
    description = "Gives extra XP for killing zombies.",
    version = "1.0",
    url = "https://steamcommunity.com/id/SyntX34 or https://github.com/SyntX34"
};

// Define the additional rewards for VIPs
#define EXTRA_XP 100 // Extra XP for killing a zombie

public void OnPluginStart()
{
    // Hook player death events to apply XP rewards
    HookEvent("player_death", OnPlayerDeath, EventHookMode_Post);
}

// Hook function to reward VIPs on kills
public Action OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
    // Get the attacker and victim IDs from the event
    int attackerID = event.GetInt("attacker");
    int victimID = event.GetInt("userid");

    // Debugging output
    PrintToServer("Attacker ID: %d, Victim ID: %d", attackerID, victimID);

    // Ensure attacker is in the game
    int attacker = GetClientOfUserId(attackerID);
    if (!IsClientInGame(attacker))
    {
        PrintToServer("Attacker %d is not in game.", attacker); // Debugging output
        return Plugin_Continue; // Exit if not in the game
    }

    // Ensure attacker is a VIP
    if (!VIP_IsClientVIP(attacker))
    {
        PrintToServer("Client %d is not a VIP.", attacker); // Debugging output
        return Plugin_Continue; // Exit if not a VIP
    }

    // Ensure victim is in the game
    int victim = GetClientOfUserId(victimID);
    if (!IsClientInGame(victim))
    {
        PrintToServer("Victim %d is not in game.", victim); // Debugging output
        return Plugin_Continue; // Exit if not in game
    }

    // Check if the victim is a zombie
    if (IsZombie(victim)) // Implement your logic for checking zombies here
    {
        // Add extra XP for killing a zombie
        int currentXP = SMRPG_GetClientExperience(attacker);
        SMRPG_SetClientExperience(attacker, currentXP + EXTRA_XP);

        CPrintToChat(attacker, "{green}[VIP] {fullred}You've received %d extra XP for killing a zombie!", EXTRA_XP);
    }

    return Plugin_Continue;
}

// Function to check if a player is a zombie
bool IsZombie(int client)
{
    // Implement your logic to determine if the player is a zombie
    // Example logic (replace with your game's specific logic):
    return (GetClientTeam(client) == 2); // Adjust based on your zombie team's number
}
