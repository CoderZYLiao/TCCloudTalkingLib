//
//  NSMutableDictionary+ZYAdd.m
//  TCPublicKit
//
//  Created by Huang ZhiBing on 2019/12/16.
//

#import "NSMutableDictionary+ZYAdd.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (ZYAdd)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc] init];
        [obj swizzleMethod:@selector(setObject:forKey:)withMethod:@selector(safe_setObject:forKey:)];
    });
}


- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class class = [self class];
    /** 得到类的实例方法 class_getInstanceMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name)
     _Nullable __unsafe_unretained cls  那个类
     _Nonnull name 按个方法
     
     补充: class_getClassMethod 得到类的 类方法
     */
    // 必须两个Method都要拿到
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    /** 动态添加方法 class_addMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name, IMP  _Nonnull imp, const char * _Nullable types)
     class_addMethod  是相对于实现来的说的，将本来不存在于被操作的Class里的newMethod的实现添加在被操作的Class里，并使用origSel作为其选择子
     _Nonnull name  原方法选择子，
     _Nonnull imp 新方法选择子，
     
     */
    // 如果发现方法已经存在，会失败返回，也可以用来做检查用,我们这里是为了避免源方法没有实现的情况;如果方法没有存在,我们则先尝试添加被替换的方法的实现
    BOOL didAddMethod = class_addMethod(class,origSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    
    // 如果返回成功:则说明被替换方法没有存在.也就是被替换的方法没有被实现,我们需要先把这个方法实现,然后再执行我们想要的效果,用我们自定义的方法去替换被替换的方法. 这里使用到的是class_replaceMethod这个方法. class_replaceMethod本身会尝试调用class_addMethod和method_setImplementation，所以直接调用class_replaceMethod就可以了)
    if (didAddMethod) {
        class_replaceMethod(class,newSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
        
    } else { // 如果返回失败:则说明被替换方法已经存在.直接将两个方法的实现交换即
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}



- (void)safe_setObject:(id)value forKey:(NSString *)key {
    if (value) {
        [self safe_setObject:value forKey:key];
    }else {
        NSLog(@"[NSMutableDictionarysetObject: forKey:], Object cannot be nil");
    }
}

@end
