
#define CURRENT_DEVICE_REAL_SIZE            [UIScreen mainScreen].bounds.size
#define CUSTOM_ALERT_FRAME                  CGRectMake(160, 300, 320, 200)

#define PP_FIT_TOP_SIZE                     ((CURRENT_DEVICE_REAL_SIZE.height > 500) ? 44.0f : 0.0f)
#define PP_WORDS_FONT_NAME                  @"Chalkduster"

// local data key
#define PP_FIRST_LOG_IN                     @"firstenter"

// string
#define PP_PET_SKILL_SHOW_NODE_NAME         @"petskillshow"
#define PP_ENEMY_SKILL_SHOW_NODE_NAME       @"enemyskillshow"
#define PP_PET_PLAYER_SIDE_NODE_NAME        @"petsidename"
#define PP_ENEMY_SIDE_NODE_NAME             @"enemysidename"

#define PP_BACK_TO_MAIN_VIEW                @"backToMainNotification"
#define PP_BACK_TO_MAIN_VIEW_FIGHTING       @"fightingToBack"
#define PP_GOFORWARD_MENU_DUNGEON_FIGHTING  @"goForwardContent"
#define PP_HURDLE_READY_CONTENT_NAME        @"hurdleReadyContent"
#define PP_HURDLE_PETCHOOSE_CONTENT_NAME    @"petChooseContent"

#define PP_BALL_TYPE_COMBO_NAME             @"comboballname"
#define PP_BALL_TYPE_PET_ELEMENT_NAME       @"petelementball"
#define PP_BALL_TYPE_ENEMY_ELEMENT_NAME     @"enemyelementball"

#define PP_PET_COMBOS_NAME                  @"petcombos"
#define PP_ENEMY_COMBOS_NAME                @"enemycombos"
#define PP_TOUCH_NODE_BALL_NAME             @"touchballnamepet"

#define PP_SKILL_CD_LABEL_NODE_NAME         @"skillcdlabelname"
#define PP_BUFF_ANIMATION_NODE_NAME         @"buffanimationname"

#define PP_GUIDE_CONTENT_NODE_NAME          @"contentNode"

#define PP_SKILL_STATUS_VALID               1
#define PP_SKILL_STATUS_INVALID             0

// tags
#define PP_MENU_START                       1000
#define PP_MENU_COUNT                       1010
#define PP_USER_BUTON_TAG                   1050
#define PP_MENU_BUTON_TAG                   1100
#define PP_PASSNUM_CHOOSE_TABLE_TAG         1200
#define PP_SECONDARY_PASSNUM_BTN_TAG        1220
#define PP_PETS_CHOOSE_BTN_TAG              1300
#define PP_SKILLS_CHOOSE_BTN_TAG            1400
#define PP_SKILLS_VALUE_LAEBEL_TAG          1500
#define PP_ELEMENT_NAME_TAG                 1700
#define PP_BUFF_SHOW_BTN_TAG                1800

// zPosition
#define PPZ_BACK_GROUND             -10000
#define PPZ_BACK_BUTTON             10000

#define PPZ_FIGHT                   1000 // 上方战斗区基准
#define PPZ_FIGHT_BG                1010 // 战斗区背景
#define PPZ_FIGHT_BUFF              1019 // 战斗角色Buff（底层）
#define PPZ_FIGHT_ROLE              1020 // 战斗角色
#define PPZ_FIGHT_BUFF2             1021 // 战斗角色Buff（表层）

#define PPZ_FIGHT_EFFECT_DEF        1030 // 战斗角色防御特效
#define PPZ_FIGHT_EFFECT_ATT        1031 // 战斗角色攻击特效
#define PPZ_FIGHT_EFFECT            1032 // 战斗角色特效（比如技能）

#define PPZ_TABLE                   2000 // 下方弹珠台基准
#define PPZ_TABLE_BG                2010 // 弹珠台背景
#define PPZ_TABLE_BGWALL            2011 // 弹珠台外框
#define PPZ_TABLE_BALL_BUFF         2018 // 弹珠附带的Buff(底层)
#define PPZ_TABLE_BALL_ROLE         2019 // 弹珠里边的内容（人物或者连击内容）
#define PPZ_TABLE_BALL              2020 // 弹珠外圈
#define PPZ_TABLE_BALL_BUFF2        2021 // 弹珠附带的Buff(表层)

#define PPZ_TABLE_BALL_LIGHT        2022 // 弹珠飞奔的火焰
#define PPZ_TABLE_EFFECT            2030 // 弹珠效果（撞击产生的火花）
#define PPZ_TABLE_BUTTON            2040 // 技能按钮

#define PPZ_FLYUP                   3000 // 飞向人物的拳头之类的道具
#define PPZ_NUMBER                  3010 // 飞出的数字
#define PPZ_HINT                    3011 // 文字提示（第几回合等）
#define PPZ_ALERT                   3020 // 弹出框（暂停或者结算界面使用）
#define PPZ_PAUSE                   3030 // 停止（暂停界面使用）
#define PPZ_MESSAGE                 3040 // 停止（暂停界面使用）