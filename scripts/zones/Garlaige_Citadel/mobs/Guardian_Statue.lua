-----------------------------------
-- Area: Garlaige Citadel
--  Mob: Guardian Statue
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.IDLE_DESPAWN, 180)
    mob:setMobMod(xi.mobMod.GIL_MAX, -1)
    mob:addImmunity(xi.immunity.SLOW)
    mob:addImmunity(xi.immunity.SLEEP)
    mob:addImmunity(xi.immunity.BLIND)
    mob:addImmunity(xi.immunity.PARALYZE)
end

entity.onMobSpawn = function(mob)
    mob:addListener("COMBAT_TICK", "STATUE_CTICK", function(mob)
        if mob:getHPP() <= 30 and mob:getLocalVar("Berserk") == 0 then
            mob:useMobAbility(537)
            mob:setLocalVar("Berserk",1)
        end
    end)
end

entity.onMobDeath = function(mob, player, optParams)
end

return entity
