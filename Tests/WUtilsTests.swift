//
//  WUtilsTests.swift
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

import Quick
import Nimble
@testable import WMobileKit

class WUtilsTests: QuickSpec {
    override func spec() {
        describe("WUtilsSpec") {
            describe("example views") {
                it("should generate the correct number of example views") {
                    expect(WUtils.generateExampleViews(count: 12).count) == 12
                }

                it("should not generate an invalid number of example views") {
                    expect(WUtils.generateExampleViews(count: -9).count) == 0
                }

                it("should generate a view with a valid min and max") {
                    let view = WUtils.generateExampleView(minWidthHeight: 10, maxWidthHeight: 40)
                    expect(view.frame.width) >= 10
                    expect(view.frame.height) <= 40
                    expect(view.frame.height) >= 10
                }

                it("should not generate a view with an invalid min and max") {
                    let view = WUtils.generateExampleView(minWidthHeight: -40, maxWidthHeight: -10)
                    expect(view.frame.width) == 0
                    expect(view.frame.height) == 0
                }

                it("should not generate a view with a min < max") {
                    let view = WUtils.generateExampleView(minWidthHeight: 40, maxWidthHeight: 10)
                    expect(view.frame.width) == 40
                    expect(view.frame.height) == 40
                }
            }
        }

        describe("example color") {
            it("should generate a random color") {
                expect(WUtils.getRandomColor()).toNot(beNil())
            }
        }
    }
}
