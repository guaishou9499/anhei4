-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   admin
-- @email:    88888@qq.com
-- @date:     2022-06-30
-- @module:   login
-- @describe: 登陆处理
-- @version:  v1.0
--

-------------------------------------------------------------------------------------
--
local login = {
    VERSION         = '20211016.28',
    AUTHOR_NOTE     = "-[login module - 20211016.28]-",
    MODULE_NAME     = '登陆模块',
    -- 设置脚本版本
    SCRIPT_UPDATE   = 'v1.06.08A',
}

-- 自身模块
local this          = login
-- 配置模块
local settings      = settings
-- 日志模块
local trace         = trace
-- 决策模块
local decider       = decider
-- 优化列表
local game_unit     = game_unit
local main_ctx      = main_ctx
local login_unit    = login_unit
local setmetatable  = setmetatable
local pairs         = pairs
local import        = import
---@type user_set_ent
local user_set_ent    = import('game/entities/user_set_ent')
---@type login_res
local login_res    = import('game/resources/login_res')
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- 运行前置条件
this.eval_ifs = {
    -- [启用] 游戏状态列表
    yes_game_state = {login_res.STATUS_INTRO_PAGE},
    -- [禁用] 游戏状态列表
    not_game_state = {},
    -- [启用] 配置开关列表
    yes_config     = {},
    -- [禁用] 配置开关列表
    not_config     = {},
    -- [时间] 模块超时设置(可选)
    time_out       = 180,
    -- [其它] 特殊情况才用(可选)
    is_working     = function()
        return true
    end,
    -- [其它] 功能函数条件(可选)
    is_execute     = function()
        return true
    end,
}

-- 轮循函数列表
login.poll_functions = {}

------------------------------------------------------------------------------------
-- 预载函数(重载脚本时)
login.super_preload = function()

end

-------------------------------------------------------------------------------------
-- 预载处理
login.preload = function()
    user_set_ent.load_user_info()
end

-------------------------------------------------------------------------------------
-- 轮循功能入口
login.looping = function()

end

-------------------------------------------------------------------------------------
-- 功能入口函数
login.entry = function()
    local action_list = {
    }
    -- 加载前延迟
    decider.sleep(3000)
    while decider.is_working()
    do
        -- 执行轮循任务
        decider.looping()
        -- 判断 登录窗口 是否存在
        local btn_enter_game = ui_unit.get_control_byeid(0x48801B7B648303CF, 0xDD39E402BC4D0BC2, true)
        if btn_enter_game ~= 0 then
            ui_unit.btn_click(btn_enter_game)
        end
        -- 适当延时(切片)
        decider.sleep(2000)
    end
end


-------------------------------------------------------------------------------------
-- 模块超时处理
login.on_timeout = function()

end

-------------------------------------------------------------------------------------
-- 定时调用入口
login.on_timer = function(timer_id)
    xxmsg('login.on_timer -> '..timer_id)
end

-------------------------------------------------------------------------------------
-- 卸载处理
login.unload = function()
    --xxmsg('login.unload')
end

-------------------------------------------------------------------------------------
-- 效验登陆异常
login.check_login_error = function()

end

-------------------------------------------------------------------------------------
-- 实例化新对象

function login.__tostring()
    return this.MODULE_NAME
end

login.__index = login

function login:new(args)
    local new = { }

    -- 预载函数(重载脚本时)
    if this.super_preload then
        this.super_preload()
    end

    if args then
        for key, val in pairs(args) do
            new[key] = val
        end
    end

    -- 设置元表
    return setmetatable(new, login)
end

-------------------------------------------------------------------------------------
-- 返回对象
return login:new()

-------------------------------------------------------------------------------------