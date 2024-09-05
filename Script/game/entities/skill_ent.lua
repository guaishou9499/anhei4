------------------------------------------------------------------------------------
-- game/entities/skill_ent.lua
--
-- 实体示例
--
-- @module      skill_ent
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-05-09
-- @copyright   2023
-- @usage
-- local skill_ent = import('game/entities/skill_ent')
------------------------------------------------------------------------------------

-- 模块定义
---@class skill_ent
local skill_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = '1.0.0',
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = '2023-05-09 - Initial release',
    -- 模块名称
    MODULE_NAME = 'skill_ent module',
    -- 只读模式
    READ_ONLY = false,

}

-- 实例对象
local this = skill_ent
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
---@type skill_res
local skill_res = import('game/resources/skill_res')
local item_ent = import('game/entities/item_ent')
---@type actor_ent
local actor_ent = import('game/entities/actor_ent')
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function skill_ent.super_preload()
    --this.skill_is_can_use = decider.run_action_wrapper('判断技能是否可以使用', this.skill_is_can_use)
end

-- 集结呐喊
-- 战吼
-- 挑战怒吼
-- 狂战士之怒
-- 突刺打击
-- 先祖之锤
-- 使用技能打怪
--
function skill_ent.use_skill_jjlh()
    local skill_info = skill_ent.get_skill_info_by_name('集结呐喊')
    if skill_ent.skill_is_can_use(skill_res['野蛮人'][4]['集结呐喊'], skill_info) then
        skill_unit.use_skill_target(skill_info.id, local_player:cid(), local_player:cx(),   local_player:cy(),   local_player:cz())
        decider.sleep(400)
    end
end

function skill_ent.use_skill_zh()
    local skill_info = skill_ent.get_skill_info_by_name('战吼')
    if skill_ent.skill_is_can_use(skill_res['野蛮人'][3]['战吼'], skill_info) then
        skill_unit.use_skill_target(skill_info.id, local_player:cid(), local_player:cx(),   local_player:cy(),   local_player:cz())
        decider.sleep(400)
    end
end

function skill_ent.use_skill_tznh()
    local skill_info = skill_ent.get_skill_info_by_name('挑战怒吼')
    if skill_ent.skill_is_can_use(skill_res['野蛮人'][4]['挑战怒吼'], skill_info) then
        skill_unit.use_skill_target(skill_info.id, local_player:cid(), local_player:cx(),   local_player:cy(),   local_player:cz())
        decider.sleep(400)
    end
end

function skill_ent.use_skill_hzszn()
    local skill_info = skill_ent.get_skill_info_by_name('狂战士之怒')
    if skill_ent.skill_is_can_use(skill_res['野蛮人'][1]['狂战士之怒'], skill_info) then
        skill_unit.use_skill_target(skill_info.id, local_player:cid(), local_player:cx(),   local_player:cy(),   local_player:cz())
        decider.sleep(400)
    end
end

function skill_ent.use_skill_xzzc(monster_info)
    local skill_info = skill_ent.get_skill_info_by_name('先祖之锤')
    if skill_ent.skill_is_can_use(skill_res['野蛮人'][5]['先祖之锤'], skill_info) then
        local x, y = game_unit.world_to_screen(monster_info.x, monster_info.y, monster_info.z)
        main_ctx:move_cursor(x, y)
        skill_unit.use_skill_target(skill_info.id,monster_info.cid, monster_info.x, monster_info.y, monster_info.z)
        decider.sleep(400)
        main_ctx:reset_pos()
    end
end

function skill_ent.use_skill_tcdj(monster_info)
    local skill_info = skill_ent.get_skill_info_by_name('突刺打击')
    if skill_ent.skill_is_can_use(skill_res['野蛮人'][6]['突刺打击'], skill_info) then
       skill_unit.use_skill_target(skill_info.id,monster_info.cid, monster_info.x, monster_info.y, monster_info.z)
        decider.sleep(500)
        main_ctx:reset_pos()
    end
end

-- 使用技能打怪
function skill_ent.use_skill_kill_monster(monster_info)
    if table.is_empty(monster_info) then
        return false, '怪物信息为空'
    end
    trace.output('攻击' .. monster_info.c_name)
    local skill_id, skill_info = skill_ent.get_can_use_skill_id()
    if skill_id == 0 then
        return false, '没有可用的技能'
    end
    local x, y, z = monster_info.x, monster_info.y, monster_info.z
    local target_cid = 0
    if skill_info.myself then
        target_cid = local_player:cid()
    elseif skill_info.monster then
        target_cid = monster_info.cid
    end
    local cx, cy = game_unit.world_to_screen(monster_info.x, monster_info.y, monster_info.z)
    main_ctx:move_cursor(cx, cy)
    decider.sleep(100)
    skill_unit.use_skill_target(skill_id, target_cid, x, y, z)
    decider.sleep(300)
    if skill_info.cd then
        skill_ent[skill_info.name] = { cd = os.time() }
    end
    main_ctx:reset_pos()
    return true
end




-- 获取可以使用的技能id
function skill_ent.get_can_use_skill_id()
    local skill_data = skill_res['野蛮人']
    for i = 1, #skill_data do
        local skill_list = skill_data[i]
        for k, v in pairs(skill_list) do
            -- 通过技能名字判断技能信息
            local skill_info = skill_ent.get_skill_info_by_name(k)
            if skill_ent.skill_is_can_use(v, skill_info) then
                return skill_info.id, v
            end
        end
    end
    return 0, {}
end

-- 判断技能是否可以使用
function skill_ent.skill_is_can_use(skill_data, skill_info)

    if table.is_empty(skill_info) then
        return false, '技能' .. skill_data.name .. '未学习'
    end
    if skill_info.level <= 0 then
        return false, '技能' .. skill_data.name .. '等级【' .. skill_info.level .. '】过低'
    end
    if skill_data.cd then
        local skill_name = skill_data.name
        if not skill_ent[skill_name] then
            skill_ent[skill_name] = { cd = 0 }
        end
        if os.time() - skill_ent[skill_name].cd <= skill_data.cd then
            return false, '1.技能' .. skill_data.name .. '冷却中'
        end
    end
    if skill_data.baoming then
        if local_player:health() >= skill_data.baoming then
            return false, '技能' .. skill_data.name .. '未到达血量最低值'
        end
    end
    if skill_info.status ~= skill_data.status then
        return false, '技能' .. skill_data.name .. '冷却中'
    end
    if skill_info.need_mp then
        local spirits = local_player:spirits()
        if spirits < 30 or local_player:spirits() / local_player:max_spirits() < 0.5 then
            return false, '技能' .. skill_data.name .. '当前蓝量不足' .. spirits
        end
    end
    if skill_data.need_hg then
        if not actor_ent.near_have_haigu() then
            return false, '技能' .. skill_data.name .. '周围没有骸骨'
        end
    end
    -- 判断技能是否在快捷栏
    if skill_data.name ~= '闪避' and not skill_ent.skill_is_in_shortcut(skill_info.id) then
        return false, '技能' .. skill_data.name .. '不在快捷栏'
    end
    return true
end

-- 判断技能是否在快捷栏
function skill_ent.skill_is_in_shortcut(skill_id)
    for i = 0, 5 do
        if skill_unit.get_shorcut_skill_id(i) == skill_id then
            return true
        end
    end
    return false
end

-- 使用闪避技能
function skill_ent.use_shanbi_skill(x, y, z)
    local skill_info = skill_ent.get_skill_info_by_name('闪避')
    local skill_data = skill_res.GENERAL['闪避']
    if skill_ent.skill_is_can_use(skill_data, skill_info) then
        skill_unit.use_skill_target(skill_info.id, 0, x, y, z)
        decider.sleep(500)
    end
end

------------------------------------------------------------------------------------
-- [读取] 通过技能名称获取指定技能信息
--
-- @tparam              string                   name           技能名称（汉）
-- @tfield[table]       number                   id             技能ID
-- @tfield[table]       string                   c_name         技能中文名称
-- @tfield[table]       string                   e_name         技能英文名称
-- @tfield[table]       number                   status         技能状态
-- @tfield[table]       number                   level          技能等级
-- @tfield[table]       number                   ptr            技能资源指针
-- @usage
-- local info = skill_ent.get_skill_info_by_name(name, 'name')
------------------------------------------------------------------------------------
skill_ent.get_skill_info_by_name = function(name)
    local r_tab = {}
    local list = skill_unit.list(0)
    for i = 1, #list do
        local skill_info = list[i]
        if skill_info.c_name == name then
            r_tab = {
                -- 技能ID
                id = skill_info.id,
                -- 技能中文名称
                c_name = name,
                -- 技能英文名称
                e_name = skill_info.e_name,
                -- 技能状态
                status = skill_info.status,
                -- 技能等级
                level = skill_info.level,
                -- 技能资源指针
                ptr = skill_info.ptr,
            }
            break
        end
    end
    return r_tab
end


------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function skill_ent.__tostring()
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
function skill_ent.__newindex(t, k, v)
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
skill_ent.__index = skill_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function skill_ent:new(args)
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
    return setmetatable(new, skill_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return skill_ent:new()

-------------------------------------------------------------------------------------