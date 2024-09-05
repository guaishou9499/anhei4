-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   admin
-- @email:    88888@qq.com
-- @date:     2023-02-14
-- @module:   start
-- @describe: 入口文件
-- @version:  v1.0
--

-------------------------------------------------------------------------------------
local main_ctx = main_ctx
local is_exit = is_exit
local sleep = sleep
local import = import
local math = math
local local_player = local_player
-- 引入管理对象
local core = import('base/core')
-- 导入公用库
local example = import('example/example')

-------------------------------------------------------------------------------------
-- LUA入口函数(正式 CTRL+F5)
function main()
    -- 预载处理
    core.preload()
    -- 主循环
    while not is_exit()
    do
        core.entry() -- 入口调用
        sleep(1000)
    end
    -- 卸载处理
    core.unload()
    main_ctx:set_action('脚本停止')
end

-------------------------------------------------------------------------------------
-- 定时器入口
function on_timer(timer_id)
    -- 分发到脚本管理
    -- core.on_timer(timer_id)
end

function main_test()

    local module_list = {
        import('game/modules/tests'),
    }
    core.set_module_list(module_list)
    core.entry() -- 入口调用
    xxmsg('结束------')
end

-------------------------------------------------------------------------------------
-- 格式化输出
-------------------------------------------------------------------------------------
function xprint(...)
    local args = {...}
    local formatted_args = {}

    for _, v in ipairs(args) do
        -- 根据值的类型来决定如何格式化
        if type(v) == 'number' then
            if v == math.floor(v) then
                -- 整数，以16进制显示，并用括号包围
                table.insert(formatted_args, string.format('(0x%X)', v))
            else
                -- 浮点数，带两位小数，并用括号包围
                table.insert(formatted_args, string.format('(%0.2f)', v))
            end
        elseif type(v) == 'string' then
            -- 字符串，带引号，并用括号包围
            table.insert(formatted_args, string.format('("%s")', v))
        else
            -- 其他类型，直接转换为字符串，并用括号包围
            table.insert(formatted_args, '(' .. tostring(v) .. ')')
        end
    end

    print(table.concat(formatted_args, ', '))
end

-------------------------------------------------------------------------------------
-- 答应分割线
-------------------------------------------------------------------------------------
function print_divider(test_name)
    local divider = string.rep("=", 80)
    local title = string.format("=  %s  =", test_name)
    local space_len = (80 - #title) / 2
    local title_line = string.rep(" ", math.floor(space_len)) .. title .. string.rep(" ", math.ceil(space_len))
    print(divider)
    print(title_line)
    print(divider)
end
