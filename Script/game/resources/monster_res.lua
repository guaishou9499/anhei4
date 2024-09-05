-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   admin
-- @email:    88888@qq.com
-- @date:     2022-06-30
-- @module:   monster_res
-- @describe: 物品资源
-- @version:  v1.0
--
local pairs = pairs
local string = string
-------------------------------------------------------------------------------------
-- 物品资源
---@class monster_res
local monster_res = {
    MONSTER_NAME = {
        ['腐臭遗骸'] = true,
        ['腐烂尸魔'] = true,
        ['沉沦魔'] = true,
        ['沉沦魔癫狂者'] = true,
        ['沉沦魔监察者'] = true,
        ['屠夫'] = true,
        ['蹒跚的行尸'] = true,

        ['冰族穿刺者'] = true,
        ['冰族撕裂者'] = true,
        ['冰族萨满'] = true,
        ['冰族掠夺者'] = true,
        ['骷髅'] = true,
        ['噶尔'] = true,
        ['白骨战士尸弓'] = true,
        ['白骨战士'] = true,
        ['白骨战士尸斧手'] = true,
        ['白骨战士弓手'] = true,
        ['白骨战士队长'] = true,
        ['妖灵'] = true,
        ['复仇的灵体'] = true,

        ['蛮兽'] = true,
        ['蝎子'] = true,
        ['灼痛钉刺'] = true,
        ['断骨手'] = true,
        ['黑卫士'] = true,
        ['神射手'] = true,
        ['割喉者'] = true,
        ['拆解者'] = true,
        ['铜牙'] = true,

    },
}
local this = monster_res

-- 判断是否为怪物
function monster_res.is_monster(c_name)
    local ret_b = false
    if monster_res.MONSTER_NAME[c_name] then
        ret_b = true
    end
    return ret_b
end

-------------------------------------------------------------------------------------
-- 返回对象
return monster_res

-------------------------------------------------------------------------------------