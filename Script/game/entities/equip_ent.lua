------------------------------------------------------------------------------------
-- game/entities/equip_ent.lua
--
-- 实体示例
--
-- @module      equip_ent
-- @author      admin
-- @license     MIT
-- @release     v1.0.0 - 2023-05-09
-- @copyright   2023
-- @usage
-- local equip_ent = import('game/entities/equip_ent')
------------------------------------------------------------------------------------

-- 模块定义
---@class equip_ent
local equip_ent = {
    -- 模块版本 (主版本.次版本.修订版本)
    VERSION = '1.0.0',
    -- 作者备注 (更新日期 - 更新内容简述)
    AUTHOR_NOTE = '2023-05-09 - Initial release',
    -- 模块名称
    MODULE_NAME = 'equip_ent module',
    -- 只读模式
    READ_ONLY = false,
}

-- 实例对象
local this = equip_ent
-- 日志模块
local trace = trace
-- 决策模块
local decider = decider
local table = table
local item_unit = item_unit
local import = import
local common = common
---@type equip_res
local equip_res = import('game/resources/equip_res')
---@type user_set_ent
local user_set_ent = import('game/entities/user_set_ent')

------------------------------------------------------------------------------------
-- [事件] 预载函数(重载脚本)
------------------------------------------------------------------------------------
function equip_ent.super_preload()

end

-- 通过装备类型获取装备所需要的属性
function equip_ent.get_equip_need_attr_by_type(equip_type)
    local manda_attr, pre_attr = {}, {}
    local equip_need_attr = equip_res.EQUIP_ATTR['野蛮人'][equip_type]
    if equip_need_attr then
        manda_attr = equip_need_attr.manda_attr
        pre_attr = equip_need_attr.pre_attr
    end
    return manda_attr, pre_attr
end



-- 通过装备信息获取装备属性
function equip_ent.get_equip_attr_by_equip_info(equip_info)
    -- 装备指针
    local equip_ptr = equip_info.ptr
    local equip_type = equip_res.get_eqyip_type_by_e_name(equip_info.e_name)
    xxmsg('保留传奇装备'..tostring(user_set_ent['保留传奇装备']))
    if user_set_ent['保留传奇装备'] == 1 and actor_unit.get_attr_byid_int(equip_ptr, equip_res.tItemInfo['物品品级'].ID) == 5 then
        return true
    end
    if equip_type == '' then
        xxmsg('装备类型无法确认' .. equip_info.e_name)
        return false
    end
    if actor_unit.get_attr_byid_int(equip_ptr,equip_res.tItemInfo['物品强度'].ID) <= 720 then
        return false
    end
    local manda_attr, pre_attr = equip_ent.get_equip_need_attr_by_type(equip_type)
    if table.is_empty(manda_attr) and table.is_empty(pre_attr) then
       return false
    end
    -- 判断物品品质是否为先祖
    if actor_unit.get_attr_byid_int(equip_ptr, equip_res.tItemInfo['物品质量'].ID) < 1 then
        return false
    end
    if actor_unit.get_attr_byid_int(equip_ptr, equip_res.tItemInfo['物品品级'].ID) < 4 then
        return false
    end

    for i = 1, #manda_attr do
        local attr_info = equip_res.tItemInfo[manda_attr[i]]
        if attr_info then
            if attr_info.int then
                local attr_id = actor_unit.get_attr_byid_int(equip_ptr, attr_info.ID)
                if attr_id <= 0 then
                    return false
                end
            elseif attr_info.float then
                local attr_id = actor_unit.get_attr_byid_float(equip_ptr, attr_info.ID)
                if attr_id <= 0 then
                    return false
                end
                if equip_type == '双手剑' and manda_attr[i] == '暴击伤害' then
                    if attr_id <= 0.35 then
                        return false
                    end
                elseif equip_type == '剑' and manda_attr[i] == '暴击伤害' then
                    if attr_id <= 0.175 then
                        return false
                    end
                end
            else
                return false
            end
        else
            return false
        end
    end
    -- 判断优先属性数量
    local num = #manda_attr
    for i = 1, #pre_attr do
        local attr_info = equip_res.tItemInfo[pre_attr[i]]
        if attr_info then
            if attr_info.int then
                local attr_id = actor_unit.get_attr_byid_int(equip_ptr, attr_info.ID)
                if attr_id > 0 then
                    num = num + 1
                end
            elseif attr_info.float then
                local attr_id = actor_unit.get_attr_byid_float(equip_ptr, attr_info.ID)
                if attr_id > 0 then
                    num = num + 1
                end
            end
        end
    end
    if num < 2 then
        return false
    end
    return true
end

-- 获取指定装备信息
function equip_ent.get_equip_info_by_ptr(ptr)
    local ret_t = {}
    local equip_list = equip_ent.get_bag_equip_info()
    for i = 1, #equip_list do
        if equip_list[i].ptr == ptr then
            ret_t = equip_list[i]
            break
        end
    end
    return ret_t
end

-- 通过prt获取装备信息
function equip_ent.get_bag_equip_info()
    local ret_t = {}
    local list = item_unit.list(0)
    for i = 1, #list do
        local equip_info = list[i]
        local tem_t = {
            -- 最大血量
            type = equip_info.type,
            -- 当前血量
            x = equip_info.x,
            -- 状态
            y = equip_info.status,
            -- 中文名称
            title = equip_info.title,
            -- 英文名称
            ptr = equip_info.ptr,
            -- 等级
            e_name = equip_info.e_name,
            -- id
            talk_id = equip_info.talk_id,
            -- aid
            cid = equip_info.cid,
            -- X坐标
            c_name = equip_info.c_name,
        }
        table.insert(ret_t, tem_t)
    end
    return ret_t

end

-- 判断装备耐久
function equip_ent.equip_durability()
    local equip_list = {
        { '头盔', 4 },
        { '胸甲', 5 },
        { '主武器', 8 },
        { '副武器', 9 },
        { '中左武器', 11 },
        { '中右武器', 12 },
        { '手套', 13 },
        { '腰甲', 14 },
        { '长靴', 15 },
        { '戒指上', 16 },
        { '戒指下', 17 },
        { '护符', 18 },
    }
    for i = 1, #equip_list do
        local equip_info = item_unit.list(equip_list[i][2])[1]
        if equip_info and not table.is_empty(equip_info) then
            local equip_ptr = equip_info.ptr
            local attr = equip_res.tItemInfo['装备磨损度'].ID
            local attr_id = actor_unit.get_attr_byid_int(equip_ptr, attr)
            local attrib_list = actor_unit.attrib_list(equip_ptr)
            for j = 1, #attrib_list do
                if attrib_list[j].int == attr_id then
                    if attrib_list[j].float < 0.8 then
                        return true
                    end
                end
            end
        end
    end
    return false
end


------------------------------------------------------------------------------------
-- [内部] 将对象转换为字符串
--
-- @local
-- @treturn      string                     模块名称
------------------------------------------------------------------------------------
function equip_ent.__tostring()
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
function equip_ent.__newindex(t, k, v)
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
equip_ent.__index = equip_ent

------------------------------------------------------------------------------------
-- [构造] 创建一个新的实例
--
-- @local 
-- @tparam       table     args             可选参数，用于初始化新实例
-- @treturn      table                      新创建的实例
------------------------------------------------------------------------------------
function equip_ent:new(args)
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
    return setmetatable(new, equip_ent)
end

-------------------------------------------------------------------------------------
-- 返回实例对象
-------------------------------------------------------------------------------------
return equip_ent:new()

-------------------------------------------------------------------------------------
