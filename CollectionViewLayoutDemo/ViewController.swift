//
//  ViewController.swift
//  CollectionViewLayoutDemo
//
//  Created by SamChiang on 2020/8/11.
//  Copyright © 2020 SamChiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var layout: SCCollectionViewLeftAlignedLayout = {
        let layout = SCCollectionViewLeftAlignedLayout()
        let itemSpacing: CGFloat = 10
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 150, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
        return layout
    }()

    var dataArr = ["我是段文字", "我是长文字所以我很长", "我是段文字", "我是段文字", "我是段文字", "我是段文字",  "我是段文字","我是长文字所以我很长"]

    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .yellow
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - UICollectionViewDelegate

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
        cell.backgroundColor = getRandomColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - layout.minimumInteritemSpacing * 4) / 3
        if dataArr[indexPath.item].count > 8 {
            return CGSize(width: floor(itemWidth * 2 + layout.minimumInteritemSpacing), height: 50)
        } else {
            return CGSize(width: floor(itemWidth), height: 50)
        }
    }
}





func getRandomColor() -> UIColor {
    let red = CGFloat(Int.random(in: 0 ... 255)) / 255
    let green = CGFloat(Int.random(in: 0 ... 255)) / 255
    let blue = CGFloat(Int.random(in: 0 ... 255)) / 255

    return UIColor(red: red, green: green, blue: blue, alpha: 1)
}
