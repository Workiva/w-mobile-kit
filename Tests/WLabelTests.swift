//
//  WLabelTests.swift
//  WMobileKit
//
//  Copyright 2016 Workiva Inc.
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

class WLabelTests: QuickSpec {
    override func spec() {
        describe("WLabelSpec") {
            var subject: UIViewController!
            var wlabel: WLabel!

            beforeEach({
                subject = UIViewController()

                let window = UIWindow(frame: UIScreen.mainScreen().bounds)
                window.rootViewController = subject

                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()

                wlabel = WLabel()
            })

            describe("when the bounds change") {
                it("should trigger the didSet") {
                    wlabel.bounds = CGRect(x: 1, y: 1, width: 200, height: 200)
                }
            }

        }
    }
}
