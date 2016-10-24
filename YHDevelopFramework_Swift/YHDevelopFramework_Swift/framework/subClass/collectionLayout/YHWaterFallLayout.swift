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
    private var maxYDic = NSMutableDictionary()
    private var itemWidth: CGFloat = 0
    override func prepare() {
        super.prepare()
        //计算每隔item的宽度,(容器视图宽度-左右间距-列间距)/列数
        let spaceLength = sectionInset.left + sectionInset.right + CGFloat.init(column - 1)  * minimumInteritemSpacing
        let width = (collectionView?.bounds.size.width)!
        itemWidth = (width - spaceLength) / CGFloat.init(column)
        for i in 0..<column {
            maxYDic.setValue(sectionInset.top, forKey: String.init(i))
        }
        let count = collectionView?.numberOfItems(inSection: 0)
        attributeList.removeAll()
        for i in 0..<count! {
            let attribute = layoutAttributesForItem(at: IndexPath.init(row: i, section: 0))
            attributeList.append(attribute!)
        }
    }
    
    override var collectionViewContentSize: CGSize {
    
        var maxY: CGFloat = 0
        for dic in maxYDic.enumerated() {
            let temp = CGFloat.init(dic.element.value as! CGFloat)
            if maxY < temp {
                maxY = temp
            }
        }
        return CGSize.init(width: 0, height: maxY + sectionInset.bottom)
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributeList
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        var minIndex = 0
        for dic in maxYDic {
            let height = maxYDic.value(forKey: String.init(minIndex)) as! CGFloat
            let dicHeight = dic.value as! CGFloat
            if  dicHeight < height {
                minIndex = Int.init(dic.key as! String)!
            }
        }
        let itemX = sectionInset.left + (minimumInteritemSpacing + itemWidth) * CGFloat.init(minIndex)
        let maxhHeight = maxYDic.value(forKey: String.init(minIndex)) as! CGFloat
        let itemY = maxhHeight + minimumLineSpacing
        var itemHeight: CGFloat = 0
        if delegate != nil {
            itemHeight = (delegate?.cellHeight(for: indexPath))!
        }
        attribute.frame = CGRect.init(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
        maxYDic[String.init(minIndex)] = attribute.frame.maxY
        return attribute
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return !(collectionView?.bounds.equalTo(newBounds))!
    }
    
}
