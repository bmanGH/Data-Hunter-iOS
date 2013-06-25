//
//  DHVoiceModel.h
//  Data-Hunter-iOS
//
//  Created by bman on 6/25/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHObjectModel.h"

@class DHTextModel;
@class DHUserModel;

@interface DHVoiceModel : DHObjectModel

@property (nonatomic, copy) NSString* referenceTextModelIndexID;
@property (nonatomic, copy) NSString* ownerUserModelIndexID;
@property (nonatomic, copy) NSURL* dataFileURL;

+ (void) storeDataBase;
+ (void) restoreDataBase;

- (DHTextModel*) referenceTextModel;
- (DHUserModel*) ownerUserModel;

@end
