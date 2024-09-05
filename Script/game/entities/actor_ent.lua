------------------------------------------------------------------------------------
-- game/entities/actor_ent.lua
--
-- 这个模块主要是项目内周围环境相关功能操作。
--
-- @module      actor_ent
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
-- @usage
-- local actor_ent = import('game/entities/actor_ent')
------------------------------------------------------------------------------------

-- 模块定义
---@class actor_ent
local actor_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = '1.0.0',
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = '2023-03-22 - Initial release',
    -- 模块名称
    MODULE_NAME = 'actor_ent module',
    -- 只读模式
    READ_ONLY = false,
    -- 当前角色
    LOCAL_PLAYER = 0,
    -- 玩家
    OTHER_PLAYER = 1,
    -- npc
    GAME_NPC = 2,
    -- 怪物
    GAME_MONSTER = 3
}

-- 实例对象
local this = actor_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local common = common
local pairs = pairs
local table = table
local ipairs = ipairs
local math = math
local main_ctx = main_ctx
local actor_unit = actor_unit
local actor_ctx = actor_ctx
local import = import
local ui_unit = ui_unit
local local_player = local_player
local rawset = rawset
local setmetatable = setmetatable
local utils = import('base/utils')
local actor_res = import('game/resources/actor_res')
local map_res = import('game/resources/map_res')

---@type monster_res
local monster_res = import('game/resources/monster_res')
---@type item_res
local item_res = import('game/resources/item_res')

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
actor_ent.super_preload = function()

end

-- 获取附近物品信息
function actor_ent.get_near_actor_info(map)
    map = map or ''
    local ret_t = {}
    -- 获取周围所有环境信息
    local list = actor_ent.get_actor_info_by_any(-1)
    -- 获取周围怪物信息
    for i = 1, #list do
        local actor_info = list[i]
        local read = false
        if not read and monster_res.is_monster(actor_info.c_name) and actor_info.health > 0 and actor_info.distance < 10 then
            read = true
            actor_info.is_monster = true
        end
        if read then
            ret_t[#ret_t + 1] = actor_info
        end
    end
    -- 获取周围地上物品信息
    list = actor_ent.get_actor_info_by_any(4)
    for i = 1, #list do
        local actor_info = list[i]
        local read = false
        if item_res.is_money_item(actor_info.c_name) and actor_info.distance > 2 then
            read = true
            actor_info.is_money = true
        end
        if not read and item_res.is_equip_item(actor_info.c_name) then
            if #item_unit.list(0) < 33 then
                read = true
                actor_info.is_equip = true
            end
        end
        if read then
            if actor_info.distance > 10 or table.is_empty(map_unit.get_nav_path(map,actor_info.x, actor_info.y, actor_info.z)) then
                read = false
            end
        end
        if read then
            ret_t[#ret_t + 1] = actor_info
        end
    end
    table.sort(ret_t, function(a, b)
        return a.distance < b.distance
    end)
    return ret_t[1] or {}
end

function actor_ent.get_box_info()
    local ret_t = {}
    local list = actor_ent.get_actor_info_by_any(-1)
    for i = 1, #list do
        local actor_info = list[i]
        if monster_res.is_open_item(actor_info.c_name) and actor_info.interact then
            ret_t = actor_info
            break
        end
    end
    return ret_t
end

--获取金币信息
function actor_ent.get_jinbi_info()
    local ret_t = {}
    local tmp_t = {}
    local list = actor_ent.get_actor_info_by_any(4)
    for i = 1, #list do
        local actor_info = list[i]
        if monster_res.is_cailiao_item(actor_info.c_name) then
            if actor_info.e_name ~= 'Health_Potion_Dose_PickUp' then
                tmp_t[#tmp_t + 1] = actor_info
            end
        end
    end
    table.sort(tmp_t, function(a, b)
        return a.distance < b.distance
    end)
    ret_t = tmp_t[1] or {}
    return ret_t
end

--获取装备信息
function actor_ent.get_equip_info_by_dist(dist)
    local ret_t = {}
    local tmp_t = {}
    local list = actor_ent.get_actor_info_by_any(4)
    for i = 1, #list do
        local actor_info = list[i]
        if monster_res.is_equip_item(actor_info.c_name) and actor_info.distance <= dist and not string.find(actor_info.c_name, '宝石') and not string.find(actor_info.c_name, '钻石') then
            tmp_t[#tmp_t + 1] = actor_info
        end
    end
    table.sort(tmp_t, function(a, b)
        return a.distance < b.distance
    end)
    ret_t = tmp_t[1] or {}
    return ret_t
end

--判断周围是否有骸骨
actor_ent.near_have_haigu = function()
    local ret_b = false
    local list = actor_ent.get_actor_info_by_any(-1)
    for i = 1, #list do
        local actor_info = list[i]
        if actor_info.distance <= 12 and actor_info.e_name == 'Necro_Corpse' and actor_info.type2 == 93 then
            ret_b = true
            break
        end
    end
    return ret_b
end

--判断周围是否有骸骨
actor_ent.near_haigu_info = function()
    local ret_t = {}
    local list = actor_ent.get_actor_info_by_any(-1)
    for i = 1, #list do
        local actor_info = list[i]
        if actor_info.distance <= 12 and actor_info.e_name == 'Necro_Corpse' and actor_info.type2 == 93 then
            ret_t = actor_info
            break
        end
    end
    return ret_t
end

-- 通过中文名字获取环境信息
actor_ent.get_actor_info_by_c_name = function(c_name)
    local ret_t = {}
    local list = actor_unit.list(-1)
    for i = 1, #list do
        if list[i].c_name == c_name then
            ret_t = list[i]
            break
        end
    end
    return ret_t
end

--通过英文名字获取环境信息
function actor_ent.get_actor_info_by_e_name(e_name)
    local ret_t = {}
    local list = actor_ent.get_actor_info_by_any(-1)
    for i = 1, #list do
        if list[i].e_name == e_name then
            ret_t = list[i]
            break
        end
    end
    return ret_t
end

--判断周围怪物数量
function actor_ent.near_monster_nums()
    local ret_n = 0
    local list = actor_ent.get_actor_info_by_any(-1)
    for i = 1, #list do
        local actor_info = list[i]
        if actor_info.distance <= 10 then
            if monster_res.is_monster(actor_info.c_name) and actor_info.health > 0 then
                if actor_info.c_name ~= '腐臭遗骸' or (actor_info.c_name == '腐臭遗骸' and actor_info.status == 32) then
                    ret_n = ret_n + 1
                end
            end
        end
    end
    return ret_n
end

------------------------------------------------------------------------------------
-- [读取] 获取附近的怪物信息
------------------------------------------------------------------------------------
function actor_ent.get_near_monster_info()
    local ret_t = {}
    local tmp_t = {}
    local list = actor_ent.get_actor_info_by_any(-1)
    for i = 1, #list do
        local actor_info = list[i]
        if monster_res.is_monster(actor_info.c_name) and actor_info.health > 0 and actor_info.distance < 10 then
            if actor_info.c_name ~= '腐臭遗骸' or (actor_info.c_name == '腐臭遗骸' and actor_info.status == 32) then
                tmp_t[#tmp_t + 1] = actor_info
            end
        end
    end
    table.sort(tmp_t, function(a, b)
        return a.distance < b.distance
    end)
    ret_t = tmp_t[1] or {}
    return ret_t
end




------------------------------------------------------------------------------------
-- [读取] 根据对象任意字段值返回对象信息表
-- 获取列表(-1所有、1玩家、4地面物品)
------------------------------------------------------------------------------------
actor_ent.get_actor_info_by_any = function(actor_type)
    local ret_t = {}
    local list = actor_unit.list(actor_type)
    for i = 1, #list do
        local actor_info = list[i]
        local tem_t = {
            -- 最大血量
            max_health = actor_info.max_health,
            -- 当前血量
            health = actor_info.health,
            -- 状态
            status = actor_info.status,
            -- 中文名称
            c_name = actor_info.c_name,
            -- 英文名称
            e_name = actor_info.e_name,
            -- 等级
            level = actor_info.level,
            -- id
            cid = actor_info.cid,
            -- aid
            aid = actor_info.aid,
            -- X坐标
            x = actor_info.x,
            -- Y坐标
            y = actor_info.y,
            -- Z坐标
            z = actor_info.z,
            -- 资源指针1
            ptr1 = actor_info.ptr1,
            -- 资源指针2
            ptr2 = actor_info.ptr2,
            -- 类型1
            type1 = actor_info.type1,
            -- 类型2
            type2 = actor_info.type2,
            -- 类型3
            type3 = actor_info.type3,
            -- 类型4
            type4 = actor_info.type4,
            -- 距离
            distance = actor_info.distance,
            -- 对话id
            talk_id = actor_info.talk_id,
        }
        table.insert(ret_t, tem_t)
    end
    return ret_t
end

-- 获取附近物品信息
function actor_ent.get_near_monster_info2()
    local ret_t = {}
    -- 获取周围所有环境信息
    local list = actor_ent.get_actor_info_by_any(-1)
    -- 获取周围怪物信息
    for i = 1, #list do
        local actor_info = list[i]
        local read = false
        if not read and monster_res.is_monster(actor_info.c_name) and actor_info.health > 0 and actor_info.distance < 5 then
            read = true
            actor_info.is_monster = true
        end
        if read then
            ret_t[#ret_t + 1] = actor_info
        end
    end
    table.sort(ret_t, function(a, b)
        return a.distance < b.distance
    end)
    return ret_t[1] or {}
end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function actor_ent.__tostring()
    return this.MODULE_NAME
end

------------------------------------------------------------------------------------
-- [内部] 防止动态修改(this.READ_ONLY值控制)
--
-- @local
-- @tparam       table     t                被修改的表
-- @tparam       any       k                要修改的键
-- @tparam       any       v                要修改的值
------------------------------------------------------------------------------------
actor_ent.__newindex = function(t, k, v)
    if this.READ_ONLY then
        error('attempt to modify read-only table')
        return
    end
    rawset(t, k, v)
end

------------------------------------------------------------------------------------
-- [内部] 设置item的__index元方法指向自身
--
-- @local
------------------------------------------------------------------------------------
actor_ent.__index = actor_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local 
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function actor_ent:new(args)
    local new = {}
    -- 预载函数(重载脚本时)
    if this.super_preload then
        this.super_preload()
    end
    -- 将args中的键值对复制到新实例中
    if args then
        for key, val in pairs(args) do
            new[key] = val
        end
    end
    -- 设置元表
    return setmetatable(new, actor_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return actor_ent:new()

-------------------------------------------------------------------------------------