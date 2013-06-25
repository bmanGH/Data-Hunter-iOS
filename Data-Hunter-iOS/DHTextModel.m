//
//  DHTextModel.m
//  Data-Hunter-iOS
//
//  Created by bman on 6/25/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import "DHTextModel.h"
#import "DHVoiceModel.h"


static NSMutableDictionary* g_textModelCache = nil;

@implementation DHTextModel

+ (void) restoreDataBase {
    g_textModelCache = [[NSMutableDictionary alloc] init];
    
    NSString* dataBaseFilePath = [[NSBundle mainBundle] pathForResource:@"Data-Hunter-iOS_juzi" ofType:@"txt"];
    NSString* dataBaseFile = [NSString stringWithContentsOfFile:dataBaseFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray* rows = [dataBaseFile componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSArray* sentence = [row componentsSeparatedByString:@":::"];
        NSString* indexID = sentence[0];
        NSString* text = sentence[1];
        
        DHTextModel* textModel = [[DHTextModel alloc] init];
        textModel.indexID = indexID;
        textModel.text = text;
        g_textModelCache[indexID] = textModel;
    }
}

- (NSArray*) referenceVoiceModels {
    NSMutableArray* ret = [NSMutableArray array];
    
    NSDictionary* voiceModels = [DHVoiceModel allObject];
    for (NSString* voiceModelIndexID in [DHVoiceModel allObject]) {
        DHVoiceModel* voiceModel = voiceModels[voiceModelIndexID];
        if ([voiceModel.referenceTextModelIndexID isEqual:self.indexID]) {
            [ret addObject:voiceModel];
        }
    }
    
    return ret;
}


#pragma mark - Override

+ (instancetype) fetchObjectModelWithIndexID:(NSString*)indexID {
    return g_textModelCache[indexID];
}

+ (NSUInteger) objectCount {
    return g_textModelCache.count;
}

+ (NSDictionary*) allObject {
    return g_textModelCache;
}

- (BOOL) upload {
    if (self.indexID) { // 更新
        if (g_textModelCache[self.indexID]) {
            g_textModelCache[self.indexID] = self;
            return YES;
        }
        else {
            return NO;
        }
    }
    else { // 新建
        self.indexID = [[self class] UUIDString];
        g_textModelCache[self.indexID] = self;
        return YES;
    }
}

- (BOOL) remove {
    if (self.indexID) { // 必须上传过服务器之后才能从服务器移除
        if (g_textModelCache[self.indexID]) { // 必须有存在过
            [g_textModelCache removeObjectForKey:self.indexID];
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
        self.text = jsonObject[@"text"];
        
        return self;
    }
    return nil;
}

- (NSDictionary*) toJSONObject {
    NSMutableDictionary* ret = [NSMutableDictionary dictionary];
    
    ret[@"indexID"] = self.indexID;
    ret[@"text"] = self.text;
    
    return ret;
}

@end
