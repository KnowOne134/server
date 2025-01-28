-----------------------------------
-- Promotion: Lance Corporal
-- Logid: 6     Quest: 92
-- Abquhbah:                 !pos 35.5 -6.6 -58 50
-- Nafiwaa:                  !pos -74 -6 126 50
-- Mythralline Wellspring 1: !pos -92 -15 -339 51
-- Mythralline Wellspring 2: !pos -218 -15 -388 51
-- Mythralline Wellspring 3: !pos 181 -23 268 51
-- Mythralline Wellspring 4: !pos 259 -23 132 51
-- Mythralline Wellspring 5: !pos 181 -15 373 52
-----------------------------------

local quest = Quest:new(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.PROMOTION_LANCE_CORPORAL)

local function getQuestMiniGameBits(player)
    local value = 0
    local keyItems =
    {
        { ki = xi.ki.TEST_TUBE_1, value = 1 },
        { ki = xi.ki.TEST_TUBE_2, value = 2 },
        { ki = xi.ki.TEST_TUBE_3, value = 4 },
        { ki = xi.ki.TEST_TUBE_4, value = 8 },
        { ki = xi.ki.TEST_TUBE_5, value = 16 },
    }

    for _, test_tube in pairs(keyItems) do
        if not player:hasKeyItem(test_tube.ki) then
            value = value + test_tube.value
        end
    end

    return value
    --[[
    the math used to get end results
    tube 1 = 1
    tube 2 = 4
    tube 3 = 16
    tube 4 = 64
    tube 5 = 256
    ]]
end

local function checkForReset(player, option1)
    local tube = utils.splitBits(option1, 2)
    local count = 0
    local result = true

    for i = 1, 5 do
        local vial = tube[i]
        if vial then
            if vial == 0 then
                count = count + 3
            elseif vial == 1 then
                count = count + 2
            elseif vial == 2 then
                count = count + 1
            end
        else
            count = count + 3
        end
    end

    if count > 1 then
        result = false
    end

    return result
end

local function getQuestReward(player)
    local option = quest:getVar(player,'Stage')
    local items = 0
    local amount = 0
    local rewards =
    {
        [1] = { item = xi.items.IMPERIAL_MYTHRIL_PIECE, amount = math.random(3, 4) },
        [2] = { item = xi.items.IMPERIAL_GOLD_PIECE, amount = 1 },
        [3] = { item = xi.items.IMPERIAL_GOLD_PIECE, amount = 2 },
    }

    local Luminium = { 108, 168, 228, 312, 372, 432 }
    local Platinum =
    {
        15, 24, 26, 27, 28, 29, 30, 37, 38, 39, 40, 41, 42, 44, 45, 48, 49, 50, 51, 52, 53, 54, 56, 57, 71, 72, 75, 76, 77,
        78, 86, 87, 88, 89, 90, 91, 92, 93, 97, 98, 99, 100, 101, 102, 104, 105, 112, 113, 114, 116, 117, 135, 136, 137,
        138, 139, 140, 141, 146, 147, 148, 149, 150, 152, 153, 156, 160, 161, 162, 164, 165, 176, 177, 195, 196, 197, 198,
        200, 201, 204, 208, 209, 210, 212, 213, 216, 224, 225, 269, 270, 277, 279, 280, 281, 282, 284, 285, 291, 292, 293,
        294, 296, 297, 300, 304, 308, 309, 329, 330, 331, 332, 333, 337, 339, 340, 341, 342, 344, 345, 348, 352, 353, 354,
        356, 357, 360, 356, 360, 368, 369, 384, 389, 390, 392, 393, 396, 400, 401, 402, 404, 405, 408, 416, 417, 420, 449,
        450, 452, 453, 464, 465, 468, 480, 522, 523, 524, 525, 533, 534, 536, 537, 540, 544, 546, 548, 549, 552, 560, 564,
        581, 582, 584, 585, 588, 593, 594, 596, 597, 600, 608, 609, 612, 624, 641, 642, 644, 645, 648, 656, 657, 660, 672,
        704, 705, 708, 720, 776, 777, 780, 785, 786, 788, 789, 792, 800, 804, 816, 836, 837, 838, 840, 848, 849, 852, 864,
        896, 897, 900, 912, 960
    }

    if utils.tableContains(Luminium, option) then
        items = rewards[3].item
        amount = rewards[3].amount
    elseif utils.tableContains(Platinum, option) then
        choice = math.random(1, 2)
        items = rewards[choice].item
        amount = rewards[choice].amount
    end

    return items, amount
end

quest.reward =
{
    keyItem = xi.ki.LC_WILDCAT_BADGE,
    title = xi.title.LANCE_CORPORAL,
}

quest.sections =
{
    {
        -- Start Quest: Trigger Abquhbah
        check = function(player, status, vars)
            return status == xi.quest.status.AVAILABLE and player:getVar("AssaultPromotion") >= 25
            and player:getQuestStatus(xi.quest.log_id.AHT_URHGAN, xi.quest.id.ahtUrhgan.PROMOTION_SUPERIOR_PRIVATE) == xi.quest.status.COMPLETED
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Abquhbah'] = quest:progressEvent(5030, { text_table = 0 }),

            onEventFinish =
            {
                [5030] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },
    {
        -- Quest started 1st Stage: Trigger Nafiwaa and recieve 5 KI empty test tubes
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 0
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Abquhbah'] = quest:event(5032):importantOnce(),

            ['Nafiwaa'] = quest:progressEvent(5035, { text_table = 0 }),

            onEventFinish =
            {
                [5035] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                    npcUtil.giveKeyItem(player, { xi.ki.EMPTY_TEST_TUBE_1, xi.ki.EMPTY_TEST_TUBE_2,
                        xi.ki.EMPTY_TEST_TUBE_3, xi.ki.EMPTY_TEST_TUBE_4, xi.ki.EMPTY_TEST_TUBE_5 })
                end,
            },
        },
    },
    {
        -- Quest 2nd Stage: Goto Mythralline Wellsprings and change Empty tests tubes to filled KI's
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 1 and vars.Option < 31
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Abquhbah'] = quest:event(5033):importantOnce(),

            ['Nafiwaa'] =
            {
                onTrigger = function(player, npc)
                    local testTubes = quest:getVar(player, 'Option')

                    if testTubes == 0 then
                        return quest:event(5036)
                    else
                        return quest:event(5037, {[1] = utils.countSetBits(testTubes)})
                    end
                end,
            },
        },
        [xi.zone.WAJAOM_WOODLANDS] =
        {
            ['Mythralline_Wellspring_1'] =
            {
                onTrigger = function(player, npc)
                    if player:hasKeyItem(xi.ki.EMPTY_TEST_TUBE_1) then
                        return quest:progressEvent(4)
                    else
                        return quest:messageSpecial(zones[player:getZoneID()].text.SPRING_WATER)
                    end
                end,
            },
            ['Mythralline_Wellspring_2'] =
            {
                onTrigger = function(player, npc)
                    if player:hasKeyItem(xi.ki.EMPTY_TEST_TUBE_2) then
                        return quest:progressEvent(5)
                    else
                        return quest:messageSpecial(zones[player:getZoneID()].text.SPRING_WATER)
                    end
                end,
            },
            ['Mythralline_Wellspring_3'] =
            {
                onTrigger = function(player, npc)
                    if player:hasKeyItem(xi.ki.EMPTY_TEST_TUBE_3) then
                        return quest:progressEvent(6)
                    else
                        return quest:messageSpecial(zones[player:getZoneID()].text.SPRING_WATER)
                    end
                end,
            },
            ['Mythralline_Wellspring_4'] =
            {
                onTrigger = function(player, npc)
                    if player:hasKeyItem(xi.ki.EMPTY_TEST_TUBE_4) then
                        return quest:progressEvent(7)
                    else
                        return quest:messageSpecial(zones[player:getZoneID()].text.SPRING_WATER)
                    end
                end,
            },

            onEventFinish =
            {
                [4] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, xi.ki.TEST_TUBE_1)
                    player:delKeyItem(xi.ki.EMPTY_TEST_TUBE_1)
                    quest:setVarBit(player, 'Option', 0)
                end,
                [5] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, xi.ki.TEST_TUBE_2)
                    player:delKeyItem(xi.ki.EMPTY_TEST_TUBE_2)
                    quest:setVarBit(player, 'Option', 1)
                end,
                [6] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, xi.ki.TEST_TUBE_3)
                    player:delKeyItem(xi.ki.EMPTY_TEST_TUBE_3)
                    quest:setVarBit(player, 'Option', 2)
                end,
                [7] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, xi.ki.TEST_TUBE_4)
                    player:delKeyItem(xi.ki.EMPTY_TEST_TUBE_4)
                    quest:setVarBit(player, 'Option', 3)
                end,
            },
        },
        [xi.zone.BHAFLAU_THICKETS] =
        {
            ['Mythralline_Wellspring_5'] =
            {
                onTrigger = function(player, npc)
                    if player:hasKeyItem(xi.ki.EMPTY_TEST_TUBE_5) then
                        return quest:progressEvent(10)
                    else
                        return quest:messageSpecial(zones[player:getZoneID()].text.SPRING_WATER)
                    end
                end,
            },

            onEventFinish =
            {
                [10] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, xi.ki.TEST_TUBE_5)
                    player:delKeyItem(xi.ki.EMPTY_TEST_TUBE_5)
                    quest:setVarBit(player, 'Option', 4)
                end,
            },
        },
    },
    {
        -- Quest 3rd Stage: Trigger Nafiwaa to do mini game
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog == 1 and vars.Option == 31
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Nafiwaa'] =
            {
                onTrigger = function(player, npc)
                    local vialsUsed = quest:getVar(player, 'Stage')
                    local continueProcess = vialsUsed == 0 and 0 or 1
                    return quest:progressEvent(5038, { [2] = vialsUsed, [5] = getQuestMiniGameBits(player), [7] = continueProcess, text_table = 0 })
                end,
            },

            onEventFinish =
            {
                [5038] = function(player, csid, option, npc)
                    local option1, option2 = utils.varSplit(option, 16)
                    if option2 == 0x8000 then -- accept then results
                        quest:setVar(player, 'Stage', option1)
                        quest:setVar(player, 'Prog', vanaDay() + 1)
                        quest:setVar(player, "Option", 0)
                        player:delKeyItem(xi.ki.EMPTY_TEST_TUBE_1)
                        player:delKeyItem(xi.ki.EMPTY_TEST_TUBE_2)
                        player:delKeyItem(xi.ki.EMPTY_TEST_TUBE_3)
                        player:delKeyItem(xi.ki.EMPTY_TEST_TUBE_4)
                        player:delKeyItem(xi.ki.EMPTY_TEST_TUBE_5)
                        player:delKeyItem(xi.ki.TEST_TUBE_1)
                        player:delKeyItem(xi.ki.TEST_TUBE_2)
                        player:delKeyItem(xi.ki.TEST_TUBE_3)
                        player:delKeyItem(xi.ki.TEST_TUBE_4)
                        player:delKeyItem(xi.ki.TEST_TUBE_5)
                    else
                        quest:setVar(player, 'Stage', option1)
                        local tube = utils.splitBits(option1, 2)
                        if tube[1] and tube[1] == 3 and player:hasKeyItem(xi.ki.TEST_TUBE_1) then
                            player:delKeyItem(xi.ki.TEST_TUBE_1)
                            player:addKeyItem(xi.ki.EMPTY_TEST_TUBE_1)
                        end
                        if tube[2] and tube[2] == 3 and player:hasKeyItem(xi.ki.TEST_TUBE_2) then
                            player:delKeyItem(xi.ki.TEST_TUBE_2)
                            player:addKeyItem(xi.ki.EMPTY_TEST_TUBE_2)
                        end
                        if tube[3] and tube[3] == 3 and player:hasKeyItem(xi.ki.TEST_TUBE_3) then
                            player:delKeyItem(xi.ki.TEST_TUBE_3)
                            player:addKeyItem(xi.ki.EMPTY_TEST_TUBE_3)
                        end
                        if tube[4] and tube[4] == 3 and player:hasKeyItem(xi.ki.TEST_TUBE_4) then
                            player:delKeyItem(xi.ki.TEST_TUBE_4)
                            player:addKeyItem(xi.ki.EMPTY_TEST_TUBE_4)
                        end
                        if tube[5] and tube[5] == 3 and player:hasKeyItem(xi.ki.TEST_TUBE_5) then
                            player:delKeyItem(xi.ki.TEST_TUBE_5)
                            player:addKeyItem(xi.ki.EMPTY_TEST_TUBE_5)
                        end

                        if checkForReset(player, option1) then
                            quest:setVar(player, "Option", 0)
                            quest:setVar(player, 'Stage', 0)
                            player:delKeyItem(xi.ki.TEST_TUBE_1)
                            player:delKeyItem(xi.ki.TEST_TUBE_2)
                            player:delKeyItem(xi.ki.TEST_TUBE_3)
                            player:delKeyItem(xi.ki.TEST_TUBE_4)
                            player:delKeyItem(xi.ki.TEST_TUBE_5)
                            if not player:hasKeyItem(xi.ki.EMPTY_TEST_TUBE_1) then
                                player:addKeyItem(xi.ki.EMPTY_TEST_TUBE_1)
                            end
                            if not player:hasKeyItem(xi.ki.EMPTY_TEST_TUBE_2) then
                                player:addKeyItem(xi.ki.EMPTY_TEST_TUBE_2)
                            end
                            if not player:hasKeyItem(xi.ki.EMPTY_TEST_TUBE_3) then
                                player:addKeyItem(xi.ki.EMPTY_TEST_TUBE_3)
                            end
                            if not player:hasKeyItem(xi.ki.EMPTY_TEST_TUBE_4) then
                                player:addKeyItem(xi.ki.EMPTY_TEST_TUBE_4)
                            end
                            if not player:hasKeyItem(xi.ki.EMPTY_TEST_TUBE_5) then
                                player:addKeyItem(xi.ki.EMPTY_TEST_TUBE_5)
                            end
                        end
                    end
                end,
            },
        },
    },
    {
        -- Complete Quest: after game day wait, enter region
        check = function(player, status, vars)
            return status == xi.quest.status.ACCEPTED and vars.Prog > 1 and vars.Stage > 0
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Nafiwaa'] = quest:event(5039),

            ['Abquhbah'] = quest:event(5034):importantOnce(),

            onRegionEnter =
            {
                [3] = function(player, region)
                    if quest:getVar(player, 'Prog') <= vanaDay() then
                        return quest:progressEvent(5031, { text_table = 0 })
                    end
                end,
            },

            onEventFinish =
            {
                [5031] = function(player, csid, option, npc)
                    local item, amount = getQuestReward(player)
                    if item > 0 then
                        if not npcUtil.giveItem(player, {{item, amount}}) then
                            return
                        end
                    end
                    quest:complete(player)
                    quest:messageSpecial(zones[player:getZoneID()].text.LANCE_CORPORAL)
                    player:setVar("AssaultPromotion", 0)
                    player:delKeyItem(xi.ki.SP_WILDCAT_BADGE)
                end,
            },
        },
    },
}

return quest
