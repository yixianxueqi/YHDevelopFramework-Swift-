//
//  SpringDemoViewController.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/18.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit
import Spring

class SpringDemoViewController: BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var animateView: SpringView!
    @IBOutlet weak var forceTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var delayTextField: UITextField!
    @IBOutlet weak var dampTextField: UITextField!
    @IBOutlet weak var velocityTextField: UITextField!
    @IBOutlet weak var rotateTextField: UITextField!
    @IBOutlet weak var xTextField: UITextField!
    @IBOutlet var yTextField: UITextField!
    @IBOutlet weak var scaleTextField: UITextField!
    
    @IBOutlet weak var pickView: UIPickerView!
    var selectAnimation: Int?
    var selectCurves: Int?
    let animations: [Spring.AnimationPreset] = [
        .Shake,
        .Pop,
        .Morph,
        .Squeeze,
        .Wobble,
        .Swing,
        .FlipX,
        .FlipY,
        .Fall,
        .SqueezeLeft,
        .SqueezeRight,
        .SqueezeDown,
        .SqueezeUp,
        .SlideLeft,
        .SlideRight,
        .SlideDown,
        .SlideUp,
        .FadeIn,
        .FadeOut,
        .FadeInLeft,
        .FadeInRight,
        .FadeInDown,
        .FadeInUp,
        .ZoomIn,
        .ZoomOut,
        .Flash
    ]
    var animationCurves: [Spring.AnimationCurve] = [
        .EaseIn,
        .EaseOut,
        .EaseInOut,
        .Linear,
        .Spring,
        .EaseInSine,
        .EaseOutSine,
        .EaseInOutSine,
        .EaseInQuad,
        .EaseOutQuad,
        .EaseInOutQuad,
        .EaseInCubic,
        .EaseOutCubic,
        .EaseInOutCubic,
        .EaseInQuart,
        .EaseOutQuart,
        .EaseInOutQuart,
        .EaseInQuint,
        .EaseOutQuint,
        .EaseInOutQuint,
        .EaseInExpo,
        .EaseOutExpo,
        .EaseInOutExpo,
        .EaseInCirc,
        .EaseOutCirc,
        .EaseInOutCirc,
        .EaseInBack,
        .EaseOutBack,
        .EaseInOutBack
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickView.delegate = self
        pickView.dataSource = self
        pickView.showsSelectionIndicator = true
        initializeParam()
    }
    
    func initializeParam() {
        
        forceTextField.text = "1"
        durationTextField.text = "1"
        delayTextField.text = "0"
        dampTextField.text = "0.7"
        velocityTextField.text = "0.7"
        rotateTextField.text = "0"
        scaleTextField.text = "1"
        xTextField.text = "0"
        yTextField.text = "0"
        rotateTextField.text = "0"
        selectAnimation = 0
        selectCurves = 0
    }
    
    func transFloatValue(_ text: String) -> CGFloat {
    
        return CGFloat.init(Float.init(text)!)
    }
    
    func setOptions() {
    
        animateView.force = transFloatValue(forceTextField.text!)
        animateView.duration = transFloatValue(durationTextField.text!)
        animateView.delay = transFloatValue(delayTextField.text!)
        animateView.damping = transFloatValue(dampTextField.text!)
        animateView.velocity = transFloatValue(velocityTextField.text!)
        animateView.rotate = transFloatValue(rotateTextField.text!)
        animateView.x = transFloatValue(xTextField.text!)
        animateView.y = transFloatValue(yTextField.text!)
        animateView.scaleX = transFloatValue(scaleTextField.text!)
        animateView.scaleY = transFloatValue(scaleTextField.text!)
        animateView.animation = animations[selectAnimation!].rawValue
        animateView.curve = animationCurves[selectCurves!].rawValue
    }
    
    @IBAction func clickAnimate(_ sender: UIButton) {

        setOptions()
        animateView.animate()
        animateView.animateNext {
            log.debug("animate complete")
        }
    }
    
    // MARK: - UIPickerViewDelegate,UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? animations.count : animationCurves.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? animations[row].rawValue : animationCurves[row].rawValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            selectAnimation = row
        default:
            selectCurves = row
        }
    }
}
