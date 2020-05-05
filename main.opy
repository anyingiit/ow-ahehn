'''
更新记录
'''
#GLobal privte
globalvar i
globalvar j
globalvar k

#Global variables
globalvar gameMode
globalvar hitList
globalvar whiteAndBlackList
globalvar whiteAndBlackListIndex #白名单或黑名单相对于全部英雄的索引位置
globalvar whiteListAndBlackListMaxLength
globalvar allHeroes

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
allHeroes = []
for i in range(0,len(getAllHeroes())):
    allHeroes[i] = getAllHeroes()[i]
#文本初始化
hudSubtext([p for p in getAllPlayers() if not p.isHoldingButton(Button.INTERACT)],"按下互动键(F)查看快捷键说明",HudPosition.LEFT,2,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
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
    else:
        wait(1)
        #提示力量超出上限

@Rule "[热键]暗杀名单内玩家击杀所有暗杀名单玩家"
@Event eachPlayer
if eventPlayer.inHitList and eventPlayer.allowKillLimit > 0 and eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) and eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
    smallMessage(eventPlayer,"你确定要做出决定吗?如果确定请长按...")
    wait(1.5,Wait.ABORT_WHEN_FALSE)
    for i in range(0,len(getAllPlayers())):
        if getAllPlayers()[i].inHitList:
            kill(getAllPlayers()[i],null)
            getAllPlayers()[i].isKillerKill = true
    eventPlayer.allowKillLimit-=1
    smallMessage(eventPlayer,"[{0}/{1}]".format(eventPlayer.allowKillLimit,PlayerMaxPower))

@Rule "[多行文本]快捷键提示"
@Event global
hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT)],"当前游戏模式:{0}{1}".format("(自动)" if GameDefaultMode == 0 else "", "正常模式" if gameMode == 1 else null + "白名单模式" if gameMode == 2 else null + "黑名单模式" if gameMode == 3 else null),HudPosition.LEFT,0,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
if gameMode>=2 and gameMode <=3:
    hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT)],"{0}列表:".format("白名单" if gameMode == 2 else null + "黑名单" if gameMode == 3 else null),HudPosition.LEFT,1,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
    for i in range(0,len(whiteAndBlackList)):
        j = whiteAndBlackList[i]
        wait(0.5)
        hudSubtext([p for p in getAllPlayers() if p.isHoldingButton(Button.INTERACT)],k,HudPosition.LEFT,2,Color.YELLOW,HudReeval.VISIBILITY_AND_STRING,SpecVisibility.DEFAULT)
        wait(0.5)
