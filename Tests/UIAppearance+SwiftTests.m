//
//  UIAppearance+SwiftTests.m
//  WMobileKit

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