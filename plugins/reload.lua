---@meta _
---@diagnostic disable: lowercase-global

local is_god_boon = {
	ZeusUpgrade = true,
	HeraUpgrade = true,
	PoseidonUpgrade = true,
	ApolloUpgrade = true,
	DemeterUpgrade = true,
	HestiaUpgrade = true,
	AphroditeUpgrade = true,
	HephaestusUpgrade = true,
	HermesUpgrade = true,
	ArtemisUpgrade = true,
	AresUpgrade = true,
}

function isBoonSubjectExcluded(subjectName)
	if subjectName == nil or subjectName:sub(1,3) == "NPC" then return true end
	if is_god_boon[subjectName] then
		return not config.GodUpgrade_enabled
	else
		return not config[subjectName .. "_enabled"]
	end
end

function resizeBoonScreenData(screen, scaleFactor)
	screen.ButtonSpacingY = rom.game.ScreenData.UpgradeChoice.ButtonSpacingY * scaleFactor
	screen.StatLineLeft.LineSpacingBottom = rom.game.ScreenData.UpgradeChoice.StatLineLeft.LineSpacingBottom * scaleFactor
	screen.StatLineRight.LineSpacingBottom = rom.game.ScreenData.UpgradeChoice.StatLineLeft.LineSpacingBottom * scaleFactor
	screen.RarityText.OffsetY = rom.game.ScreenData.UpgradeChoice.RarityText.OffsetY * scaleFactor
	screen.RarityText.FontSize = rom.game.ScreenData.UpgradeChoice.RarityText.FontSize * scaleFactor ^ (1/3)
	screen.TitleText.OffsetY = rom.game.ScreenData.UpgradeChoice.TitleText.OffsetY * scaleFactor
	screen.TitleText.FontSize = rom.game.ScreenData.UpgradeChoice.TitleText.FontSize * scaleFactor ^ (1/3)
	screen.DescriptionText.OffsetY = rom.game.ScreenData.UpgradeChoice.DescriptionText.OffsetY * scaleFactor * scaleFactor
	screen.DescriptionText.FontSize = 20 * scaleFactor ^ (1/3)
	screen.IconOffsetY = rom.game.ScreenData.UpgradeChoice.IconOffsetY * scaleFactor
	screen.ExchangeIconOffsetY = rom.game.ScreenData.UpgradeChoice.ExchangeIconOffsetY * scaleFactor
	screen.ExchangeIconOffsetX = rom.game.ScreenData.UpgradeChoice.ExchangeIconOffsetX + 5 * (config.choices - 3)
	screen.ExchangeSymbol.OffsetX = rom.game.ScreenData.UpgradeChoice.ExchangeSymbol.OffsetX + 5 * (config.choices - 3)
	screen.BonusIconOffsetY = rom.game.ScreenData.UpgradeChoice.BonusIconOffsetY * scaleFactor
	screen.QuestIconOffsetY = rom.game.ScreenData.UpgradeChoice.QuestIconOffsetY * scaleFactor
	screen.PoseidonDuoIconOffsetY = rom.game.ScreenData.UpgradeChoice.PoseidonDuoIconOffsetY * scaleFactor
	screen.ElementIcon.YShift = rom.game.ScreenData.UpgradeChoice.ElementIcon.YShift * scaleFactor
	screen.ExchangeSymbol.OffsetY = rom.game.ScreenData.UpgradeChoice.ExchangeSymbol.OffsetY * scaleFactor
end

function resizeBoonScreenComponents(screen, itemIndex, scaleFactor)
	local components = screen.Components
	local key = "PurchaseButton"..itemIndex
	SetScaleY({ Id = components[key].Id, Fraction = scaleFactor, Duration = 0 })
	components[key].ScaleFactor = scaleFactor
	SetScaleY({ Id = components[key.."Highlight"].Id, Fraction = scaleFactor, Duration = 0 })
	SetScaleX({ Id = components[key.."Icon"].Id, Fraction = scaleFactor, Duration = 0 })
	SetScaleY({ Id = components[key.."Icon"].Id, Fraction = scaleFactor, Duration = 0 })
	if config.choices ~= 3 then
		Move({ Id = components[key.."Icon"].Id, Angle = 360, Distance = 5 * (config.choices - 3) })
	end
	SetScaleX({ Id = components[key.."Frame"].Id, Fraction = scaleFactor, Duration = 0 })
	SetScaleY({ Id = components[key.."Frame"].Id, Fraction = scaleFactor, Duration = 0 })
	if config.choices ~= 3 then
		Move({ Id = components[key.."Frame"].Id, Angle = 360, Distance = 5 * (config.choices - 3) })
	end
	if components[key.."ElementIcon"] then
		SetScaleX({ Id = components[key.."ElementIcon"].Id, Fraction = scaleFactor, Duration = 0 })
		SetScaleY({ Id = components[key.."ElementIcon"].Id, Fraction = scaleFactor, Duration = 0 })
	end
	if components[key.."ExchangeSymbol"] and components[key.."ExchangeIcon"] and components[key.."ExchangeIconFrame"] then
		SetScaleX({ Id = components[key.."ExchangeSymbol"].Id, Fraction = scaleFactor, Duration = 0 })
		SetScaleY({ Id = components[key.."ExchangeSymbol"].Id, Fraction = scaleFactor, Duration = 0 })
		SetScaleX({ Id = components[key.."ExchangeIcon"].Id, Fraction = scaleFactor, Duration = 0 })
		SetScaleY({ Id = components[key.."ExchangeIcon"].Id, Fraction = scaleFactor, Duration = 0 })
		SetScaleX({ Id = components[key.."ExchangeIconFrame"].Id, Fraction = scaleFactor, Duration = 0 })
		SetScaleY({ Id = components[key.."ExchangeIconFrame"].Id, Fraction = scaleFactor, Duration = 0 })
		if config.choices ~= 3 then
			Move({ Id = components[key.."ExchangeSymbol"].Id, Angle = 360, Distance = 5 * (config.choices - 3) })
			Move({ Id = components[key.."ExchangeIcon"].Id, Angle = 360, Distance = 5 * (config.choices - 3) })
			Move({ Id = components[key.."ExchangeIconFrame"].Id, Angle = 360, Distance = 5 * (config.choices - 3) })
		end
	end
	if components[key.."QuestIcon"] then
		SetScaleX({ Id = components[key.."QuestIcon"].Id, Fraction = scaleFactor, Duration = 0 })
		SetScaleY({ Id = components[key.."QuestIcon"].Id, Fraction = scaleFactor, Duration = 0 })
	end
end
