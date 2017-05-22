//
//  NSString_ERegularCheck.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/20.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import Foundation

extension NSString {

    func regularCheck(_ rule: String) -> Bool {
    
        guard rule.length > 0 else {
            return false
        }
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", rule)
        return predicate.evaluate(with: self)
    }
}

class RegularRule {

    //校验用户名 - 只含有汉字、数字、字母、下划线，下划线位置不限
    static let userName = "^[a-zA-Z0-9_\\u4e00}-\\u9fa5]+$"
    //校验用户名 - 只含有汉字、数字、字母、下划线不能以下划线开头和结尾
    static let userName2 = "^(?!_)(?!.*?_$)[a-zA-Z0-9_\\u4e00-\\u9fa5]+$"
    /*
     校验邮箱
     验证类似 3289@qq.com  或者 3289@qq.vip.cn
     如果失败请用 email2
     */
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+(\\.[A-Za-z]{2,4})+"
    //校验邮箱
    static let email2 = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}||[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}+\\.[A-Za-z]{2,4}]"
    //校验密码 - 允许包含字母、数字、下划线、*、#
    static let password = "(^[A-Za-z0-9_*#]{0,15}$)"
    //校验电话号 - 
    static let telPhone = "^(\\d{3,4}-)\\d{7,8}$"
    //校验手机号 - 手机号以13， 15，17，18开头，八个 \d 数字字符
    static let mobilPhone = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
    //检测传真格式 - 
    static let fax = "((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)"
    //校验纯数字
    static let number = "^[0-9]*$"
    //检查是否是数字或者浮点数
    static let floatNumber = "^[0-9]+[.]{0,1}[0-9]{0,1}$"
    //检测除_与-之外的特殊字符是否存在
    static let regex = "^[A-Za-z0-9\\u4e00-\\u9fa5_-]+$"
    //检测是否是URL
    static let url = "((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"
    //检测身份证号
    static let idCard = "^(\\d{14}|\\d{17})(\\d|[xX])$"
    //检测是否是QQ号 - 腾讯QQ号从10 000 开始
    static let qq = "[1-9][0-9]{5,9}"
    //车牌号验证
    static let carNumber = "^[\\u4e00-\\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\\u4e00-\\u9fa5]$"
    //检测邮政编码
    static let postNumber = "[1-9]\\d{5}(?!\\d)"
    //检测IP地址
    static let ipNumber = "^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$"
    //检测只能输入由数字和26个英文字母、下划线组成的字符串
    static let varStr = "^[0-9a-zA-Z_]{1,}$"
    //验证首字母大写
    static let FirstUpper = "^[A-Z][a-zA-Z0-9]{0,}$"
    //检测匹配帐号是否合法 - 字母开头，允许5-16字节，允许字母数字下划线
    static let account = "^[a-zA-Z][a-zA-Z0-9_]{4,15}$"
    //检测匹配空行
    static let spaceLine = "\\n[\\s| ]*\\r"
    //匹配首尾空白字符
    static let spaceInHeaderTail = "^\\s*|\\s*$"
    //匹配是否含有^%&',;=?$\"等字符：。
    static let special = "[-\\[\\]~`!@#$%^&*()_+=|}{:;'/?,.\"\\\\]*"
    //2~4个汉字
    static let twoFourChinese = "^[\\u4e00-\\u9fa5]{2,4}$"
    //匹配年-月-日
    static let formatDate = "^((((1[6-9]|[2-9]\\d)\\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\\d|3[01]))|(((1[6-9]|[2-9]\\d)\\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\\d|30))|(((1[6-9]|[2-9]\\d)\\d{2})-0?2-(0?[1-9]|1\\d|2[0-8]))|(((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$"
    //只能输入有两位小数的正实数
    static let twoSpitNumber = "(^[1-9][0-9]{0,9}(\\.[0-9]{0,2})?)|(^0(\\.[0-9]{0,2})?)"
    //只能输入1~6位的数字
    static let oneSixNumber = "^\\d{1,6}$"
    //只能输入6位数字
    static let sixOnlyNumber = "^\\d{6}$"
    //至少输入6位数字
    static let sixMoreNumber = "^\\d{6,}$"
    
}
