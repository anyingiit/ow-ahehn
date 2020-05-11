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

globalvar allHeros
globalvar heros 
globalvar i

rule "gamemod choice":
    @Event global
    allHeros = []
    heros = []
    allHeros = getAllHeroes()
    for i in range(0,3):
        heros.append(random.choice(getDamageHeroes()))
    for i in range(len(heros)):
        hudSubtext(hostPlayer,heros[i],HudPosition.LEFT,0,Color.BLUE,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)