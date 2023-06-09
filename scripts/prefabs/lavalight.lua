local assets =
{
    Asset("ANIM", "anim/fire_large_character.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
    "firefx_light",
}

local heats = { 50, 65, 100 }

local function GetHeatFn(inst)
    return heats[inst.components.firefx.level] or 40
end

local firelevels =
{
    {anim="loop_small", pre="pre_small", pst="post_small", sound="dontstarve/common/campfire", radius=2, intensity=.6, falloff=.7, colour = {197/255,197/255,170/255}, soundintensity=1},
    {anim="loop_med", pre="pre_med", pst="post_med",  sound="dontstarve/common/treefire", radius=3, intensity=.75, falloff=.5, colour = {255/255,255/255,192/255}, soundintensity=1},
    {anim="loop_large", pre="pre_large", pst="post_large",  sound="dontstarve/common/forestfire", radius=4, intensity=.8, falloff=.33, colour = {197/255,197/255,170/255}, soundintensity=1},
}

local function Extinguish(inst)
    inst.components.firefx:Extinguish()
    --remove once the pst animation has finished
    inst:ListenForEvent("animover", inst.Remove)
    --backup removal task in case we are asleep and animation isn't updating
    inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), inst.Remove)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("fire_large_character")
    inst.AnimState:SetBuild("fire_large_character")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)
    --inst.AnimState:SetFinalOffset(3)
    --inst.AnimState:PlayAnimation("collapse_small")

    --inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    --HASHEATER (from heater component) added to pristine state for optimization
    inst:AddTag("HASHEATER")

    inst.Transform:SetScale(1.0, 4, 1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("firefx")
    inst.components.firefx.levels = firelevels
    inst.components.firefx:SetLevel(3)
    inst.components.firefx:SetPercentInLevel(1)
    inst:DoTaskInTime(3, Extinguish)

    inst:AddComponent("heater")
    inst.components.heater.heatfn = GetHeatFn

    return inst
end

return Prefab("lavalight", fn, assets, prefabs)
