-------------------------------------------------------------------------------------
-- -*- coding: utf-8 -*-
--
-- @author:   admin
-- @email:    88888@qq.com
-- @date:     2022-06-30
-- @module:   skill_res
-- @describe: 物品资源
-- @version:  v1.0
--
local pairs = pairs
local string = string
-------------------------------------------------------------------------------------
-- 物品资源
---@class shop_res
local shop_res = {
    -- 基奥瓦沙
    ['基奥瓦沙'] = {
        ['武器商人'] = {
            c_name = '欧兹伦',
            e_name = 'TWN_Frac_Kyovashad_Vendor_Armor',
            x = -1409.0595703125,
            y = 168.30078125,
            z = 101.7705078125,
        },
        ['护甲商人'] = {
            c_name = '洛诺瓦',
            e_name = 'TWN_Frac_Kyovashad_Vendor_Armor',
            x = -1408.849609375,
            y = 170.4384765625,
            z = 101.7705078125,
        },
        ['饰品商人'] = {
            c_name = '伊达尼亚',
            e_name = 'TWN_Frac_Kyovashad_Vendor_Silversmith',
            x = -1394.439453125,
            y = 114.30078125,
            z = 102.0205078125,
        },
        ['铁匠'] = {
            c_name = '基维克',
            e_name = 'TWN_Frac_Kyovashad_Crafter_Blacksmith',
            x = -1407.5498046875,
            y = 177.140625,
            z = 101.455078125,

        },
        ['首饰匠'] = {
            c_name = '克拉西亚',
            e_name = 'TWN_Frac_Kyovashad_Crafter_Jeweler',
            x = -1397.9697265625,
            y = 114.52734375,
            z = 102.0205078125,
        },
        ['秘术师'] = {
            c_name = '德姆彦',
            e_name = 'TWN_Frac_Kyovashad_Crafter_Occultist',
            x = -1379.8798828125,
            y = 113.52734375,
            z = 101.1416015625,
        },
        ['储存箱'] = {
            c_name = '储藏箱',
            e_name = 'Stash',
            x = -1416.7800292969,
            y = 133.36199951172,
            z = 105.28099822998,

        },
    },

    -- 干燥平原
    ['凯·巴杜'] = {
        ['武器商人'] = {
            c_name = '奥德萨拉',
            e_name = 'TWN_Step_KedBardu_Vendor_Weapons',
            x = -866.0048828125,
            y = -977.3212890625,
            z = 12.31640625,
        },
        ['护甲商人'] = {
            c_name = '德尔格',
            e_name = 'TWN_Step_KedBardu_Vendor_Armor',
            x = -876.720703125,
            y = -979.2255859375,
            z = 12.0869140625,
        },
        ['饰品商人'] = {
            c_name = '哈瓦尔',
            e_name = 'TWN_Step_KedBardu_Vendor_Silversmith',
            x = -903.783203125,
            y = -995.8984375,
            z = 21.5390625,
        },
        ['铁匠'] = {
            c_name = '瑟伦嘉',
            e_name = 'TWN_Step_KedBardu_Crafter_Blacksmith',
            x = -872.48828125,
            y = -981.3818359375,
            z = 12.2099609375,
        },
        ['首饰匠'] = {
            c_name = '童格尔',
            e_name = 'TWN_Step_KedBardu_Crafter_Jeweler',
            x = -903.28125,
            y = -989.2333984375,
            z = 21.6015625,
        },
        ['秘术师'] = {
            c_name = '诺敏',
            e_name = 'TWN_Step_KedBardu_Crafter_Occultist',
            x = -929.1298828125,
            y = -980.3515625,
            z = 20.529296875,
        },
        ['储存箱'] = {
            c_name = '储藏箱',
            e_name = 'Stash',
            x = -911.22198486328,
            y = -1017.3900146484,
            z = 21.457099914551,
        },
    },

    -- 哈维泽
    ['扎宾泽特'] = {
        ['武器商人'] = {
            c_name = '卡佩克',
            e_name = 'TWN_Hawe_Zarbinzet_Vendor_Weapons',
            x = -234.787109375,
            y = 403.9599609375,
            z = 51.048828125,
        },
        ['护甲商人'] = {
            c_name = '马特夫',
            e_name = 'TWN_Hawe_Zarbinzet_Vendor_Armor',
            x = -229.1103515625,
            y = 408.6005859375,
            z = 50.7001953125,
        },
        ['饰品商人'] = {
            c_name = '米斯兰',
            e_name = 'TWN_Hawe_Zarbinzet_Vendor_Silversmith',
            x = -208.078125,
            y = 410.83984375,
            z = 50.4482421875,
        },
        ['铁匠'] = {
            c_name = '卡莱尔',
            e_name = 'TWN_Hawe_Zarbinzet_Crafter_Blacksmith',
            x = -232.3916015625,
            y = 412.875,
            z = 50.7802734375,
        },
        ['首饰匠'] = {
            c_name = '阿廖妮',
            e_name = 'TWN_Hawe_Zarbinzet_Crafter_Jeweler',
            x = -203.9609375,
            y = 406.9443359375,
            z = 50.49609375,
        },
        ['秘术师'] = {
            c_name = '弗拉丹',
            e_name = 'TWN_Hawe_Zarbinzet_Crafter_Occultist',
            x = -178.3251953125,
            y = 407.796875,
            z = 49.5419921875,
        },
        ['储存箱'] = {
            c_name = '储藏箱',
            e_name = 'Stash',
            x = -217.74499511719,
            y = 360.05499267578,
            z = 49.022300720215,
        },
    },

    -- 凯基斯坦
    ['吉·库尔'] = {
        ['武器商人'] = {
            c_name = '波佐',
            e_name = 'TWN_Kehj_GeaKul_Vendor_Weapons',
            x = 697.5048828125,
            y = -381.1259765625,
            z = 1.3994140625,
        },
        ['护甲商人'] = {
            c_name = '阿齐德',
            e_name = 'TWN_Kehj_GeaKul_Vendor_Armor',
            x = 702.03125,
            y = -379.6884765625,
            z = 1.3994140625,
        },
        ['饰品商人'] = {
            c_name = '莎拉',
            e_name = 'TWN_Kehj_GeaKul_Vendor_Silversmith',
            x = 669.1181640625,
            y = -386.8994140625,
            z = 1.3994140625,
        },
        ['铁匠'] = {
            c_name = '甘苏',
            e_name = 'TWN_Kehj_GeaKul_Crafter_Blacksmith',
            x = 687.04296875,
            y = -369.900390625,
            z = 1.3994140625,
        },
        ['首饰匠'] = {
            c_name = '卡维',
            e_name = 'TWN_Kehj_GeaKul_Crafter_Jeweler',
            x = 667.4912109375,
            y = -382.5205078125,
            z = 1.3994140625,
        },
        ['秘术师'] = {
            c_name = '米斯拉',
            e_name = 'TWN_Kehj_GeaKul_Crafter_Occultist',
            x = 606.4462890625,
            y = -405.783203125,
            z = 7.4296875,
        },
        ['储存箱'] = {
            c_name = '储藏箱',
            e_name = 'Stash',
            x = 647.63500976562,
            y = -428.46099853516,
            z = 2.1800999641418,
        },
    },

    -- 索伦格
    ['塞瑞加'] = {
        ['武器商人'] = {
            c_name = '碧莎',
            e_name = 'TWN_Scos_Cerrigar_Vendor_Weapons',
            x = -1652.9892578125,
            y = -622.1455078125,
            z = 37.888671875,
        },
        ['护甲商人'] = {
            c_name = '阿林',
            e_name = 'TWN_Scos_Cerrigar_Vendor_Armor',
            x = -1658.08984375,
            y = -619.69140625,
            z = 37.841796875,
        },
        ['饰品商人'] = {
            c_name = '艾尔巴特',
            e_name = 'TWN_Scos_Cerrigar_Vendor_Silversmith',
            x = -1676.599609375,
            y = -584.64453125,
            z = 37.8583984375,
        },
        ['铁匠'] = {
            c_name = '赛蒂斯',
            e_name = 'TWN_Scos_Cerrigar_Crafter_Blacksmith',
            x = -1649.349609375,
            y = -627.68359375,
            z = 37.9619140625,
        },
        ['首饰匠'] = {
            c_name = '瑞林',
            e_name = 'TWN_Scos_Cerrigar_Crafter_Jeweler',
            x = -1676.509765625,
            y = -581.177734375,
            z = 37.8623046875,
        },
        ['秘术师'] = {
            c_name = '奥伊芙妮',
            e_name = 'TWN_Scos_Cerrigar_Crafter_Occultist',
            x = -1684.2294921875,
            y = -602.52734375,
            z = 37.6484375,
        },
        ['储存箱'] = {
            c_name = '储藏箱',
            e_name = 'Stash',
            x = -1647.5500488281,
            y = -660.53100585938,
            z = 41.115200042725,
        },
    },
}
local this = shop_res

-------------------------------------------------------------------------------------
-- 返回对象
return shop_res

-------------------------------------------------------------------------------------
--    ['塞瑞加'] = {
--        ['武器商人'] = {

--        },
--        ['护甲商人'] = {

--        },
--        ['饰品商人'] = {
--
--        },
--        ['铁匠'] = {

--        },
--        ['首饰匠'] = {
--
--        },
--        ['秘术师'] = {
--
--        },
--        ['储存箱'] = {
--
--        },
--    },