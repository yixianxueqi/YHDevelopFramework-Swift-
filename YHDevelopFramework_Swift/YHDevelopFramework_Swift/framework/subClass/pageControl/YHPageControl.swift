//
//  YHPageControl.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/24.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class YHPageControl: UIControl {
    
    var numberOfPages = 0 {
        didSet{ createSubview() }
    }
    var currentPage = 0 {
        willSet{
            guard newValue < numberOfPages else {
                return
            }
            setSelectItem(newValue)
        }
        didSet { setUnSelectItem(oldValue) }
    }
    var hidesForSiglePage = false {
        didSet { customView() }
    }
    //此属性需要在pointSize确定后才可生效
    var isCircle = false {
        didSet { changeBtnBorder() }
    }
    var pageIndicatorTintColor = UIColor.darkGray {
        didSet { setPointColor() }
    }
    var currentPageIndicatorTintColor = UIColor.white {
        didSet { setPointColor() }
    }
    //点大小
    var pointSize = CGSize.init(width: 15, height: 15) {
        didSet { changePointSize() }
    }
    //点间隙
    var space:CGFloat = 8.0 {
        didSet { customView() }
    }
    //点击回调
    var clickFunc:((Int) -> Void)?
    override var frame: CGRect {
        didSet { customView() }
    }
    private var activeImage: UIImage?
    private var unActiveImage: UIImage?
    private var subViewList:[YHButton] = Array()
    
    // MARK: - method
    //设置图片
    func setImageOfPoint(_ activeImage: UIImage, _ unActiveImage: UIImage) {
        self.activeImage = activeImage
        self.unActiveImage = unActiveImage
        setPointImage()
    }
    //设置颜色
    func setColorOfPoint(_ normalColor: UIColor, _ selectColor: UIColor) {
        pageIndicatorTintColor = normalColor
        currentPageIndicatorTintColor = selectColor
        setPointColor()
    }
    // MARK: - private method
    //创建子视图
    private func createSubview() {
    
        for i in 0..<numberOfPages {
            let btn = YHButton.init(type: .custom)
            subViewList.append(btn)
            btn.bounds = CGRect.init(x: 0, y: 0, width: pointSize.width, height: pointSize.height)
            btn.unSelectBackGroundColor = pageIndicatorTintColor
            btn.selectBackGroundColor = currentPageIndicatorTintColor
            btn.isSelected = false
            btn.tag = i + 1
            btn.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
        }
        customView()
    }
    //点击响应事件及回调
    @objc private func clickBtn(_ btn: YHButton) {
        currentPage = (btn.tag - 1)
        if clickFunc != nil {
            clickFunc!(btn.tag - 1)            
        }
    }
    private func setSelectItem(_ index: Int) {
        subViewList[index].isSelected = true
    }
    private func setUnSelectItem(_ index: Int) {
        if index != currentPage {
            subViewList[index].isSelected = false
        }
    }
    private func setPointColor() {
        for i in 0..<numberOfPages {
         subViewList[i].unSelectBackGroundColor = pageIndicatorTintColor
         subViewList[i].unSelectBackGroundColor = currentPageIndicatorTintColor
        }
    }
    private func setPointImage() {
        for i in 0..<numberOfPages {
            subViewList[i].setBackgroundImage(unActiveImage, for: .normal)
            subViewList[i].setBackgroundImage(activeImage, for: .selected)
        }
    }
    
    private func changePointSize() {
        for i in 0..<numberOfPages {
            subViewList[i].bounds = CGRect.init(x: 0, y: 0, width: pointSize.width, height: pointSize.height)
        }
        customView()
    }
    //改变圆角
    private func changeBtnBorder() {
        
        for i in 0..<numberOfPages {
            let btn = subViewList[i]
            if isCircle {
                btn.layer.cornerRadius = pointSize.width * 0.5
                btn.layer.masksToBounds = true
            } else {
                btn.layer.cornerRadius = 0
                btn.layer.masksToBounds = false
            }
        }
    }
    //设置视图
    private func customView() {
    
        if numberOfPages < 2 , hidesForSiglePage {
            self.isHidden = true
        } else {
            self.isHidden = false
        }
        if subviews.count > 0 {
            layoutView()
        } else {
            for i in 0..<numberOfPages {
                addSubview(subViewList[i])
            }
            layoutView()
        }
    }
    //布局btn
    private func layoutView() {
        var originX: CGFloat = 0
        let centerY = bounds.height * 0.5
        let needLength = pointSize.width * CGFloat.init(numberOfPages) + space * CGFloat.init(numberOfPages + 1)
        if needLength < bounds.width {
           originX = (bounds.width - needLength) * 0.5
        }
        for i in 0..<numberOfPages {
            let btn = subViewList[i]
            let halfWidth = pointSize.width * 0.5
            let length = CGFloat.init(i + 1) * (space + halfWidth) + CGFloat.init(i) * halfWidth
            let centerX = originX + length
            btn.center = CGPoint.init(x: centerX, y: centerY)
        }
    }
}

class YHButton : UIButton {
    
    var selectBackGroundColor: UIColor?
    var unSelectBackGroundColor: UIColor?
    override var isSelected: Bool {
        willSet {
            backgroundColor = newValue ? selectBackGroundColor! : unSelectBackGroundColor!
        }
    }
}
