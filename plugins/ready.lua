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

-- ModUtil Override on CreateUpgradeChoiceButton for scaling
-- Known issue: causes cosmetic gray overlay on NPC boon screens (Arachne, Echo, etc.)
-- NPC boons remain fully functional despite the overlay
do
	local orig = rom.game.CreateUpgradeChoiceButton
	modutil.mod.Path.Override("CreateUpgradeChoiceButton", function(screen, lootData, itemIndex, itemData)
		if config.enabled ~= true or isBoonSubjectExcluded(screen.SubjectName) then
			return orig(screen, lootData, itemIndex, itemData)
		end

		screen.MaxChoices = config.choices
		local scaleFactor = 3.0 / config.choices
		resizeBoonScreenData(screen, scaleFactor)

		local button = orig(screen, lootData, itemIndex, itemData)

		resizeBoonScreenComponents(screen, itemIndex, scaleFactor)

		return button
	end)
end

do
	local orig = rom.game.DestroyBoonLootButtons
	modutil.mod.Path.Override("DestroyBoonLootButtons", function(screen, lootData)
		orig(screen, lootData)
		local components = screen.Components
		local toDestroy = {}
		for index = 3, CHOICE_LIMIT.MAX do
			local keys = {
				"PurchaseButton"..index,
				"PurchaseButton"..index.."Lock",
				"PurchaseButton"..index.."Highlight",
				"PurchaseButton"..index.."Icon",
				"PurchaseButton"..index.."ExchangeIcon",
				"PurchaseButton"..index.."ExchangeIconFrame",
				"PurchaseButton"..index.."QuestIcon",
				"PurchaseButton"..index.."ElementIcon",
				"Backing"..index,
				"PurchaseButton"..index.."Frame",
				"PurchaseButton"..index.."Patch",
			}
			for _, k in pairs(keys) do
				if components[k] then
					table.insert(toDestroy, components[k].Id)
					components[k] = nil
				end
			end
		end
		Destroy({ Ids = toDestroy })
	end)
end

do
	local orig = rom.game.HandleUpgradeChoiceSelection
	modutil.mod.Path.Override("HandleUpgradeChoiceSelection", function(screen, button, args)
		screen.UpgradeButtons = game.CollapseTable(screen.UpgradeButtons)
		orig(screen, button, args)
	end)
end
