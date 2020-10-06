//
//  Task+CoreDataProperties.swift
//  Taskee
//
//  Created by Benjamin Simpson on 10/5/20.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var datedue: Date?
    @NSManaged public var status: Bool
    @NSManaged public var title: String?
    @NSManaged public var project: Project?

}

