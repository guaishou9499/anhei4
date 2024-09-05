------------------------------------------------------------------------------------
-- game/entities/dungeon_ent.lua
--
-- 实体示例
--
-- @module      dungeon_ent
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-05-09
-- @copyright   2023
-- @usage
-- local dungeon_ent = import('game/entities/dungeon_ent')
------------------------------------------------------------------------------------

-- 模块定义
---@class dungeon_ent
local dungeon_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = '1.0.0',
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = '2023-05-09 - Initial release',
    -- 模块名称
    MODULE_NAME = 'dungeon_ent module',
    -- 只读模式
    READ_ONLY = false,

}

-- 实例对象
local this = dungeon_ent
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

local item_unit = item_unit
local actor_unit = actor_unit
local game_unit = game_unit
local main_ctx = main_ctx
local local_player = local_player
---@type map_res
local map_res = import('game/resources/map_res')
---@type dungeon_res
local dungeon_res = import('game/resources/dungeon_res')
---@type item_ent
local item_ent = import('game/entities/item_ent')
---@type actor_ent
local actor_ent = import('game/entities/actor_ent')
---@type shop_ent
local shop_ent = import('game/entities/shop_ent')
---@type map_ent
local map_ent = import('game/entities/map_ent')
---@type skill_ent
local skill_ent = import('game/entities/skill_ent')
---@type team_ent
local team_ent = import('game/entities/team_ent')
---@type user_set_ent
local user_set_ent = import('game/entities/user_set_ent')

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function dungeon_ent.super_preload()

end

-- 获取副本信息
function dungeon_ent.get_dungeon_res_by_name(fb_name)
    local dungeon_res_info = dungeon_res[fb_name] or {}
    return dungeon_res_info
end

--开始副本
function dungeon_ent.stats_dungeon(fb_name)
    local dungeon_res_info = dungeon_ent.get_dungeon_res_by_name(fb_name)
    if table.is_empty(dungeon_res_info) then
        trace.output('无法获取' .. fb_name .. '副本信息')
        return false
    end
    if dungeon_res_info.fb_map_id ~= game_unit.get_curr_map_id() then
        shop_ent.shop_out()
    end
    if user_set_ent['副本组队'] == 1 then
        local ret_team_info, ret_team_idx, ret_my_idx = team_ent.team_party('副本')
        if table.is_empty(ret_team_info) then
            return false
        end
    end
    dungeon_ent.in_dungeon(dungeon_res_info.fb_map_id, dungeon_res_info.out_map_list, dungeon_res_info.e_name, dungeon_res_info.tp_map_id, dungeon_res_info.x, dungeon_res_info.y, dungeon_res_info.z)
    if dungeon_res_info.fb_map_id == game_unit.get_curr_map_id() then
        dungeon_ent.fight_fb(fb_name, dungeon_res_info.fb_map_id)
    end
end

-- 进入副本
function dungeon_ent.in_dungeon(fb_map_id, out_map_list, fb_e_name, tp_map_id, fb_x, fb_y, fb_z)
    local e_name = fb_e_name
    local x, y, z = fb_x, fb_y, fb_z
    while decider.is_working() do
        if local_player:hp() > 0 then
            if fb_map_id == game_unit.get_curr_map_id() then
                return
            end
            -- 判断是否在指定地图
            if tp_map_id == game_unit.get_curr_area_id() then
                local dist = actor_unit.dist2(x, y, z)
                if dist <= 3 then

                  --  sleep(1000 * 60 * 15)
                  --  for i = 1, 600 do
                  --      trace.output('等待进入副本'..i)
                  --      sleep(1000)
                  --  end
                    local fb_info = actor_ent.get_actor_info_by_e_name(e_name)
                    if not table.is_empty(fb_info) then
                        skill_unit.click_actor(fb_info.cid)
                        for i = 1, 30 do
                            if fb_map_id == game_unit.get_curr_map_id() then
                                break
                            end
                            trace.output('进入副本中中[' .. i .. ']')
                            decider.sleep(1000)
                        end
                    end
                else
                    trace.output('移动至副本门口')
                    map_ent.build_nav_map(x, y, z)
                end
            else
                actor_unit.teleport(tp_map_id)
                decider.sleep(1000)
                for i = 1, 30 do
                    trace.output('传送' .. tostring(map_res.ID_TO_NAME[tp_map_id]) .. '中[' .. i .. ']')
                    if tp_map_id == game_unit.get_curr_area_id() then
                        break
                    end
                    decider.sleep(1000)
                end
            end
        else
            trace.output('等待6秒复活')
            decider.sleep(6000)
            actor_unit.rise_man()
            decider.sleep(2000)
        end
        decider.sleep(2000)
    end
end
--GetNavigationPathEx 未加载或生成导航地图 浸血冰川


function dungeon_ent.fight_fb(fb_name, fb_id)
    local map_info = dungeon_res[fb_name].END_POS
    while decider.is_working() do
        for map_name, map_res_data in pairs(map_info) do
            local curr_area_name = game_unit.get_curr_area_name()
            if curr_area_name == map_name then
                for idx = 1, #map_res_data do
                    local x,y,z = map_res_data[idx].x,map_res_data[idx].y,map_res_data[idx].z
                    local map = map_res_data[idx].map
                    while decider.is_working() do
                        if fb_id ~= game_unit.get_curr_map_id() then
                            return
                        end
                        if game_unit.get_curr_area_name() ~= map_name then
                            break
                        end
                        if local_player:hp() > 0 then
                            -- 加血
                            item_ent.use_hp()

                            -- 退出副本条件
                            if user_set_ent['副本组队'] == 1 then
                                if #party_unit.member_list() < #team_ent.get_team_job_list() then
                                    dungeon_ent.out_dungeon(fb_id,map)
                                end
                            end
                            -- 判断是否打怪
                            if user_set_ent['副本组队'] ~= 1 or party_unit.is_leader() or user_set_ent['小号帮打'] >= 1 then
                                -- 地图选项
                                -- 卡位判断
                                if map_ent.move_lag() then
                                    map_ent.out_dungeon(fb_id)
                                end
                                if map_res_data[idx].end_map then
                                    if actor_unit.dist2(x, y, z) <= 3 then
                                        dungeon_ent.out_dungeon(fb_id,map)
                                    end
                                elseif map_res_data[idx].need_down then
                                    if actor_unit.dist2(x, y, z) <= 3 then
                                        local actor_info2 = actor_ent.get_actor_info_by_e_name('Traversal_Gizmo_FreeClimb_Down')
                                        if not table.is_empty(actor_info2) then
                                            skill_unit.click_actor(actor_info2.cid)
                                            decider.sleep(2000)
                                            for i = 1, 10 do
                                                if map_name ~= game_unit.get_curr_area_name() then
                                                    break
                                                end
                                                decider.sleep(500)
                                            end
                                        end
                                    end
                                elseif map_res_data[idx].putong then
                                    if actor_unit.dist2(x, y, z) <= 3 then
                                        break
                                    end
                                end
                                -- 退出副本
                                if fb_id ~= game_unit.get_curr_map_id() then
                                    return
                                end
                                local actor_info = actor_ent.get_near_actor_info(map)
                                -- 判断移动到指定位置
                                if not table.is_empty(actor_info) then
                                    if actor_info.is_money then
                                        trace.output('捡取物品' .. actor_info.c_name)
                                        map_ent.fb_move_to_xyz2(actor_info.x, actor_info.y, actor_info.z,map)
                                    elseif actor_info.is_monster then
                                        trace.output('攻击怪物' .. actor_info.c_name)
                                        skill_ent.use_skill_kill_monster(actor_info)
                                    elseif actor_info.is_equip then
                                        trace.output('拾取装备' .. actor_info.c_name)
                                        map_ent.fb_move_to_xyz2(actor_info.x, actor_info.y, actor_info.z,map)
                                        if actor_unit.dist2(actor_info.x, actor_info.y, actor_info.z) <= 1.9 then
                                            actor_unit.pick_item(actor_info.aid)
                                            decider.sleep(100)
                                        end
                                    end
                                else
                                    trace.output('移动》地图》' .. map_name)
                                    map_ent.fb_move_to_xyz(x, y, z,map)
                                end
                            else
                                trace.output('等待大号刷图')
                            end


                        else
                            trace.output('等待6秒复活')
                            decider.sleep(6000)
                            actor_unit.rise_man()
                            decider.sleep(2000)
                        end



                        decider.sleep(100)
                    end



                end
            end

        end
        decider.sleep(100)
    end
end






-- 退出副本
function dungeon_ent.out_dungeon(fb_id,map)
    -- 周围存在可领取物品
    local actor_info = actor_ent.get_near_actor_info(map)
    if not table.is_empty(actor_info) then
        return false
    end
    if fb_id ~= game_unit.get_curr_map_id() then
        return true
    end
    if #party_unit.member_list() > 1 and party_unit.is_leader() then
        team_ent.out_team()
        for i = 1, 30 do
            local curr_map_id = game_unit.get_curr_map_id()
            if fb_id ~= curr_map_id and curr_map_id ~= 42422.0 then
                return true
            end
            actor_info = actor_ent.get_near_actor_info(map)
            if not table.is_empty(actor_info) then
                return false
            end
            trace.output('传送回城[' .. i .. ']')
            decider.sleep(500)
        end
    else
        actor_unit.teleport(map_res.NAME_TO_ID['扎宾泽特'])
        decider.sleep(2000)
        for i = 1, 30 do
            local curr_map_id = game_unit.get_curr_map_id()
            if fb_id ~= curr_map_id and curr_map_id ~= 42422.0 then
                return true
            end
            actor_info = actor_ent.get_near_actor_info(map)
            if not table.is_empty(actor_info) then
                return false
            end
            trace.output('传送回城[' .. i .. ']')
            decider.sleep(500)
        end
        team_ent.out_team()
    end
    return false
end

function dungeon_ent.get_fb_map_path(fb_name)
    local fb_map = {}
    local path = dungeon_res[fb_name].path
    for i = 1, #path do
        if path[i][1].x == local_player:cx() and path[i][1].y == local_player:cy() then
            fb_map = path[i]
            break
        end
    end
    return fb_map
end








------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function dungeon_ent.__tostring()
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
function dungeon_ent.__newindex(t, k, v)
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
dungeon_ent.__index = dungeon_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function dungeon_ent:new(args)
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
    return setmetatable(new, dungeon_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return dungeon_ent:new()

-------------------------------------------------------------------------------------
