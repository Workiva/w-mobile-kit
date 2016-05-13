//
//  WToastTests.swift
//  WMobileKit

import Quick
import Nimble
@testable import WMobileKit

class WSwitchSpec: QuickSpec {
    override func spec() {
        describe("WSwitchSpec") {
            var subject: UIViewController!
            var window: UIWindow!
            var toastView: WSwitch!
            
            beforeEach({
                subject = UIViewController()
                
                window = UIWindow(frame: UIScreen.mainScreen().bounds)
                WToastManager.sharedInstance.rootWindow = window
                window.rootViewController = subject
                
                subject.beginAppearanceTransition(true, animated: false)
                subject.endAppearanceTransition()
            })
        }
    }
}