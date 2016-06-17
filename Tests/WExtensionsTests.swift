//
//  WExtensionsTests.swift
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

class WExtensionsSpec: QuickSpec {
    override func spec() {
        describe("WExtensionsSpec") {
            let name1 = "John"
            let name2 = "John Smith"
            let name3 = "John Smith Man"
            let name4 = "John Smith Man Anderson"
            let name5 = "John Smith Man Anderson Paul"

            describe("initials") {
                it("should get the initials for names for the default initial length") {
                    let initials1 = name1.initials()
                    expect(initials1) == "J"

                    let initials2 = name2.initials()
                    expect(initials2) == "JS"

                    let initials3 = name3.initials()
                    expect(initials3) == "JSM"

                    let initials4 = name4.initials()
                    expect(initials4) == "JSM"

                    let initials5 = name5.initials()
                    expect(initials5) == "JSM"
                }

                it("should get the initials for names for a custom initial length") {
                    let initials1 = name1.initials(4)
                    expect(initials1) == "J"

                    let initials2 = name2.initials(4)
                    expect(initials2) == "JS"

                    let initials3 = name3.initials(4)
                    expect(initials3) == "JSM"

                    let initials4 = name4.initials(4)
                    expect(initials4) == "JSMA"

                    let initials5 = name5.initials(4)
                    expect(initials5) == "JSMA"
                }
            }

            describe("CRC32") {
                it("should get CRC32 int for the given strings") {
                    let hash1: UInt = name1.crc32int()
                    expect(hash1) == 2437433000

                    let hash2: UInt = name2.crc32int()
                    expect(hash2) == 3474982680

                    let hash3: UInt = name3.crc32int()
                    expect(hash3) == 560327294

                    let hash4: UInt = name4.crc32int()
                    expect(hash4) == 2014365601

                    let hash5: UInt = name5.crc32int()
                    expect(hash5) == 3467306619
                }
            }
        }
    }
}
