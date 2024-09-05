------------------------------------------------------------------------------------
-- game/entities/item_ent.lua
--
-- 实体示例
--
-- @module      item_ent
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-05-09
-- @copyright   2023
-- @usage
-- local item_ent = import('game/entities/item_ent')
------------------------------------------------------------------------------------

-- 模块定义
---@class item_ent
local item_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = '1.0.0',
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = '2023-05-09 - Initial release',
    -- 模块名称
    MODULE_NAME = 'item_ent module',
    -- 只读模式
    READ_ONLY = false,

}

-- 实例对象
local this = item_ent
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

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function item_ent.super_preload()

end

-- 使用药水
function item_ent.use_hp()
    if item_ent.use_hp_time and os.time() - item_ent.use_hp_time < 3 then
        return false
    end
    if local_player:health() >= 0.99 then
        return
    end
    decider.sleep(200)
    main_ctx:do_skey(0x51)
    item_ent.use_hp_time = os.time()
end

---- 开启箱子
--function item_ent.open_box()
--    if actor_ent.near_monster_nums() > 0 then
--        return false
--    end
--    local box_info = actor_ent.get_box_info()
--    if table.is_empty(box_info) then
--        return false
--    end
--    map_ent.fb_move_to_xyz(box_info.x, box_info.y, box_info.z)
--    if actor_unit.dist2(box_info.x, box_info.y, box_info.z) <= 1.9 then
--        skill_unit.click_actor(box_info.cid)
--        decider.sleep(500)
--    end
--end


-- 获取装备的威能名称
function item_ent.get_item_weineng(item_info)
    local ret_s = ''
    if table.is_empty(item_info) then
        return ret_s
    end
    local item_name = item_info.c_name
    local item_title = item_info.title
    if type(item_name) ~= 'string' or type(item_title) ~= 'string' then
        return ret_s
    end
     ret_s = string.gsub(item_title,item_name,'')

    return ret_s
end


------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function item_ent.__tostring()
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
function item_ent.__newindex(t, k, v)
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
item_ent.__index = item_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function item_ent:new(args)
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
    return setmetatable(new, item_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return item_ent:new()

-------------------------------------------------------------------------------------
