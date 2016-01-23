//
//  CustomTextField.h
//  Nearby
//
//  Created by xwbb on 15/12/4.
//  Copyright © 2015年 Mr.Y. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField

{
    int margin;
}

- (id)initWithFrame:(CGRect)frame
      withPlaceholder:(NSString *)placeholder
         withLeftView:(UIView *)leftView;

@end
