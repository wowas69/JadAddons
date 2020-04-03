-- Globals
local spellPool = {};
local auraPool = {};
local barsPool = {};
local CAST_PLS = "CAST";
local FREE_CAST = "FREE";
local CD_FORMAT = "%.1f";
local ROW_1 = -250;

-- App init
local mainFrame = CreateFrame("Frame", "JadUIFrame");
mainFrame:RegisterEvent("PLAYER_LOGIN");

local function OnEvent(self, event, ...)
    JadUI_Main();
end

mainFrame:SetScript("OnEvent", OnEvent);

function JadUI_Main()
    -- Player & Target frames
    PlayerFrame:ClearAllPoints();
    PlayerFrame:SetPoint("CENTER", -420, 350);

    TargetFrame:ClearAllPoints();
    TargetFrame:SetPoint("CENTER", 420, 350);

    MainMenuBarArtFrame:Hide();

    local playerClass, playerSpec = GetPlayerInfo();

    if (playerClass == "WARRIOR" and playerSpec == "Arms") then
        ArmsWarriorSetup();
    elseif (playerClass == "MAGE" and playerSpec == "Fire") then
        FireMageSetup();
    end
    
    -- Start UI updates
    C_Timer.NewTicker(0.01, Refresh);

    print("|cFF00FF80JadUI v1.69|r |cFFFFFF00initialized!|r");
end

function ArmsWarriorSetup()
    -- Bars
    CreateUIBar("Health", 200, 20, -100, ROW_1 + 50, 0.78, 0.61, 0.43, RefreshHealth);
    CreateUIBar("Rage", 200, 20, -100, ROW_1 + 30, 1, 0, 0, RefreshRage);
    CreateUICastBar("PlayerCast", 200, 20, -100, ROW_1 - 75, 1, 1, 0, RefreshPlayerCast);
    CreateUICastBar("PlayerChannel", 200, 20, -100, ROW_1 - 75, 0, 1, 0, RefreshPlayerChannel);

    -- Auras
    CreateUIAura("Sweeping Strikes", 40, -100, ROW_1 + 85, true);
    CreateUIAura("Test of Might", 40, -60, ROW_1 + 85, true);
    CreateUIAura("Draconic Empowerment", 40, -20, ROW_1 + 85, true);
    CreateUIAura("Vita Charged", 40, 20, ROW_1 + 85, true);
    CreateUIAura("Racing Pulse", 40, 60, ROW_1 + 85, true);
    CreateUIAura("Dragon's Flight", 40, 100, ROW_1 + 85, true);

    -- Spells
    CreateUISpell("Bladestorm", 40, -140, ROW_1, false, false, true);
    CreateUISpell("Die by the Sword", 40, -180, ROW_1, false, false, false);
    CreateUISpell("Hamstring", 40, -220, ROW_1, false, false, true);
    CreateUISpell("Sweeping Strikes", 40, -140, ROW_1 + 40, false, false, true);
    CreateUISpell("Berserker Rage", 40, -180, ROW_1 + 40, false, false, true);
    CreateUISpell("Battle Shout", 40, -220, ROW_1 + 40, false, false, false);

    CreateUISpell("Whirlwind", 40, -80, ROW_1, true, false, true);
    --CreateUISpell("Rend", 40, -80, ROW_1, false, false, true);
    CreateUISpell("Mortal Strike", 40, -40, ROW_1, false, false, true);
    CreateUISpell("Overpower", 40, 0, ROW_1, true, false, false);
    CreateUISpell("Execute", 40, 40, ROW_1, true, false, false);
    CreateUISpell("Slam", 40, 80, ROW_1, true, false, true);

    CreateUISpell("Storm Bolt", 40, -80, ROW_1 - 40, false, false, false);
    CreateUISpell("Pummel", 40, -40, ROW_1 - 40, false, false, false);
    CreateUISpell("Charge", 40, 0, ROW_1 - 40, false, false, false);
    CreateUISpell("Heroic Leap", 40, 40, ROW_1 - 40, false, false, false);
    CreateUISpell("Victory Rush", 40, 80, ROW_1 - 40, true, false, false);

    CreateUISpell("Warbreaker", 40, 140, ROW_1, false, false, true);
    CreateUISpell("Skullsplitter", 40, 180, ROW_1, false, false, false);
    --CreateUISpell("Disarm", 40, 220, ROW_1, false, false, false);
    --CreateUISpell("Focused Azerite Beam", 40, 140, ROW_1 + 40,  false, false, true);
    --CreateUISpell("Memory of Lucid Dreams", 40, 140, ROW_1 + 40,  false, false, true);
    CreateUISpell("Blood of the Enemy", 40, 140, ROW_1 + 40,  false, false, true);
    CreateUISpell("Intimidating Shout", 40, 180, ROW_1 + 40, false, false, true);
    CreateUISpell("Rallying Cry", 40, 260, ROW_1 + 40, false, false, true);
end

function FireMageSetup()
	-- Bars
    CreateUIBar("Health", 200, 20, -100, ROW_1 + 50, 0, 1, 0, RefreshHealth);
    CreateUIBar("Mana", 200, 20, -100, ROW_1 + 30, 0, 0, 1, RefreshMana);
    CreateUICastBar("PlayerCast", 200, 20, -100, ROW_1 - 75, 1, 1, 0, RefreshPlayerCast);
    CreateUICastBar("PlayerChannel", 200, 20, -100, ROW_1 - 75, 0, 1, 0, RefreshPlayerChannel);

    -- Auras
    CreateUIAura("Combustion", 40, -100, ROW_1 + 85, true);
    CreateUIAura("Memory of Lucid Dreams", 40, -60, ROW_1 + 85, true);
    --CreateUIAura("Draconic Empowerment", 40, -20, ROW_1 + 85, true);
    --CreateUIAura("Vita Charged", 40, 20, ROW_1 + 85, true);
    --CreateUIAura("Racing Pulse", 40, 60, ROW_1 + 85, true);
    --CreateUIAura("Dragon's Flight", 40, 100, ROW_1 + 85, true);

    -- Spells
    CreateUISpell("Blazing Barrier", 40, -140, ROW_1, false, false, true);
    CreateUISpell("Remove Curse", 40, -180, ROW_1, false, false, false);
    --CreateUISpell("Time Warp", 40, -220, ROW_1, false, false, true);
    CreateUISpell("Rune of Power", 40, -140, ROW_1 + 40, false, true, true);
    CreateUISpell("Invisibility", 40, -180, ROW_1 + 40, false, false, true);
    CreateUISpell("Time Warp", 40, -220, ROW_1 + 40, false, false, false);

    CreateUISpell("Fire Blast", 40, -80, ROW_1, true, true, true);
    CreateUISpell("Pyroblast", 40, -40, ROW_1, true, false, true);
    CreateUISpell("Fireball", 40, 0, ROW_1, false, false, false);
    CreateUISpell("Meteor", 40, 40, ROW_1, false, false, false);
    CreateUISpell("Flamestrike", 40, 80, ROW_1, true, false, true);

    CreateUISpell("Dragon's Breath", 40, -80, ROW_1 - 40, false, false, false);
    CreateUISpell("Counterspell", 40, -40, ROW_1 - 40, false, false, false);
    CreateUISpell("Spellsteal", 40, 0, ROW_1 - 40, false, false, false);
    CreateUISpell("Shimmer", 40, 40, ROW_1 - 40, false, true, false);
    CreateUISpell("Frost Nova", 40, 80, ROW_1 - 40, true, false, false);

    CreateUISpell("Combustion", 40, 140, ROW_1, false, false, true);
    CreateUISpell("Scorch", 40, 180, ROW_1, false, false, false);
    CreateUISpell("Memory of Lucid Dreams", 40, 140, ROW_1 + 40,  false, false, true);
    --CreateUISpell("Manifesto of Madness", 40, 180, ROW_1 + 40, false, false, true);
    CreateUISpell("Ice Block", 40, 260, ROW_1 + 40, false, false, true);
end

function CreateUISpell(name, size, posX, posY, castWhenHighlight, trackCharges, priorityCast)
    local spellFrame = CreateFrame("Frame", nil, UIParent);
    spellFrame:SetFrameStrata("BACKGROUND");
    spellFrame:SetWidth(size);
    spellFrame:SetHeight(size);
    spellFrame:SetPoint("CENTER", posX, posY);

    local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(name);
    
    local spellBackground = spellFrame:CreateTexture(nil, "BACKGROUND");
    spellBackground:SetColorTexture(0, 0, 0, 0);
    spellBackground:SetAllPoints(spellFrame);

    local spellForeground = spellFrame:CreateTexture(nil, "LOW");
    spellForeground:SetTexture(spellIcon);
    spellForeground:SetAllPoints(spellFrame);

    local spellCooldown = CreateFrame("Cooldown", "SpellCD", spellFrame, "CooldownFrameTemplate");
    spellCooldown:SetAllPoints();

    local text = spellFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    text:SetPoint("BOTTOM", 0, -20);
    text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
    text:SetJustifyH("LEFT")

    local chargesText = spellFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    chargesText:SetPoint("BOTTOMRIGHT", 0, 0);
    chargesText:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE");
    chargesText:SetJustifyH("LEFT");
    chargesText:SetShadowOffset(1, -1);
    chargesText:SetTextColor(1, 1, 1);

    spellFrame:Show();

    spellPool[spellId] = {
        background = spellBackground,
        foreground = spellForeground,
        text = text,
        chargesText = chargesText,
        castWhenHighlight = castWhenHighlight,
        spellName = name,
        trackCharges = trackCharges,
        priorityCast = priorityCast,
        cooldown = spellCooldown
	};
end

function CreateUIAura(name, size, posX, posY, trackValue)
    local auraFrame = CreateFrame("Frame", nil, UIParent);
    auraFrame:SetFrameStrata("BACKGROUND");
    auraFrame:SetWidth(size);
    auraFrame:SetHeight(size);
    auraFrame:SetPoint("CENTER", posX, posY);

    local auraTexture = auraFrame:CreateTexture(nil, "LOW");
    auraTexture:SetAllPoints(auraFrame);

    local auraCooldown = CreateFrame("Cooldown", "AuraCD", auraFrame, "CooldownFrameTemplate");
    auraCooldown:SetAllPoints()

    local auraText = auraCooldown:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    auraText:SetPoint("BOTTOM", 0, 0);
    auraText:SetTextColor(1, 1, 1, 1);

    auraPool[name] = {
        frame = auraFrame,
        texture = auraTexture,
        text = auraText,
        cooldown = auraCooldown,
        iconSet = false,
        trackValue = trackValue
	};
end

function CreateUIBar(name, width, height, posX, posY, cRed, cGreen, cBlue, refreshCall)
    local statusbar = CreateFrame("StatusBar", nil, UIParent)
    statusbar:SetPoint("LEFT", UIParent, "CENTER", posX, posY)
    statusbar:SetWidth(width)
    statusbar:SetHeight(height)
    statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
    statusbar:GetStatusBarTexture():SetHorizTile(false)
    statusbar:GetStatusBarTexture():SetVertTile(false)
    statusbar:SetStatusBarColor(cRed, cGreen, cBlue)

    local text = statusbar:CreateFontString(nil, "OVERLAY")
    text:SetPoint("LEFT", 4, 0)
    text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
    text:SetJustifyH("LEFT")
    text:SetShadowOffset(1, -1)
    text:SetTextColor(1, 1, 1)
    text:SetText("100%")
  
    local statusbarBack = CreateFrame("Frame", nil, UIParent)
    statusbarBack:SetPoint("LEFT", UIParent, "CENTER", posX, posY)
    statusbarBack:SetWidth(width)
    statusbarBack:SetHeight(height)

    local background = statusbarBack:CreateTexture(nil, "BACKGROUND");
    background:SetColorTexture(cRed, cGreen, cBlue, 0.2);
    background:SetAllPoints(statusbarBack);
  
    barsPool[name] = 
    {
        frame = statusbar,
        width = width,
        text = text,
        refreshCall = refreshCall
    };
end

function CreateUICastBar(name, width, height, posX, posY, cRed, cGreen, cBlue, refreshCall)
    local statusbar = CreateFrame("StatusBar", nil, UIParent);
    statusbar:SetPoint("LEFT", UIParent, "CENTER", posX, posY);
    statusbar:SetWidth(width);
    statusbar:SetHeight(height);
    statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar");
    statusbar:GetStatusBarTexture():SetHorizTile(false);
    statusbar:GetStatusBarTexture():SetVertTile(false);
    statusbar:SetStatusBarColor(cRed, cGreen, cBlue);

    local text = statusbar:CreateFontString(nil, "OVERLAY");
    text:SetPoint("LEFT", height + 10, 0);
    text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE");
    text:SetJustifyH("LEFT");
    text:SetShadowOffset(1, -1);
    text:SetTextColor(1, 1, 1);
    text:SetText("Focused Azerite Beam");

    local icon = statusbar:CreateTexture(nil, "OVERLAY");
    icon:SetPoint("LEFT", 0, 0);
    icon:SetWidth(height);
    icon:SetHeight(height);
    icon:SetTexture(2967111);
  
    barsPool[name] = 
    {
        frame = statusbar,
        width = width,
        text = text,
        refreshCall = refreshCall,
        icon = icon
    };
end

function Refresh()
	for spellId, spellData in pairs(spellPool) do
        RefreshUISpell(spellId, spellData);
    end

    for auraName, auraData in pairs(auraPool) do
        RefreshUIAura(auraName, auraData);
    end

    for barName, barData in pairs(barsPool) do
        RefreshUIBar(barName, barData);
    end
end

function RefreshUISpell(spellId, spellData)
    local cdStart, cdDuration = GetSpellCooldown(spellId);
    local onCooldown = cdStart > 0 and cdDuration > 0;
    local usable = IsUsableSpell(spellId);
    local highlighted = IsSpellOverlayed(spellId);
    local buffName, expirationTime = FindAura("player", spellData.spellName);
    local charges = GetSpellCharges(spellId);
    local cdLeft = cdStart + cdDuration - GetTime();

    -- Handle charges
    if spellData.trackCharges and charges then
        spellData.chargesText:SetText(charges);
    end

    -- Handle textures
    if onCooldown then
        spellData.cooldown:SetCooldown(cdStart, cdDuration);
        spellData.cooldown:Show();
    else
        spellData.cooldown:Hide();
    end

    if not usable then
        spellData.foreground:SetAlpha(0.5);
        spellData.background:SetColorTexture(0, 0, 1, 0.8);
    else
        spellData.foreground:SetAlpha(1);
        spellData.background:SetColorTexture(0, 0, 0, 0);
    end

    if spellData.castWhenHighlight and highlighted then
        spellData.foreground:SetAlpha(0.5);
        spellData.background:SetColorTexture(1, 1, 0, 0.8);
        
        if not usable then
            spellData.background:SetColorTexture(0.6, 0.6, 1, 0.8);
        end
    end
end

function RefreshUIAura(auraName, auraData)
    local name, _, icon, value, expirationTime, duration = FindAura("player", auraName);

    if name == auraName then
        if not auraData.iconSet then
            auraData.iconSet = true;
            auraData.texture:SetTexture(icon);
        end

        auraData.cooldown:SetCooldown(expirationTime - duration, duration);

        if auraData.trackValue then
            auraData.text:SetText(value);
        else 
            auraData.text:SetText("");
        end

        auraData.cooldown:Show();
        auraData.frame:Show();
    else
        auraData.cooldown:Hide();
        auraData.frame:Hide();
    end
end

function RefreshUIBar(barName, barData)
	barData.refreshCall(barData);
end

-- name, expString, icon, value, expirationTime, duration
function FindAura(unit, spellName)
    for i = 1, 40 do
	   local name, icon, _, _, duration, expirationTime, _, _, _, _, _, _, _, _, _, value = UnitAura(unit, i);
       
       if name == spellName then
            local expString = "";

            if expirationTime then
                local expTime = expirationTime - GetTime();

                if expTime < 60 and expTime >= 0 then
                    expString = string.format(CD_FORMAT, expTime);
                end
            end

            return name, expString, icon, value, expirationTime, duration;
       end
    end

    return nil, nil, nil, nil, nil, nil;
end

function RefreshRage(barData)
    local rage = UnitPower("player");
    local frameWidth = rage * barData.width / 100;
    
    if frameWidth == 0 then
        frameWidth = 1;
    end

    barData.text:SetText(rage);
    barData.frame:SetWidth(frameWidth);
end

function RefreshMana(barData)
    local mana = UnitPower("player");
    local maxMana = UnitPowerMax("player");
    local frameWidth = mana * barData.width / maxMana;
    
    local manaText = string.format("%.1f", (mana / maxMana) * 100) .. "%";

    if frameWidth == 0 then
        frameWidth = 1;
    end

    barData.text:SetText(manaText);
    barData.frame:SetWidth(frameWidth);
end

function RefreshHealth(barData)
    local health = UnitHealth("player");
    local maxHealth = UnitHealthMax("player");

    local healthText = string.format("%.1f", (health / maxHealth) * 100) .. "%";
    local frameWidth = health * barData.width / maxHealth;
  
    if frameWidth == 0 then
        frameWidth = 1;
        healthText = "DEAD";
    end

    barData.text:SetText(healthText);
    barData.frame:SetWidth(frameWidth);
end

function RefreshPlayerCast(barData)
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo("player")

    if name then
        CastingBarFrame:Hide();

        local total = (endTimeMS - startTimeMS) / 1000;
        local finish = endTimeMS / 1000 - GetTime();
        local progress = 1 - (finish / total);

        barData.icon:SetTexture(texture);
        barData.text:SetText(name);
        barData.frame:SetWidth(progress * barData.width);
        barData.frame:Show();
    else
        barData.frame:Hide();
    end
end

function RefreshPlayerChannel(barData)
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo("player")

    if name then
        CastingBarFrame:Hide();

        local total = (endTimeMS - startTimeMS) / 1000;
        local finish = endTimeMS / 1000 - GetTime();
        local progress = finish / total;

        barData.icon:SetTexture(texture);
        barData.text:SetText(name);
        barData.frame:SetWidth(progress * barData.width);
        barData.frame:Show();
    else
        barData.frame:Hide();
    end
end

function GetPlayerInfo()
	local _, name = GetSpecializationInfo(GetSpecialization());
    local _, class = UnitClass("player");

    return class, name;
end

    -- spellFrame:SetMovable(true);
    -- spellFrame:EnableMouse(true);
    -- spellFrame:RegisterForDrag("LeftButton");
    -- spellFrame:SetScript("OnDragStart", spellFrame.StartMoving);
    -- spellFrame:SetScript("OnDragStop", spellFrame.StopMovingOrSizing);