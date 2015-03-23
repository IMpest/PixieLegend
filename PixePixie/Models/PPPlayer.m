#import "PPPlayer.h"

static PPPlayer * localPlayer = nil;

@implementation PPPlayer

@synthesize playerName;
@synthesize playerLevel;
@synthesize playerEnergy;
@synthesize playerStone;
@synthesize playerGold;
@synthesize playerFriends;
@synthesize playerPixies;

+(PPPlayer *)getInstance
{
    @synchronized(self){
        if (localPlayer == nil) {
            localPlayer = [[PPPlayer alloc] init];
            localPlayer.playerName = @"testName";
            localPlayer.playerLevel = 1;
            localPlayer.playerEnergy = 150;
            localPlayer.playerStone = 100;
            localPlayer.playerGold = 99999;
            localPlayer.playerFriends = [NSArray array];
            localPlayer.playerPixies = [NSArray array];
        }
    }
    return localPlayer;
}

@end
