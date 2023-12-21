//
//  Employee+CoreDataProperties.swift
//  POCDemo
//
//  Created by Chakshu Dawara on 20/12/23.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var name: String?

}

extension Employee : Identifiable {

}
