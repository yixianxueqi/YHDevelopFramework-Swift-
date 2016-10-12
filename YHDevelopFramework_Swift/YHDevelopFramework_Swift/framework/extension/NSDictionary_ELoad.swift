//
//  Dictionary_ELoad.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/10/12.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

extension NSDictionary {

    //从plist文件读取字典
    static func dicFromPlist(_ name: String) -> NSDictionary? {
        
        guard let path = Bundle.main.path(forResource: name, ofType: ".plist") else {
            return nil
        }
        return NSDictionary.init(contentsOfFile: path) 
    }
    
    //从json文件读取字典
    static func dicFromJson(_ name: String) -> NSDictionary? {
    
        guard let path = Bundle.main.path(forResource: name, ofType: ".json") else {
            return nil
        }
        guard let data = NSData.init(contentsOfFile: path) as? Data else {
            return nil
        }
        do {
           let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            return json as? NSDictionary
        } catch {
            log.error(" dicFromJson error ")
        }
        return nil
    }
}
