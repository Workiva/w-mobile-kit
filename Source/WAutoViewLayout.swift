//
//  WAutoViewLayout.swift
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

import UIKit
import SnapKit

public class WAutoViewLayoutVC: UIViewController {
    public var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    public var flowLayout = UICollectionViewFlowLayout()

    public var views: [UIView] = [] {
        didSet {
            refreshAutoViewLayout()
        }
    }

    public var leftSpacing: CGFloat = 5 {
        didSet {
            updateCollectionView()
        }
    }
    public var topSpacing: CGFloat = 5 {
        didSet {
            updateCollectionView()
        }
    }
    public var rightSpacing: CGFloat = 5 {
        didSet {
            updateCollectionView()
        }
    }
    public var bottomSpacing: CGFloat = 5 {
        didSet {
            updateCollectionView()
        }
    }

    public var fittedHeight: CGFloat {
        get {
            return collectionView.collectionViewLayout.collectionViewContentSize().height
        }
    }

    let reuseIdentifier = "cell"

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        commonInit()
    }

    func commonInit() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.scrollEnabled = false

        updateCollectionView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.frame = view.frame

        view.addSubview(collectionView)
        collectionView.snp_remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize().height)
        }
    }

    func updateCollectionView() {
        flowLayout.sectionInset = UIEdgeInsets(top: topSpacing, left: leftSpacing, bottom: bottomSpacing, right: rightSpacing)
        collectionView.collectionViewLayout = flowLayout
    }

    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        coordinator.animateAlongsideTransition(nil, completion:  { [weak self] _ in
            self?.refreshAutoViewLayout()
        })
    }

    public func refreshAutoViewLayout() {
        collectionView.reloadData()

        collectionView.snp_updateConstraints { (make) in
            make.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize().height)
        }
    }
}

extension WAutoViewLayoutVC: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return views[indexPath.row].frame.size
    }
}

extension WAutoViewLayoutVC: UICollectionViewDelegate {}

extension WAutoViewLayoutVC: UICollectionViewDataSource {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)

        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })

        if (indexPath.row < views.count) {
            let newView = views[indexPath.row]
            cell.contentView.addSubview(newView)
            newView.snp_makeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }

        return cell
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views.count
    }
}
