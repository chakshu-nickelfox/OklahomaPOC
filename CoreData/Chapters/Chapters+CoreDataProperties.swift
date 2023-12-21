//
//  Chapters+CoreDataProperties.swift
//  POCDemo
//
//  Created by Chakshu Dawara on 20/12/23.
//
//

import Foundation
import CoreData


extension Chapters {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chapters> {
        return NSFetchRequest<Chapters>(entityName: "Chapters")
    }

    @NSManaged public var chapterID: String?
    @NSManaged public var chapterName: String?

}

extension Chapters : Identifiable {

}
