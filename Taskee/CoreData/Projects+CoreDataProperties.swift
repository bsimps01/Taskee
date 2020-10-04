//
//  Project+CoreDataProperties.swift
//  Taskee
//
//  Created by Benjamin Simpson on 10/3/20.
//

import Foundation
import CoreData

extension Projects {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Projects> {
        return NSFetchRequest<Projects>(entityName: "Project")
    }

    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var tasks: NSSet?
    
}
    
extension Projects {
        
    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Tasks)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Tasks)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)
        
    }
