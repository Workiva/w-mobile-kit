//
//  PanelExample.swift
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

public class PanelExampleVC: WPagingPanelVC {
    override public func viewDidLoad() {
        super.viewDidLoad()

        let panelContent1 = PanelContentVC()
        let panelContent2 = PanelContentVC()
        panelContent2.contentType = 1
        let panelContent3 = PanelContentVC()
        panelContent3.contentType = 2

        floatingButton.icon = UIImage(named: "drawer")

        minimumSnapHeight = 240

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

        if (contentType < 2) {
            let tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")

            view.addSubview(tableView)

            tableView.snp.makeConstraints { (make) in
                make.edges.equalTo(view)
            }
        } else {
            let colorView = UIView()
            colorView.backgroundColor = UIColor.blue.withAlphaComponent(0.6)
            view.addSubview(colorView)

            let label = UILabel()
            label.text = "This view has a set height, so we need a minimum height for smaller screen sizes"
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textColor = .white
            label.font = .boldSystemFont(ofSize: 18)
            label.textAlignment = .center
            colorView.addSubview(label)


            colorView.snp.makeConstraints { (make) in
                make.left.top.right.width.equalTo(view).inset(20)
                make.height.equalTo(180)
            }

            label.snp.makeConstraints { (make) in
                make.edges.equalTo(colorView).inset(8)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        cell.textLabel?.text = "Cell " + String(indexPath.row + (contentType * tableView.numberOfRows(inSection: 0)))

        return cell
    }
}

class OuterContentVC: WSideMenuContentVC {
    weak var panelDelegate: WPanelDelegate?

    var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white.withAlphaComponent(0.5)

        view.addSubview(whiteView)
        whiteView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(20).priority(1000)
        }

        whiteView.addSubview(label)

        label.font = .systemFont(ofSize: 40)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        if let panelDelegate = panelDelegate {
            label.text = "This is the content of the view controller\nPanel: " + (panelDelegate.isSidePanel() ? "Side Panel" : "Vertical Panel")
        } else {
            label.text = "This is the content of the view controller"
        }

        label.snp.makeConstraints { (make) in
            make.center.equalTo(whiteView).priorityHigh()
            make.width.equalTo(whiteView).multipliedBy(0.9)
        }
    }

    // Can use viewWillTransitionToSize and animating alongside coordinator to detect is panel changes between side panel
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { (context) in
                if let panelDelegate = self.panelDelegate {
                    self.label.text = "This is the content of the view controller\nPanel: " + (panelDelegate.isSidePanel() ? "Side Panel" : "Vertical Panel")
                }
            },
            completion: nil
        )
    }
}
