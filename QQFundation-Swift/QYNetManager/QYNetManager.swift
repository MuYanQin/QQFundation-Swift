//
//  QYNetManager.swift
//  QQFundation-Swift
//
//  Created by peanut on 2023/3/27.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit
import Alamofire


/// 防抖模式
enum antiShake {
//    取消前面的请求
case cancelPrev
//    取消后面的请求
case canceBehind
}

class QYNetManager{
    
    /// 存储每次请求的dataRequest url为key 取消请求用
    private static var map = Dictionary<String,DataRequest>();
    
    /// 防抖模式默认不响应后面的请求
    static var antiShakeMode = antiShake.canceBehind
    
    
    /// 发起get请求
    /// - Parameters:
    ///   - url: 数据接口
    ///   - param: 参数。可选
    ///   - from: 来自哪个视图 可选。hud用
    ///   - success: 成功回调
    ///   - failed: 失败回调
    static func RTGet(url:String,
                      param:Dictionary<String,Any>? = nil,
                      from:UIViewController? = nil,
                      success:@escaping ((_ res:Any) -> Void),
                      failed:@escaping  ((_ err:Error) -> Void)){
        
        TXD(url: url, method: HTTPMethod.get, encoding: URLEncodedFormParameterEncoder.default as! ParameterEncoding) { res in
            success(res)
        } failed: { err in
            failed(err)
        }
    }
    
    /// 发起post请求
    /// - Parameters:
    ///   - url: 接口
    ///   - param: 参数 可选
    ///   - from: 来自哪个视图 可选。hud用
    ///   - success: 成功回调
    ///   - failed: 失败回调
    static func RTSPost(url:String,
                      param:Dictionary<String,Any>? = nil,
                      from:UIViewController? = nil,
                      success:@escaping ((_ res:Any) -> Void),
                      failed:@escaping  ((_ err:Error) -> Void)){
        
        TXD(url: url, method: HTTPMethod.post, encoding: URLEncodedFormParameterEncoder(destination: .httpBody) as! ParameterEncoding) { res in
            success(res)
        } failed: { err in
            failed(err)
        }
    }
    
    /// 发起post请求 参数json形式提交
    /// - Parameters:
    ///   - url: 接口
    ///   - param: 参数 可选
    ///   - from: 来自哪个视图 可选。hud用
    ///   - success: 成功回调
    ///   - failed: 失败回调
    static func RTSPostWithJson(url:String,
                      param:Dictionary<String,Any>? = nil,
                      from:UIViewController? = nil,
                      success:@escaping ((_ res:Any) -> Void),
                      failed:@escaping  ((_ err:Error) -> Void)){
        TXD(url: url, method: HTTPMethod.post, encoding: JSONParameterEncoder.sortedKeys as! ParameterEncoding) { res in
            success(res)
        } failed: { err in
            failed(err)
        }
    }
    static func RTSUpload(url:String,
                          param:Dictionary<String,Any>,
                          images:Array<UIImage>,
                          from:UIViewController,
                          fileMark:String,
                          progress:@escaping ((_ res:Any) -> Void),
                          success:@escaping ((_ res:Any) -> Void),
                          failed:@escaping  ((_ err:Error) -> Void)){
        
        
        AF.upload(multipartFormData: { multipartFormData in
            
        }, to: "",method: .post,headers: []).uploadProgress(closure: { progress in
            
        }).responseData{ res in
            
        };
    }
    
    
    /// 私有方法 请求发送
    /// - Parameters:
    ///   - url: 数据接口
    ///   - param: 参数
    ///   - method: get、post
    ///   - encoding: 编码类型
    ///   - from: 来自视图
    ///   - success: 成功
    ///   - failed: 失败
    private static func TXD(url:String,
                     param:Dictionary<String,Any>? = nil,
                     method: HTTPMethod,
                     encoding: ParameterEncoding,
                     from:UIViewController? = nil,
                     success:@escaping ((_ res:Any) -> Void),
                     failed:@escaping  ((_ err:Error) -> Void)){
        
        switch antiShakeMode {
        case .cancelPrev:
            if (map[url] != nil){
                map[url]?.cancel();
                print("已取消\(url)，发起新的请求");
            }
        case .canceBehind:
            if (map[url] != nil){
                print("当前已存在\(url)请求。此请求已被拦截");
                return
            }
        }
        
        let dataRequest =   AF.request(
            url,
            method: method,
            parameters: param,
            encoding: encoding,
            requestModifier: {$0.timeoutInterval = 15})
            .responseData{ res in
             switch res.result{
            
             case let .success(data):
                 guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else{
                      return
                 }
                 let dic = json as! Dictionary<String ,Any>
                 
                 success(dic);
                 break;
             case let .failure(error):
                 failed(error as Error)
                 break;
             }
         }
        
        map[url] = dataRequest;
    }
    
}




/**
 
 struct HTTPBinResponse: Codable {
     let data : [item];

     let msg: String;
     let status: Int;
 }

 struct item : Codable,Identifiable{
     let   author :String;
     let   bookname :String;
     let   id :Int;
     let   publisher :String;
 }
 
 let url = "http://www.liulongbin.top:3006/api/getbooks";

 //responseData响应格式
 AF.request(url,
             requestModifier: {$0.timeoutInterval = 15})
  .responseData{ res in
      switch res.result{
     
      case let .success(data):
          /*
          if let dic = try? JSONDecoder().decode(HTTPBinResponse.self, from: data){
              print(" responseData" , dic);
              success(data)
          }
          */
          guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else{
               return
          }
          print("responseData====" ,json);

          break;
      case let .failure(error):
          failed(error as Error)
          break;
      }
  }
 
 //responseDecodable响应格式
 AF.request(url,
            requestModifier: {$0.timeoutInterval = 15})
 .responseDecodable(of: HTTPBinResponse.self){ res in
     switch res.result{
    
     case let .success(data):
         print("responseDecodable" , (data as HTTPBinResponse).status)
         break;
     case let .failure(error):
         failed(error as Error)
         break;
     }
 }
 
  
  
 //responseString响应格式
  AF.request(url,
             requestModifier: {$0.timeoutInterval = 15})
  .responseString { res in
      switch res.result{
     
      case let .success(data):
          //JSON字符串-->data-->JSON对象
          let jsonString = data as String;
          let jsonData = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data()
          guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else{
               return
          }
          print("responseString====" , data)
          print("responseString====" ,json)
       
          break;

      case let .failure(error):
          failed(error as Error)
          break;
      }
  }
 */
