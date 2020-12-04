//
//  Data+CoreDataProperties.swift
//  try
//
//  Created by Sachin Guliani on 9/28/20.
//
//

import Foundation
import CoreData


extension Data {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Data> {
        return NSFetchRequest<Data>(entityName: "Data")
    }

    @NSManaged public var name: String?
    @NSManaged public var clicked_count: Int16
    @NSManaged public var saved: Bool
    @NSManaged public var ofZipFile: ZipFile?

}
