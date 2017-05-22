//
//  YHWaterFallLayout.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/22.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import CoreGraphics

protocol YHWaterFallLayoutDelegate {
    
    func cellHeight(for indexPath: IndexPath) -> CGFloat
    
}

class YHWaterFallLayout: UICollectionViewFlowLayout {
    
    var column = 3
    var delegate:YHWaterFallLayoutDelegate?
    private var attributeList = [UICollectionViewLayoutAttributes]()
    private var topYList = [CGFloat]()
    private var itemWidth: CGFloat = 0
    private var storeAttributeList = [UICollectionViewLayoutAttributes]()
    private let bounds = UIScreen.main.bounds
    private let gloabQueue = DispatchQueue.global(qos: .utility)
    private let mainQueue = DispatchQueue.main
    
    override func prepare() {
        super.prepare()
    
        //计算每隔item的宽度,(容器视图宽度-左右间距-列间距)/列数
        if itemWidth == 0 {
            let spaceLength = sectionInset.left + sectionInset.right + CGFloat.init(column - 1)  * minimumInteritemSpacing
            let width = (collectionView?.bounds.size.width)!
            itemWidth = (width - spaceLength) / CGFloat.init(column)
        }
        //当attribute个数小于item个数时进行计算，当attribute计算完毕后，就不再重复求attribute
        //即第一次时就创建了所有的attribute,后续使用缓存的attributeList
        if attributeList.count != (collectionView?.numberOfItems(inSection: 0))! {
            for _ in 0..<column {
                topYList.append(sectionInset.top)
            }
            let count = collectionView?.numberOfItems(inSection: 0)
            for i in 0..<count! {
                let attribute = layoutAttributesForItem(at: IndexPath.init(row: i, section: 0))
                attributeList.append(attribute!)
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
    
        let item = getMaxTopY()
        return CGSize.init(width: 0, height: item.1 + sectionInset.bottom)
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        return attributeList
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let minItem = getMinTopY()
        let itemX = sectionInset.left + (minimumInteritemSpacing + itemWidth) * CGFloat.init(minItem.0)
        let maxhHeight = minItem.1
        let itemY = maxhHeight + minimumLineSpacing
        var itemHeight: CGFloat = 0
        if delegate != nil {
            itemHeight = (delegate?.cellHeight(for: indexPath))!
        }
        attribute.frame = CGRect.init(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
        topYList[minItem.0] = attribute.frame.maxY
        return attribute
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return !(collectionView?.bounds.equalTo(newBounds))!
    }
    //获取数组内最小元素
    private func getMinTopY() -> (Int, CGFloat) {
        
        var min:(Int, CGFloat) = (0, topYList.first!)
        for (index, value) in topYList.enumerated() {
            if min.1 > value {
                min.0 = index
                min.1 = value
            }
        }
        return min
    }
    //获取数组内最大元素
    private func getMaxTopY() -> (Int, CGFloat) {
    
        var max:(Int, CGFloat) = (0, topYList.first!)
        for (index,value) in topYList.enumerated() {
            if max.1 < value {
                max.0 = index
                max.1 = value
            }
        }
        return max
    }
}
