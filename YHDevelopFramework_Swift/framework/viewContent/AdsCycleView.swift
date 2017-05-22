//
//  AdsCycleView.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/24.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import Kingfisher

class AdsCycleView: UIView, UIScrollViewDelegate {

    var clickHandle:((Int) -> Void)?
    
    private var adsStringList: [String]?
    private var pageControl: YHPageControl?
    private var alignment: ControlAlignment?
    private var scrollView: UIScrollView?
    private let urlList: [String]?
    private let holdImage: UIImage?
    private let imageList: [UIImage]?
    private var imageViewList = [UIImageView]()
    private var tempList = [UIImageView]()
    private var timer: Timer?
    //此值用来解决定时器第一次走时的bug
    private var tempIndex: Int = 0
    
    // MARK: - init
    init(frame: CGRect, urlList: [String], holdImage: UIImage) {
        self.urlList = urlList
        self.holdImage = holdImage
        self.imageList = nil
        super.init(frame: frame)
        createSubImageView(false)
    }
    init(frame: CGRect, imageList: [UIImage]) {
        self.urlList = nil
        self.holdImage = nil
        self.imageList = imageList
        super.init(frame: frame)
        createSubImageView(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.urlList = nil
        self.holdImage = nil
        self.imageList = nil
        super.init(coder: aDecoder)
    }
    // MARK: - method
    //添加广告词
    func customAdsStringList(_ strList: [String]) {
        adsStringList = strList
        addAdsString()
    }
    //添加分页控制器，建议若存在广告词则在customAdsStringList之后调用此方法
    //注：如果存在广告词，则默认居右
    func customPageControl(_ pageControl: YHPageControl, _ alignment: ControlAlignment) {
        self.pageControl = pageControl
        if adsStringList != nil {
            self.alignment = ControlAlignment.right
        } else {
            self.alignment = alignment
        }
        addPageControl()
    }
    //开启自动滚动轮播,时间间隔默认5s
    func startAutoCycle(_ seconds: TimeInterval = 5) {
    
        if timer != nil {
            resumeTimer()
        } else {
            timer = Timer.init(timeInterval: seconds, target: self, selector: #selector(timeGo), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
            timer?.fire()
        }
    }
    //定时器相关
    func stopTimer() {
        timer?.fireDate = Date.distantFuture
    }
    func resumeTimer() {
        timer?.fireDate = Date.distantPast
    }
    func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - private method
    private func createSubImageView(_ isLocalImage: Bool) {
        
        if isLocalImage {
            for (index, img) in (imageList?.enumerated())! {
                let imgView = getImageView()
                imgView.image = img
                imageViewList.append(imgView)
                //额外获取创建第一个和最后一个
                if index == 0 {
                    let imgView = getImageView()
                    imgView.image = img
                    tempList.append(imgView)
                }
                if index == (imageList?.count)! - 1 {
                    let imgView = getImageView()
                    imgView.image = img
                    tempList.append(imgView)
                }
            }
        } else {
            for (index, urlStr) in (urlList?.enumerated())! {
                let url = URL.init(string: urlStr)
                let imgView = getImageView()
                imgView.kf.setImage(with: url, placeholder: holdImage, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
                imageViewList.append(imgView)
                //额外获取创建第一个和最后一个
                if index == 0 {
                    let imgView = getImageView()
                    imgView.kf.setImage(with: url, placeholder: holdImage, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
                    tempList.append(imgView)
                }
                if index == (urlList?.count)! - 1 {
                    let imgView = getImageView()
                    imgView.kf.setImage(with: url, placeholder: holdImage, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
                    tempList.append(imgView)
                }
            }
        }
        //无限循环轮播，需要n+2张，即首尾各加一张
        imageViewList.insert(tempList.last!, at: 0)
        imageViewList.append(tempList.first!)
        customView()
    }
    //布局界面
    private func customView() {
        
        scrollView = getScrollView()
        addSubview(scrollView!)
        for (index, imgView) in imageViewList.enumerated() {
            imgView.tag = index + 1
            imgView.frame = CGRect.init(x: CGFloat.init(index) * bounds.width, y: 0, width: bounds.width, height: bounds.height)
            scrollView?.addSubview(imgView)
        }
        scrollView?.setContentOffset(CGPoint.init(x: bounds.width, y: 0), animated: false)
    }
    //设置广告词
    private func addAdsString() {
    
        let firstStr = adsStringList?.first!
        let lastStr = adsStringList?.last!
        adsStringList?.insert(lastStr!, at: 0)
        adsStringList?.append(firstStr!)
        
        for (index, imgView) in imageViewList.enumerated() {
            addTitleLabelToImageView((adsStringList?[index])!, imgView: imgView)
        }
    }
    //添加title至图片上
    private func addTitleLabelToImageView(_ title: String, imgView: ImageView?) {
        
        if title.isEmpty {
            return
        }
        let space: CGFloat = 8
        let width = bounds.width * 0.67
        let strHeight = stringHeight(title, width: width, fontSize: 11.0)
        let bgHeight = strHeight + space * 2
        let bgImageView = UIImageView.init(frame: CGRect.init(x: 0, y: bounds.height - bgHeight, width: bounds.width, height: bgHeight))
        bgImageView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let label = UILabel.init(frame: CGRect.init(x: space, y: space, width: width, height: strHeight))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.numberOfLines = 2
        label.text = title
        bgImageView.addSubview(label)
        imgView?.addSubview(bgImageView)
        
    }
    //获取文本高度
    private func stringHeight(_ str: String, width: CGFloat, fontSize: CGFloat) -> CGFloat {
        
        return str.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize)], context: nil).size.height
    }
    //添加分页控制器
    private func addPageControl() {
    
        let width: CGFloat = bounds.width * 0.33
        let height: CGFloat = 30
        var rect: CGRect!
        if alignment == ControlAlignment.right {
           rect = CGRect.init(x: bounds.width - width, y: bounds.height - height, width: width, height: 30)
        } else if alignment == ControlAlignment.center {
            let x = (bounds.width - width) * 0.5
            rect = CGRect.init(x: x, y: bounds.height - height, width: width, height: height)
        } else {
            rect = CGRect.init(x: 8, y: bounds.height - height, width: width, height: height)
        }
        pageControl?.frame = rect
        pageControl?.isUserInteractionEnabled = false
        addSubview(pageControl!)
        self.bringSubview(toFront: pageControl!)
    }
    //获取imageView
    private func getImageView() -> UIImageView {
    
        let imgView = UIImageView.init()
        imgView.contentMode = .scaleToFill
        imgView.backgroundColor = UIColor.white
        imgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapHandle(tap:)))
        imgView.addGestureRecognizer(tap)
        return imgView
    }
    //获取scrollView
    private func getScrollView() -> UIScrollView {
        
        let scView = UIScrollView.init()
        scView.frame = bounds
        let width = CGFloat.init(imageViewList.count) * bounds.width
        scView.contentSize = CGSize.init(width: width, height: bounds.height)
        scView.bounces = false
        scView.isPagingEnabled = true
        scView.showsHorizontalScrollIndicator = false
        scView.showsVerticalScrollIndicator = false
        scView.delegate = self
        return scView
    }
    //事件处理
    @objc private func tapHandle(tap: UITapGestureRecognizer) {
        if let handle = clickHandle {
            handle((tap.view?.tag)! - 2)
        }
    }
    //定时器执行
    @objc private func timeGo() {
    
        var width: CGFloat!
        if tempIndex < 1{
            width = (scrollView?.contentOffset.x)!
            tempIndex += 1
        } else {
            width = (scrollView?.contentOffset.x)! + bounds.width
        }
        scrollView?.setContentOffset(CGPoint.init(x: width, y: 0), animated: true)
        let seconds = DispatchTime.now() + Double(0.25)
        DispatchQueue.main.asyncAfter(deadline: seconds) { 
            self.cycleMove(width)
        }
    }
    //滚动
    private func cycleMove(_ offsetX: CGFloat) {
    
        let width = bounds.width
        let index = Int.init(offsetX / width)
        if index == imageViewList.count - 1 {
            scrollView?.setContentOffset(CGPoint.init(x: width, y: 0), animated: false)
            pageControl?.currentPage = 0
        } else if index == 0 {
            let toX = CGFloat.init(imageViewList.count - 2) * width
            scrollView?.setContentOffset(CGPoint.init(x: toX, y: 0), animated: false)
            pageControl?.currentPage = (pageControl?.numberOfPages)! - 1
        } else {
            pageControl?.currentPage = index - 1
        }
    }
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        cycleMove(scrollView.contentOffset.x)
    }
}

enum ControlAlignment {
    case left
    case center
    case right
}
