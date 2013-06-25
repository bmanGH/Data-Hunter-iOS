//
//  DHVoiceModel.m
//  Data-Hunter-iOS
//
//  Created by bman on 6/25/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import "DHVoiceModel.h"
#import "DHTextModel.h"
#import "DHUserModel.h"

static NSMutableDictionary* g_voiceModelCache = nil;

@implementation DHVoiceModel

+ (void) storeDataBase {
    NSMutableArray* jsonObjectArray = [NSMutableArray array];
    for (NSString* indexID in g_voiceModelCache) {
        DHVoiceModel* userModel = g_voiceModelCache[indexID];
        NSDictionary* jsonObject = [userModel toJSONObject];
        [jsonObjectArray addObject:jsonObject];
    }
    
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES)
                              lastObject];
    NSString* file = [documentPath stringByAppendingPathComponent:@"Voices.db"];
    [[jsonObjectArray toJSONString] writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (void) restoreDataBase {
    g_voiceModelCache = [[NSMutableDictionary alloc] init];
    
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES)
                              lastObject];
    NSString* file = [documentPath stringByAppendingPathComponent:@"Voices.db"];
    NSString* jsonString = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
    NSArray* jsonObjectArray = [jsonString toJSONObject];
    for (NSDictionary* jsonObject in jsonObjectArray) {
        DHVoiceModel* userModel = [[DHVoiceModel alloc] initWithJSON:jsonObject];
        g_voiceModelCache[userModel.indexID] = userModel;
    }
}

- (DHTextModel*) referenceTextModel {
    return [DHTextModel fetchObjectModelWithIndexID:self.referenceTextModelIndexID];
}

- (DHUserModel*) ownerUserModel {
    return [DHUserModel fetchObjectModelWithIndexID:self.ownerUserModelIndexID];
}


#pragma mark - Override

+ (instancetype) fetchObjectModelWithIndexID:(NSString*)indexID {
    return g_voiceModelCache[indexID];
}

+ (NSUInteger) objectCount {
    return g_voiceModelCache.count;
}

+ (NSDictionary*) allObject {
    return g_voiceModelCache;
}

- (BOOL) upload {
    if (self.indexID) { // 更新
        if (g_voiceModelCache[self.indexID]) {
            g_voiceModelCache[self.indexID] = self;
            return YES;
        }
        else {
            return NO;
        }
    }
    else { // 新建
        self.indexID = [[self class] UUIDString];
        g_voiceModelCache[self.indexID] = self;
        return YES;
    }
}

- (BOOL) remove {
    if (self.indexID) { // 必须上传过服务器之后才能从服务器移除
        if (g_voiceModelCache[self.indexID]) { // 必须有存在过
            [g_voiceModelCache removeObjectForKey:self.indexID];
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
        self.referenceTextModelIndexID = jsonObject[@"referenceTextModelIndexID"];
        self.ownerUserModelIndexID = jsonObject[@"ownerUserModelIndexID"];
        self.dataFileURL = [NSURL URLWithString:jsonObject[@"dataFileURL"]];
        
        return self;
    }
    return nil;
}

- (NSDictionary*) toJSONObject {
    NSMutableDictionary* ret = [NSMutableDictionary dictionary];
    
    ret[@"indexID"] = self.indexID;
    ret[@"referenceTextModelIndexID"] = self.referenceTextModelIndexID;
    ret[@"ownerUserModelIndexID"] = self.ownerUserModelIndexID;
    ret[@"dataFileURL"] = [self.dataFileURL absoluteString];
    
    return ret;
}

@end
