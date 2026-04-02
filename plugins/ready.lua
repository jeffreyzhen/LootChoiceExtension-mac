---@meta _
---@diagnostic disable: lowercase-global

modutil.mod.Path.Override("GetTotalLootChoices", function()
    return config.choices
end)

modutil.mod.Path.Override("CalcNumLootChoices", function(isGodLoot, treatAsGodLootByShops)
    local numChoices = config.choices
    if (isGodLoot or treatAsGodLootByShops) and HasHeroTraitValue("RestrictBoonChoices") then
        numChoices = numChoices - 1
    end
    return numChoices
end)

