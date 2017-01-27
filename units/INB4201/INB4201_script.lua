-- SAM

local AddLights = import('/lua/nomadsutils.lua').AddLights
local NStructureUnit = import('/lua/nomadsunits.lua').NStructureUnit
local MissileWeapon1 = import('/lua/nomadsweapons.lua').MissileWeapon1

NStructureUnit = AddLights(NStructureUnit)
INB4201 = Class(NStructureUnit) {
    Weapons = {
        MainGun = Class(MissileWeapon1) {},
    },

    LightBones = { {'blinklight.001',}, },
}

TypeClass = INB4201