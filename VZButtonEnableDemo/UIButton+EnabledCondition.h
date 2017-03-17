//
//  UIButton+EnabledCondition.h
//
//  Created by verus on 16/10/18.
//

#import "VZButtonEnabledCondition.h"
#import <UIKit/UIKit.h>

@interface UIButton (EnabledCondition)

- (void)addEnabledCondition:(VZButtonEnabledCondition *)condition;

@end
