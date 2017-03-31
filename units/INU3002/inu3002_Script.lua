-- T3 tank

local NLandUnit = import('/lua/nomadsunits.lua').NLandUnit
local AnnihilatorCannon1 = import('/lua/nomadsweapons.lua').AnnihilatorCannon1
local RocketWeapon1 = import('/lua/nomadsweapons.lua').RocketWeapon1

INU3002 = Class(NLandUnit) {
    Weapons = {
        MainGun = Class(AnnihilatorCannon1) {},
        Rocket = Class(RocketWeapon1) {},
    },
}

TypeClass = INU3002
