//
//  SpinnerExamplesVC.swift
//  WMobileKitExample
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

import Foundation
import WMobileKit

open class SpinnerExamplesVC: WSideMenuContentVC {
    var currentProgress: CGFloat = 0
    let progressSpinner1 = WSpinner()
    let progressSpinner2 = WSpinner()
    let progressSpinner3 = WSpinner()

    open override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Indeterminate spinners.
        let emptyProgressSpinner = WSpinner(frame: .zero)
        view.addSubview(emptyProgressSpinner)
        emptyProgressSpinner.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(85)
            make.height.equalTo(85)
        }

        let indeterminateSpinner2 = WSpinner(frame: .zero)
        view.addSubview(indeterminateSpinner2)
        indeterminateSpinner2.snp.makeConstraints { (make) in
            make.centerY.equalTo(emptyProgressSpinner)
            make.right.equalTo(emptyProgressSpinner.snp.left).offset(-12)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        indeterminateSpinner2.indeterminate = true
        indeterminateSpinner2.backgroundLineColor = .gray
        indeterminateSpinner2.progressLineColor = .blue

        let indeterminateSpinner3 = WSpinner(frame: .zero)
        view.addSubview(indeterminateSpinner3)
        indeterminateSpinner3.snp.makeConstraints { (make) in
            make.centerY.equalTo(emptyProgressSpinner)
            make.left.equalTo(emptyProgressSpinner.snp.right).offset(12)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        indeterminateSpinner3.indeterminate = true
        indeterminateSpinner3.progressLineColor = .orange

        // MARK: Progress spinners.
        view.addSubview(progressSpinner1)
        progressSpinner1.snp.makeConstraints { (make) in
            make.top.equalTo(emptyProgressSpinner.snp.bottom).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        progressSpinner1.progressLineColor = .gray
        progressSpinner1.backgroundLineColor = .cyan
        progressSpinner1.icon = UIImage(named: "gear")!

        view.addSubview(progressSpinner2)
        progressSpinner2.snp.makeConstraints { (make) in
            make.centerY.equalTo(progressSpinner1)
            make.right.equalTo(progressSpinner1.snp.left).offset(-12)
            make.width.equalTo(55)
            make.height.equalTo(55)
        }
        progressSpinner2.lineWidth = 6
        progressSpinner2.progressLineColor = .cyan

        view.addSubview(progressSpinner3)
        progressSpinner3.snp.makeConstraints { (make) in
            make.centerY.equalTo(progressSpinner1)
            make.left.equalTo(progressSpinner1.snp.right).offset(12)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        progressSpinner3.lineWidth = 2
        progressSpinner3.progressLineColor = .black

        // MARK: Intended styling.
        let indeterminateSpinner4 = WSpinner(frame: .zero)
        indeterminateSpinner4.indeterminate = true
        view.addSubview(indeterminateSpinner4)
        indeterminateSpinner4.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(progressSpinner1.snp.bottom).offset(10)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }

        // MARK: Reset progress to allow a better demo.
        let resetProgressButton = UIButton()
        view.addSubview(resetProgressButton)
        resetProgressButton.setTitle("Reset Progress", for: .normal)
        resetProgressButton.setTitleColor(.white, for: .normal)
        resetProgressButton.backgroundColor = .clear
        resetProgressButton.layer.borderColor = UIColor.white.cgColor
        resetProgressButton.layer.cornerRadius = 5
        resetProgressButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.snp.bottom).offset(-12)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        let resetTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SpinnerExamplesVC.updateProgress(_:)))
        resetTapRecognizer.numberOfTapsRequired = 1
        resetProgressButton.addGestureRecognizer(resetTapRecognizer)

        startProgress()
    }

    open func updateProgress(_ sender: AnyObject) {
        if sender is Timer {
            let timer = sender as! Timer;

            currentProgress += 0.02

            if (currentProgress >= 1) {
                timer.invalidate()
            }
        } else if sender is UIGestureRecognizer {
            currentProgress = 0
            startProgress()
        }

        setProgress(currentProgress)
    }

    open func setProgress(_ progress: CGFloat) {
        progressSpinner1.progress = progress
        progressSpinner2.progress = progress
        progressSpinner3.progress = progress
    }

    open func startProgress() {
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SpinnerExamplesVC.updateProgress(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
}
