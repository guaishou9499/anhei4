------------------------------------------------------------------------------------
-- tests/tests.lua
--
-- 示例和测试入口文件。
--
-- @module      tests
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
-- @usage
-- local tests = import('tests/tests.lua')
------------------------------------------------------------------------------------

-- 模块定义
local tests = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = '1.0.0',
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = '2023-03-22 - Initial release',
    -- 模块名称
    MODULE_NAME = 'tests module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = tests
-- 工具函数
local utils = utils
-- 辅助对象
local helper = import('base/helper')
-- 配置管理
local configer = import('base/configer')
-- JSON解析
local dkjson = import('base/dkjson')
-- 优化列表
local os = os
local math = math
local table = table
local main_ctx = main_ctx
local print = print
local cjson = cjson
local print_r = print_r
---@type login_res
local login_res = import('game/resources/login_res')
-- 运行前置条件
this.eval_ifs = {
    -- [启用] 游戏状态列表
    yes_game_state = {},
    -- [禁用] 游戏状态列表
    not_game_state = {},
    -- [启用] 配置开关列表
    yes_config = {},
    -- [禁用] 配置开关列表
    not_config = {},
    -- [时间] 模块超时设置(可选)
    time_out = 0,
    -- [其它] 特殊情况才用(可选)
    is_working = function()
        return true
    end,
    -- [其它] 功能函数条件(可选)
    is_execute = function()
        return true
    end,
}
---@type skill_ent
local skill_ent = import('game/entities/skill_ent')
---@type actor_ent
local actor_ent = import('game/entities/actor_ent')
---@type skill_res
local skill_res = import('game/resources/skill_res')
---@type map_ent
local map_ent = import('game/entities/map_ent')
---@type item_ent
local item_ent = import('game/entities/item_ent')
---@type dungeon_ent
local dungeon_ent = import('game/entities/dungeon_ent')
---@type shop_ent
local shop_ent = import('game/entities/shop_ent')
local team_ent = import('game/entities/team_ent')
---@type equip_ent
local equip_ent = import('game/entities/equip_ent')
---@type example
local example = import('example/example')
local equip_res = import('game/resources/equip_res')
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function tests.super_preload()

end

-------------------------------------------------------------------------------------
-- 模块入口
-------------------------------------------------------------------------------------
function tests.entry()
    -- xprint(ui_unit.get_msgbox_title())
    -- -- 获取消息框内容
    -- xprint(ui_unit.get_msgbox_content())

    xxmsg(ui_unit.get_msgbox_title())
    xxmsg(ui_unit.get_msgbox_content())
end

------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function tests.__tostring()
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
function tests.__newindex(t, k, v)
    if this.READ_ONLY then
        error('attempt to modify read-only table')
        return
    end
    rawset(t, k, v)
end

------------------------------------------------------------------------------------
-- 设置item的__index元方法指向自身
--
-- @local
------------------------------------------------------------------------------------
tests.__index = tests

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local 
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function tests:new(args)
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
    return setmetatable(new, tests)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return tests:new()

-------------------------------------------------------------------------------------
