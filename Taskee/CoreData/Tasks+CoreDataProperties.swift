//
//  TaskCoreData.swift
//  Taskee
//
//  Created by Benjamin Simpson on 9/30/20.
//

import Foundation
import CoreData

extension Tasks {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var status: Bool
    @NSManaged public var duedate: Date?
    @NSManaged public var project: Projects?
}

