//
//  Model.swift
//  try
//
//  Created by Sachin Guliani on 4/5/20.
//

import Foundation
import UIKit
import CoreData

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

var labelsPerImage = 10

var RefreshOperation = LimitedOperation(limit: 5)
var SaveOperation = LimitedOperation(limit: 10)

class LimitedOperation {
    // Mechanism to block operations if operation continues too many times in a minute
    
    deinit {
        print("LimitedOperation DeInitialized")
    }
    
    var block_refresh = false
    var count = 0
    var year = 0
    var day = 0
    var hour = 0
    var minute = 0
    let limit_count: Int
    
    init(limit: Int) {
        limit_count = limit
    }
        
    /*
    func access() -> Bool {
        return !self.block_refresh
    }
    */
    
    func incrementToLimit() -> Bool {
        print("HERE IS THE COUNT:")
        print(self.count)
        let date = Date()
        let calendar = Calendar.current
        let current_year = calendar.component(.year, from: date)
        let current_day = calendar.component(.day, from: date)
        let current_hour = calendar.component(.hour, from: date)
        let current_minute = calendar.component(.minute, from: date)
        var minute_difference = current_minute - minute
        if current_minute < 5 {
            minute_difference += 60
        }
        if self.count >= self.limit_count - 1 {
            //print("CHECK CONDITION")
            if current_year == self.year && current_day == self.day && current_hour == self.hour && minute_difference < 5 {
                return false
            } else {
                self.year = current_year
                self.day = current_day
                self.hour = current_hour
                self.minute = current_minute
                self.count = 1
            }
        } else if current_year == self.year && current_day == self.day && current_hour == self.hour && current_minute == minute {
            self.count += 1
        } else {
            self.year = current_year
            self.day = current_day
            self.hour = current_hour
            self.minute = current_minute
            self.count = 1
        }
        return true
    }
}

func clearCache() {
    // Clears previously downloaded image
    let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first


    let cachePath = cache!.path
    let filePathName = "\(cachePath)/image"
    do {
        if FileManager.default.fileExists(atPath: filePathName) {
            try FileManager.default.removeItem(atPath: filePathName)
        }
    } catch {
        print(error)
    }
       
}

var ColorLabelToUIColor: [Color: UIColor] = [.black:UIColor.black, .red:UIColor.red, .green:UIColor.green, .blue:UIColor.blue, .orange:UIColor.orange, .purple:UIColor.purple, .yellow:UIColor.yellow]

var UnSelectedColor: Color = .black
var SelectedColor: Color = .red

var CurrentLabelType: TypeOfLabel = .boundingBox

var CurrentColorButtonSelected: UIButton?
var SelectedOrUnSelectedButton: UnselectedOrSelected = .UnSelected

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func save() {
    // Save to Core Data
    do {
        try context.save()
    } catch {
        print("Failed saving")
    }
}
