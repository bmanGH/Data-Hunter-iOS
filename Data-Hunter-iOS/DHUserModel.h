//
//  DHUserModel.h
//  Data-Hunter-iOS
//
//  Created by bman on 6/25/13.
//  Copyright (c) 2013 liulishuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHObjectModel.h"


@class DHTextModel;

extern const NSString* kDHMaleGenderValue;
extern const NSString* kDHFemaleGenderValue;

@interface DHUserModel : DHObjectModel

@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* userPassword;
@property (nonatomic, copy) NSString* location;
@property (nonatomic, copy) NSString* gender;

+ (void) storeDataBase;
+ (void) restoreDataBase;

+ (instancetype) currentUserModel; // 当前用户

/**
 * 用户登陆
 * @return 没有相应用户或登陆失败则返回空
 */
+ (instancetype) signInWithUserName:(NSString*)userName userPassword:(NSString*)userPassword;

+ (BOOL) signOut; // 用户登出

- (NSArray*) ownerVoiceModels;

/**
 * 随机获得一个用户还没有语音数据的文本
 */
- (DHTextModel*) fetchRandomTextModelWithoutRecordedVoice;

@end
