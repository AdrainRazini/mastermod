local InsertService = game:GetService("InsertService")
local assetId = 119435101634997 -- ID de um modelo público da Toolbox

local asset = InsertService:LoadAsset(assetId)
asset.Parent = game.Players.LocalPlayer.Backpack
