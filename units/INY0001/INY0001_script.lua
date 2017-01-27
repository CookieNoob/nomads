-- Nomads regular intel probe deployed

local SupportingArtilleryAbility = import('/lua/nomadsutils.lua').SupportingArtilleryAbility
local NStructureUnit = import('/lua/nomadsunits.lua').NStructureUnit

NStructureUnit = SupportingArtilleryAbility( NStructureUnit )

INY0001 = Class(NStructureUnit) {

OnCreate = function(self)
--LOG('create')
NStructureUnit.OnCreate(self)
end,

    OnStopBeingBuilt = function(self, builder, layer)
        NStructureUnit.OnStopBeingBuilt(self, builder, layer)
        self:EnableArtillerySupport(true)
--        self:ForkThread( self.PointAntennaStraightUp )
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        if self.BuoyParent and not self.BuoyParent:BeenDestroyed() then
            self.BuoyParent:Kill()
        end
        NStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    SetParentBuoy = function(self, buoy)
        self.BuoyParent = buoy
    end,

    PointAntennaStraightUp = function(self)
        --LOG('INY0001: PointAntennaStraightUp')

        WaitSeconds(0.2)

        local orientation = self:GetOrientation()
        --LOG('orientation = '..repr(orientation))

-- TODO: make antenna go striaght up

-- bit 1 = op zn kop
-- bit 2 = achterstevoren
-- bit 3 = op zn kop
-- bit 4 = weet niet

        self:SetOrientation( {0,0,0,0}, true)
for t=1, 10 do
    WaitTicks(5)
        self:SetOrientation( { t * 0.1 ,0,0,0}, true)
end

    end,
}

TypeClass = INY0001

