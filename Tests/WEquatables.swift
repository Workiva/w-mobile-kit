//
//  WEquatables.swift
//  WMobileKit
//
//  All extensions on C Types to conform to `Equatable` should live in here.
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

import UIKit

extension CGColor: Equatable {}
public func ==(lhs: CGColor, rhs: CGColor) -> Bool {
    return CGColorEqualToColor(lhs, rhs)
}

extension CGPath: Equatable {}
public func ==(lhs: CGPath, rhs: CGPath) -> Bool {
    return CGPathEqualToPath(lhs, rhs)
}