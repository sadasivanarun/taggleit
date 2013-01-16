
#import <Foundation/Foundation.h>


@interface DAUtility : NSObject<UIAlertViewDelegate> {
    
    SEL selector;
    id target;
}
+ (NSString *) getDocumentPathForUser;
+ (NSString *)stringValueForNil :(NSString *)value;
//+ (BOOL)getNetworkStatusInBool;
+ (id)getValueForKey:(NSString *)plistItem fromPlistFile:(NSString *)fileName;
+ (void)setValueForKey:(NSString *)key withValue:(id)value toPlistFile:(NSString *)fileName;
+(NSString *)getDocumentPathForUserDB;
@end

