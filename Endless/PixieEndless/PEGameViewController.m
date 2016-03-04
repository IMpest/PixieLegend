//
//  GameViewController.m
//  PixieEndless
//
//  Created by silver6wings on 15/4/27.
//  Copyright (c) 2015年 silver6wings. All rights reserved.
//

#import "PEGameViewController.h"

@implementation PEGameViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Configure the view.
    //    SKView * skView = (SKView *)self.view;
    SKView * skView = [[SKView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    NSLog(@"height=%f",skView.frame.size.height);
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    SKScene *scene = [[SKScene alloc] initWithSize:skView.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [scene setBackgroundColor:[UIColor cyanColor]];
    // Present the scene.
    [skView presentScene:scene];
    
    [self.view addSubview:skView];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
