-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   core
-- @email:    88888@qq.com 
-- @date:     2021-07-05
-- @module:   example
-- @describe: 示例代码模块
-- @version:  v1.0
--

local VERSION = '20210705' -- version history at end of file
local AUTHOR_NOTE = "-[20210705]-"
---@class example
local example = {  
	VERSION      = VERSION,
	AUTHOR_NOTE  = AUTHOR_NOTE,
}

local this = example

local config_client = import('base/config')
local monster_res = import('game/resources/monster_res')

function example.test_ui_unit()
   -- 输出分割线
   print_divider('ui_unit')

   -- 查找UI控件 最后一个参数: 是否显示
   -- local btn_enter_game = ui_unit.get_control_byeid(0x48801B7B648303CF, 0xDD39E402BC4D0BC2, true)
   -- xprint(btn_enter_game)
   -- if btn_enter_game ~= 0 then
   --     --xprint( ui_unit.btn_click(btn_enter_game) )
   -- end

   -- local temp = ui_unit.get_control_byeid(0xB5D0140FACEA6BCC, 0x6107F6AF5B7D3FFD, false)
   -- xprint(temp)、
   -- 显示状态
   -- xprint(mem_unit.rm_byte(temp + 0x1C))
   -- 获取文本
   -- xprint(ui_unit.get_text(temp))

   -- -- 获取消息框架标题
   -- xprint(ui_unit.get_msgbox_title())
   -- -- 获取消息框内容
   -- xprint(ui_unit.get_msgbox_content())
   -- -- 点击接受
   -- xprint(ui_unit.msgbox_accept())

   --login_unit.enter_game()

   --local btn_enter_game = ui_unit.get_control_byeid(0x48801B7B648303CF, 0xDD39E402BC4D0BC2, true)

   -- 直接设置xy位置
   --game_unit.set_mouse_cd(x, y)
   --游戏里面的坐标 转换成 屏幕坐标
   -- local x, y = game_unit.world_to_screen(x, y, z)

   --    .def(&MoveCursor,               xorstr("move_cursor"))
   --    .def(&DoLClick,                 xorstr("lclick"))
   --    .def(&DoRClick,                 xorstr("rclick"))
   -- 点击
   --main_ctx:lclick(327, 610)
end

-------------------------------------------------------------------------------------
-- skill_unit 示例
-------------------------------------------------------------------------------------
function example.test_skill_unit()
   -- 输出分割线
   print_divider('skill_unit')

   -- 获取列表(-1、0)
   local list = skill_unit.list(-1)
   xprint(#list)
   print_r(list)

   -- 技能状态
   -- skill_unit.get_skill_status(skill_id)
   -- 获取快捷栏技能(0 - 5)
   -- skill_unit.get_shorcut_skill_id(0)
   -- 设置快捷栏技能
   -- skill_unit.set_shortcut_skill(skill_id, 2);
   -- 使用技能
   -- target_cid = 0 -- 这个不为零会忽略 x,y,z
   -- skill_unit.use_skill_target(skill_id, target_cid, x, y, z)
end


-------------------------------------------------------------------------------------
-- item_unit 示例
-------------------------------------------------------------------------------------
function example.test_item_unit()
   -- 输出分割线
   print_divider('item_unit')

   -- 获取列表(装备、身上装备、消耗、等所有物品; -1、其它值)
   --    -- 4 头盔
   --    -- 5 胸甲
   --    -- 8 主武器
   --    -- 9 副武器
   --    -- 11 中左武器
   --    -- 12 中右武器
   --    -- 13 手套
   --    -- 14 腰甲
   --    -- 15 长靴
   --    -- 16 1戒指
   --    -- 17 2戒指
   --    -- 18 项链


   --    --
   --    --attrib_list
   --    --set_deposit_page
   --    --get_itemid_bypos
   --    --repair_all_Item
   --    --batch_salvage_item
   --    --move_item
   --    --get_item_bypos
   --    --list
   --    --repair_Item
   --    --salvage_item
   --    --get_item_title
   --    --get_attr_float
   --    --new
   --    --debug
   --    --get_attr_byte

   local list = item_unit.list(-1)
   xprint(#list)
   print_r(list)
   for i = 1, #list do
      local item_info = list[i]
      xxmsg(string.format('c_name[%s] e_name[%s] cid[%s] x[%s] y[%s] ptr[%s] type[%s] title[%s]',
              tostring(item_info.c_name),     -- 装备名
              tostring(item_info.e_name),     -- 英文名字
              tostring(item_info.cid),        -- cid
              tostring(item_info.x),
              tostring(item_info.y),
              tostring(item_info.ptr),
              tostring(item_info.type),
              tostring(item_info.title)       -- 全名
      ))
   end

   local item =  1723876620224
   local list = actor_unit.attrib_list(item)
   xprint(#list)
   print_r(list)
   -- 判断品质 （先祖 = 2，神圣 = 1，普通 = 0）
   --actor_unit.get_attr_byid_int(ptr, 0xFFFFFFFF00000162)
   -- 判断质量 （暗金 = 6，传奇 = 5）
   --actor_unit.get_attr_byid_int(ptr, 0xFFFFFFFF00000160)
   -- 出售装备
   -- item_unit.sell_item(item_prt)

   -- 不清楚
   --item_unit.get_attr_int()
   --item_unit.use_equip()


end
--
-- test_mastery_unit
function example.test_near_actor_unit2()
   local tabe = {}
   local list = actor_unit.list(-1)
   for i = 1, #list do
      local actor_info = list[i]
      if actor_info.type1 == 255 and actor_info.type2 == -1 and actor_info.type3 == 16 and actor_info.type4 > 0 and actor_info.max_health > 1 and actor_info.health > 0 and actor_info.status == 32 then


         if not monster_res.is_monster(actor_info.c_name) then
         --   xxmsg(actor_info.c_name)
            --
            xxmsg(string.format('[\'%s\'] = true,',actor_info.c_name))
         end
      end
   end
end

function example.test_near_actor_unit3()
   local tabe = {}
   local list = actor_unit.list(-1)
   for i = 1, #list do
      local actor_info = list[i]--pe1[255] type2[1] type3[16] type4[0]
      if actor_info.type1 == 255 and actor_info.type2 == 1 and actor_info.type3 == 16 and actor_info.type4 == 0 and actor_info.interact then
         tabe[#tabe + 1] = actor_info
      end
   end
   table.sort(tabe, function(a, b)
      return a.distance < b.distance
   end)
   return tabe[1] or {}
end


-------------------------------------------------------------------------------------
-- test_mastery_unit
function example.test_near_actor_unit()
   local list = actor_unit.list(-1)
   for i = 1, #list do
      local actor_info = list[i]

         xxmsg(string.format('max_health[%s] health[%s] status[%s] c_name[%s]  e_name[%s]  level[%s] cid[%s] aid[%s] x[%s] y[%s] z[%s] ptr1[%s] ptr2[%s] type1[%s] type2[%s] type3[%s] type4[%s] distance[%s] talk_id[%s] interact[%s]',
                 tostring(actor_info.max_health), -- 最大血量
                 tostring(actor_info.health),     -- 当前血量
                 tostring(actor_info.status),     -- 状态
                 tostring(actor_info.c_name),     -- 中文名字
                 tostring(actor_info.e_name),     -- 英文名字
                 tostring(actor_info.level),      -- 等级
                 tostring(actor_info.cid),        -- cid
                 tostring(actor_info.aid),        -- aid
                 tostring(actor_info.x),
                 tostring(actor_info.y),
                 tostring(actor_info.z),
                 tostring(actor_info.ptr1),
                 tostring(actor_info.ptr2),
                 tostring(actor_info.type1),
                 tostring(actor_info.type2),
                 tostring(actor_info.type3),
                 tostring(actor_info.type4),
                 tostring(actor_info.distance),
                 tostring(actor_info.talk_id),
                 tostring(actor_info.interact)
         ))

   end
end

-------------------------------------------------------------------------------------
-- actor_unit 示例
-------------------------------------------------------------------------------------
function example.test_actor_unit()
   -- 输出分割线
   print_divider('actor_unit')

   -- 获取列表(-1所有、1玩家、4地面物品)
   local list = actor_unit.list(-1)
   xprint(#list)
   print_r(list)

   -- 获取对象属性值(其它属性id有待整理)
   local ptr = 0
   actor_unit.get_attr_byid_int(ptr, 0xFFFFFFFF00000025)  -- 获取对象等级
   actor_unit.get_attr_byid_float(ptr, 0xFFFFFFFF0000005E) -- 获取对象血量百分比

   -- 角色数据
   -- 角色cid
   -- local_player:cid()
   -- 角色aid
   -- local_player:aid()
   -- 对话id
   -- local_player:talk_id()
   -- 英文名
   -- local_player:e_name()
   -- 中文名
   -- local_player:c_name()
   -- 等级
   -- local_player:level()
   -- 状态
   -- local_player:status()
   -- 血量百分比
   -- local_player:health()
   -- 生命值
   -- local_player:hp()
   -- 最大血量
   -- local_player:max_hp()
   -- 当前精魄
   -- local_player:spirits()
   -- 最大精魄
   -- local_player:max_spirits()
   -- 是否在移动中
   -- local_player:is_move()
   -- x 轴
   -- local_player:cx()
   -- y 轴
   -- local_player:cy()
   -- z 轴
   -- local_player:cz()
   -- 角色离xyz距离
   -- local_player:dist_xyz(x, y, z)
   -- 角色离xyz距离
   -- actor_unit.dist2(x, y, z)


   -- 检测对象是否存在
   -- actor_unit.get_object_by_id(cid)
   -- 走路 z坐标可以为0
   -- actor_unit.walk_to(tx, ty, tz)
   -- 拾取
   -- actor_unit.pick_item(aid)
end

function example.test_party_unit()
   --party_unit.member_list()
   --
   --2这个是接受组队 按钮
   --ui_unit.get_control_byeid(0x02DEA0631BA49D96, 0xDFBE50774B5B6B62, true)
end





-------------------------------------------------------------------------------------
-- game_unit 示例
-------------------------------------------------------------------------------------
function example.test_game_unit()
   -- 输出分割线
   print_divider('game_unit')

   -- 根据对象CID或AID取对象指针
   local cid = 0x00080001
   local aid = 0x00100001
   local actor = game_unit.get_actor_byid(aid)
   local object = game_unit.get_object_byid(cid)
   xprint(actor, object)

   -- 当前地图ID与当前角色CID
   local curr_map_id = game_unit.get_curr_map_id()
   local curr_player_cid = game_unit.get_curr_player_cid()
   xprint(curr_map_id, curr_player_cid)

   -- 取技能名称
   local skill_id = 0x0000000000102955
   local e_name = game_unit.get_element_name(0x1D, skill_id)
   local name_id = game_unit.get_name_id(0x2A, e_name, 'Power')
   local c_name = game_unit.get_name_byid(name_id)
   xprint(e_name, name_id, c_name)

   -- 当前地图名称
   -- game_unit.get_curr_area_name()
   -- 获取当前地图id
   -- game_unit.get_curr_area_id()
   -- 判断是否障碍
   --game_unit.is_obstacle(cx,cy,cz)
   -- 游戏状态
   --game_unit.get_game_status_ex()
   --game_unit.get_game_status()
   -- 地图类型
   --game_unit.get_curr_map_type()

   -- 不清楚
   --world_to_screen
   -- 不清楚
   --debug
   --set_mouse_cd
   --get_element_name
   --get_name_ptr

end

-------------------------------------------------------------------------------------
-- dkjson 示例
-------------------------------------------------------------------------------------
function example.test_dkjson()
   -- 编码测试
   local encode = function()
      print('dkjson.encode test.')
      local tbl = {
         animals = { 'dog', 'cat', 'aardvark' },
         instruments = { 'violin', 'trombone', 'theremin' },
         bugs = dkjson.null,
         trees = nil
      }
      local str = dkjson.encode(tbl, { indent = true })
      print(str)
   end
   -- 解码测试
   local decode = function()
      print('dkjson.decode test.')
      local str = [[
        {
            "numbers": [ 2, 3, -20.23e+2, -4 ],
            "currency": "\u20AC"
        }
        ]]
      local obj, pos, err = dkjson.decode(str, 1, nil)
      if err then
         print("Error:", err)
      else
         print("currency", obj.currency)
         for i = 1, #obj.numbers do
            print(obj.numbers[i])
         end
      end
   end
   encode()
   decode()
end

-------------------------------------------------------------------------------------
-- cjson 示例
-------------------------------------------------------------------------------------
function example.test_cjson()
   local my_json = [[{"my_array":[]}]]
   local t = cjson.decode(my_json)
   print_r(t)
   cjson.encode(t)

   cjson.decode_array_with_array_mt(true)
   local my_json = [[{"my_array":[]}]]
   local t = cjson.decode(my_json)
   print_r(t)
   print(cjson.encode(t))
end

-------------------------------------------------------------------------------------
-- redis 示例
-------------------------------------------------------------------------------------
function example.test_redis()
    --local trans_size = 0
    --local start_time = os.clock()
    --for i = 1, 1000
    --do
    --    local data = utils.random_string(math.random(0x100, 0x1000))
    --    trans_size = trans_size + #data
    --    main_ctx:redis_set_string('TEST:AA' .. i, data)
    --    local result = main_ctx:redis_get_string('TEST:AA' .. i)
    --    if not result then
    --        print(i)
    --        break
    --    end
    --end
    --print('use timer:' .. os.clock() - start_time)
    --print('send bytes:' .. trans_size)

   print(main_ctx:redis_get_string('TEST:AA1'))
   print(main_ctx:redis_exists('TEST:AA1'))
   print(main_ctx:redis_set_expire('TEST001', 60))
   print(main_ctx:redis_delete('TEST001', 60))
end

-------------------------------------------------------------------------------------
-- 实例化新对象

function example.__tostring()
    return "mir4 example package"
 end

example.__index = example

function example:new(args)
   local new = { }

   if args then
      for key, val in pairs(args) do
         new[key] = val
      end
   end

   -- 设置元表
   return setmetatable(new, example)
end

-------------------------------------------------------------------------------------
-- 返回对象
return example:new()

-------------------------------------------------------------------------------------