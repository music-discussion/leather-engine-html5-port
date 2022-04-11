-- REWRITE BY LEATHER128 CUZ GOODNESS THAT OLD CODE IS CONFUSING

-- GLOBAL VARIABLES
-- basically just a list of the start and end of all the rounds (in sections)
FIGHT_SECTIONS = {
    {24, 32},
    {66, 82},
    {100, 104},
    {112, 116},
    {-1, -1} -- i didn't feel like adding an actual check for if there were more rounds so uh yeah lmao
}

ROUND = 1

OG_POSITIONS = {
    ["spurk"] = {["x"] = 0, ["y"] = 0},
    ["ron"] = {["x"] = 0, ["y"] = 0}
}

-- name = actor name of the funny guy who have da glowing eyes and stuff
-- fighter name = actor name of the funny guy who looks like a jojo stand
SpurkName = "SpurkMattAnim"
SpurkFighterName = "bfCharacter2"
SpurkGroupCharName = "bfCharacter1"

RonName = "RonMattAnim"
RonFighterName = "dadCharacter2"
RonGroupCharName = "dadCharacter1"

function start(song)
    print(song)

    OG_POSITIONS["spurk"] = {["x"] = getActorX(SpurkGroupCharName), ["y"] = getActorY(SpurkGroupCharName)}
    OG_POSITIONS["ron"] = {["x"] = getActorX(RonGroupCharName), ["y"] = getActorY(RonGroupCharName)}

    -- Make da sprites with the animations
    makeAnimatedSprite(SpurkName, "NCSpurkmattpower", 10000, 10000)
    addActorAnimation(SpurkName, "anim", "matt stando pose", 24, true)
    playActorAnimation(SpurkName, "anim")
    setActorFlipX(true, SpurkName)

    makeAnimatedSprite(RonName, "ronmattpower", 10000, 10000)
    addActorAnimation(RonName, "anim", "matt stando pose", 24, true)
    playActorAnimation(RonName, "anim")

    resetMatts()
end

function resetMatts()
    setActorPos(10000, 10000, SpurkName)
    setActorPos(10000, 10000, SpurkFighterName)

    setActorPos(10000, 10000, RonName)
    setActorPos(10000, 10000, RonFighterName)

    setActorVisible(true, SpurkFighterName)
    setActorVisible(true, RonFighterName)

    setActorVisible(true, SpurkName)
    setActorVisible(true, RonName)
end

CUR_SECTION = 0

-- basically for fight states, 0 = not started, 1 = they at the middle, 2 = fighting, 3 = going back, 4 = done
FIGHT_STATE = 0

function update(elapsed)
    CUR_SECTION = math.floor(curBeat / 4)

    -- minus a section because it takes a section to tween
    if CUR_SECTION == FIGHT_SECTIONS[ROUND][1] - 1 and FIGHT_STATE == 0 then
        resetMatts()

        FIGHT_STATE = 1

        tweenPosIn(SpurkGroupCharName, 785, OG_POSITIONS.spurk.y, (crochet / 1000) * 16)
        tweenPosIn(RonGroupCharName, 267, OG_POSITIONS.ron.y, (crochet / 1000) * 16)
    end

    if CUR_SECTION == FIGHT_SECTIONS[ROUND][1] and FIGHT_STATE == 1 then
        FIGHT_STATE = 2

        -- set positions of funny stands to the place
        setActorPos(getActorX(SpurkGroupCharName), getActorY(SpurkGroupCharName), SpurkFighterName)
        setActorPos(getActorX(RonGroupCharName), getActorY(RonGroupCharName), RonFighterName)

        -- hide old chars cuz yeah
        setActorVisible(false, SpurkGroupCharName)
        setActorVisible(false, RonGroupCharName)

        -- put funny men to space of stands
        setActorPos(getActorX(SpurkFighterName), getActorY(SpurkFighterName), SpurkName)
        setActorPos(getActorX(RonFighterName), getActorY(RonFighterName), RonName)

        -- tween funny men to the space where yes
        tweenPosOut(SpurkName, OG_POSITIONS.spurk.x, OG_POSITIONS.spurk.y, (crochet / 1000) * 16)
        tweenPosOut(RonName, OG_POSITIONS.ron.x, OG_POSITIONS.ron.y, (crochet / 1000) * 16)
    end

    if CUR_SECTION == FIGHT_SECTIONS[ROUND][2] - 1 and FIGHT_STATE == 2 then
        FIGHT_STATE = 3

        -- tween stands back
        tweenPosIn(SpurkFighterName, OG_POSITIONS.spurk.x, OG_POSITIONS.spurk.y, (crochet / 1000) * 16)
        tweenPosIn(RonFighterName, OG_POSITIONS.ron.x, OG_POSITIONS.ron.y, (crochet / 1000) * 16)
    end

    if CUR_SECTION == FIGHT_SECTIONS[ROUND][2] and FIGHT_STATE == 3 then
        FIGHT_STATE = 0
        ROUND = ROUND + 1

        resetMatts()

        -- set stuff to invisible just incase stuff doesn't align perfectly in timing and tweens bug out
        setActorVisible(false, SpurkFighterName)
        setActorVisible(false, RonFighterName)

        setActorVisible(false, SpurkName)
        setActorVisible(false, RonName)

        -- set old guys back to normal B)
        setActorVisible(true, SpurkGroupCharName)
        setActorVisible(true, RonGroupCharName)
        
        setActorPos(OG_POSITIONS.spurk.x, OG_POSITIONS.spurk.y, SpurkGroupCharName)
        setActorPos(OG_POSITIONS.ron.x, OG_POSITIONS.ron.y, RonGroupCharName)
    end
end