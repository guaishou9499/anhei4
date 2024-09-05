------------------------------------------------------------------------------------
-- game/entities/ map_ent.lua
--
-- 实体示例
--
-- @module       map_ent
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-05-09
-- @copyright   2023
-- @usage
-- local  map_ent = import('game/entities/ map_ent')
------------------------------------------------------------------------------------

-- 模块定义
---@class map_ent
local map_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = '1.0.0',
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = '2023-05-09 - Initial release',
    -- 模块名称
    MODULE_NAME = ' map_ent module',
    -- 只读模式
    READ_ONLY = false,

}

-- 实例对象
local this = map_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local pairs = pairs
local table = table
local rawset = rawset
local skill_ctx = skill_ctx
local skill_unit = skill_unit
local setmetatable = setmetatable
local import = import
---@type actor_ent
local actor_ent = import('game/entities/actor_ent')
---@type skill_ent
local skill_ent = import('game/entities/skill_ent')
local team_ent = import('game/entities/team_ent')
local map_res = import('game/resources/map_res')
---@type item_ent
local item_ent = import('game/entities/item_ent')
local example =  import('example/example')
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function map_ent.super_preload()

end

-- 捡物品移动
function map_ent.fb_move_to_xyz2(cx, cy, cz, name)
    -- 构建地图路径标
    name = name or ''
    -- 加载地图
    map_unit.load_nav_map(name)
    -- 验证地图有效
    if not map_unit.check_nav_map(name) then
        local map_name = game_unit.get_curr_area_name()
        trace.output('未构建地图' .. name .. '信息无法移动')
        xxmsg(('未构建地图' .. name .. '信息无法移动'))
        return false
    end
    -- 获取移动路径
    local path = map_unit.get_nav_path(name, cx, cy, cz)
    if table.is_empty(path) then
        skill_ent.use_shanbi_skill(cx, cy, cz)
        map_unit.walk_to(cx, cy, cz, 2)
    end
    for i = 1, #path do
        local x = path[i]['x']
        local y = path[i]['y']
        local z = path[i]['z']
        local dis = actor_unit.dist2(cx, cy, cz)
        if dis > 0.5 then
            map_unit.walk_to(x, y, z, 2)
        else
            map_unit.walk_to(cx, cy, cz, 2)
            break
        end
        for j = 1, 50 do
            if actor_unit.dist2(x, y, z) < 1.5 then
                break
            end
            if local_player:hp() <= 0 then
                return
            end
            if not local_player:is_move() then
                map_unit.walk_to(x, y, z, 2)
            end
            if j == 20 then
                skill_ent.use_shanbi_skill(cx, cy, cz)
            end
            decider.sleep(50)
        end
    end
end

-- 副本移动
function map_ent.fb_move_to_xyz(cx, cy, cz, name)
    name = name or ''
    -- 加载地图
    map_unit.load_nav_map(name)
    -- 验证地图有效
    if not map_unit.check_nav_map(name) then
        local map_name = game_unit.get_curr_area_name()
        trace.output('未构建地图' .. name .. '信息无法移动')
        xxmsg(('未构建地图' .. name .. '信息无法移动'))
        return false
    end
    -- 获取移动路径
    local path = map_unit.get_nav_path(name, cx, cy, cz)
    -- 移动路径是否为空
    if table.is_empty(path) then
        xxmsg(('直接移动'))
        map_unit.walk_to(cx, cy, cz, 2)
        return
    end
    for i = 1, #path do
        skill_ent.use_skill_jjlh()
        local x = path[i]['x']
        local y = path[i]['y']
        local z = path[i]['z']
        local dis = actor_unit.dist2(cx, cy, cz)
        if not is_working() then
            return false
        end
        local actor_info = actor_ent.get_near_actor_info(name)
        if not table.is_empty(actor_info) then
            return
        end
        if dis > 0.5 then
            map_unit.walk_to(x, y, z, 2)
        else
            map_unit.walk_to(cx, cy, cz, 2)
            break
        end
        -- 2.5 秒
        for j = 1, 50 do
            if actor_unit.dist2(x, y, z) < 0.5 then
                break
            end
            if local_player:hp() <= 0 then
                return
            end
            if not local_player:is_move() then
                map_unit.walk_to(x, y, z, 2)
            end
            if j == 20 then
                skill_ent.use_shanbi_skill(cx, cy, cz)
            end
            decider.sleep(50)
        end
    end
end

-- 退出副本
function map_ent.out_dungeon(fb_id)
    if fb_id ~= game_unit.get_curr_map_id() then
        return true
    end
    --42422.0
    if #party_unit.member_list() > 1 and party_unit.is_leader() then
        team_ent.out_team()
        for i = 1, 30 do
            local curr_map_id = game_unit.get_curr_map_id()
            if fb_id ~= curr_map_id and curr_map_id ~= 42422.0 then
                return true
            end
            trace.output('传送回城[' .. i .. ']')
            decider.sleep(1000)
        end
    else
        actor_unit.teleport(map_res.NAME_TO_ID['扎宾泽特'])
        decider.sleep(2000)
        for i = 1, 30 do
            local curr_map_id = game_unit.get_curr_map_id()
            if fb_id ~= curr_map_id and curr_map_id ~= 42422.0 then
                return true
            end
            decider.sleep(1000)
        end
    end
    return false
end

-- 大地图移动
function map_ent.build_nav_map(cx, cy, cz)
    map_unit.load_nav_map('')
    if not map_unit.check_nav_map('') then
        local map_name = game_unit.get_curr_area_name()
        trace.output('未构建地图' .. map_name .. '信息无法移动')
        return false
    end
    local path = map_unit.get_nav_path('', cx, cy, cz)
    if table.is_empty(path) then
        xxmsg('空')
        map_unit.walk_to(cx, cy, cz, 2)
        return
    end
    for k, v in ipairs(path)
    do
        local x = v['x']
        local y = v['y']
        local z = v['z']
        local dis = actor_unit.dist2(cx, cy, cz)
        if dis > 0.5 then
            map_unit.walk_to(x, y, z, 2)
        else
            map_unit.walk_to(cx, cy, cz, 2)
            break
        end

        for i = 1, 50
        do
            if actor_unit.dist2(x, y, z) < 0.5 then
                break
            end
            decider.sleep(50)
            if local_player:hp() <= 0 then
                return
            end
            if not local_player:is_move() then
                map_unit.walk_to(x, y, z, 2)
            end
        end
        decider.sleep(50)
    end
end

--------------------------------------------------------------------------------
-- [条件] 判断是否卡位置(内部使用)
--
-- @static
-- @tparam      integer      num    在同一位置范围的次数
-- @tparam      integer      dis    在同一位置的范围
-- @treturn     boolean
-- @usage
-- if move_ent.move_lag() then main_ctx:end_game() end
--------------------------------------------------------------------------------
map_ent.move_lag = function()
    local ret_b = false
    --记录在同一位置次数
    if not this.check_auto then
        this.check_auto = 0
    end
    if not this.last_x or this.last_x == 0 then
        --记录坐标
        this.last_x = local_player:cx()
        this.last_y = local_player:cy()
        this.last_z = local_player:cz()
    else
        --位置不变记录次数+1，变化位置记录清空
        if actor_unit.dist2(this.last_x, this.last_y, this.last_z) < 2 then
            if this.check_auto == 0 then
                this.check_auto = os.time()
            end
        else
            this.last_x = 0
            this.last_y = 0
            this.last_z = 0
            this.check_auto = 0
        end
        -- 在同一位置的次数超过次数num 返回true
        local lag_time = os.time() - this.check_auto
        if this.check_auto > 0 and lag_time >= 60 then
            ret_b = true
            this.check_auto = 0
        end
        if this.check_auto > 0 and lag_time >= 30 then
            trace.output('卡位>' .. (60 - (lag_time)) .. '秒后 >退出副本')
            decider.sleep(2000)
        end
    end
    return ret_b
end

-- 移动到指定位置
function map_ent.test111(map_name, cx, cy, cz)
    map_name = map_name or ''
    map_unit.load_nav_map(map_name)
    if map_unit.check_nav_map(map_name) then
        map_unit.load_nav_map(map_name)
    else
        map_unit.build_nav_map(map_name, 200, 1)
    end
    local path = map_unit.get_nav_path(map_name, cx, cy, cz)
    if table.is_empty(path) then
        map_unit.walk_to(cx, cy, cz, 2)
        return
    end

    for i = 1, #path, 4 do
        local x = path[i]['x']
        local y = path[i]['y']
        local z = path[i]['z']
        local dis = actor_unit.dist2(cx, cy, cz)
        if dis > 1 then
            map_unit.walk_to(x, y, z, 2)
        else
            map_unit.walk_to(cx, cy, cz, 2)
            break
        end
        if not is_working() then
            return
        end
        -- 2.5 秒
        for j = 1, 50 do
            item_ent.use_hp()
            skill_ent.use_skill_jjlh()
            example.test_near_actor_unit2()
            skill_ent.use_skill_kill_monster(actor_ent.get_near_monster_info2())
            if actor_unit.dist2(x, y, z) < 1 then
                break
            end
            if local_player:hp() <= 0 then
                return
            end
            if not local_player:is_move() then
                map_unit.walk_to(x, y, z, 2)
            end
            if j == 20 then
                skill_ent.use_shanbi_skill(cx, cy, cz)
            end
            decider.sleep(50)
        end
    end
end

-- 移动到指定位置


--for i = 1, #move_list do
--    local cx = move_list[i].x
--    local cy = move_list[i].y
--    local cz = move_list[i].z
--    while is_working() do
--        if actor_unit.dist2(cx, cy, cz) < 1 then
--            break
--        end
--        map_ent.test111(nil,cx, cy, cz)
--        decider.sleep(100)
--    end
--end

-- 从铁狼营地进入奥杜尔的洞穴
function map_ent.move_to_tra_pos(pos_list)
    local move_list = {
        { x = 259, y = -642, z = 4 ,tp_id = 912124,map_name = '铁狼营地'},
        { x = 340, y = -545, z = 10 },
        { x = 374, y = -593, z = 11 },
        { x = 387, y = -626, z = 10 },
    }
    pos_list = pos_list or move_list
    while is_working() do
        if actor_unit.dist2(pos_list[#pos_list].x, pos_list[#pos_list].y, pos_list[#pos_list].z) < 1 then
            break
        end
        if game_unit.get_curr_area_name() == pos_list[1].map_name then
            for i = 1, #pos_list do
                local cx = pos_list[i].x
                local cy = pos_list[i].y
                local cz = pos_list[i].z
                while is_working() do
                    if actor_unit.dist2(cx, cy, cz) < 3 then
                        break
                    end
                    map_ent.test111(nil, cx, cy, cz)
                    decider.sleep(100)
                end
            end
        else
            actor_unit.teleport(pos_list[1].tp_id)
            decider.sleep(1000)
            for i = 1, 30 do
                trace.output('传送' ..  pos_list[1].map_name .. '中[' .. i .. ']')
                if pos_list[1].tp_id == game_unit.get_curr_area_id() then
                    break
                end
                decider.sleep(1000)
            end
        end
    end
end
------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function map_ent.__tostring()
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
function map_ent.__newindex(t, k, v)
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
map_ent.__index = map_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function map_ent:new(args)
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
    return setmetatable(new, map_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return map_ent:new()

-------------------------------------------------------------------------------------
