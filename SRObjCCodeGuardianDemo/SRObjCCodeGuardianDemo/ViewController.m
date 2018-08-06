//
//  ViewController.m
//  SRObjCCodeGuardianDemo
//
//  Created by https://github.com/guowilling on 2017/7/27.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+SRGuardian.h"
#import "NSMutableArray+SRGuardian.h"
#import "NSMutableDictionary+SRGuardian.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // NSArray+Guardian
    NSArray *testArray = @[@"one", @"two"];
    NSString *testString = testArray[2]; // 2 index is out of bounds.
    if (testString) {
        NSLog(@"%@", testString);
    }
    
    // NSMutableArray+Guardian
    NSMutableArray *testArrayM = [NSMutableArray arrayWithArray:@[@"one", @"two"]];
    NSString *tempString = nil;
    [testArrayM addObject:tempString]; // can't add nil object into array.
    
    // NSMutableDictionary+Guardian
    NSMutableDictionary *testDicM = [NSMutableDictionary dictionary];
    [testDicM setObject:nil forKey:@"name"];
    
    // NullSafe
    id nullValue = [NSNull null];
    NSString *result = [nullValue stringValue]; // [NSNull stringValue]: unrecognized selector sent to instance -> return nil
    NSAssert(result == nil, @"result is not nil.");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
