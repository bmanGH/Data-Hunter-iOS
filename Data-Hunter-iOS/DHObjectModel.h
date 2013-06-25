//
//  DHObjectModel.h
//  Data-Hunter-iOS
//
//  Created by bman on 6/25/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHObjectModel : NSObject

@property (nonatomic, copy) NSString* indexID; // 如果为空则表示还没有保存到服务器

+ (instancetype) fetchObjectModelWithIndexID:(NSString*)indexID;
+ (NSUInteger) objectCount;
+ (NSDictionary*) allObject;
+ (NSString*) UUIDString;

- (BOOL) upload; // 创建或更新
- (BOOL) remove; // 移除

- (id) initWithJSON:(NSDictionary*)jsonObject;
- (NSDictionary*) toJSONObject;

@end

// JSON Helper

@interface NSDictionary (JSONCategories)

+ (NSDictionary*) dictionaryWithContentsOfJSON:(NSString*)filePath;
- (NSData*) toJSON;
- (NSString*) toJSONString;

@end

@interface NSArray (JSONCategories)

+ (NSArray*) arrayWithContentsOfJSON:(NSString*)filePath;
- (NSData*) toJSON;
- (NSString*) toJSONString;

@end

@interface NSString (JSONCategories)

- (id) toJSONObject;

@end
