//
//  RealmManager.swift
//  POCDemo
//
//  Created by Chakshu Dawara on 20/12/23.
//

import Foundation
import RealmSwift

struct RealmManager {
    
    static let realm = try! Realm()
    
    static func getAllChapters() -> [ChapterList] {
        let chapters = realm.objects(ChapterList.self).map { $0 }
        return Array(chapters)
    }
}
