local assets = 
{
    Asset("ANIM","anim/lotus_umbrella.zip"),
    Asset("ANIM","anim/swap_lotus_umbrella.zip"),
    Asset("ATLAS","images/inventoryimages/lotus_umbrella.xml"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_lotus_umbrella", "swap_lotus_umbrella") -- 以下三句都是设置动画表现的，不会对游戏实际内容产生影响，你可以试试去掉的效果
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.DynamicShadow:SetSize(1.7, 1) -- 设置阴影大小，你可以仔细观察装备荷叶伞时，人物脚下的阴影变化
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry") -- 和上面的装备回调类似，可以试试去掉的结果
    owner.AnimState:Show("ARM_normal")
    owner.DynamicShadow:SetSize(1.3, 0.6)
end

local function onperish(inst)
    inst:Remove() -- 当耐久度归零时，荷叶伞自动消失
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("lotus_umbrella")
    inst.AnimState:SetBuild("lotus_umbrella")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("nopunch")
    inst:AddTag("umbrella")
    inst:AddTag("waterproofer")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    --通用组件
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lotus_umbrella.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    --核心组件
    --防雨
    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_HUGE) -- 设置防雨系数
    --遮阳
    inst:AddComponent("insulator")
    inst.components.insulator:SetSummer() -- 设置只能防热
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED) -- 设置防热系数

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED) -- 设置耐久度
    inst.components.perishable:StartPerishing() -- 当物体生成的时候就开始腐烂
    inst.components.perishable:SetOnPerishFn(onperish) -- 设置耐久度归零的回调函数
    inst:AddTag("show_spoilage")

    return inst
end

return Prefab("common/inventory/lotus_umbrella", fn, assets)