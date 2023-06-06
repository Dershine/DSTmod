PrefabFiles = {
    "lotus_umbrella",
}

env.RECIPETABS = GLOBAL.RECIPETABS
env.TECH = GLOBAL.TECH

local recipe_name = "lotus_umbrella"
local ingredients = {Ingredient("cutgrass", 1), Ingredient("twigs", 1)}
local tech = TECH.NONE --所需科技，必须使用常量表TECH的值
local config = {
    atlas = "images/inventoryimages/lotus_umbrella.xml",
}
AddRecipe2(recipe_name, ingredients, tech, config)

env.STRINGS = GLOBAL.STRINGS
STRINGS.NAMES.LOTUS_UMBRELLA = "荷叶伞"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LOTUS_UMBRELLA = "这伞能挡雨吗"
STRINGS.RECIPE_DESC.LOTUS_UMBRELLA = "荷叶做的雨伞" -- 制作栏描述