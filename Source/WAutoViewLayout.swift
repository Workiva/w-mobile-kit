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

public class AutoViewLayoutVC: UIViewController {
    public var collectionView: UICollectionView!
    let reuseIdentifier = "cell"

    public var views: [UIView] = []
    public var fittedHeight: CGFloat {
        get {
            return collectionView.collectionViewLayout.collectionViewContentSize().height
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.scrollEnabled = false

        view.addSubview(collectionView)
        collectionView.snp_remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize().height)
        }
    }

    func generateExampleViews(count: Int) -> [UIView] {
        var views: [UIView] = []

        for _ in 0...count {
            views.append(generateExampleView())
        }

        return views
    }

    func generateExampleView() -> UIView {
        // Size with width and height from 50-150
        let view = UIView(frame: CGRectMake(0, 0, CGFloat(arc4random_uniform(101)) + 30, CGFloat(arc4random_uniform(101)) + 30))
        view.backgroundColor = getRandomColor()

        return view
    }
}

extension AutoViewLayoutVC: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return views[indexPath.row].frame.size
    }
}

extension AutoViewLayoutVC: UICollectionViewDelegate {
}

extension AutoViewLayoutVC: UICollectionViewDataSource {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)

        cell.backgroundColor = getRandomColor()

        return cell
    }

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views.count
    }
}

func getRandomColor() -> UIColor{
    let randomRed:CGFloat = CGFloat(drand48())
    let randomGreen:CGFloat = CGFloat(drand48())
    let randomBlue:CGFloat = CGFloat(drand48())
    
    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
}
