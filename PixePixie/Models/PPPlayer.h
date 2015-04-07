

@interface PPPlayer : NSObject
{
    NSString * playerName;
    int playerLevel;
    
    long playerEnergy;
    long playerStone;
    long playerGold;
    
    NSArray * playerFriends;
    NSArray * playerPixies;
    
}

@property(nonatomic, retain) NSString * playerName;
@property(nonatomic, assign) int playerLevel;

@property(nonatomic, assign) long playerEnergy;
@property(nonatomic, assign) long playerStone;
@property(nonatomic, assign) long playerGold;

@property(nonatomic, retain) NSArray * playerFriends;
@property(nonatomic, retain) NSArray * playerPixies;

+(PPPlayer *)getInstance;

@end
