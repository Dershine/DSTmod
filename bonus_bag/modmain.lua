PrefabFiles = {
    "month_card_bag"
}

env.RECIPETABS = GLOBAL.RECIPETABS
env.TECH = GLOBAL.TECH

local recipe_name = "month_card_bag"
local ingredients = {Ingredient(CHARACTER_INGREDIENT.SANITY, 10)}
local tech = TECH.NONE
local config = {
    atlas = "images/inventoryimages/miao_packbox_full.xml",
}
AddRecipe2(recipe_name, ingredients, tech, config)

env.STRINGS = GLOBAL.STRINGS
STRINGS.NAMES.MONTH_CARD_BAG = "月卡每日奖励包"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MONTH_CARD_BAG = "聊胜于无"
STRINGS.RECIPE_DESC.BONUS_BAG = "荷叶做的雨伞" -- 制作栏描述