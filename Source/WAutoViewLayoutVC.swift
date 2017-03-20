//
//  WAutoViewLayoutVC.swift
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

import UIKit
import SnapKit

class WLeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
       var attributes = super.layoutAttributesForElements(in: rect)

        if let originalAttributes = attributes {
            // Make a copy to avoid warnings
            attributes = NSArray(array: originalAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
        }

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if (layoutAttribute.frame.origin.y >= maxY) {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}

public class WAutoViewLayoutVC: UIViewController {
    public var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    public var flowLayout = UICollectionViewFlowLayout()

    public var alignment: xAlignment = .center {
        didSet {
            if (alignment != oldValue) {
                switch alignment {
                case .right:
                    print("Only left and centered are currently supported. Defaulting to centered...")
                    alignment = .center
                    flowLayout = UICollectionViewFlowLayout()
                case .left:
                    flowLayout = WLeftAlignedCollectionViewFlowLayout()
                case .center:
                    flowLayout = UICollectionViewFlowLayout()
                }

                updateCollectionView()
                refreshAutoViewLayout()
            }
        }
    }

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
            return collectionView.collectionViewLayout.collectionViewContentSize.height
        }
    }

    public class func estimatedFittedHeight(views: [UIView], constrainedWidth: CGFloat, leftSpacing: CGFloat = 5, topSpacing: CGFloat = 5, rightSpacing: CGFloat = 5, bottomSpacing: CGFloat = 5) -> CGFloat {
        let autoViewLayoutVC = WAutoViewLayoutVC(width: constrainedWidth)
        autoViewLayoutVC.leftSpacing = leftSpacing
        autoViewLayoutVC.topSpacing = topSpacing
        autoViewLayoutVC.rightSpacing = rightSpacing
        autoViewLayoutVC.bottomSpacing = bottomSpacing

        autoViewLayoutVC.views = views

        return autoViewLayoutVC.fittedHeight
    }

    let reuseIdentifier = "cell"

    /// Use so that the size of the collection view is correct
    public convenience init(width: CGFloat) {
        self.init()
        
        updateWidth(width: width)
    }

    /// If the height of the collection view is not set during init, call this method to update the width.
    public func updateWidth(width: CGFloat) {
        view.frame.size.width = width
        collectionView.frame.size.width = width
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        commonInit()
    }

    func commonInit() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear

        updateCollectionView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.frame = view.frame

        view.addSubview(collectionView)
        collectionView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize.height)
        }
    }

    func updateCollectionView() {
        flowLayout.sectionInset = UIEdgeInsets(top: topSpacing, left: leftSpacing, bottom: bottomSpacing, right: rightSpacing)
        collectionView.collectionViewLayout = flowLayout
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil, completion:  { [weak self] _ in
            self?.refreshAutoViewLayout()
        })
    }

    public func refreshAutoViewLayout() {
        collectionView.reloadData()

        collectionView.snp.updateConstraints { (make) in
            make.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize.height)
        }
    }
}

extension WAutoViewLayoutVC: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return views[indexPath.row].frame.size
    }
}

extension WAutoViewLayoutVC: UICollectionViewDelegate {}

extension WAutoViewLayoutVC: UICollectionViewDataSource {
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath)

        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })

        if (indexPath.row < views.count) {
            let newView = views[indexPath.row]
            cell.contentView.addSubview(newView)
            newView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views.count
    }
}
