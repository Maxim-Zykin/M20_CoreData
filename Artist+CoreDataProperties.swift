//
//  Artist+CoreDataProperties.swift
//  M20
//
//  Created by Максим Зыкин on 12.05.2024.
//
//

import Foundation
import CoreData


extension Artist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artist> {
        return NSFetchRequest<Artist>(entityName: "Artist")
    }

    @NSManaged public var name: String?
    @NSManaged public var lastName: String?
    @NSManaged public var dateOfBith: Date?
    @NSManaged public var country: String?

}

extension Artist : Identifiable {

}
