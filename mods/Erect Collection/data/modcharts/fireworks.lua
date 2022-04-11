local shieldhp = 0
local damaging = false
local healtimer = 0
local timer = 0
local damagetimer = 0
local pendinghp = 0
local shieldlimit = 128
local nothit = 0
local textcolor = "w"
function start(start)
    createSound("test","confirmMenu") -- make the funny sounds
    createSound("shield1","shield1")
    createSound("shield2","shield2")
    createSound("shield3","shield3")
    createSound("shield4","shield4")
    createSound("shield5","shield5")
    createSound("antiafk1","antiafk1")
    createSound("antiafk2","antiafk2")
    createSound("FireworkExplosion","FireworkExplosion")
    createSound("break","break")
    createSound("glass1","glass1")
    createSound("glass2","glass2")
    if downscroll == 0 then -- make it so that downscroll doesn't have the arrows cover the funny
        makeSprite("shield","shield",1150,550,3)
        setActorScroll(0,0,"shield")
        makeAnimatedSprite("100digit","number",1120,650,10)
        setActorScroll(0,0,"100digit")
        makeAnimatedSprite("10digit","number",1180,650,10)
        setActorScroll(0,0,"10digit")
        makeAnimatedSprite("1digit","number",1240,650,10)
        setActorScroll(0,0,"1digit")
    else
        makeSprite("shield","shield",1150,0,3)
        setActorScroll(0,0,"shield")
        makeAnimatedSprite("100digit","number",1120,100,10)
        setActorScroll(0,0,"100digit")
        makeAnimatedSprite("10digit","number",1180,100,10)
        setActorScroll(0,0,"10digit")
        makeAnimatedSprite("1digit","number",1240,100,10)
        setActorScroll(0,0,"1digit")
    end
    for i = 0,9 do
        addActorAnimation("1digit","w"..tostring(i),"w"..tostring(i),1,false)
        addActorAnimation("1digit","r"..tostring(i),"r"..tostring(i),1,false)
        addActorAnimation("10digit","w"..tostring(i),"w"..tostring(i),1,false)
        addActorAnimation("10digit","r"..tostring(i),"r"..tostring(i),1,false)
        addActorAnimation("100digit","w"..tostring(i),"w"..tostring(i),1,false)
        addActorAnimation("100digit","r"..tostring(i),"r"..tostring(i),1,false)
    end
	addActorAnimation("1digit","blank","rblank",1,false)
    addActorAnimation("10digit","blank","rblank",1,false)
    addActorAnimation("100digit","blank","rblank",1,false)
end

function update(elapsed)
    timer = timer + elapsed
    if pendinghp > 0 then
        healtimer = healtimer + elapsed
    end
    if damaging then
        damagetimer = damagetimer + elapsed
		textcolor = "r" -- r for red and w for white text
    else
		textcolor = "w"
	end
    if shieldhp > 0 then -- counter stuff
        playActorAnimation("1digit",textcolor..(shieldhp - (math.floor(shieldhp / 10)*10)),true)
        if shieldhp >= 100 then
            playActorAnimation("100digit",textcolor..math.floor(shieldhp / 100),true)
            playActorAnimation("10digit",textcolor..math.floor((shieldhp % 100) / 10),true)
        elseif shieldhp >= 10 then
            playActorAnimation("10digit",textcolor..math.floor(shieldhp / 10),true)
            playActorAnimation("100digit","blank",true)
        else
            playActorAnimation("100digit","blank",true)
            playActorAnimation("10digit","blank",true)
        end
	else
        damaging = true
		playActorAnimation("100digit","blank",true)
        playActorAnimation("10digit","blank",true)
        if (math.floor(timer * 2) % 2) == 0 then
            playActorAnimation("1digit","r0",true)
        else
            playActorAnimation("1digit","w0",true)
        end
    end
    if damagetimer > 0.5 then
        damaging = false
        damagetimer = 0
    end
    if healtimer > 0.1 and pendinghp > 0 then
        shieldhp = shieldhp + 1
        if shieldhp > shieldlimit then
            shieldhp = shieldlimit
        end
        pendinghp = pendinghp - 1
    end
end


function playerOneSing(note, songpos, type)
    if type == "default" then -- reset the antiafk measure
        nothit = 0
    end
    if type == "Fireworks" then -- damage 16 shield, if no shield, half health
        playSound("FireworkExplosion",true)
        if shieldhp > 0 then
		playSound("shield"..math.random(1,5),true)
           shieldhp = shieldhp - 16
           damaging = true
           if shieldhp < 1 then
            playSound("break",true)
                shieldhp = 0
            end 
        else
            setHealth(getHealth() - 1)
        end
    elseif type == "XPbottle" then -- do an unintentionally obnoxious sound and heal the shield by 8
        playSound("glass"..math.random(1,2),true)
        if shieldhp < shieldlimit then
            pendinghp = pendinghp + 8
        else
            setHealth(getHealth() + 0.035)
        end
    end
end

function playerOneSingHeld(note, songpos)
    if shieldhp == 0 then -- just to make sure you don't get damaged for hitting holds
        setHealth(getHealth() - 0.02)
    end
end

function playerOneMiss(note, songpos, type, isHeld)
    if shieldhp > 0 then -- make the shield take the damage instead of the healthbar
        nothit = nothit + 1
        playSound("shield"..math.random(1,5),true)
        if nothit < 3 then
            shieldhp = shieldhp - 1
        else
            playSound("antiafk"..math.random(1,2),true)
            shieldhp = shieldhp - nothit
            if shieldhp < 0 then
                shieldhp = 0
            end
        end
        damaging = true
        if not isHeld then
            setHealth(getHealth() + 0.07)
        else
            setHealth(getHealth() + 0.035)
        end
        if shieldhp < 1 then
            playSound("break",true)
        end
    end
end

function popUpScore(rating, combo)
    if shieldhp == 0 then -- cancel out the hardcoded health values when shield is 0
        if rating == "sick" or rating == "marvelous" then
            setHealth(getHealth() - 0.035)
        elseif rating == "good" then
            setHealth(getHealth() - 0.015)
        elseif rating == "bad" then
            setHealth(getHealth() - 0.005)
        elseif rating == "shit" and shieldhp > 0 then
            playSound("shield"..math.random(1,5),true)
            shieldhp = shieldhp - 1
            damaging = true
        end
    end
end