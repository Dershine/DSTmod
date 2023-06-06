local function OnUnwrapped(inst, pos, doer)
    for i, v in ipairs(loottable) do
        local item = SpawnPrefab(v)
        if item ~= nil then
            if item.Physics ~= nil then
                item.Physics:Teleport(pos:Get())
            else
                item.Transform:SetPosition(pos:Get())
            end
            if item.components.inventoryitem ~= nil then
                item.components.inventoryitem:InheritMoisture(moisture, iswet)
                if tossloot then
                    item.components.inventoryitem:OnDropped(true, .5)
                end
            end
        end
    end
    if doer ~= nil and doer.SoundEmitter ~= nil then
        doer.SoundEmitter:PlaySound(inst.skin_wrap_sound or "dontstarve/common/together/packaged")
    end
    inst:Remove()
end

local function OnWrapped(inst, gifts)
    if inst ~= nil then
        for i,gift in ipairs(inst.extrareward) do
            table.insert(gifts,SpawnPrefab(gift))
        end
        inst.extrareward = nil
    end
    return gifts
end

local function createbundle()
    local assets =
    {
        Asset("ANIM", "anim/bonus_bag.zip"),
    }

    local prefabs =
    {
        "bonus_pouch",
    }

    local function createPouch()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("bonus_bag")
        inst.AnimState:SetBuild("bonus_bag")
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("bundle")
        inst:AddTag("unwrappable")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem:SetSinks(true)

        inst.AddComponent("unwrappable")

        return inst
    end
    local inst = createPouch()
    local final = {}
    local pouch = SpawnPrefab("bonus_pouch")
    local prize_items = {}
    for i = 1, 20 do
        table.insert(prize_items, SpawnPrefab("log"))
    end
    pouch.components.unwrappable:WrapItems(prize_items)
    table.insert(final,pouch)
    final = OnWrapped(inst, final)
    return final
end

local function fn()
    local inst = 
    return inst
end