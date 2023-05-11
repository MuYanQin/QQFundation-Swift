//
//  UserInfo.swift
//  QQFundation-Swift
//
//  Created by songping on 2023/5/11.
//  Copyright © 2023 leaduadmin. All rights reserved.
//

import UIKit
@objcMembers
class UserInfo: NSObject {
    var name :String = ""
    var id  :String = ""
    var gender :String = ""
    
    private static var _sharedInstance:UserInfo?
    
    static func sharedInstance() -> UserInfo{
        guard let instance = _sharedInstance else {
            _sharedInstance = UserInfo()
            return _sharedInstance!
        }
        return instance
    }
    private override init() {
    }
    
    static func writeUserInfo(_ dic:Dictionary<String,String>) ->Void{
        let str = self.getUserInfoPath("123")
        if FileManager.isContainAtPath(str){
            if FileManager.removeItemAtPath(str){
                print("remove succcess")
            }else{
                print("remove failed")
            }
        }
        // 归档
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: dic, requiringSecureCoding: false)
            let fileURL = URL(fileURLWithPath: str)
            try data.write(to: fileURL, options: .atomic)
            print("归档成功")
        } catch {
            print("归档失败：\(error.localizedDescription)")
        }
        setCacheInfo()
    }
    
    static func updateValue(_ key :String , _ value:String){
        if key.isEmpty || value.isEmpty{
            return
        }
        var dic = getUserInfoDic()
        dic.updateValue(value, forKey: key)
        writeUserInfo(dic)
        setCacheInfo()
    }
    
    static func updateInfoDic(_ userDic :Dictionary<String,String>){

        var dic = getUserInfoDic()
        dic.merge(userDic) { (_, new) in new }
        writeUserInfo(dic)
        setCacheInfo()
    }
    
    static func cleanUpInfo(){
        if FileManager.removeItemAtPath(self.getUserInfoPath("123")){
            print("用户信息移除完毕")
        }else{
            print("用户信息移除失败")
        }
        Mirror(reflecting: sharedInstance).children.forEach { (child) in
            print(child.label ?? "") // 获取字段名
            print(type(of: child.value)) // 获取字段类型
        }
        _sharedInstance = nil
    }
    static func getUserInfoDic() ->Dictionary<String,String>{
        let fileURL = URL(fileURLWithPath: self.getUserInfoPath("123"))
        if let data = try? Data(contentsOf: fileURL) {
            do {
                let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
                print("解档成功：",object! as Any)
                return object as! Dictionary<String, String>
            } catch {
                print("解档失败：\(error.localizedDescription)")
            }
        } else {
            print("文件不存在")
        }
        return [:]
    }
    static func setCacheInfo() -> Void{
        sharedInstance().setValuesForKeys(getUserInfoDic())
    }
    static func getUserInfoPath(_ userId:String) ->String{
        return URL(fileURLWithPath: FileManager.documentsPath()).appendingPathComponent("\(userId).txt", isDirectory: true).path
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
