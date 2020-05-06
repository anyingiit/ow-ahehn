'''
更新记录
V0.68   2020年5月6日01:05:55 EJNJE
V0.7    2020年5月6日01:37:36 9D1MH -> GR3QR(去注释)
V0.701  2020年5月6日08:44:05 X3B05(去注释)
V0.702  2020年5月6日10:07:37 8SD5Q(去注释)
V0.703  2020年5月6日10:32:30 R59E5(去注释)
V0.704  2020年5月6日18:32:30 9BZM0(去注释)
'''
#GLobal privte
globalvar i
globalvar j
globalvar k

#Global variables
globalvar gameMode
globalvar hitList
globalvar whiteAndBlackList
globalvar whiteListAndBlackListMaxLength


#Global Config
globalvar GameDefaultMode #[0-defalt]auto [1]normal [2]whiteList [3]blackList
globalvar WhiteListAndBlackListShiftType
globalvar WhiteAndBlackListDftMaxLength
globalvar WhiteListDefaultMaxLength
globalvar BlackListDefaultMaxLength
globalvar PlayerMaxPower

#Player variables
playervar inHitList
playervar isKillerKill
playervar allowKillLimit
playervar deathCause #[1]自杀 [2]被杀手暗杀 [3]在暗杀名单被在暗杀名单玩家击杀 [4]在暗杀名单被非暗杀名单玩家击杀
playervar firstInGameTips
playervar findShortcut
playervar reelectHero
#Subroutine Names


@Rule "禁用查看器录制"
@Disabled
@Event global
disableInspector()

@Rule "[自定义]游戏运行模式: (默认)[0]自动 [1]无修改 [2]白名单模式 [3]黑名单模式"
@Event global
GameDefaultMode = 0

@Rule "[自定义]白名单&黑名单转换英雄类型 (默认)[0]平均分配 [1]随机"
@Event global
WhiteListAndBlackListShiftType = 0

@Rule "[自定义]白名单&黑名单默认最大人数: [0]随机 (默认)[>0]使用该值"
@Event global
WhiteAndBlackListDftMaxLength = 3

@Rule "[自定义]白名单默认最大人数: (默认)[0]使用默认最大人数 [>0]使用该值"
@Event global
WhiteListDefaultMaxLength = 0

@Rule "[自定义]黑名单默认最大人数: (默认)[0]使用默认最大人数 [>0]使用该值"
@Event global
BlackListDefaultMaxLength = 0

@Rule "[自定义]玩家最大可储藏权力"
@Event global
PlayerMaxPower = 3

@Rule "初始化"
@Event global
#数组初始化
whiteAndBlackList = []
#文本初始化
hudSubtext([p for p in getAllPlayers() if not p.isHoldingButton(Button.INTERACT)],"按下互动键(F)查看游戏状态信息",HudPosition.LEFT,2,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
hudSubtext(getAllPlayers(),"作者:由我来守护你#51421",HudPosition.TOP,0,Color.WHITE,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
#游戏模式类型初始化
gameMode = random.randint(1,3) if GameDefaultMode == 0 else GameDefaultMode
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
                    if i == 1:
                        k = random.choice(getTankHeroes())
                    elif i == 2:
                        k = random.choice(getDamageHeroes())
                    elif i == 3:
                        k = random.choice(getSupportHeroes())

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
@Rule "玩家死亡类型鉴定"
@Event playerDied
if attacker == victim and not victim.isKillerKill:
    victim.deathCause = 1
elif attacker == victim and victim.isKillerKill:
    victim.isKillerKill = false
    victim.deathCause = 2
elif victim.inHitList and attacker.inHitList:
    victim.deathCause = 3
elif victim.inHitList and not attacker.inHitList:
    victim.deathCause = 4
@Rule "玩家正在换英雄操作, 并且玩家死亡"
@Event playerDied
if victim.reelectHero:
    victim.setRespawnTime(0.5)
    victim.reelectHero = false
@Rule "白名单模式-玩家使用白名单英雄"
@Event eachPlayer
if gameMode == 2 and eventPlayer.getCurrentHero() in whiteAndBlackList:
    eventPlayer.inHitList = false

@Rule "白名单模式-玩家使用非白名单英雄"
@Event eachPlayer
if gameMode == 2 and not eventPlayer.getCurrentHero() in whiteAndBlackList:
    eventPlayer.inHitList = true

@Rule "黑名单模式-玩家使用黑名单英雄"
@Event eachPlayer
if gameMode == 3 and eventPlayer.getCurrentHero() in whiteAndBlackList:
    eventPlayer.inHitList = true

@Rule "黑名单模式-玩家使用非黑名单英雄"
@Event eachPlayer
if gameMode == 3 and not eventPlayer.getCurrentHero() in whiteAndBlackList:
    eventPlayer.inHitList = false

@Rule "在暗杀名单内玩家死亡获得权力"
@Event playerDied
if victim.inHitList and victim.deathCause == 3:
    if victim.allowKillLimit < PlayerMaxPower:
        victim.allowKillLimit++
        smallMessage(victim,"您的某种力量被激发了...")
    else:
        smallMessage(victim,"您的某种力量已达上限...")

@Rule "[热键]暗杀名单内玩家击杀所有暗杀名单玩家"
@Event eachPlayer
if eventPlayer.inHitList and eventPlayer.allowKillLimit > 0 and eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
    if not eventPlayer.findShortcut:
        eventPlayer.findShortcut = true
    smallMessage(eventPlayer,"你确定要做出决定吗?如果确定请长按...")
    wait(1.5,Wait.ABORT_WHEN_FALSE)
    for i in range(0,len(getAllPlayers())):
        if getAllPlayers()[i].inHitList:
            kill(getAllPlayers()[i],null)
            getAllPlayers()[i].isKillerKill = true
    eventPlayer.allowKillLimit-=1
    smallMessage(eventPlayer,"[{0}/{1}]".format(eventPlayer.allowKillLimit,PlayerMaxPower))

@Rule "[热键]更换英雄"
@Event eachPlayer
if  not eventPlayer.isInSpawnRoom() and not eventPlayer.reelectHero and eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.RELOAD):
    smallMessage(eventPlayer,"您正在进行换英雄操作, 请继续长按")
    wait(1.5,Wait.ABORT_WHEN_FALSE)
    eventPlayer.setRespawnTime(10)
    wait(0.1)
    smallMessage(eventPlayer,"操作成功!")
    wait(1.0)
    smallMessage(eventPlayer,"死亡后, 您将获得10秒的更换英雄时间!")
    eventPlayer.reelectHero = true

@Rule "[热键]重新显示欢迎语"
@Event eachPlayer
if eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.JUMP) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
    smallMessage(eventPlayer,"您正在重置欢迎语, 请继续长按")
    wait(1.5,Wait.ABORT_WHEN_FALSE)
    eventPlayer.firstInGameTips = false
    smallMessage(eventPlayer,"欢迎语重置成功!")
@Rule "玩家进场欢迎语"
@Event eachPlayer
if eventPlayer.getCurrentHero() and not eventPlayer.firstInGameTips:
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
    
@Rule "玩家被杀手杀死提示"
@Event playerDied
if victim.deathCause == 2:
    wait(2.5)
    smallMessage(victim,"您刚刚被他人暗杀...")
@Rule "[多行文本]快捷键提示(全局)"
@Event global
#左侧
hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT)],"当前游戏模式:{0}{1}".format("(自动)" if GameDefaultMode == 0 else "", "正常模式" if gameMode == 1 else null + "白名单模式" if gameMode == 2 else null + "黑名单模式" if gameMode == 3 else null),HudPosition.LEFT,0,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
if gameMode>=2 and gameMode <=3:
    hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT)],"{0}列表:".format("白名单" if gameMode == 2 else null + "黑名单" if gameMode == 3 else null),HudPosition.LEFT,9,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
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
hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT)],"更换英雄    =         互动 + 换弹",HudPosition.RIGHT,1,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT)],"重新查看欢迎信息     = 互动 + 跳 + 左键",HudPosition.RIGHT,2,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
@Rule "[多行文本]快捷键提示(每个玩家)"
@Event eachPlayer
#左侧
hudSubtext([eventPlayer if eventPlayer.isHoldingButton(Button.INTERACT) else null],"您的剩余力量:[{0}]".format(eventPlayer.allowKillLimit if eventPlayer.allowKillLimit > 0 else "无"),HudPosition.LEFT,2,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
hudSubtext([eventPlayer if eventPlayer.isHoldingButton(Button.INTERACT) else null],"力量触发快捷键:< {0} >".format("互动键(F) + 左键 + 右键" if eventPlayer.findShortcut else "未发现"),HudPosition.LEFT,3,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)

#TODO: 点子 玩家被击杀后可以选择复仇 但是代价将会把一个或多个队友杀死