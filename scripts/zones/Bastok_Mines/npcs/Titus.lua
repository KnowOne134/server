-----------------------------------
-- Area: Bastok Mines
--  NPC: Titus
-- Alchemy Synthesis Image Support
-----------------------------------
require("scripts/globals/status")
require("scripts/globals/crafting")
local ID = require("scripts/zones/Bastok_Mines/IDs")
-----------------------------------
local entity = {}

entity.onTrade = function(player, npc, trade)
end

entity.onTrigger = function(player, npc)
    local guildMember = xi.crafting.isGuildMember(player, 1)
    local SkillCap = xi.crafting.getCraftSkillCap(player, xi.skill.ALCHEMY)
    local SkillLevel = player:getSkillLevel(xi.skill.ALCHEMY)

    if (guildMember == 1) then
        if (player:hasStatusEffect(xi.effect.ALCHEMY_IMAGERY) == false) then
            player:startEvent(123, SkillCap, SkillLevel, 1, 137, player:getGil(), 0, 0, 0)
        else
            player:startEvent(123, SkillCap, SkillLevel, 1, 137, player:getGil(), 6758, 0, 0)
        end
    else
        player:startEvent(123)
    end
end

entity.onEventUpdate = function(player, csid, option)
end

entity.onEventFinish = function(player, csid, option)
    if (csid == 123 and option == 1) then
        player:messageSpecial(ID.text.ALCHEMY_SUPPORT, 0, 7, 1)
        player:addStatusEffect(xi.effect.ALCHEMY_IMAGERY, 1, 0, 120)
    end
end

return entity
