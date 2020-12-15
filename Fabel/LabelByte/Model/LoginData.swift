//
//  Data.swift
//  LabelByte
//
//  Created by Sachin Guliani on 6/20/20.
//

import Foundation
import Security

class KeyChain {
    
    class func save(key: String, data: NSData) {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)

    }

    class func load(key: String) -> NSData? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return (dataTypeRef! as! NSData)
        } else {
            return nil
        }


    }
    
    class func convertStrToNSData(string: String) -> NSData {
        let data = string.data(using: .utf8)
        return data! as NSData
    }
    
    class func convertNSDataToStr(data: NSData) -> String {
        let nsAnswer = NSString(data: data as Foundation.Data, encoding: String.Encoding.utf8.rawValue)
        return nsAnswer! as String
    }
    

}
