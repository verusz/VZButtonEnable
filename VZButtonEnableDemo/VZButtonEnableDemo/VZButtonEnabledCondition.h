//
//  VZButtonEnabledCondition.h
//
//  Created by verus on 16/10/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const kWPButtonEnabledConditionNotification =
@"kWTLButtonEnabledConditionNotification";
static NSString *const kWPButtonDisabledConditionNotification =
@"kWTLButtonDisabledConditionNotification";
@interface VZButtonEnabledCondition : NSObject

/**
 *  添加textfield的判断状况
 *
 *  @param textField 对象textfield
 *  @param maxLength 最大长度
 *  @param minLength 最小长度
 *
 *  @return 返回condition
 */
- (instancetype)initWithTextField:(UITextField *)textField
                        maxLength:(NSInteger)maxLength
                        minLength:(NSInteger)minLength;

/**
 *  添加除了textfield之外对象的判断状况
 *
 *  @param block    需要满足的判断条件
 *  @param object   满足判断条件的对象
 *  @param property 对象属性的键值（注意键值的正确性，不然会导致crash）
 *
 *  @return 返回condition
 */
- (instancetype)initWithBlock:(BOOL (^)(id object, NSString *property))block
                       object:(id)object
                     property:(NSString *)property;

/**
 *  是否满足条件的变量，无需手动调用
 */
@property (nonatomic, assign) BOOL enable;
@end
