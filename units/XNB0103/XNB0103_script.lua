-- T1 naval factory

local NSeaFactoryUnit = import('/lua/nomadsunits.lua').NSeaFactoryUnit
local AddRapidRepair = import('/lua/nomadsutils.lua').AddRapidRepair

NSeaFactoryUnit = AddRapidRepair(NSeaFactoryUnit)

XNB0103 = Class(NSeaFactoryUnit) {

    Calc = function(self)
        local initial, length = NSeaFactoryUnit.Calc(self)
        return -initial, -length
    end,
}

TypeClass = XNB0103