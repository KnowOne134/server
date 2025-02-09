-----------------------------------
-- Area: Port Windurst
--  NPC: Pichichi
-----------------------------------
require("scripts/globals/quests")
require("scripts/settings/main")
-----------------------------------
local entity = {}

entity.onTrade = function(player, npc, trade)
end

entity.onTrigger = function(player, npc)

    local TruthJusticeOnionWay = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.TRUTH_JUSTICE_AND_THE_ONION_WAY)
    local KnowOnesOnions       = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.KNOW_ONE_S_ONIONS)
    local InspectorsGadget     = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.INSPECTOR_S_GADGET)
    local OnionRings           = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.ONION_RINGS)
    local CryingOverOnions     = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.CRYING_OVER_ONIONS)
    local ThePromise           = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.THE_PROMISE)

    if ThePromise == QUEST_COMPLETED then
        if math.random(0, 1) == 1 then
            player:startEvent(530)
        else
            player:startEvent(536)
        end
    elseif CryingOverOnions == QUEST_COMPLETED then
        player:startEvent(511)
    elseif CryingOverOnions == QUEST_ACCEPTED then
        player:startEvent(503)
    elseif OnionRings == QUEST_COMPLETED then
        player:startEvent(445)
    elseif OnionRings == QUEST_ACCEPTED then
        player:startEvent(438)
    elseif InspectorsGadget == QUEST_COMPLETED then
        player:startEvent(423)
    elseif InspectorsGadget == QUEST_ACCEPTED then
        player:startEvent(415)
    elseif KnowOnesOnions == QUEST_COMPLETED then
        player:startEvent(411)
    elseif KnowOnesOnions == QUEST_ACCEPTED then
        if player:getCharVar("KnowOnesOnions") == 2 then
            player:startEvent(410)
        else
            player:startEvent(395)
        end
    elseif TruthJusticeOnionWay == QUEST_COMPLETED then
        player:startEvent(385)
    elseif TruthJusticeOnionWay == QUEST_ACCEPTED then
        player:startEvent(374)
    else
        player:startEvent(364)
    end

end

entity.onEventUpdate = function(player, csid, option)
end

entity.onEventFinish = function(player, csid, option)
end

return entity
