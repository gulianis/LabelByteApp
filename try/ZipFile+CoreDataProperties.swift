//
//  ZipFile+CoreDataProperties.swift
//  try
//
//  Created by Sandeep Guliani on 9/28/20.
//
//

import Foundation
import CoreData


extension ZipFile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ZipFile> {
        return NSFetchRequest<ZipFile>(entityName: "ZipFile")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var name: String?
    @NSManaged public var clicked: Bool
    @NSManaged public var unsaved_data_count: Int16
    @NSManaged public var date: String?
    @NSManaged public var file: NSSet?
    @NSManaged public var ofAccount: Account?

}

// MARK: Generated accessors for file
extension ZipFile {

    @objc(addFileObject:)
    @NSManaged public func addToFile(_ value: Data)

    @objc(removeFileObject:)
    @NSManaged public func removeFromFile(_ value: Data)

    @objc(addFile:)
    @NSManaged public func addToFile(_ values: NSSet)

    @objc(removeFile:)
    @NSManaged public func removeFromFile(_ values: NSSet)

}
