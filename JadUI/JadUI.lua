-- Globals
local spellPool = {};
local CAST_PLS = "CAST";
local FREE_CAST = "FREE";
local CD_FORMAT = "%.1f";
local ROW_1 = -120;
local ROW_2 = -220;

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

    -- Left side
    CreateUISpell("Revenge", 40, -25, ROW_1, false, false, true, false);
    CreateUISpell("Shield Slam", 40, -70, ROW_1, true, false, true, false);
    CreateUISpell("Thunder Clap", 40, -115, ROW_1, true, false, false, false);
    CreateUISpell("Devastate", 40, -160, ROW_1, true, false, false, false);
    CreateUISpell("Battle Shout", 40, -280, ROW_1, true, true, false, false);

    CreateUISpell("Shield Wall", 40, -25, ROW_2, false, true, false, false);
    CreateUISpell("Spell Reflection", 40, -70, ROW_2, false, true, false, false);
    CreateUISpell("Berserker Rage", 40, -115, ROW_2, false, true, false, false);

    CreateUISpell("Heroic Leap", 40, -280, ROW_1 + 100, false, false, false, false);
    CreateUISpell("Intercept", 40, -280, ROW_1 + 160, false, false, false, true);

    -- Right side
    CreateUISpell("Shield Block", 40, 25, ROW_1, true, true, false, true);
    CreateUISpell("Ignore Pain", 40, 70, ROW_1, true, true, false, false);
    CreateUISpell("Avatar", 40, 115, ROW_1, true, true, false, false, true);
    CreateUISpell("Demoralizing Shout", 40, 160, ROW_1, true, false, false, false, true);

    CreateUISpell("Last Stand", 40, 25, ROW_2, false, true, false, false);
    CreateUISpell("Victory Rush", 40, 70, ROW_2, false, true, true, false);
    CreateUISpell("Rallying Cry", 40, 115, ROW_2, false, true, false, false);

    CreateUISpell("Shockwave", 40, 280, ROW_1, true, false, false, false);
    CreateUISpell("Hyper Organic Light Originator", 40, 325, ROW_1, true, false, false, false);

    CreateUISpell("Pummel", 40, 280, ROW_1 + 100, false, false, false, false);
    CreateUISpell("Taunt", 40, 280, ROW_1 + 160, false, false, false, false);
    CreateUISpell("Heroic Throw", 40, 280, ROW_1 + 220, false, false, false, false);
    CreateUISpell("Intimidating Shout", 40, 280, ROW_1 + 280, false, false, false, false);
    
    -- Start UI updates
    C_Timer.NewTicker(0.01, RefreshUISpells);

    print("|cFF00FF80JadUI v0.69|r |cFFFFFF00initialized!|r");
end

-- spellPool[spellId]: background, foreground, text, chargesText, castWhenAvailable, trackBuff, castWhenHighlight, spellName, trackCharges, priorityCast
function CreateUISpell(name, size, posX, posY, castWhenAvailable, trackBuff, castWhenHighlight, trackCharges, priorityCast)
    local spellFrame = CreateFrame("Frame", nil, UIParent);
    local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(name);
    
    local spellBackground = spellFrame:CreateTexture(nil, "BACKGROUND");
    spellBackground:SetColorTexture(0, 0, 0, 0.8);
    spellBackground:SetAllPoints(spellFrame);

    local spellForeground = spellFrame:CreateTexture(nil, "LOW");
    spellForeground:SetTexture(spellIcon);
    spellForeground:SetAllPoints(spellFrame);

    spellFrame:SetFrameStrata("BACKGROUND");
    spellFrame:SetWidth(size);
    spellFrame:SetHeight(size);
    spellFrame:SetPoint("CENTER", posX, posY);
    -- spellFrame:SetMovable(true);
    -- spellFrame:EnableMouse(true);
    -- spellFrame:RegisterForDrag("LeftButton");
    -- spellFrame:SetScript("OnDragStart", spellFrame.StartMoving);
    -- spellFrame:SetScript("OnDragStop", spellFrame.StopMovingOrSizing);

    local text = spellFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    text:SetPoint("BOTTOM", 0, -20);

    local chargesText = spellFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    chargesText:SetPoint("TOPRIGHT", 5, 5);

    spellFrame:Show();

    spellPool[spellId] = {
        background = spellBackground,
        foreground = spellForeground,
        text = text,
        chargesText = chargesText,
        castWhenAvailable = castWhenAvailable,
        trackBuff = trackBuff,
        castWhenHighlight = castWhenHighlight,
        spellName = name,
        trackCharges = trackCharges,
        priorityCast = priorityCast
	};
end

function RefreshUISpells()
	for spellId, spellData in pairs(spellPool) do
        RefreshUISpell(spellId, spellData)
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

    -- Handle text
    if spellData.trackBuff and buffName then
        spellData.text:SetText(expirationTime);

    elseif onCooldown then
        local cdString = string.format(CD_FORMAT, cdLeft);
        spellData.text:SetText(cdString);

    elseif spellData.castWhenHighlight and highlighted then
        spellData.text:SetText(FREE_CAST);

    elseif spellData.castWhenAvailable then
        spellData.text:SetText(CAST_PLS);

    else
        spellData.text:SetText("");
    end

    spellData.text:SetPoint("BOTTOM", 0, -spellData.text:GetStringHeight() - 2);

    -- Handle textures
    if spellData.trackBuff and buffName then
        spellData.background:SetColorTexture(0, 0, 0, 0.8);
        spellData.foreground:SetAlpha(1);

    elseif spellData.castWhenHighlight and highlighted then
        spellData.background:SetColorTexture(1, 1, 0, 0.8);
        
        if onCooldown or not usable then
            spellData.foreground:SetAlpha(0.5);
        else
            spellData.foreground:SetAlpha(0.8);
        end

    elseif onCooldown or not usable then
        spellData.foreground:SetAlpha(0.5);

        if spellData.priorityCast and cdLeft < 1 then
            spellData.background:SetColorTexture(0, 1, 0.5, 0.8);
        else
            spellData.background:SetColorTexture(0, 0, 0, 0.8);
        end

    elseif spellData.castWhenAvailable then
        spellData.background:SetColorTexture(0, 1, 0.5, 0.8);
        spellData.foreground:SetAlpha(0.8);

    else
        spellData.background:SetColorTexture(0, 0, 0, 0.8);
        spellData.foreground:SetAlpha(0.8);
    end
end

-- auraId, expString
function FindAura(unit, spellName)
    for i = 1, 40 do
	   local name, _, _, _, _, expirationTime = UnitAura(unit, i);

       if name == spellName then
            local expString = ""

            if expirationTime then
                local expTime = expirationTime - GetTime() 

                if expTime < 60 and expTime >= 0 then
                    expString = string.format(CD_FORMAT, expTime)
                end
            end

            return name, expString;
       end
    end

    return nil, nil;
end