//
//  WSpinnerExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class LoadingModalExamplesVC: WSideMenuContentVC {
    let smallFrame = UIView()
    var loadingModal: WLoadingModal? = nil
    var loadingTapRecognizer: UITapGestureRecognizer?
    var smallLoadingTapRecognizer: UITapGestureRecognizer?

    public override func viewDidLoad() {
        super.viewDidLoad()

        let loadingModalButton: UIButton = UIButton()
        view.addSubview(loadingModalButton)
        loadingModalButton.setTitle("Large Loading Modal", forState: .Normal)
        loadingModalButton.setTitleColor(.whiteColor(), forState: .Normal)
        loadingModalButton.backgroundColor = .clearColor()
        loadingModalButton.layer.borderColor = UIColor.whiteColor().CGColor
        loadingModalButton.layer.cornerRadius = 5
        loadingModalButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        loadingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoadingModalExamplesVC.displayLoadingModal(_:)))
        loadingTapRecognizer!.numberOfTapsRequired = 1
        loadingModalButton.addGestureRecognizer(loadingTapRecognizer!)

        smallFrame.backgroundColor = .lightGrayColor()
        view.addSubview(smallFrame)
        smallFrame.snp_makeConstraints { (make) in
            make.top.equalTo(loadingModalButton.snp_bottom).offset(20)
            make.right.equalTo(view).offset(-10)
            make.bottom.equalTo(view).offset(-10)
            make.left.equalTo(view).offset(10)
        }

        let smallLoadingModalButton: UIButton = UIButton()
        smallFrame.addSubview(smallLoadingModalButton)
        smallLoadingModalButton.setTitle("Small Loading Modal", forState: .Normal)
        smallLoadingModalButton.setTitleColor(.whiteColor(), forState: .Normal)
        smallLoadingModalButton.backgroundColor = .clearColor()
        smallLoadingModalButton.layer.borderColor = UIColor.whiteColor().CGColor
        smallLoadingModalButton.layer.cornerRadius = 5
        smallLoadingModalButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(smallFrame)
            make.centerY.equalTo(smallFrame)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        smallLoadingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoadingModalExamplesVC.displayLoadingModal(_:)))
        smallLoadingTapRecognizer!.numberOfTapsRequired = 1
        smallLoadingModalButton.addGestureRecognizer(smallLoadingTapRecognizer!)
    }

    public func displayLoadingModal(sender: AnyObject?) {
        // One is already shown
        if (loadingModal != nil) {
            return
        }

        if let senderButton = sender as? UIGestureRecognizer {
            loadingModal = WLoadingModal(.grayColor(),
                                         title: "Title Text",
                                         description: "This will go away in 3 seconds.")

            if (senderButton == loadingTapRecognizer!) {
                loadingModal?.show(view, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            } else if (senderButton == smallLoadingTapRecognizer!) {
                loadingModal?.show(smallFrame, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            }

            let timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(LoadingModalExamplesVC.dismissLoadingModal(_:)), userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        }
    }

    public func dismissLoadingModal(sender: AnyObject?) {
        if (loadingModal != nil) {
            loadingModal!.removeFromSuperview()
            loadingModal = nil
            
            if let timer = sender as? NSTimer {
                timer.invalidate()
            }
        }
    }
}