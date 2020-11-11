//
//  Model.swift
//  try
//
//  Created by Sachin Guliani on 4/5/20.
//

import Foundation
import UIKit
import CoreData


struct Rectangle {
    var x: Double
    var y: Double
    var w: Double
    var h: Double
    var view: UIView
}

struct Credentials {
    var username: String
    var password: String
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

class DiskStatus {

    //MARK: Formatter MB only
    class func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }


    //MARK: Get String Value
    class var totalDiskSpace:String {
        get {
            return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
        }
    }

    class var freeDiskSpace:String {
        get {
            return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
        }
    }

    class var usedDiskSpace:String {
        get {
            return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
        }
    }


    //MARK: Get raw value
    class var totalDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
                return space!
            } catch {
                return 0
            }
        }
    }

    class var freeDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
                return freeSpace!
            } catch {
                return 0
            }
        }
    }

    class var usedDiskSpaceInBytes:Int64 {
        get {
            let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
            return usedSpace
        }
    }

}

func blockRefresh() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) { // Change `2.0` to the desired number of seconds.
       // Code you want to be delayed
        block_refresh = false
    }
}

class ModelTest {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveModel() {
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func deleteCoreData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        do {
            let results = try context.fetch(request)

            for data in results as! [NSManagedObject] {
                //let val_name = data.value(forKey: "name") as! String
                //let val_date = data.value(forKey: "date") as! String
                context.delete(data)
                saveModel()
            }
        } catch {
            print("It Failed")
        }
    }
    
    func forTestingCallCoreData() -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Account")
        do {
            let results = try context.fetch(request)
            return results.count
        } catch {
            print("It Failed")
        }
        return -1
    }
}


var currentUsername = ""

var block_refresh = false
var date_count = 0
var year = 0
var day = 0
var hour = 0
var minute = 0
 



