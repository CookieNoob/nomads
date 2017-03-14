do


local oldDefaultProjectileWeapon = DefaultProjectileWeapon

DefaultProjectileWeapon = Class(oldDefaultProjectileWeapon) {		

-- Another way to disable a weapon below, use SuspendWeaponFire(). This is less invasive and doesn't disable the aiming manip, etc.
-- Had to change the RackSalvoFireReadyState for this though

    SuspendWeaponFire = function(self, bool)
        self.WeaponSuspended = (bool == true)
    end,

    OnCreate = function(self)
        oldDefaultProjectileWeapon.OnCreate(self)
        self.WeaponSuspended = false
    end,

    RackSalvoFireReadyState = State (oldDefaultProjectileWeapon.RackSalvoFireReadyState) {
        Main = function(self)
            local bp = self:GetBlueprint()
            if (bp.CountedProjectile == true and bp.WeaponUnpacks == true) then
                self.unit:SetBusy(true)
            else
                self.unit:SetBusy(false)
            end
            self.WeaponCanFire = true
            if self.EconDrain then
                self.WeaponCanFire = false
                WaitFor(self.EconDrain)
                RemoveEconomyEvent(self.unit, self.EconDrain)
                self.EconDrain = nil
                self.WeaponCanFire = true
            end
            if self.WeaponSuspended then  -- allowing weapons to be suspended
                self.WeaponCanFire = false
                while self.WeaponSuspended do
                    WaitTicks(1)
                end
                self.WeaponCanFire = true
            end
            if bp.CountedProjectile == true  or bp.AnimationReload then
                ChangeState(self, self.RackSalvoFiringState)
            end
        end,

        OnFire = function(self)
            oldDefaultProjectileWeapon.RackSalvoFireReadyState.OnFire(self)
        end,
    },


    OnWeaponFired = function(self)
        self:SwitchAimController()
        oldDefaultProjectileWeapon.OnWeaponFired(self)
    end,

    -- when changing the ROF the recoil return speed has to be adjusted accordingly. Added override via boolean argument
    ChangeRateOfFire = function(self, newROF, dontRecalcRecoilReturnSpeed)
        oldDefaultProjectileWeapon.ChangeRateOfFire(self, newROF)
        if dontRecalcRecoilReturnSpeed ~= false then
            local bp = self:GetBlueprint()
            local dist = bp.RackRecoilDistance
            local rof = self:GetRateOfFire()
            if dist > 0 and newROF > 0 then
                self.RackRecoilReturnSpeed = bp.RackRecoilReturnSpeed or math.abs( dist / (( 1 / rof ) - (bp.MuzzleChargeDelay or 0))) * 1.25
            else
                self.RackRecoilReturnSpeed = -1
            end
        end
    end,

    CapIsBeingUsed = function(self)  -- this is here to make sure this function can always available, regardless rest of scripting is available
        return false
    end,

    GetDamageTable = function(self)
        local table = oldDefaultProjectileWeapon.GetDamageTable(self)
        table.DamageToShields = self:GetBlueprint().DamageToShields or 0
        table.InitialDamageAmount = self:GetBlueprint().InitialDamage or 0
        return table
    end,

    CreateProjectileForWeapon = function(self, bone)
        -- when a nuke is launched the function NukeCreatedAtUnit is called. This happens in the RackSalvoFiringState. For tactical missile
        -- launchers this doesn't happen but it is necessary to properly handle ammo count on the UI. This function is called just before
        -- NukeCreatedAtUnit is called for nukes. In other words, it is the ideal place to inject a new function for the tactical missiles
        -- without having to do something destructure for that state code (which I really dont want to touch).

        local proj = oldDefaultProjectileWeapon.CreateProjectileForWeapon(self, bone)

        -- calling TacMissileCreatedAtUnit() when launching a tactical missile counted projectile
        local bp = self:GetBlueprint()
        if bp.CountedProjectile == true then
            if not bp.NukeWeapon then
                self.unit:TacMissileCreatedAtUnit()
            end
        end

        return proj
    end,
}


local oldDefaultBeamWeapon = DefaultBeamWeapon

DefaultBeamWeapon = Class(oldDefaultBeamWeapon) {

    PlayFxBeamEnd = function(self, beam)
        oldDefaultBeamWeapon.PlayFxBeamEnd(self, beam)
        self:SwitchAimController()
    end,

    GetNextRackSalvoNumber = function(self)
        local next = (self.CurrentRackSalvoNumber or 1) + 1 -- works differently from the parent class, here + 1 is correct
        local bp = self:GetBlueprint()
        if next > table.getn(bp.RackBones) then
            next = 1
        end
        return next
    end,
}


end