//
//  DHUserModel.m
//  Data-Hunter-iOS
//
//  Created by bman on 6/25/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import "DHUserModel.h"
#import "DHVoiceModel.h"
#import "DHTextModel.h"
#import "Underscore.h"


NSString* kDHMaleGenderValue = @"male";
NSString* kDHFemaleGenderValue = @"female";

static NSMutableDictionary* g_userModelCache = nil;
static DHUserModel* g_currentUserModel = nil;

@implementation DHUserModel

+ (void) storeDataBase {
    NSMutableArray* jsonObjectArray = [NSMutableArray array];
    for (NSString* indexID in g_userModelCache) {
        DHUserModel* userModel = g_userModelCache[indexID];
        NSDictionary* jsonObject = [userModel toJSONObject];
        [jsonObjectArray addObject:jsonObject];
    }
    
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES)
                              lastObject];
    NSString* file = [documentPath stringByAppendingPathComponent:@"Users.db"];
    [[jsonObjectArray toJSONString] writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (void) restoreDataBase {
    g_userModelCache = [[NSMutableDictionary alloc] init];
    
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES)
                              lastObject];
    NSString* file = [documentPath stringByAppendingPathComponent:@"Users.db"];
    NSString* jsonString = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
    NSArray* jsonObjectArray = [jsonString toJSONObject];
    for (NSDictionary* jsonObject in jsonObjectArray) {
        DHUserModel* userModel = [[DHUserModel alloc] initWithJSON:jsonObject];
        g_userModelCache[userModel.indexID] = userModel;
    }
}

+ (instancetype) currentUserModel {
    return g_currentUserModel;
}

+ (instancetype) signInWithUserName:(NSString*)userName userPassword:(NSString*)userPassword {
    // 如果已经登陆则，应先登出
    if (g_currentUserModel)
        return nil;
    
    for (NSString* userModelIndexID in g_userModelCache) {
        DHUserModel* userModel = g_userModelCache[userModelIndexID];
        if ([userModel.userName isEqual:userName] &&
            [userModel.userPassword isEqual:userPassword]) {
            g_currentUserModel = userModel;
            return userModel;
        }
    }
    return nil;
}

+ (BOOL) signOut {
    if (g_currentUserModel) {
        g_currentUserModel = nil;
        return YES;
    }
    else {
        return NO;
    }
}

- (NSArray*) ownerVoiceModels {
    NSMutableArray* ret = [NSMutableArray array];
    
    NSDictionary* voiceModels = [DHVoiceModel allObject];
    for (NSString* voiceModelIndexID in [DHVoiceModel allObject]) {
        DHVoiceModel* voiceModel = voiceModels[voiceModelIndexID];
        if ([voiceModel.ownerUserModelIndexID isEqual:self.indexID]) {
            [ret addObject:voiceModel];
        }
    }
    
    return ret;
}

- (DHTextModel*) fetchRandomTextModelWithoutRecordedVoice {
    // 从所有文本中排除该用户已经录音过的
    NSArray* recordedVoiceModels = [self ownerVoiceModels];
    NSArray* remainTextModels = Underscore.filter([[DHTextModel allObject] allValues], ^BOOL (DHTextModel* textModel) {
        return ! Underscore.any(recordedVoiceModels, ^BOOL (DHVoiceModel* voiceModel) {
            return [voiceModel.referenceTextModelIndexID isEqual:textModel.indexID];
        });
    });
    
    // 在剩余的文本中随机取得一个返回
    if (remainTextModels && remainTextModels.count > 0) {
        NSInteger ranIndex = rand() % remainTextModels.count;
        return remainTextModels[ranIndex];
    }
    else {
        return nil;
    }
}


#pragma mark - Override

+ (instancetype) fetchObjectModelWithIndexID:(NSString*)indexID {
    return g_userModelCache[indexID];
}

+ (NSUInteger) objectCount {
    return g_userModelCache.count;
}

+ (NSDictionary*) allObject {
    return g_userModelCache;
}

- (BOOL) upload {
    if (self.indexID) { // 更新
        if (g_userModelCache[self.indexID]) {
            g_userModelCache[self.indexID] = self;
            return YES;
        }
        else {
            return NO;
        }
    }
    else { // 新建
        // 新建的话要检测是否有重名用户
        for (NSString* indexID in g_userModelCache) {
            DHUserModel* userModel = g_userModelCache[indexID];
            if ([userModel.userName isEqual:self.userName]) {
                return NO;
            }
        }
        
        self.indexID = [[self class] UUIDString];
        g_userModelCache[self.indexID] = self;
        return YES;
    }
}

- (BOOL) remove {
    if (self.indexID) { // 必须上传过服务器之后才能从服务器移除
        if (g_userModelCache[self.indexID]) { // 必须有存在过
            [g_userModelCache removeObjectForKey:self.indexID];
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}

- (id) initWithJSON:(NSDictionary*)jsonObject {
    self = [self init];
    if (self) {
        self.indexID = jsonObject[@"indexID"];
        self.userName = jsonObject[@"userName"];
        self.userPassword = jsonObject[@"userPassword"];
        self.location = jsonObject[@"location"];
        self.gender = jsonObject[@"gender"];
        
        return self;
    }
    return nil;
}

- (NSDictionary*) toJSONObject {
    NSMutableDictionary* ret = [NSMutableDictionary dictionary];
    
    ret[@"indexID"] = self.indexID;
    ret[@"userName"] = self.userName;
    ret[@"userPassword"] = self.userPassword;
    ret[@"location"] = self.location;
    ret[@"gender"] = self.gender;
    
    return ret;
}

@end
