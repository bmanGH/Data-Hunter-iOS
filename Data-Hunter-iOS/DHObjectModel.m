//
//  DHObjectModel.m
//  Data-Hunter-iOS
//
//  Created by bman on 6/25/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import "DHObjectModel.h"

@implementation DHObjectModel

+ (instancetype) fetchObjectModelWithIndexID:(NSString*)indexID {
    return nil;
}

+ (NSUInteger) objectCount {
    return 0;
}

+ (NSDictionary*) allObject {
    return nil;
}

+ (NSString*) UUIDString {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    
    return uuid;
}

- (BOOL) upload {
    return NO;
}

- (BOOL) remove {
    return NO;
}

- (BOOL) isEqual:(id)object {
    if ([object isKindOfClass:[DHObjectModel class]]) {
        DHObjectModel* objectModel = (DHObjectModel*)object;
        if ([objectModel.indexID isEqual:self.indexID]) {
            return YES;
        }
        else {
            return [super isEqual:object];
        }
    }
    else {
        return [super isEqual:object];
    }
}

- (id) initWithJSON:(NSDictionary*)jsonObject {
    return nil;
}

- (NSDictionary*) toJSONObject {
    return nil;
}

@end


#pragma mark - JSON Helper

@implementation NSDictionary (JSONCategories)

+ (NSDictionary*) dictionaryWithContentsOfJSON:(NSString*)filePath {
	NSData* data = [NSData dataWithContentsOfFile:filePath];
	NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
												options:kNilOptions error:&error];
    if (error != nil)
		return nil;
    return result;
}

- (NSData*) toJSON {
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
												options:kNilOptions error:&error];
    if (error != nil)
		return nil;
    return result;
}

- (NSString*) toJSONString {
    NSData* jsonData = [self toJSON];
    __autoreleasing NSString* ret = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	return ret;
}

@end

@implementation NSArray (JSONCategories)

+ (NSArray*) arrayWithContentsOfJSON:(NSString*)filePath {
	NSData* data = [NSData dataWithContentsOfFile:filePath];
	NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
												options:kNilOptions error:&error];
    if (error != nil)
		return nil;
    return result;
}

- (NSData*) toJSON {
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
												options:kNilOptions error:&error];
    if (error != nil)
		return nil;
    return result;
}

- (NSString*) toJSONString {
    NSData* jsonData = [self toJSON];
    __autoreleasing NSString* ret = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	return ret;
}

@end

@implementation NSString (JSONCategories)

- (id) toJSONObject {
	NSError* error = nil;
	id result = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (error != nil)
		return nil;
    return result;
}

@end
