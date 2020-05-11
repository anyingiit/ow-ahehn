/*
更新记录
V0.68   2020年5月6日01:05:55 EJNJE
V0.7    2020年5月6日01:37:36 9D1MH -> GR3QR(去注释)
V0.701  2020年5月6日08:44:05 X3B05(去注释)
V0.702  2020年5月6日10:07:37 8SD5Q(去注释)
V0.703  2020年5月6日10:32:30 R59E5(去注释)
V0.704  2020年5月6日18:32:30 9BZM0(去注释)
V0.705  2020年5月8日13:37:52 2R7A1(去注释)
V0.705  2020年5月8日18:45:01 (WARNING, 该版本受到编辑器影响未正确发布!)
V0.706  2020年5月8日18:45:01 (WARNING, 该版本受到编辑器影响未正确发布!)
*/
#!obfuscate
settings {
    "main": {
        "description": "无修练枪 - 人性版[ver0.706]                                                                                                   1. 在您或他人做出决定前,该房不会和普通练枪房有任何区别                                                            2. 开发者: 由我来守护你#51421                                                                                                                                3. 该版本发布日期2020-5-9 21:00:40"
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
#GLobal privte
globalvar i
globalvar j
globalvar k

#Global variables
globalvar gameMode
globalvar hitList
globalvar whiteAndBlackList
globalvar whiteListAndBlackListMaxLength
globalvar allowAnyLocationSwitchHeros

#Global Config
globalvar GameDefaultMode #[0-defalt]auto [1]normal [2]whiteList [3]blackList
globalvar WhiteListAndBlackListShiftType
globalvar WhiteAndBlackListDftMaxLength
globalvar WhiteListDefaultMaxLength
globalvar BlackListDefaultMaxLength
globalvar PlayerMaxPower
globalvar KillerKillKillerTips
globalvar KillerDiedOfKillerKillTips
globalvar WhichMapAnytimeSwitchHeros

#Player variables
playervar inHitList
playervar isKillerBatchKill
playervar allowKillLimit
playervar deathCause #[1]自杀 [2]被杀手暗杀 [3]在暗杀名单被在暗杀名单玩家击杀 [4]在暗杀名单被非暗杀名单玩家击杀
playervar firstInGameTips
playervar findShortcut
#Subroutine Names


rule "禁用查看器录制":
    @Disabled
    @Event global
    disableInspector()

rule "[自定义]游戏运行模式: (默认)[0]自动 [1]无修改 [2]白名单模式 [3]黑名单模式":
    @Event global
    GameDefaultMode = 0

rule "[自定义]白名单&黑名单转换英雄类型 (默认)[0]平均分配 [1]随机":
    @Event global
    WhiteListAndBlackListShiftType = 0

rule "[自定义]白名单&黑名单默认最大人数: [0]随机 (默认3)[>0]使用该值":
    @Event global
    WhiteAndBlackListDftMaxLength = 3

rule "[自定义]白名单默认最大人数: (默认)[0]使用默认最大人数 [>0]使用该值":
    @Event global
    WhiteListDefaultMaxLength = 0

rule "[自定义]黑名单默认最大人数: (默认)[0]使用默认最大人数 [>0]使用该值":
    @Event global
    BlackListDefaultMaxLength = 0

rule "[自定义]玩家最大可储藏权力: (默认3)[>0]使用该值":
    @Event global
    PlayerMaxPower = 3

rule "[自定义]杀手击杀杀手提示: [真]提示 (默认)[假]不提示":
    @Event global
    KillerKillKillerTips = false

rule "[自定义]杀手被杀手击杀提示: (默认)[真]提示 [假]不提示":
    @Event global
    KillerDiedOfKillerKillTips = true

rule "[自定义]允许在什么地图随时切换英雄: (默认)[0]在没有重生室的地图(如创意工坊地图) [1]在任何地图":
    @Event global
    WhichMapAnytimeSwitchHeros = 0

rule "初始化":
    @Event global
    #数组初始化
    whiteAndBlackList = []
    #文本初始化
    hudSubtext([p for p in getAllPlayers() if not p.isHoldingButton(Button.INTERACT)],"按下互动键(F)查看游戏状态信息",HudPosition.LEFT,2,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(),"作者:由我来守护你#51421",HudPosition.TOP,0,Color.WHITE,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    #游戏模式类型初始化
    gameMode = random.randint(1,3) if GameDefaultMode == 0 else GameDefaultMode
    #允许在任何地点切换英雄初始化
    allowAnyLocationSwitchHeros = ((getCurrentMap() == Map.WORKSHOP_CHAMBER or 
    getCurrentMap() == Map.WORKSHOP_EXPANSE or 
    getCurrentMap() == Map.WORKSHOP_EXPANSE_NIGHT or 
    getCurrentMap() == Map.WORKSHOP_ISLAND  or 
    getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) if WhichMapAnytimeSwitchHeros == 0 else false) or (
        (true) if WhichMapAnytimeSwitchHeros == 1 else false)
    #游戏模式初始化
    if gameMode >=2 and gameMode <=3:
        #构建最大黑白名单人名数量
        WhiteAndBlackListDftMaxLength = WhiteAndBlackListDftMaxLength if WhiteAndBlackListDftMaxLength > 0 else random.randint(1,len(getAllPlayers()))
        switch(gameMode):
            case 2:
                whiteListAndBlackListMaxLength = WhiteListDefaultMaxLength if WhiteListDefaultMaxLength > 0 else WhiteAndBlackListDftMaxLength
                break
            case 3:
                whiteListAndBlackListMaxLength = BlackListDefaultMaxLength if BlackListDefaultMaxLength > 0 else WhiteAndBlackListDftMaxLength
                break
        #构建白名单
        switch(WhiteListAndBlackListShiftType):
            case 0:
                for i in range(1,(3 + 1)):
                    for j in range(1,(whiteListAndBlackListMaxLength / 3) + 1):
                        switch(i):
                            case 1:
                                k = random.choice(getTankHeroes())
                                break
                            case 2:
                                k = random.choice(getDamageHeroes())
                                break
                            case 3:
                                k = random.choice(getSupportHeroes())
                                break
                        if not k in whiteAndBlackList:
                            whiteAndBlackList.append(k)
                        else:
                            j --
                break
            case 1:
                for i in range(1,whiteListAndBlackListMaxLength + 1):
                    j = random.choice(getAllHeroes())
                    if not j in whiteAndBlackList:
                        whiteAndBlackList.append(j)
                    else:
                        i --
                break
rule "玩家死亡类型鉴定":
    @Event playerDied
    if attacker == victim and not victim.isKillerBatchKill:
        victim.deathCause = 1
    elif attacker == victim and victim.isKillerBatchKill:
        victim.isKillerBatchKill = false
        victim.deathCause = 2
    elif victim.inHitList and attacker.inHitList: #可以多加一个判定, 判定攻击者不是自己
        victim.deathCause = 3
    elif victim.inHitList and not attacker.inHitList:
        victim.deathCause = 4
rule "白名单模式-玩家使用白名单英雄":
    @Event eachPlayer
    @Condition gameMode == 2 and eventPlayer.getCurrentHero() in whiteAndBlackList
        eventPlayer.inHitList = false

rule "白名单模式-玩家使用非白名单英雄":
    @Event eachPlayer
    @Condition gameMode == 2 and not eventPlayer.getCurrentHero() in whiteAndBlackList
        eventPlayer.inHitList = true

rule "黑名单模式-玩家使用黑名单英雄":
    @Event eachPlayer
    @Condition gameMode == 3 and eventPlayer.getCurrentHero() in whiteAndBlackList
        eventPlayer.inHitList = true

rule "黑名单模式-玩家使用非黑名单英雄":
    @Event eachPlayer
    @Condition gameMode == 3 and not eventPlayer.getCurrentHero() in whiteAndBlackList
        eventPlayer.inHitList = false

rule "在暗杀名单内玩家死亡获得权力,并提示玩家力量触发":
    @Event playerDied
    @Condition victim.inHitList and victim.deathCause == 3
        if victim.allowKillLimit < PlayerMaxPower:
            victim.allowKillLimit++
            if KillerDiedOfKillerKillTips:
                smallMessage(victim,"您的某种力量似乎被激发了...")
            if KillerKillKillerTips:
                smallMessage(attacker,"他的力量似乎被激发了...")
        else:
            smallMessage(victim,"您的某种力量已达上限...")

rule "[热键]暗杀名单内玩家击杀所有暗杀名单玩家":
    @Event eachPlayer
    @Condition eventPlayer.inHitList and eventPlayer.allowKillLimit > 0 and eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
        if not eventPlayer.findShortcut:
            eventPlayer.findShortcut = true
        smallMessage(eventPlayer,"你确定要做出决定吗?如果确定请长按...")
        wait(1.5,Wait.ABORT_WHEN_FALSE)
        for i in range(0,len(getAllPlayers())):
            if getAllPlayers()[i].inHitList:
                kill(getAllPlayers()[i],null)
                getAllPlayers()[i].isKillerBatchKill = true
        eventPlayer.allowKillLimit-=1
        smallMessage(eventPlayer,"[{0}/{1}]".format(eventPlayer.allowKillLimit,PlayerMaxPower))

rule "[热键]更换英雄":
    @Event eachPlayer
    @Condition not eventPlayer.isInSpawnRoom() and allowAnyLocationSwitchHeros and eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.RELOAD)
        smallMessage(eventPlayer,"您正在进行换英雄操作, 请继续长按")
        wait(1.5,Wait.ABORT_WHEN_FALSE)
        eventPlayer.setAllowedHeroes(random.choice(eventPlayer.getAllowedHeroes().exclude(eventPlayer.getCurrentHero())))
        wait(0.5)
        eventPlayer.setAllowedHeroes(getAllHeroes().exclude(eventPlayer.getAllowedHeroes()))
        wait(0.5)
        eventPlayer.resetHeroAvailability()

rule "[热键]重新显示欢迎语":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.JUMP) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
        smallMessage(eventPlayer,"您正在重置欢迎语, 请继续长按")
        wait(1.5,Wait.ABORT_WHEN_FALSE)
        eventPlayer.firstInGameTips = false
        smallMessage(eventPlayer,"欢迎语重置成功!")
rule "玩家进场欢迎语": #TODO: 增加可以使用随时更换英雄的地图, 提示可以更换英雄的信息
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != null and not eventPlayer.firstInGameTips
        wait(1)
        smallMessage(eventPlayer,"欢迎您进入无修练枪房!!!")
        wait(1.5)
        smallMessage(eventPlayer,"请您在正式游玩之前时候仔细检查房间各项设置, 谨防篡改!")
        wait(2)
        smallMessage(eventPlayer,"游戏模式开发者: 由我来守护你#51421")
        wait(1.5)
        smallMessage(eventPlayer,"您接下可以直接游戏, 或者查看左上角游戏提示")
        wait(2)
        smallMessage(eventPlayer,"游戏准备完毕, 祝您游玩愉快!")
        eventPlayer.firstInGameTips = true
    
rule "玩家被杀手使用力量批量击杀":
    @Event playerDied
    @Condition victim.deathCause == 2
        wait(2.5)
        smallMessage(victim,"您刚刚被他人暗杀...")

rule "[多行文本]快捷键提示(全局)":
    @Event global
    #左侧
    hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT)],"当前游戏模式:{0}{1}".format("(自动)" if GameDefaultMode == 0 else "", "正常模式" if gameMode == 1 else "白名单模式" if gameMode == 2 else "黑名单模式" if gameMode == 3 else null),HudPosition.LEFT,0,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    if gameMode>=2 and gameMode <=3:
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT)],"{0}列表:".format("白名单" if gameMode == 2 else "黑名单" if gameMode == 3 else null),HudPosition.LEFT,9,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.ANA in whiteAndBlackList],"   {0}".format(Hero.ANA),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.ASHE in whiteAndBlackList],"   {0}".format(Hero.ASHE),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.BAPTISTE in whiteAndBlackList],"   {0}".format(Hero.BAPTISTE),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.BASTION in whiteAndBlackList],"   {0}".format(Hero.BASTION),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.BRIGITTE in whiteAndBlackList],"   {0}".format(Hero.BRIGITTE),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.DOOMFIST in whiteAndBlackList],"   {0}".format(Hero.DOOMFIST),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.DVA in whiteAndBlackList],"   {0}".format(Hero.DVA),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.ECHO in whiteAndBlackList],"   {0}".format(Hero.ECHO),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.GENJI in whiteAndBlackList],"   {0}".format(Hero.GENJI),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.HAMMOND in whiteAndBlackList],"   {0}".format(Hero.HAMMOND),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.HANZO in whiteAndBlackList],"   {0}".format(Hero.HANZO),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.JUNKRAT in whiteAndBlackList],"   {0}".format(Hero.JUNKRAT),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.LUCIO in whiteAndBlackList],"   {0}".format(Hero.LUCIO),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.MCCREE in whiteAndBlackList],"   {0}".format(Hero.MCCREE),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.MEI in whiteAndBlackList],"   {0}".format(Hero.MEI),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.MERCY in whiteAndBlackList],"   {0}".format(Hero.MERCY),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.MOIRA in whiteAndBlackList],"   {0}".format(Hero.MOIRA),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.ORISA in whiteAndBlackList],"   {0}".format(Hero.ORISA),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.PHARAH in whiteAndBlackList],"   {0}".format(Hero.PHARAH),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.REAPER in whiteAndBlackList],"   {0}".format(Hero.REAPER),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.REINHARDT in whiteAndBlackList],"   {0}".format(Hero.REINHARDT),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.ROADHOG in whiteAndBlackList],"   {0}".format(Hero.ROADHOG),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.SIGMA in whiteAndBlackList],"   {0}".format(Hero.SIGMA),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.SOLDIER in whiteAndBlackList],"   {0}".format(Hero.SOLDIER),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.SOMBRA in whiteAndBlackList],"   {0}".format(Hero.SOMBRA),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.SYMMETRA in whiteAndBlackList],"   {0}".format(Hero.SYMMETRA),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.TORBJORN in whiteAndBlackList],"   {0}".format(Hero.TORBJORN),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.TRACER in whiteAndBlackList],"   {0}".format(Hero.TRACER),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.WIDOWMAKER in whiteAndBlackList],"   {0}".format(Hero.WIDOWMAKER),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.WINSTON in whiteAndBlackList],"   {0}".format(Hero.WINSTON),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.ZARYA in whiteAndBlackList],"   {0}".format(Hero.ZARYA),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and Hero.ZENYATTA in whiteAndBlackList],"   {0}".format(Hero.ZENYATTA),HudPosition.LEFT,10,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    #右侧
    hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT)],"游戏快捷键信息",HudPosition.RIGHT,0,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT) and allowAnyLocationSwitchHeros],"更换英雄    =         互动 + 换弹",HudPosition.RIGHT,1,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT)],"重新查看欢迎信息     = 互动 + 跳 + 左键",HudPosition.RIGHT,2,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
rule "[多行文本]快捷键提示(每个玩家)":
    @Event eachPlayer
    #左侧
    if gameMode>=2 and gameMode <=3:
        hudSubtext([eventPlayer if eventPlayer.isHoldingButton(Button.INTERACT) else null],"您的剩余力量:[{0}]".format(eventPlayer.allowKillLimit if eventPlayer.allowKillLimit > 0 else "无"),HudPosition.LEFT,2,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        hudSubtext([eventPlayer if eventPlayer.isHoldingButton(Button.INTERACT) else null],"力量触发快捷键:< {0} >".format("互动键(F) + 左键 + 右键" if eventPlayer.findShortcut else "未发现"),HudPosition.LEFT,3,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)

#TODO: 点子 玩家被击杀后可以选择复仇 但是代价将会把一个或多个队友杀死
#TODO: 鉴挂模式