//
//  PanelExample.swift
//  WMobileKitExample
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

import Foundation
import WMobileKit

public class PanelExampleVC: WPagingPanelVC {
    public override func viewDidLoad() {
        super.viewDidLoad()

        let panelContent1 = PanelContentVC()
        let panelContent2 = PanelContentVC()
        panelContent2.contentType = 1
        let panelContent3 = PanelContentVC()
        panelContent3.contentType = 2

        floatingButton.icon = UIImage(named: "drawer")

        pages = [panelContent1, panelContent2, panelContent3]

        let outerContentVC = OuterContentVC()
        outerContentVC.panelDelegate = self

        // Can add content directly to contentContainerView
        addViewControllerToContainer(contentContainerView, viewController: outerContentVC)
    }
}

class PanelContentVC: WSideMenuContentVC, UITableViewDelegate, UITableViewDataSource {
    var contentType: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tableCell")

        view.addSubview(tableView)

        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")!
        cell.textLabel?.text = "Cell " + String(indexPath.row + (contentType * tableView.numberOfRowsInSection(0)))

        return cell
    }
}

class OuterContentVC: WSideMenuContentVC {
    weak var panelDelegate: WPanelDelegate?

    var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)

        view.addSubview(whiteView)
        whiteView.snp_makeConstraints { (make) in
            make.edges.equalTo(view).inset(20).priorityHigh()
        }

        whiteView.addSubview(label)

        label.font = .systemFontOfSize(40)
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        if let panelDelegate = panelDelegate {
            label.text = "This is the content of the view controller\nPanel: " + (panelDelegate.isSidePanel() ? "Side Panel" : "Vertical Panel")
        } else {
            label.text = "This is the content of the view controller"
        }

        label.snp_makeConstraints { (make) in
            make.center.equalTo(whiteView).priorityHigh()
            make.width.equalTo(whiteView).multipliedBy(0.9)
        }
    }

    // Can use viewWillTransitionToSize and animating alongside coordinator to detect is panel changes between side panel
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        coordinator.animateAlongsideTransition({ (context) in
                if let panelDelegate = self.panelDelegate {
                    self.label.text = "This is the content of the view controller\nPanel: " + (panelDelegate.isSidePanel() ? "Side Panel" : "Vertical Panel")
                }
            },
            completion: nil
        )
    }
}
