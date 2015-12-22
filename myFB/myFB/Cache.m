//
//  Cache.m
//  myFB
//
//  Created by AnLab Mac on 11/24/15.
//  Copyright © 2015 TeengLiu. All rights reserved.
//

#import "Cache.h"
#import <Foundation/Foundation.h>
#import <Security/Security.h>

static NSString *const kCacheVer = @"v2";

#define USER_DEFAULTS_INSTALLED_KEY @"myFbHuyLe"

@implementation Cache

+ (void)initialize
{
    if (self == [Cache class]) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULTS_INSTALLED_KEY]) {
            [Cache clearCache];
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_DEFAULTS_INSTALLED_KEY];
    }
}

+ (NSString *)keychainKey
{
    return [NSString stringWithFormat:@"%@", kCacheVer];
}

+ (void)saveCacheItem:(SUCacheItem *)item
{
    [self deleteCacheItem];
    NSString *key = [self keychainKey];
    NSString *error;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
    if (error) {
        NSLog(@"Failed to serialize item for insertion into keychain:%@", error);
        return;
    }
    NSDictionary *keychainQuery = @{(__bridge id)kSecAttrAccount : key,
                                    (__bridge id)kSecValueData : data,
                                    (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                    (__bridge id)kSecAttrAccessible : (__bridge id) kSecAttrAccessibleWhenUnlockedThisDeviceOnly,};
    OSStatus result = SecItemAdd((__bridge CFDictionaryRef)keychainQuery, nil);
    if (result != noErr) {
        NSLog(@"Failed to add item to keychain");
        return;
    }
}

+ (void)deleteCacheItem
{
    NSString *key = [self keychainKey];
    NSDictionary *keychainQuery = @{(__bridge id)kSecAttrAccount : key,
                                    (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                    (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly,};
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    if (result != noErr) {
        NSLog(@"Failed to delete item");
        return;
    }
}

+(SUCacheItem *)getCacheItem
{
    NSString *key = [self keychainKey];
    NSDictionary *keychainQuery = @{(__bridge id)kSecAttrAccount : key,
                                    (__bridge id)kSecReturnData : (__bridge id)kCFBooleanTrue,
                                    (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword};
    CFDataRef serializedDictionaryRef;
    OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&serializedDictionaryRef);
    if (result == noErr) {
        NSData *data = (__bridge_transfer NSData*)serializedDictionaryRef;
        if (data) {
            return [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return nil;
}
+(void)clearCache
{
    NSArray *secItemClasses = @[(__bridge id)kSecClassGenericPassword,
                                (__bridge id)kSecClassInternetPassword,
                                (__bridge id)kSecClassCertificate,
                                (__bridge id)kSecClassKey,
                                (__bridge id)kSecClassIdentity];
    for (id secItemClass in secItemClasses) {
        NSDictionary *spec = @{(__bridge id)kSecClass: secItemClass};
        SecItemDelete((__bridge CFDictionaryRef)spec);
    }
}
@end
