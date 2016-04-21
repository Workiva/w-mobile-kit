//
//  TextFieldExamplesVC.swift
//  WMobileKitExample

import Foundation
import WMobileKit

public class TextFieldsExamplesVC: WSideMenuContentVC {
    @IBOutlet var storyboardTextField: WTextField?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Text Field with no icons.
        let noIconsLabel = UILabel()
        noIconsLabel.text = "This WTextField has no icons."
        noIconsLabel.textAlignment = .Center
        view.addSubview(noIconsLabel)
        noIconsLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(storyboardTextField!.snp_bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }

        let noIconsTextField = WTextField()
        view.addSubview(noIconsTextField)
        noIconsTextField.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(noIconsLabel.snp_bottom).offset(4)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        // MARK: Text Field with a left icon.
        let leftIconLabel = UILabel()
        leftIconLabel.text = "This WTextField has a left icon."
        leftIconLabel.textAlignment = .Center
        view.addSubview(leftIconLabel)
        leftIconLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(noIconsTextField.snp_bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }

        let leftIconTextField = WTextField()
        leftIconTextField.leftImage = UIImage(named: "person_1")
        view.addSubview(leftIconTextField)
        leftIconTextField.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(leftIconLabel.snp_bottom).offset(4)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        // MARK: Text Field with a right icon.
        let rightIconLabel = UILabel()
        rightIconLabel.text = "This WTextField has a right icon."
        rightIconLabel.textAlignment = .Center
        view.addSubview(rightIconLabel)
        rightIconLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(leftIconTextField.snp_bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }

        let rightIconTextField = WTextField()
        rightIconTextField.rightImage = UIImage(named: "gear_1")
        rightIconTextField.textColor = UIColor.blackColor()
        rightIconTextField.placeholder = "This has black text."
        view.addSubview(rightIconTextField)
        rightIconTextField.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(rightIconLabel.snp_bottom).offset(4)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        rightIconTextField.imageSquareSize = 32
        rightIconTextField.bottomLineColor = .blackColor()
        rightIconTextField.tintColor = .blackColor()
        rightIconTextField.bottomLineWidth = 2

        // MARK: Text Field with both icons.
        let bothIconLabel = UILabel()
        bothIconLabel.text = "This WTextField has both icons."
        bothIconLabel.textAlignment = .Center
        view.addSubview(bothIconLabel)
        bothIconLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(rightIconTextField.snp_bottom).offset(10)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }

        let bothIconTextField = WTextField()
        bothIconTextField.leftImage = UIImage(named: "person_1")
        bothIconTextField.rightImage = UIImage(named: "gear_1")
        view.addSubview(bothIconTextField)
        bothIconTextField.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(bothIconLabel.snp_bottom).offset(4)
            make.width.equalTo(view).offset(-10)
            make.height.equalTo(30)
        }
    }
}