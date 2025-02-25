-----------------------------------
-- Peace for the Spirit
-----------------------------------
-- Log ID: 0, Quest ID: 86
-----------------------------------
-- Curilla      : !pos 27 0 0 233
-- Sharzalion   : !pos 95 0 111 230
-- Dry Fountain : !pos -17 -16 67 204
-- Daggao       : !pos 89 0 119 230
-- Oaken Box    : !pos -164 0.1 225 200
-----------------------------------
local feiyinID   = zones[xi.zone.FEIYIN]
local garlaigeID = zones[xi.zone.GARLAIGE_CITADEL]

local quest = Quest:new(xi.questLog.SANDORIA, xi.quest.id.sandoria.PEACE_FOR_THE_SPIRIT)

quest.reward =
{
    item  = xi.item.WARLOCKS_CHAPEAU,
    fame  = 60,
    title = xi.title.PARAGON_OF_RED_MAGE_EXCELLENCE,
}

quest.sections =
{
    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_AVAILABLE and
                player:hasCompletedQuest(xi.questLog.SANDORIA, xi.quest.id.sandoria.ENVELOPED_IN_DARKNESS) and
                player:getMainLvl() >= xi.settings.main.AF3_QUEST_LEVEL and
                player:getMainJob() == xi.job.RDM
        end,

        [xi.zone.CHATEAU_DORAGUILLE] =
        {
            ['Curilla'] = quest:event(109):replaceDefault(),

            onEventFinish =
            {
                [109] = function(player, csid, option, npc)
                    if option == 1 then
                        quest:begin(player)
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_ACCEPTED and
                vars.Prog == 0
        end,

        [xi.zone.CHATEAU_DORAGUILLE] =
        {
            ['Curilla'] = quest:event(108),
        },

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Sharzalion']  = quest:progressEvent(64),
            ['Valderotaux'] = quest:event(53),

            onEventFinish =
            {
                [64] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_ACCEPTED and
                vars.Prog == 1
        end,

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Sharzalion']  = quest:event(65),
            ['Valderotaux'] = quest:event(55),
        },

        [xi.zone.CHATEAU_DORAGUILLE] =
        {
            ['Curilla'] = quest:event(108),
        },

        [xi.zone.FEIYIN] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    if not player:hasItem(xi.items.ANTIQUE_COIN) then
                        SpawnMob(feiyinID.mob.MISER_MURPHY)
                    end
                end,
            },

            ['Dry_Fountain'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, xi.item.ANTIQUE_COIN) then
                        return quest:progressEvent(17)
                    end
                end,

                onTrigger = function(player, npc)
                    return quest:messageSpecial(feiyinID.text.DRIED_UP_FOUNTAIN + 1, xi.item.ANTIQUE_COIN)
                end,
            },

            onEventFinish =
            {
                [17] = function(player, csid, option, npc)
                    player:confirmTrade()
                    quest:setVar(player, 'Prog', 2)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_ACCEPTED and
                vars.Prog == 2
        end,

        [xi.zone.CHATEAU_DORAGUILLE] =
        {
            ['Curilla'] = quest:event(113),
        },

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Sharzalion']  = quest:event(66),
            ['Daggao']      = quest:event(72),
            ['Valderotaux'] = quest:event(57),
        },

        [xi.zone.GARLAIGE_CITADEL] =
        {
            ['Oaken_Box'] =
            {
                onTrigger = function(player, npc)
                    if npcUtil.popFromQM(player, npc, garlaigeID.mob.GUARDIAN_STATUE, { hide = 0 }) then
                        return quest:messageSpecial(garlaigeID.text.SENSE_OF_FOREBODING)
                    end
                end,
            },

            ['Guardian_Statue'] =
            {
                onMobDeath = function(mob, player, optParams)
                    quest:setVar(player, 'Prog', 3)
                    quest:setLocalVar(player, 'Option', 1)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_ACCEPTED and
                vars.Prog == 3
        end,

        [xi.zone.CHATEAU_DORAGUILLE] =
        {
            ['Curilla'] = quest:event(51),
        },

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Sharzalion']  = quest:event(66),
            ['Daggao']      = quest:event(72),
            ['Valderotaux'] = quest:event(57),
        },

        [xi.zone.GARLAIGE_CITADEL] =
        {
            ['Oaken_Box'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHasExactly(trade, xi.item.NAIL_PULLER) then
                        return quest:progressEvent(14)
                    end
                end,

                onTrigger = function(player, npc)
                    if
                        player:hasItem(xi.item.NAIL_PULLER) and
                        quest:getLocalVar(player, 'Option') == 1
                    then
                        return quest:messageSpecial(garlaigeID.text.NAIL_PULLER, xi.items.NAIL_PULLER)
                    elseif npcUtil.popFromQM(player, npc, garlaigeID.mob.GUARDIAN_STATUE, { hide = 0 }) then
                        return quest:messageSpecial(garlaigeID.text.SENSE_OF_FOREBODING)
                    end
                end,
            },

            onEventFinish =
            {
                [14] = function(player, csid, option, npc)
                    player:confirmTrade()
                    quest:setVar(player, 'Prog', 4)
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_ACCEPTED and
                vars.Prog == 4
        end,

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Sharzalion']  = quest:event(66),
            ['Valderotaux'] = quest:event(59),
            ['Daggao']      = quest:event(73),
        },

        [xi.zone.NORTHERN_SAN_DORIA] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    return 49
                end,
            },

            onEventFinish =
            {
                [49] = function(player, csid, option, npc)
                    if quest:complete(player) then
                        quest:setVar(player, 'Option', 1)
                    end
                end,
            },
        },
    },
    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_COMPLETED
        end,

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Sharzalion']  = quest:event(67):replaceDefault(),
            ['Valderotaux'] = quest:event(56):replaceDefault(),
            ['Daggao']      = quest:event(73):replaceDefault(),
        },

        [xi.zone.CHATEAU_DORAGUILLE] =
        {
            ['Curilla'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Option') == 1 then
                        return quest:progressEvent(52)
                    end
                end,
            },

            onEventFinish =
            {
                [52] = function(player, csid, option, npc)
                    quest:setVar(player, 'Option', 0)
                end,
            },
        },
    },
}

return quest
