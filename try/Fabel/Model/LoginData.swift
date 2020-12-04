//
//  Data.swift
//  try
//
//  Created by Sachin Guliani on 6/20/20.
//

import Foundation
import Security

class KeyChain {
    /*
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data] as [String: Any]
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    
    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne ] as [String: Any]
        
        var dataTypeRef: AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
   */
    
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
        return data as! NSData
    }
    
    class func convertNSDataToStr(data: NSData) -> String {
        let nsAnswer = NSString(data: data as! Foundation.Data, encoding: String.Encoding.utf8.rawValue)
        return nsAnswer as! String
    }
    

}

//extension Data {
//    init<T>(from value: T) {
//        var value = value
//        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
//    }
//
//    func to<T>(type: T.Type) -> T {
//        return self.withUnsafeBytes { $0.load(as: T.self) }
//    }
//}


/*
protocol KeyChainDelegate {
    func StoreData(_ username: String, _ password: String, _ token: String) throws
}

class AccountHandler {
    var delegate: KeyChainDelegate?
    
    func Login(_ username: String, _ password: String, _ token: String) throws{
        try self.delegate?.StoreData(username, password, token)
    }
}

class AccountReceiver: KeyChainDelegate {
    func StoreData(_ username: String, _ password: String, _ token: String) throws {
        let data = Data(from: password)
        let status = KeyChain.save(key: username, data: data)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status)}
        print(username)
        print(password)
        
    }
}
*/
