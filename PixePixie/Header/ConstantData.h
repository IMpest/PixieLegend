
static const int kWallThick = 15;                   // 墙的厚度
static const int kBallNumberMax = 15;               // 球的最大数量
static const int kBallSize = 50;                    // 默认球的直径
static const int kBallSizePixie = 50;               // 宠物球的直径
static const int kBallSustainRounds = 2;            // 元素球持续回合最大值

static const float kBallLinearDamping = 0.6f;       // 线阻尼系数
static const float kBallAngularDamping = 0.8f;      // 角阻尼系数
static const float kBallFriction = 0.0f;            // 表面摩擦力
static const float kBallRestitution = 1.0f;         // 弹性恢复系数

static const float kAutoAttackMax = 50.0f;          // 自动攻击最大力量限制
static const float kBounceReduce = 0.4f;            // 弹出去的按距离比例衰减系数
static const float kVelocityAddition = 1.1f;        // 撞击加速系数
static const float kStopThreshold = 5.0f;           // 球速度停止阈值
static const float kBallAccelerateMin = 15.0f;      // 速度发光最小的阈值
static const float kFrameInterval = 0.10f;          // FPS默认10

static const int kHurtBasicValue = 125;             // 物理攻击基础伤害值

static const int kElementTypeMax = 10;              // 最大元素类型个数

// 元素对应字符串
static  NSString * kElementTypeString[kElementTypeMax+1] = {
    @"none",
    @"metal",
    @"plant",
    @"water",
    @"fire",
    @"earth",
    @"steel",
    @"posion",
    @"ice",
    @"blaze",
    @"stone"
};

// 元素类型定义
typedef NS_ENUM(int, PPElementType)
{
    PPElementTypeNone = 0,    // 无
    
    PPElementTypeMetal,       // 金
    PPElementTypePlant,       // 木
    PPElementTypeWater,       // 水
    PPElementTypeFire,        // 火
    PPElementTypeEarth,       // 土
    
    PPElementTypeSteel,       // 钢
    PPElementTypePosion,      // 毒
    PPElementTypeIce,         // 冰
    PPElementTypeBlaze,       // 炎
    PPElementTypeStone        // 岩
};

// 属性相克数值策划表
static const float kElementInhibition[kElementTypeMax + 1][kElementTypeMax + 1] = {
    {0.00f, 0.00f, 0.00f, 0.00f, 0.00f, 0.00f, 0.00f, 0.00f, 0.00f, 0.00f, 0.00f},
    {0.00f, 1.00f, 1.30f, 1.00f, 0.70f, 1.15f, 0.85f, 1.15f, 0.85f, 0.55f, 1.00f},
    {0.00f, 0.70f, 1.00f, 1.15f, 1.00f, 1.30f, 0.55f, 1.15f, 1.00f, 0.85f, 1.15f},
    {0.00f, 1.15f, 0.85f, 1.00f, 0.70f, 0.70f, 1.00f, 0.70f, 0.85f, 1.15f, 0.55f},
    {0.00f, 1.30f, 1.15f, 0.70f, 1.00f, 1.00f, 1.15f, 1.00f, 0.55f, 0.85f, 0.85f},
    {0.00f, 1.00f, 0.70f, 1.30f, 1.15f, 1.00f, 0.70f, 0.55f, 1.15f, 1.00f, 0.85f},
    {0.00f, 1.15f, 1.45f, 1.15f, 0.85f, 1.30f, 1.00f, 1.15f, 1.00f, 0.70f, 1.15f},
    {0.00f, 0.85f, 1.15f, 1.30f, 1.15f, 1.45f, 0.70f, 1.00f, 1.15f, 1.00f, 1.30f},
    {0.00f, 1.15f, 1.15f, 1.15f, 1.45f, 0.85f, 1.15f, 1.00f, 1.00f, 1.30f, 0.70f},
    {0.00f, 1.45f, 1.30f, 0.85f, 1.15f, 1.15f, 1.30f, 1.15f, 0.70f, 1.00f, 1.00f},
    {0.00f, 1.15f, 0.85f, 1.45f, 1.30f, 1.15f, 1.00f, 0.70f, 1.30f, 1.15f, 1.00f}
};


