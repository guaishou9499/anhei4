------------------------------------------------------------------------------------
-- game/entities/ shop_ent.lua
--
-- 实体示例
--
-- @module       shop_ent
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-05-09
-- @copyright   2023
-- @usage
-- local  shop_ent = import('game/entities/ shop_ent')
------------------------------------------------------------------------------------

-- 模块定义
---@class shop_ent
local shop_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = '1.0.0',
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = '2023-05-09 - Initial release',
    -- 模块名称
    MODULE_NAME = ' shop_ent module',
    -- 只读模式
    READ_ONLY = false,

}

-- 实例对象
local this = shop_ent
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
---@type shop_res
local shop_res = import('game/resources/shop_res')
---@type map_res
local map_res = import('game/resources/map_res')
---@type actor_ent
local actor_ent = import('game/entities/actor_ent')
---@type map_ent
local map_ent = import('game/entities/map_ent')
---@type equip_res
local equip_res = import('game/resources/equip_res')
---@type equip_ent
local equip_ent = import('game/entities/equip_ent')
---@type user_set_ent
local user_set_ent = import('game/entities/user_set_ent')
------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function shop_ent.super_preload()

end

-- 交易
function shop_ent.shop_out()
    shop_ent.sell_item()

    if local_player:level() > 45 then
        shop_ent.repair_item()

    end
    shop_ent.cun_item()
end








-- 获取附近的商人信息
shop_ent.get_near_shop_info = function(shop_name)
    local ret_x, ret_y, ret_z = 0, 0, 0
    local ret_c_name, ret_e_name = '', ''
    --  local area_id = game_unit.get_curr_area_id()
    local map_name = '扎宾泽特'
    local ret_map_id = 673509
    --if area_id == 445553 then
    --    map_name = '基奥瓦沙'
    --elseif area_id == 216295 then
    --    map_name = '凯·巴杜'
    --    ret_map_id = 216295
    --elseif area_id == 673509 then
    --    map_name = '扎宾泽特'
    --    ret_map_id = 673509
    --elseif area_id == 747179 then
    --    map_name = '吉·库尔'
    --    ret_map_id = 747179
    --elseif area_id == 486744 then
    --    map_name = '塞瑞加'
    --    ret_map_id = 486744
    --end
    shop_name = shop_name or '武器商人'
    local shop_info = shop_res[map_name][shop_name]
    if not table.is_empty(shop_info) then
        ret_x, ret_y, ret_z = shop_info.x, shop_info.y, shop_info.z
        ret_c_name, ret_e_name = shop_info.c_name, shop_info.e_name
    end
    return ret_x, ret_y, ret_z, ret_c_name, ret_e_name, ret_map_id
end

-- 出售
function shop_ent.sell_item()
    local x, y, z, shop_c_name, shop_e_name, map_id = shop_ent.get_near_shop_info('武器商人')
    while decider.is_working() do
        if shop_c_name == '' then
            break
        end
        if not shop_ent.is_sell_equip() then
            break
        end
        if map_id == game_unit.get_curr_area_id() then
            local dist = actor_unit.dist2(x, y, z)
            if dist <= 3 then
                shop_ent.sell_equip(shop_c_name)
            else
                trace.output('出售》》移动' .. shop_c_name .. '中')
                map_ent.build_nav_map(x, y, z)
            end
        else
            actor_unit.teleport(map_id)
            for i = 1, 30 do
                trace.output('出售》》传送' .. tostring(map_res.ID_TO_NAME[map_id]) .. '中')
                if map_id == game_unit.get_curr_area_id() then
                    break
                end
                decider.sleep(500)
            end
        end
        decider.sleep(2000)
    end
end




-- 出售物品
function shop_ent.sell_equip(shop_name)
    local vendor_npc = actor_ent.get_actor_info_by_c_name(shop_name)
    if table.is_empty(vendor_npc) then
        return false, '查询不到npc信息'
    end
    if actor_unit.dist2(vendor_npc.x, vendor_npc.y, vendor_npc.z) > 3 then
        return false, '与npc距离过远'
    end
    skill_unit.click_actor(vendor_npc.cid)
    decider.sleep(2000)
    -- 获取出售物品信息
    local sell_list = item_unit.list(0)
    local save_list = equip_res.SAVE_EQUIP
    if user_set_ent['小号等级'] ~= 0 and local_player:level() >= user_set_ent['小号等级'] then
        save_list = equip_res.QZ_SAVE_EQUIP
    end
    for i = 1, #sell_list do
        if not equip_ent.get_equip_attr_by_equip_info(sell_list[i]) then
            local is_sell = true
            for j = 1, #save_list do
                if string.find(sell_list[i].title, save_list[j]) then
                    is_sell = false
                end
            end
            if is_sell then
                -- 获取当前金币
                local currency = actor_unit.get_currency(0)
                item_unit.sell_item(sell_list[i].ptr)
                trace.output('出售' .. sell_list[i].c_name)
                decider.sleep(100)
                -- 通过金币变化判断是否出售成功
                for j = 1, 30 do
                    if currency ~= actor_unit.get_currency(0) then
                        break
                    end
                    decider.sleep(100)
                end
                -- 未交易成功
                if currency == actor_unit.get_currency(0) then
                    break
                end
            end
        end
    end
end


---- 出售物品
--function shop_ent.sell_equip(shop_name)
--    local vendor_npc = actor_ent.get_actor_info_by_c_name(shop_name)
--    if table.is_empty(vendor_npc) then
--        return false, '查询不到npc信息'
--    end
--    if actor_unit.dist2(vendor_npc.x, vendor_npc.y, vendor_npc.z) > 3 then
--        return false, '与npc距离过远'
--    end
--    skill_unit.click_actor(vendor_npc.cid)
--    decider.sleep(2000)
--    -- 获取出售物品信息
--    local sell_list = item_unit.list(0)
--    local save_list = equip_res.SAVE_EQUIP
--    for i = 1, #sell_list do
--
--        local equip_type = equip_res.EQUIP_TYPE[sell_list[i].c_name]
--        if not equip_type then
--            xxmsg('测试--[\'' .. sell_list[i].c_name .. '\'] = \'9999\',--' .. sell_list[i].title)
--        else
--            local is_sell = true
--            for j = 1, #save_list do
--                if string.find(sell_list[i].title, save_list[j]) then
--                    is_sell = false
--                end
--            end
--            if is_sell then
--                -- 获取当前金币
--                local currency = actor_unit.get_currency(0)
--                item_unit.sell_item(sell_list[i].ptr)
--                trace.output('出售' .. sell_list[i].c_name)
--                decider.sleep(100)
--                -- 通过金币变化判断是否出售成功
--                for j = 1, 30 do
--                    if currency ~= actor_unit.get_currency(0) then
--                        break
--                    end
--                    decider.sleep(100)
--                end
--                -- 未交易成功
--                if currency == actor_unit.get_currency(0) then
--                    break
--                end
--            end
--        end
--    end
--end

-- 判断是否出售装备
function shop_ent.is_sell_equip()
    local sell_list = item_unit.list(0)
    local save_list = equip_res.SAVE_EQUIP
    if user_set_ent['小号等级'] ~= 0 and local_player:level() >= user_set_ent['小号等级'] then
        save_list = equip_res.QZ_SAVE_EQUIP
    end
    if #sell_list == 0 then
        return false, '出售物品数量为0'
    end
    for i = 1, #sell_list do
        if not equip_ent.get_equip_attr_by_equip_info(sell_list[i]) then
            local is_save_equip = false
            for j = 1, #save_list do
                if string.find(sell_list[i].title, save_list[j]) then
                    is_save_equip = true
                end
            end
            if not is_save_equip then
                return true
            end
        end
    end
    return false
end

-- 判断是否存仓库
function shop_ent.is_cun_cang()
    local sell_list = item_unit.list(0)
    local save_list = equip_res.SAVE_EQUIP
    if user_set_ent['小号等级'] ~= 0 and local_player:level() >= user_set_ent['小号等级'] then
        save_list = equip_res.QZ_SAVE_EQUIP
    end
    if #sell_list == 0 then
        return false, '出售物品数量为0'
    end
    for i = 1, #sell_list do
        if equip_ent.get_equip_attr_by_equip_info(sell_list[i]) then
            return true
        end
        for j = 1, #save_list do
            if string.find(sell_list[i].title, save_list[j]) then
                return true
            end
        end
    end
    return false
end

-- 存仓
function shop_ent.cun_item()
    local x, y, z, shop_c_name, shop_e_name, map_id = shop_ent.get_near_shop_info('储存箱')
    while decider.is_working() do
        if shop_c_name == '' then
            break
        end
        if not shop_ent.is_cun_cang() then
            break
        end
        if map_id == game_unit.get_curr_area_id() then
            local dist = actor_unit.dist2(x, y, z)
            if dist <= 3 then
                shop_ent.cun_equip(shop_c_name)
            else
                trace.output('存仓》移动' .. shop_c_name .. '中')
                map_ent.build_nav_map(x, y, z)
            end
        else
            actor_unit.teleport(map_id)
            for i = 1, 30 do
                trace.output('存仓》传送' .. tostring(map_res.ID_TO_NAME[map_id]) .. '中')
                if map_id == game_unit.get_curr_area_id() then
                    break
                end
                decider.sleep(1000)
            end
        end
        decider.sleep(2000)
    end
end

-- 存物品
function shop_ent.cun_equip(shop_name)
    local vendor_npc = actor_ent.get_actor_info_by_c_name(shop_name)
    if table.is_empty(vendor_npc) then
        return false, '查询不到npc信息'
    end
    if actor_unit.dist2(vendor_npc.x, vendor_npc.y, vendor_npc.z) > 3 then
        return false, '与npc距离过远'
    end
    local item_nums = item_unit.list(24)
    local idx = math.floor(#item_nums / 50)
    skill_unit.click_actor(vendor_npc.cid)
    decider.sleep(2000)
    if idx > 0 then
        item_unit.set_deposit_page(idx)
        decider.sleep(2000)
    end
    -- 获取出售物品信息
    local sell_list = item_unit.list(0)
    local save_list = equip_res.SAVE_EQUIP
    if user_set_ent['小号等级'] ~= 0 and local_player:level() >= user_set_ent['小号等级'] then
        save_list = equip_res.QZ_SAVE_EQUIP
    end
    for i = 1, #sell_list do
        if equip_ent.get_equip_attr_by_equip_info(sell_list[i]) then
            item_unit.move_item(sell_list[i].ptr, 0x18)
            trace.output('存' .. sell_list[i].c_name)
            decider.sleep(1000)
        end
        for j = 1, #save_list do
            if string.find(sell_list[i].title, save_list[j]) then
                item_unit.move_item(sell_list[i].ptr, 0x18)
                trace.output('存' .. sell_list[i].c_name)
                decider.sleep(1000)
            end
        end
    end
end

-- 维修装备
function shop_ent.repair_item()
    local x, y, z, shop_c_name, shop_e_name, map_id = shop_ent.get_near_shop_info('铁匠')
    while decider.is_working() do
        if shop_c_name == '' then
            break
        end
        if not equip_ent.equip_durability() then
            break
        end
        if map_id == game_unit.get_curr_area_id() then
            local dist = actor_unit.dist2(x, y, z)
            if dist <= 3 then
                shop_ent.repair_equip(shop_c_name)
                --  shop_ent.alvage_equip(shop_c_name)
                break
            else
                trace.output('维修》移动' .. shop_c_name .. '中')
                map_ent.build_nav_map(x, y, z)
            end
        else
            actor_unit.teleport(map_id)
            for i = 1, 30 do
                trace.output('维修》传送' .. tostring(map_res.ID_TO_NAME[map_id]) .. '中')
                if map_id == game_unit.get_curr_area_id() then
                    break
                end
                decider.sleep(1000)
            end
        end
        decider.sleep(2000)
    end
end

-- 维修物品
function shop_ent.repair_equip(shop_name)
    local vendor_npc = actor_ent.get_actor_info_by_c_name(shop_name)
    if table.is_empty(vendor_npc) then
        return false, '查询不到npc信息'
    end
    if actor_unit.dist2(vendor_npc.x, vendor_npc.y, vendor_npc.z) > 3 then
        return false, '与npc距离过远'
    end
    skill_unit.click_actor(vendor_npc.cid)
    decider.sleep(2000)
    trace.output('维修身上装备')
    item_unit.repair_all_Item(0)
    decider.sleep(2000)
end

-- 分解物品
function shop_ent.alvage_equip(shop_name)
    local vendor_npc = actor_ent.get_actor_info_by_c_name(shop_name)
    if table.is_empty(vendor_npc) then
        return false, '查询不到npc信息'
    end
    if actor_unit.dist2(vendor_npc.x, vendor_npc.y, vendor_npc.z) > 3 then
        return false, '与npc距离过远'
    end
    skill_unit.click_actor(vendor_npc.cid)
    decider.sleep(2000)
    local sell_list = item_unit.list(0)
    for i = 1, #sell_list do
        local ptr = sell_list[i].ptr
        if actor_unit.get_attr_byid_int(ptr, 0xFFFFFFFF00000160) == 5 then
            item_unit.salvage_item(sell_list[i].ptr, 0x18)
            decider.sleep(500)
        end
    end
end



------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function shop_ent.__tostring()
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
function shop_ent.__newindex(t, k, v)
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
shop_ent.__index = shop_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function shop_ent:new(args)
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
    return setmetatable(new, shop_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return shop_ent:new()

-------------------------------------------------------------------------------------
