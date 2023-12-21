//
//  ChapterList.swift
//  POCDemo
//
//  Created by Chakshu Dawara on 20/12/23.
//

import Foundation
import RealmSwift

class ChapterList: Object, Decodable {
    @objc dynamic var chapterId: String = ""
    @objc dynamic var chapterName: String = ""
}
