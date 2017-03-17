//
//  UIView+UIAppearance_Swift.m
//  WMobileKit
//
//  Copyright 2017 Workiva Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "UIAppearance+Swift.h"

@implementation UIView (UIViewAppearance_Swift)

+ (instancetype)appearanceWhenContainedWithin:(NSArray *)containers {
    NSUInteger count = containers.count;

    if (count > 10) {
        NSLog(@"Warning appearanceWhenContainedWithin cannot be used with more than 10 containers. Using the first 10.");
    }

    return [self appearanceWhenContainedIn:
            count > 0 ? containers[0] : nil,
            count > 1 ? containers[1] : nil,
            count > 2 ? containers[2] : nil,
            count > 3 ? containers[3] : nil,
            count > 4 ? containers[4] : nil,
            count > 5 ? containers[5] : nil,
            count > 6 ? containers[6] : nil,
            count > 7 ? containers[7] : nil,
            count > 8 ? containers[8] : nil,
            count > 9 ? containers[9] : nil,
            nil];
}

@end
