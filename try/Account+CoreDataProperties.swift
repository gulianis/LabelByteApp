//
//  Account+CoreDataProperties.swift
//  try
//
//  Created by Sandeep Guliani on 9/28/20.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var username: String?
    @NSManaged public var file: NSSet?

}

// MARK: Generated accessors for file
extension Account {

    @objc(addFileObject:)
    @NSManaged public func addToFile(_ value: ZipFile)

    @objc(removeFileObject:)
    @NSManaged public func removeFromFile(_ value: ZipFile)

    @objc(addFile:)
    @NSManaged public func addToFile(_ values: NSSet)

    @objc(removeFile:)
    @NSManaged public func removeFromFile(_ values: NSSet)

}
