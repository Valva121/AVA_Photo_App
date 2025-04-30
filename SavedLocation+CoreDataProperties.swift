//
//  SavedLocation+CoreDataProperties.swift
//  AVA_Photo_App
//
//  Created by Andrew Lawrence on 4/29/25.
//
//

import Foundation
import CoreData


extension SavedLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedLocation> {
        return NSFetchRequest<SavedLocation>(entityName: "SavedLocation")
    }

    @NSManaged public var title: String?
    @NSManaged public var photo: Data?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var address: String?
    

}

extension SavedLocation : Identifiable {

}
