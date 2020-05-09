#!obfuscate
settings {
    "main": {
        "description": "Test"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "spectatorSlots": 12,
        "returnToLobby": "never",
        "teamBalancing": "afterGame"
    },
    "gamemodes": {
        "skirmish": {},
        "general": {
            "gamemodeStartTrigger": "immediately",
            "healthPackRespawnTime%": 40,
            "heroLimit": "2PerTeam",
            "respawnTime%": 0
        }
    }
}
globalvar test
globalvar test1

rule "No normal removal":
    @Event global
    #No normal removal
    test = true