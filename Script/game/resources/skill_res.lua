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
---@class skill_res
local skill_res = {
    -- 通用技能
    GENERAL = {['闪避'] = { status = 0, name = '闪避' },},
    -- 野蛮人
    ['野蛮人'] = {
        -- 基础技能
        [6] = {
            ['突刺打击'] = { status = 0, name = '突刺打击',monster = true },
            ['猛击'] = { status = 0, name = '猛击' },
            ['狂乱'] = { status = 0, name = '狂乱' },
            ['剥皮'] = { status = 0, name = '剥皮' },
        },
        -- 核心技能
        [5] = {
            ['旋风斩'] = { status = 0, name = '旋风斩' },
            ['先祖之锤'] = { status = 0, name = '先祖之锤',need_mp = true,monster = true },
            ['扬石飞沙'] = { status = 0, name = '扬石飞沙' },
            ['双重横扫'] = { status = 0, name = '双重横扫' },
            ['痛割'] = { status = 0, name = '痛割' },
        },
        -- 防御技能
        [4] = {
            ['大地践踏'] = { status = 0, name = '大地践踏' },
            ['集结呐喊'] = { status = 0, name = '集结呐喊' },
            ['钢铁之肤'] = { status = 0, name = '钢铁之肤' },
            ['挑战怒吼'] = { status = 0, name = '挑战怒吼' },
        },
        -- 搏斗技能
        [3] = {
            ['踢击'] = { status = 0, name = '踢击' },
            ['战吼'] = { status = 0, name = '战吼' },
            ['冲锋'] = { status = 0, name = '冲锋' },
            ['腾空斩'] = { status = 0, name = '腾空斩' },
        },
        -- 武器精通技能
        [2] = {
            ['割裂'] = { status = 0, name = '割裂' },
            ['钢铁之握'] = { status = 0, name = '钢铁之握' },
            ['死亡重击'] = { status = 0, name = '死亡重击' },

        },
        -- 武器精通技能
        [1] = {
            ['狂战士之怒'] = { status = 0, name = '狂战士之怒' },
            ['钢铁漩涡'] = { status = 0, name = '钢铁漩涡' },
            ['先祖召唤'] = { status = 0, name = '先祖召唤' },
        },
    },
    -- 死灵技能
    ['死灵法师'] = {
        -- 基础技能
        [6] = {
            ['收割'] = { status = 0, name = '收割' },
            ['分解'] = { status = 0, name = '分解' },
            ['出血'] = { status = 0, name = '出血' },
            ['白骨碎片'] = { status = 0, name = '白骨碎片' },
        },
        -- 核心技能
        [5] = {
            ['血矛'] = { status = 0, name = '血矛', need_mp = true },
            ['血涌'] = { status = 0, name = '血涌', need_mp = true },
            ['枯萎'] = { status = 0, name = '枯萎', need_mp = true },
            ['挥斩'] = { status = 0, name = '挥斩', need_mp = true },
            ['骨矛'] = { status = 0, name = '骨矛', need_mp = true },
        },
        -- 亡骸和骇术
        [4] = {
            ['血雾'] = { status = 0, name = '血雾', baoming = 0.4 },
            ['邪爆'] = { status = 256, name = '邪爆', need_hg = true, cd = 1 },
            ['骨牢'] = { status = 0, name = '骨牢' },
            ['亡骸卷须'] = { status = 256, name = '亡骸卷须', need_hg = true },
            ['骨灵'] = { status = 0, name = '骨灵', need_mp = true },
        },
        -- 诅咒
        [3] = {
            ['铁处女'] = { status = 0, name = '铁处女', cd = 10 },
            ['衰老'] = { status = 0, name = '衰老', cd = 10 },
        },
        -- 终极
        [2] = {
            ['亡者大军'] = { status = 0, name = '亡者大军' },
            ['白骨风暴'] = { status = 0, name = '白骨风暴' },
            ['血潮'] = { status = 0, name = '血潮' },
        },
        [1] = {
            ['复生骸骨'] = { status = 384, name = '复生骸骨', need_hg = true },
            ['傀儡'] = { status = 0, name = '傀儡' },
        },
    },
}
local this = skill_res

-------------------------------------------------------------------------------------
-- 返回对象
return skill_res

-------------------------------------------------------------------------------------



