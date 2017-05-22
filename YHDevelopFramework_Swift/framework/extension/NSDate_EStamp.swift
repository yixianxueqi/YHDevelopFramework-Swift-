//
//  NSDate_EStamp.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/12.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

/*
 该格式可以指定以下内容:
 
 G: 公元时代，例如AD公元
 
 yy: 年的后2位
 
 yyyy: 完整年
 
 MM: 月，显示为1-12
 
 MMM: 月，显示为英文月份简写,如 Jan
 
 MMMM: 月，显示为英文月份全称，如 Janualy
 
 dd: 日，2位数表示，如02
 
 d: 日，1-2位显示，如 2
 
 EEE: 简写星期几，如Sun
 
 EEEE: 全写星期几，如Sunday
 
 aa: 上下午，AM/PM
 
 H: 时，24小时制，0-23
 
 h：时，12小时制，0-11
 
 m: 分，1-2位
 
 mm: 分，2位
 
 s: 秒，1-2位
 
 ss: 秒，2位
 
 S: 毫秒
 */
import UIKit

extension NSDate {

    //获取当前时间戳
    static func getCurrentDateStamp() -> String {

        return getDateStamp(NSDate())
    }
    //获取按照指定格式的当前时间
    static func  getCurrentDate(_ formatter: String) -> String {
    
        return getFormatterDateTime(date: NSDate(), formatter: formatter)
    }
    //获取指定时间的时间戳
    static func getDateStamp(_ date: NSDate) -> String {
    
        let seconds = Int(date.timeIntervalSince1970 * 1_000)
        return String(seconds)
    }
    //获取指定格式和时间的时间
    static func getFormatterDateTime(date: NSDate, formatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: date as Date)
    }
    //获取指定时间戳和格式的时间
    static func getFormatterDateTime(dateStamp: String, formatter: String) -> String {
    
        let seconds = Double(dateStamp)! / 1_000
        let date = NSDate.init(timeIntervalSince1970: seconds)
        return getFormatterDateTime(date: date, formatter: formatter)
    }
    //获取指定时间的指定间隔的开始和结束
    static func getStartAndEndDate(_ date: NSDate, type: NSCalendar.Unit) -> (NSDate?, NSDate?) {
    
        var beginDate: NSDate?
        var endDate: NSDate?
        var inteval: TimeInterval = 0
        
        let calendar = NSCalendar.current as NSCalendar
        if type == .weekOfMonth || type == .weekOfYear {
            calendar.firstWeekday = 2
        }
        guard calendar.range(of: type, start: &beginDate, interval: &inteval, for: date as Date) else {
            return (nil, nil)
        }
        endDate = beginDate?.addingTimeInterval(inteval - 1)
        return (beginDate,endDate)
    }
}
