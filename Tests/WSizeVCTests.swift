//
//  WSizeVCTests.swift
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

class WSizeVCSpec: QuickSpec {
    override func spec() {
        describe("WSizeVCSpec") {
            var subject: WSizeVC!
            var window: UIWindow!

            beforeEach({
                subject = WSizeVC()

                window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = subject
            })

            describe("size assumptions") {
                it("should return unknown if the view is not ready") {
                    expect(subject.currentSizeType()) == SizeType.unknown
                }

                it("should correct type for size assuming not in a split view") {
                    // Prep view
                    window.addSubview(subject.view)

                    subject.beginAppearanceTransition(true, animated: false)
                    subject.endAppearanceTransition()

                    if (UIDevice.current.userInterfaceIdiom == .pad) {
                        expect(subject.currentSizeType()) == SizeType.iPad
                    } else {
                        expect(subject.currentSizeType()) == SizeType.iPhone
                    }
                }
            }
        }
    }
}
