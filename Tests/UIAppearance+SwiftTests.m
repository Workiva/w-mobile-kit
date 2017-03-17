//
//  UIAppearance+SwiftTests.m
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

@import UIKit;
@import Quick;
@import Nimble;
#import "UIAppearance+Swift.h"

QuickSpecBegin(UIAppearanceSwiftSpec)

__block UIView *subject;

beforeEach(^{
    subject = [[UIView alloc] init];
});

describe(@"valid uses", ^{
    it(@"should return an appearance for given classes", ^{
        expect([UIView appearanceWhenContainedWithin:@[[UINavigationController class], [UIView class]]]).toNot(beNil());
    });
});

describe(@"invalid uses", ^{
    it(@"should return an appearance for given classes even if it is more than the max allowed", ^{
        expect([UIView appearanceWhenContainedWithin:@[[UIView class], [UIView class], [UIView class], [UIView class], [UIView class],
                                                       [UIView class], [UIView class], [UIView class], [UIView class], [UIView class],
                                                       [UIView class]]]).toNot(beNil());
    });
});

QuickSpecEnd
