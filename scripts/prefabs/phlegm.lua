local assets =
{
    Asset("ANIM", "anim/phlegm.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("phlegm")
    inst.AnimState:SetBuild("phlegm")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
    inst.components.edible.sanityvalue = -TUNING.SANITY_MED
    inst.components.edible.foodtype = FOODTYPE.GENERIC

    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("phlegm", fn, assets)