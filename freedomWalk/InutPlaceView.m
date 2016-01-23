//
//  InutPlaceView.m
//  freedomWalk
//
//  Created by 李仁杰 on 15/12/8.
//  Copyright © 2015年 YC. All rights reserved.
//

#import "InutPlaceView.h"

@interface  InutPlaceView()

- (IBAction)change;

@end

@implementation InutPlaceView


- (IBAction)change {
    NSString *mid = self.start.text;
    self.start.text = self.end.text;
    self.end.text = mid;
}
@end
