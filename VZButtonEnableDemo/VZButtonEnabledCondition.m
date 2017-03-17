//
//  VZButtonEnabledCondition.m
//
//  Created by verus on 16/10/18.
//

#import "WPButtonEnabledCondition.h"



@implementation VZButtonEnabledCondition {
  UITextField *_textField;
  NSInteger _maxLength;
  NSInteger _minLength;
  BOOL (^_boolBlock)(id object, NSString *property);
  id _object;
  NSString *_property;
}

- (BOOL)enable {
  if (_textField) {
    return _textField.text.length >= _minLength &&
           _maxLength >= _textField.text.length;
  } else {
    return _boolBlock(_object, _property);
  }
}

- (instancetype)initWithTextField:(UITextField *)textField
                        maxLength:(NSInteger)maxLength
                        minLength:(NSInteger)minLength {
  if (self = [super init]) {
    _textField = textField;
    _maxLength = maxLength;
    _minLength = minLength;
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(textFieldDidChange:)
               name:UITextFieldTextDidChangeNotification
             object:textField];
  }
  return self;
}

- (instancetype)initWithBlock:(BOOL (^)(id object, NSString *property))block
                       object:(id)object
                     property:(NSString *)property {
  if (self = [super init]) {
    _boolBlock = block;
    _object = object;
    _property = property;
    [object
        addObserver:self
         forKeyPath:property
            options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
            context:nil];
  }
  return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context {
  [self postNotification];
}

- (void)textFieldDidChange:(NSNotification *)notif {
  [self postNotification];
}

- (void)postNotification {
  if ([self enable]) {
    [[NSNotificationCenter defaultCenter]
        postNotificationName:kWPButtonEnabledConditionNotification
                      object:self];
  } else {
    [[NSNotificationCenter defaultCenter]
        postNotificationName:kWPButtonDisabledConditionNotification
                      object:self];
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_object) {
        [self removeObserver:_object forKeyPath:_property];
    }
    
}

@end
