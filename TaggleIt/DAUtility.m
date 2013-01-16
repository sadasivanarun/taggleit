
#import "DAUtility.h"
#import "DAConstants.h"
#import "CSDataBaseManager.h"
#import "CSDatabase.h"
#import <coreText/CoreText.h>

@implementation DAUtility

// get the complete path of the database file from the Document Folder

+ (NSString *) getDocumentPathForUser
{
	//---get the path of the Documents folder---
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	
	NSString *documentsDir = [paths objectAtIndex:0];
	
	//NSString *filePath = [documentsDir stringByAppendingPathComponent:MCDatabaseNameWithExt];
	
	return documentsDir;
}

+ (NSString *)stringValueForNil :(NSString *)value
{
	if(nil == value)
	{
		value = @"";
	}
	
	return value;
	
}


//+(BOOL)getNetworkStatusInBool
//{
//    NetworkStatus remoteHostStatus;
//    BOOL networkavailability = NO;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:)name:kReachabilityChangedNotification object:nil];
//    Reachability *reachability = [[Reachability reachabilityWithHostName: DAHostName] retain];
//	[reachability startNotifier];
//    remoteHostStatus = [reachability currentReachabilityStatus];
//    if(remoteHostStatus == NotReachable) 
//    {
//        networkavailability = NO;
//    }
//    else if (remoteHostStatus == ReachableViaWiFi) 
//    {
//        NSLog(@"Wifi ");
//        networkavailability = YES;
//    }
//    if(remoteHostStatus == ReachableViaWWAN)
//    {
//        NSLog(@"WWAN"); 
//        networkavailability = YES;
//    }
//    [reachability release];
//    return networkavailability;
//}
/*
 * Method to get value of a given key from the specified plist
 */

+ (id)getValueForKey:(NSString *)plistItem fromPlistFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *userConfigFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSMutableDictionary *configDic = [[NSDictionary alloc]initWithContentsOfFile:userConfigFile] ;
    
    id retString = [configDic valueForKey:plistItem];
    
    return retString;
}

/*
 * Method to set value of a given key to the specified plist
 */

+ (void)setValueForKey:(NSString *)key withValue:(id)value toPlistFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *userConfigFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc]initWithContentsOfFile:userConfigFile];
    
    [configDic setObject:value forKey:key];
    
    [configDic writeToFile:userConfigFile atomically: YES];
}

+(NSString *)getDocumentPathForUserDB
{
    NSString *databaseSaveLocation = [DAUtility getDocumentPathForUser];
    
    return [databaseSaveLocation stringByAppendingPathComponent:@"taggle.sqlite"];
}

@end

