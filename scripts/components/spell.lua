local Spell = Class(function(self,inst)
    self.inst = inst
    self.active = false
    self.spellname = "spell"

    self.onstartfn = nil
    self.onfinishfn = nil
    self.ontargetfn = nil
    self.fn = nil
    self.resumefn = nil

    self.target = nil
    self.duration = 3
    self.lifetime = 0 --How long the spell has been alive.
    self.period = nil --How often the spell ticks. Leave nil if you wish every frame.
    self.timer = nil
    self.removeonfinish = false

    --Define variables you wish to use within the spell here (fx, dmg, sound etc) using the SetVariables function.
    self.variables = {}
    --These variables are NOT saved between save and load.
end)

function Spell:OnStart()
    self.active = true
    if self.onstartfn ~= nil then
        self.onstartfn(self.inst)
    end
end

function Spell:OnFinish()
    if self.onfinishfn ~= nil then
        self.onfinishfn(self.inst)
    end

    self.inst:StopUpdatingComponent(self)

    if self.removeonfinish then
        self.inst:Remove()
    end
end

function Spell:OnUpdate(dt)
    self.lifetime = self.lifetime + dt

    if self.timer ~= nil then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self.timer = nil
        end
    end

    if self.timer == nil then
        if self.fn ~= nil then
            self.fn(self.inst, self.target)
        end

        if self.period ~= nil then
            self.timer = self.period
        end
    end

    if self.lifetime >= self.duration then
        --Spell is over
        self:OnFinish()
    end
end

function Spell:OnTarget()
    if self.ontargetfn ~= nil then
        self.ontargetfn(self.inst, self.target)
    end
end

function Spell:OnSave()
    local data = {}

    data.lifetime = self.lifetime
    data.timer = self.timer
    data.active = self.active

    if self.target ~= nil and not self.target:HasTag("player") then
        data.target = self.target.GUID
        return data, { self.target.GUID }
    end

    return data
end

function Spell:OnLoad(data)
    if data ~= nil then
        self.lifetime = data.lifetime
        self.timer = data.timer
        self.active = data.active
    end
end

function Spell:LoadPostPass(newents, data)
    if data.target ~= nil then
        local target = newents[data.target]
        if target ~= nil then
            self:SetTarget(target.entity)
            if not self.inst:IsValid() then
                return
            end
        end
    end

    if self.active then
        self:ResumeSpell()
    end
end

function Spell:StartSpell()
    if self.target == nil then
        return
    end
    self.inst:StartUpdatingComponent(self)
    self:OnStart()
end

function Spell:ResumeSpell()
    if self.resumefn ~= nil then
        local timeleft = self.duration - self.lifetime
        self.resumefn(self.inst, timeleft)
        self.inst:StartUpdatingComponent(self)
    end
end

function Spell:SetVariables(variables)
    if type(variables) ~= "table" then
        print("Spell:SetVariables: Variables must be a table.")
        return
    end

    self.variables = variables
end

function Spell:SetTarget(target)
    if not target:HasTag(self.spellname) then
        self.target = target
        self:OnTarget()
    end
end

return Spell
