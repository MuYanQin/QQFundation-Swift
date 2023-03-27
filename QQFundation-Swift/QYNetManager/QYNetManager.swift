//
//  QYNetManager.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/27.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit
import Alamofire
class QYNetManager{
    
    
    static let shared = QYNetManager()
    
    static func RTGet(url:String,
                      param:Dictionary<String,Any>,
                      from:UIViewController,
                      success:@escaping ((_ res:Any) -> Void),
                      failed:@escaping  ((_ err:Error) -> Void)){
        Alamofire.request(<#T##urlRequest: URLRequestConvertible##URLRequestConvertible#>)
        success("");
    }
    
    static func RTPost(url:String,
                      param:Dictionary<String,Any>,
                      from:UIViewController,
                      success:@escaping ((_ res:Any) -> Void),
                      failed:@escaping  ((_ err:Error) -> Void)){
        success("");
    }
    static func RTPostWithJson(url:String,
                      param:Dictionary<String,Any>,
                      from:UIViewController,
                      success:@escaping ((_ res:Any) -> Void),
                      failed:@escaping  ((_ err:Error) -> Void)){
        success("");
    }
    static func RTSUpload(url:String,
                          param:Dictionary<String,Any>,
                          images:Array<UIImage>,
                          from:UIViewController,
                          fileMark:String,
                          progress:@escaping ((_ res:Any) -> Void),
                          success:@escaping ((_ res:Any) -> Void),
                          failed:@escaping  ((_ err:Error) -> Void)){
        
    }
    

    
}

