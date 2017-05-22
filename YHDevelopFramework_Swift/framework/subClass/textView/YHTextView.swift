//
//  YHTextView.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/21.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
/*
    notice:
        长度限制和内容校验 建议只使用其一，
        若同时使用，则可能只有长度限制生效
 */
class YHTextView: UITextView {

    @IBInspectable var regularLength = Int.max
    @IBInspectable var placeHolder: String? {
        willSet {
            placeHolderLabel.text = newValue
        }
    }
    var regularRule: String?
    var regularLengthResultReport: ((Int) -> Void)?
    private let placeHolderLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 0
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addPlaceHold()
        addRegularCheckForSelf()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addPlaceHold()
        addRegularCheckForSelf()
    }
    
    private func addRegularCheckForSelf() -> Void {
    
        delegate = self
    }
    private func addPlaceHold() -> Void {
        
        self.addSubview(placeHolderLabel)
        self.setValue(placeHolderLabel, forKey: "_placeholderLabel")
    }
    
    /// 中文判断处理
    ///
    /// - Parameter textView: textView
    /// - Returns: 0是是否越界，1是是否处于高亮状态
    fileprivate func checkChineseCharacter(textView: UITextView) -> (Bool,Bool) {
    
        let selectRange = textView.markedTextRange
        var posit: UITextPosition?
        if let range = selectRange {
            posit = textView.position(from: range.start, offset: 0)
        }
        if posit != nil, selectRange != nil {
            
            let startOffset = textView.offset(from: textView.beginningOfDocument, to: (selectRange?.start)!)
            let endOffset = textView.offset(from: textView.beginningOfDocument, to: (selectRange?.end)!)
            let range = NSRange.init(location: startOffset, length: endOffset - startOffset)
            if range.location < regularLength {
                return (true,true)
            } else {
                return (false,true)
            }
        }
        return (true,false)
    }
}

extension YHTextView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        
        let result = checkChineseCharacter(textView: textView)
        if result.1 {
            return
        }
        guard textView.text.length < regularLength else {
            let index = textView.text.index(textView.text.startIndex, offsetBy: regularLength)
            text = textView.text.substring(to: index)
            regularLengthResultReport?(0)
            return
        }
        regularLengthResultReport?(regularLength - textView.text.length)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if regularLength != Int.max {
            let result = checkChineseCharacter(textView: textView)
            if result.1 {
                return true
            }
        }
        guard let _ = self.regularRule else {
            return true
        }
        let inputText = String.init(format: "%@%@", textView.text!,text)
        return (inputText as NSString).regularCheck(self.regularRule!)
    }
}
