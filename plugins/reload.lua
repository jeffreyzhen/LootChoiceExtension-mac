---@meta _
---@diagnostic disable: lowercase-global

local function isBoonSubjectExcluded(subjectName)
	if subjectName == nil or subjectName:sub(1,3) == "NPC" then return true end
	return false
end

modutil.mod.Path.Wrap("CreateUpgradeChoiceButton", function(base, screen, lootData, itemIndex, itemData)
	if isBoonSubjectExcluded(screen.SubjectName) then
		return base(screen, lootData, itemIndex, itemData)
	end

	screen.MaxChoices = config.choices
	local scaleFactor = 3.0 / config.choices
	screen.ButtonSpacingY = rom.game.ScreenData.UpgradeChoice.ButtonSpacingY * scaleFactor

	local button = base(screen, lootData, itemIndex, itemData)

	local components = screen.Components
	local key = "PurchaseButton" .. itemIndex
	if components[key] then
		SetScaleY({ Id = components[key].Id, Fraction = scaleFactor, Duration = 0 })
	end
	if components[key .. "Highlight"] then
		SetScaleY({ Id = components[key .. "Highlight"].Id, Fraction = scaleFactor, Duration = 0 })
	end
	if components[key .. "Icon"] then
		SetScaleX({ Id = components[key .. "Icon"].Id, Fraction = scaleFactor, Duration = 0 })
		SetScaleY({ Id = components[key .. "Icon"].Id, Fraction = scaleFactor, Duration = 0 })
	end
	if components[key .. "Frame"] then
		SetScaleX({ Id = components[key .. "Frame"].Id, Fraction = scaleFactor, Duration = 0 })
		SetScaleY({ Id = components[key .. "Frame"].Id, Fraction = scaleFactor, Duration = 0 })
	end

	return button
end)

modutil.mod.Path.Wrap("DestroyBoonLootButtons", function(base, screen, lootData)
	base(screen, lootData)
	local components = screen.Components
	local toDestroy = {}
	for index = 3, 6 do
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

modutil.mod.Path.Wrap("HandleUpgradeChoiceSelection", function(base, screen, button, args)
	screen.UpgradeButtons = game.CollapseTable(screen.UpgradeButtons)
	base(screen, button, args)
end)
