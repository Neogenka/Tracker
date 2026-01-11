//
//  TrackerRecordCoreData+CoreDataProperties.swift
//  
//
//  Created by МAK on 11.01.2026.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TrackerRecordCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerRecordCoreData> {
        return NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var trackerId: UUID?
    @NSManaged public var tracker: TrackerCoreData?

}

extension TrackerRecordCoreData : Identifiable {

}
