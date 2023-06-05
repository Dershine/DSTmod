PrefabFiles = {
    "lotus_umbrella",
}

local recipe_name = "lotus_umbrella"
local ingredients = {Ingredient("cutgrass", 1), Ingredient("twigs", 1)}
local tech = TECH.NONE --所需科技，必须使用常量表TECH的值
local config = {
    atlas = "images/inventoryimages/lotus_umbrella.xml",
}
AddRecipe2(recipe_name, ingredients, tech, config)

env.STRINGS = GLOBAL.STRINGS
STRINGS.NAMES.LOTUS_UMBRELLA = "荷叶伞"
STRINGS.CHARACTERS.GRNERIC.DESCRIBE.LOTUS_UMBRELLA = "这伞能挡雨吗"
STRINGS.RECIPE_DESC.LOTUS_UMBRELLA = "荷叶做的雨伞" -- 制作栏描述