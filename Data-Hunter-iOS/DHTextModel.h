//
//  DHTextModel.h
//  Data-Hunter-iOS
//
//  Created by bman on 6/25/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHObjectModel.h"


@class DHUserModel;

@interface DHTextModel : DHObjectModel

@property (nonatomic, copy) NSString* text;

+ (void) restoreDataBase;

- (NSArray*) referenceVoiceModels;

@end
