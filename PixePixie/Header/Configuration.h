
#define CurrentDeviceRealSize   [UIScreen mainScreen].bounds.size
#define CustomAlertFrame        CGRectMake(160.0f, 300.0f, 320.0f, 200.0f)

#define PP_FIT_TOP_SIZE     ((CurrentDeviceRealSize.height > 500) ? 44.0f : 0.0f)
#define PP_FIRST_LOG_IN     @"firstenter"
#define PP_WORDS_FONT_NAME  @"Chalkduster"

// string
#define PP_PET_SKILL_SHOW_NODE_NAME     @"petskillshow"
#define PP_ENEMY_SKILL_SHOW_NODE_NAME   @"enemyskillshow"
#define PP_PET_PLAYER_SIDE_NODE_NAME    @"petsidename"
#define PP_ENEMY_SIDE_NODE_NAME         @"enemysidename"

#define PP_BACK_TO_MAIN_VIEW                @"backToMainNotification"
#define PP_BACK_TO_MAIN_VIEW_FIGHTING       @"fightingToBack"
#define PP_GOFORWARD_MENU_DUNGEON_FIGHTING  @"goForwardContent"
#define PP_HURDLE_READY_CONTENT_NAME        @"hurdleReadyContent"
#define PP_HURDLE_PETCHOOSE_CONTENT_NAME    @"petChooseContent"

#define PP_BALL_TYPE_COMBO_NAME         @"comboballname"
#define PP_BALL_TYPE_PET_ELEMENT_NAME   @"petelementball"
#define PP_BALL_TYPE_ENEMY_ELEMENT_NAME @"enemyelementball"

#define PP_PET_COMBOS_NAME      @"petcombos"
#define PP_ENEMY_COMBOS_NAME    @"enemycombos"
#define PP_TOUCH_NODE_BALL_NAME @"touchballnamepet"

#define PP_SKILL_CD_LABEL_NODE_NAME @"skillcdlabelname"
#define PP_BUFF_ANIMATION_NODE_NAME @"buffanimationname"

// tags
#define PP_MENU_START 0
#define PP_MENU_COUNT 5

#define PP_USER_BUTON_TAG               50
#define PP_MENU_BUTON_TAG               100
#define PP_PASSNUM_CHOOSE_TABLE_TAG     200
#define PP_SECONDARY_PASSNUM_BTN_TAG    220
#define PP_PETS_CHOOSE_BTN_TAG          300
#define PP_SKILLS_CHOOSE_BTN_TAG        400
#define PP_SKILLS_VALUE_LAEBEL_TAG      500
#define PP_ELEMENT_NAME_TAG             700
#define PP_BUFF_SHOW_BTN_TAG            800
// zPosition

#define PP_BACK_BUTTON_ZPOSITION 100

#define PPZ_FIGHT               1000
#define PPZ_FIGHT_BG            1010
#define PPZ_FIGHT_ROLE          1020
#define PPZ_FIGHT_BUFF          1019
#define PPZ_FIGHT_EFFECT        1029
#define PPZ_FIGHT_EFFECT_DEF    1030
#define PPZ_FIGHT_EFFECT_ATT    1031

#define PPZ_TABLE               2000
#define PPZ_TABLE_BG            2010
#define PPZ_TABLE_BGWALL        2011
#define PPZ_TABLE_BALL          2020
#define PPZ_TABLE_BALL_ROLE     2019
#define PPZ_TABLE_BALL_BUFF     2018
#define PPZ_TABLE_BALL_LIGHT    2021
#define PPZ_TABLE_EFFECT        2030
#define PPZ_TABLE_BUTTON        2040

#define PPZ_FLYUP               3000