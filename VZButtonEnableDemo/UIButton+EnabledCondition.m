//
//  UIButton+EnabledCondition.m
//
//  Created by verus on 16/10/18.
//

#import "UIButton+EnabledCondition.h"
#import <objc/runtime.h>
static void *WTLButtonEnabledConditionKey = @"WTLButtonEnabledConditionKey";
static void *avoidReleaseConditionKey = @"avoidReleaseConditionKey";

//static NSString *const kWPButtonEnabledConditionNotification =
//@"kWTLButtonEnabledConditionNotification";
//
//static NSString *const kWPButtonDisabledConditionNotification =
//@"kWTLButtonDisabledConditionNotification";

@implementation UIButton (EnabledCondition)

- (void)addEnabledCondition:(VZButtonEnabledCondition *)condition {
  self.enabled = NO;
  NSMutableArray *conditions =
      objc_getAssociatedObject(self, WTLButtonEnabledConditionKey);
  NSMutableArray *avoidReleaseCondition =
      objc_getAssociatedObject(self, avoidReleaseConditionKey);//为了避免对象被释放
  if (!conditions) {
    conditions = [[NSMutableArray alloc] init];
    objc_setAssociatedObject(self, WTLButtonEnabledConditionKey, conditions,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    avoidReleaseCondition = [[NSMutableArray alloc] init];
    objc_setAssociatedObject(self, avoidReleaseConditionKey,
                             avoidReleaseCondition,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(conditionEnabled:)
               name:kWPButtonEnabledConditionNotification
             object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(conditionDisabled:)
               name:kWPButtonDisabledConditionNotification
             object:nil];
  }
  if (condition.enable == NO) {
    [conditions addObject:condition];
  }
    [avoidReleaseCondition addObject:condition];//记录所有需要满足的情况
}

- (void)conditionEnabled:(NSNotification *)noti {
  NSMutableArray *avoidReleaseCondition =
      objc_getAssociatedObject(self, avoidReleaseConditionKey);
  if (![avoidReleaseCondition containsObject:noti.object]) {
    /**
     *  收到非此对象的通知时，不进行处理
     */
    return;
  }

  NSMutableArray *conditions =
      objc_getAssociatedObject(self, WTLButtonEnabledConditionKey);
  if ([conditions containsObject:noti.object]) {
    [conditions removeObject:noti.object];
  }
  [self setButtonEnabled:conditions];
}

- (void)conditionDisabled:(NSNotification *)noti {
  NSMutableArray *avoidReleaseCondition =
      objc_getAssociatedObject(self, avoidReleaseConditionKey);
  if (![avoidReleaseCondition containsObject:noti.object]) {
    /**
     *  收到非此对象的通知时，不进行处理
     */
    return;
  }
  NSMutableArray *conditions =
      objc_getAssociatedObject(self, WTLButtonEnabledConditionKey);
  if (![conditions containsObject:noti.object]) {
    [conditions addObject:noti.object];
  }
  [self setButtonEnabled:conditions];
}

- (void)setButtonEnabled:(NSArray *)conditions {
  if (conditions.count == 0) {
    if (self.enabled == NO) {
      self.enabled = YES;
    }
  } else {
    if (self.enabled == YES) {
      self.enabled = NO;
    }
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
