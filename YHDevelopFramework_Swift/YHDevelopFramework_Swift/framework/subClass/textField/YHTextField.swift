//
//  YHTextField.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/21.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

class YHTextField: UITextField {

    
    @IBInspectable var regularLength = Int.max
    var regularRule: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addRegularCheckForSelf()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addRegularCheckForSelf()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addRegularCheckForSelf() -> Void {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidiChange(notification:)), name: .UITextFieldTextDidChange, object: nil)
        delegate = self
    }
    /// 中文判断处理
    ///
    /// - Parameter textView: textView
    /// - Returns: 0是是否越界，1是是否处于高亮状态
    fileprivate func checkChineseCharacter(textField: UITextField) -> (Bool,Bool) {
        
        let selectRange = textField.markedTextRange
        var posit: UITextPosition?
        if let range = selectRange {
            posit = textField.position(from: range.start, offset: 0)
        }
        if posit != nil, selectRange != nil {
            
            let startOffset = textField.offset(from: textField.beginningOfDocument, to: (selectRange?.start)!)
            let endOffset = textField.offset(from: textField.beginningOfDocument, to: (selectRange?.end)!)
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

//implementation Regular Check
extension YHTextField: UITextFieldDelegate {

    // MARK: - NSNotification: UITextFieldTextDidChange
    @objc fileprivate func textDidiChange(notification: NSNotification) -> Void {
        
        let result = checkChineseCharacter(textField: self)
        if result.1 {
            return
        }
        if let inputTetx = self.text {
            guard inputTetx.length < regularLength else {
                let index = inputTetx.index(inputTetx.startIndex, offsetBy: regularLength)
                text = inputTetx.substring(to: index)
                return
            }
        }
    }
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if regularLength != Int.max {
            let result = checkChineseCharacter(textField: textField)
            if result.1 {
                return true
            }
        }
        guard let _ = self.regularRule else {
            return true
        }
        let inputText = String.init(format: "%@%@", textField.text!,string)
        return (inputText as NSString).regularCheck(self.regularRule!)
    }

}
