------------------------------------------------------------------------------------
-- game/resources/ui_res.lua
--
--
--
-- @module      ui_res
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-03-22
-- @copyright   2023
-- @usage
-- local ui_res = import('game/resources/ui_res')
------------------------------------------------------------------------------------
local ui_res = {
    UI_LIST = {
        { title = '网络连接已中断', content = '游戏连接已断开: 客户端已失去服务器连接。', func = ui_unit.msgbox_accept },
        { title = '离开小队', content = '当你离开该小队时，你将失去所有部分完成的地下城、要塞或剧情任务的进度。', func = ui_unit.msgbox_accept },
        { title = '警告！', content = '该操作已取消。(代码300010)', func = function() main_ctx:end_game() end }
    },
}

-- 自身模块
local this = ui_res

-------------------------------------------------------------------------------------
-- 返回实例对象
-- 
-- @export
return ui_res

-------------------------------------------------------------------------------------