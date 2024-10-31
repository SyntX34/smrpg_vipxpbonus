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
    int attacker = GetClientOfUserId(event.GetInt("attacker"));
    int victim = GetClientOfUserId(event.GetInt("userid"));

    // Ensure attacker is in the game and is a VIP
    if (!IsClientInGame(attacker) || !VIP_IsClientVIP(attacker))
    {
        return Plugin_Continue; // Exit if not a VIP
    }

    // Ensure victim is in the game
    if (!IsClientInGame(victim))
    {
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
