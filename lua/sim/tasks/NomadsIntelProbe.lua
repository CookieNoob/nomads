local ScriptTask = import('/lua/sim/ScriptTask.lua').ScriptTask
local TASKSTATUS = import('/lua/sim/ScriptTask.lua').TASKSTATUS
local AIRESULT = import('/lua/sim/ScriptTask.lua').AIRESULT

NomadsIntelProbe = Class(ScriptTask) {

    StartTask = function(self)
        if not self:IfBrainAllowsRun( self.IntelProbe ) then
            self:SetAIResult(AIRESULT.Ignored)
        end
    end,

    IntelProbe = function(self)
        local brain = self:GetAIBrain()
        local projBp =    brain:GetSpecialAbilityParam( self.CommandData.TaskName, 'ProjectileBP')
                       or self:GetParams()['ProjectileBP']
                       or '/projectiles/NIntelProbe1/NIntelProbe1_proj.bp'
        local data = {
            Lifetime = brain:GetSpecialAbilityParam( self.CommandData.TaskName, 'Lifetime') or self:GetParams()['Lifetime'] or 60,
            Radius = brain:GetSpecialAbilityParam( self.CommandData.TaskName, 'Radius') or self:GetParams()['Radius'] or 25,
            ArtillerySupportRadius = brain:GetSpecialAbilityParam( self.CommandData.TaskName, 'ArtillerySupportRadius') or self:GetParams()['ArtillerySupportRadius'] or 0,
            Omni = brain:GetSpecialAbilityParam( self.CommandData.TaskName, 'Omni') or self:GetParams()['Omni'] or false,
            Radar = brain:GetSpecialAbilityParam( self.CommandData.TaskName, 'Radar') or self:GetParams()['Radar'] or false,
            Sonar = brain:GetSpecialAbilityParam( self.CommandData.TaskName, 'Sonar') or self:GetParams()['Sonar'] or false,
            Vision = brain:GetSpecialAbilityParam( self.CommandData.TaskName, 'Vision') or self:GetParams()['Vision'] or false,
            WaterVision = brain:GetSpecialAbilityParam( self.CommandData.TaskName, 'WaterVision') or self:GetParams()['WaterVision'] or false,
        }

        local location = self:GetLocations()[1]
        local unit = self:GetUnit()

        if unit then
            self.IntelProbeProjectile = unit:LaunchProbe(location, projBp, data)
            if self.IntelProbeProjectile then
                self:SetAIResult(AIRESULT.Unknown)
            else
                self:SetAIResult(AIRESULT.Fail)
            end
        else
            self:SetAIResult(AIRESULT.Fail)
        end
    end,
	  
    TaskTick = function(self)
        if self.IntelProbeProjectile and not self.IntelProbeProjectile:BeenDestroyed() then
            return TASKSTATUS.Wait
        else
            self:SetAIResult(AIRESULT.Success)
            return TASKSTATUS.Done
        end
    end,
}
