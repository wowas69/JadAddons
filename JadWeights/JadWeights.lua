-- Globals
local ADDON_NAME = "JadWeights";
local ADDON_VERSION = "0.69";
local TOOLTIPS = { GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3 };

local STAT_DPS = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT";
local STAT_CRIT = "ITEM_MOD_CRIT_RATING_SHORT";
local STAT_HASTE = "ITEM_MOD_HASTE_RATING_SHORT";
local STAT_MASTERY = "ITEM_MOD_MASTERY_RATING_SHORT";
local STAT_STAMINA = "ITEM_MOD_STAMINA_SHORT";
local STAT_STRENGTH = "ITEM_MOD_STRENGTH_SHORT";
local STAT_VERSATILITY = "ITEM_MOD_VERSATILITY";

local TEXT_LEFT = "Stat weight";
local COLOR_LEFT = { R = 1, G = 0.823, B = 0 };
local COLOR_RIGHT = { R = 0, G = 1, B = 0 };

-- Current weights
local dpsWeight = 15.14;
local hasteWeight = 5.06;
local critWeight = 6.36;
local masteryWeight = 5.86;
local versatilityWeight = 6.11;
local strengthWeight = 2.61;
local staminaWeight = 0.1;

-- App init
local mainFrame = CreateFrame("Frame", ADDON_NAME .. "Frame");
mainFrame:RegisterEvent("PLAYER_LOGIN");

local function OnEvent(self, event, ...)
    JadWeights_Main();
end

mainFrame:SetScript("OnEvent", OnEvent);

function JadWeights_Main()
    for _, frame in pairs(TOOLTIPS) do
        frame:HookScript("OnTooltipSetItem", OnTooltipSetItem);
    end

    print("|cFF00FF80" .. ADDON_NAME .. " v" .. ADDON_VERSION .. "|r |cFFFFFF00initialized!|r");
end

function OnTooltipSetItem(tooltip, ...)
    local _, link = tooltip:GetItem()
    local itemStats = GetItemStats(link)
  
    -- Debug with this, prints hovered item's stat strings, add them to constants if need be tracked
--  for key, val in pairs(itemStats) do
--    print(key, val)
--  end

    local dps = (itemStats[STAT_DPS] or 0) * dpsWeight;
    local crit = (itemStats[STAT_CRIT] or 0) * critWeight;
    local haste = (itemStats[STAT_HASTE] or 0) * hasteWeight;
    local mastery = (itemStats[STAT_MASTERY] or 0) * masteryWeight;
    local versatility = (itemStats[STAT_VERSATILITY] or 0) * versatilityWeight;
    local strength = (itemStats[STAT_STRENGTH] or 0) * strengthWeight;
    local stamina = (itemStats[STAT_STAMINA] or 0) * staminaWeight;

    local totalWeight = dps + crit + haste + mastery + versatility + strength + stamina;
    local weightString = "";

    if totalWeight > 0 then
        weightString = string.format("%.2f", totalWeight);
    else
        weightString = "N/A";
    end

    tooltip:AddDoubleLine(TEXT_LEFT, weightString, COLOR_LEFT.R, COLOR_LEFT.G, COLOR_LEFT.B, COLOR_RIGHT.R, COLOR_RIGHT.G, COLOR_RIGHT.B);
    tooltip:Show();
end