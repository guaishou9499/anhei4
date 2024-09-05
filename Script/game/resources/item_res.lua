-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   admin
-- @email:    88888@qq.com
-- @date:     2022-06-30
-- @module:   item_res
-- @describe: 物品资源
-- @version:  v1.0
--
local pairs = pairs
local string = string
-------------------------------------------------------------------------------------
-- 物品资源
---@class item_res
local item_res = {
    MONEY = {
        ['金币'] = true,
    },
    MATERIALS = {
        ['绞首藤'] = true,
        ['天使之息'] = true,
        ['恶魔玫瑰'] = true,
        ['嚎叫苔藓'] = true,
        ['苦莓'] = true,
        ['雷达曼草'] = true,
        ['枯影草'] = true,
        ['丧命草'] = true,
        ['铁块'] = true,
        ['银矿石'] = true,
        ['散光棱柱'] = true,
        ['生皮'] = true,
        ['精良皮革'] = true,
        ['恶魔之心'] = true,
        ['苍白之舌'] = true,
        ['墓地尘'] = true,
        ['野兽碎片'] = true,
        ['遗忘之魂'] = true,
        ['萦雾水晶'] = true,
        ['卷曲结界'] = true,
        ['玄奥符印'] = true,
        ['符印粉末'] = true,
        ['凶星碎片'] = true,
    },
    TREASURE_CHESTS = {
        ['遇害的骑士'] = true,
        ['箱子'] = true,
    },
    OTHER_ITEM = {
        ['RE'] = true,
    },


}

local this = item_res
-------------------------------------------------------------------------------------
-- 是否材料
function item_res.is_cailiao_item(c_name)
    local ret_b = false
    if item_res.MATERIALS[c_name] then
        ret_b = true
    end
    return ret_b
end

-- 是否金币
function item_res.is_money_item(c_name)
    local ret_b = false
    if item_res.MONEY[c_name] then
        ret_b = true
    end
    return ret_b
end

-- 判断是否为装备
function item_res.is_equip_item(c_name)
    local ret_b = true
    if item_res.MATERIALS[c_name] then
        ret_b = false
    end
    if item_res.OTHER_ITEM[c_name] then
        ret_b = false
    end
    if item_res.MONEY[c_name] then
        ret_b = false
    end
    if string.find(c_name, '宝石') or string.find(c_name, '钻石') then
        ret_b = false
    end
    if string.find(c_name, '药剂') or string.find(c_name, '地下城') then
        ret_b = false
    end
    return ret_b
end

-- 判断是否为箱子
function item_res.is_open_item(c_name)
    local ret_b = false
    if item_res.TREASURE_CHESTS[c_name] then
        ret_b = true
    end
    return ret_b
end


-------------------------------------------------------------------------------------
-- 返回对象
return item_res

-------------------------------------------------------------------------------------