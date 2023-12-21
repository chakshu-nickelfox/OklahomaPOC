//
//  ViewModel.swift
//  POCDemo
//
//  Created by Chakshu Dawara on 20/12/23.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
    func reloadData()
}

class ViewModel {
    
    var chapterData: [ChapterData] = []
    
    var chapterList: [ChapterList] = []
    
    weak var view: ViewModelProtocol!
    
    init (_ view: ViewModelProtocol!) {
        self.view = view
    }
    
    // MARK: - Core Data
    private func setupChapterModelsUsingCoreData() {
        if let path = Bundle.main.path(forResource: "Chapters", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let jsonData = try Data(contentsOf: fileUrl)
                let decoder = JSONDecoder()
                let chapters = try decoder.decode([ChapterData].self, from: jsonData)
                
                for chapterData in chapters {
                    let chapter = Chapters(context: CoreDataManager.shared.context)
                    chapter.chapterID = chapterData.chapterId
                    chapter.chapterName = chapterData.chapterName
                    
                    self.chapterData.append(chapterData)
                }
                self.view.reloadData()
                CoreDataManager.shared.saveContext()
                
                print(self.chapterData)
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            print("Chapters.json file not found.")
        }
    }
    
    func loadChaptersUsingCoreData() {
        self.setupChapterModelsUsingCoreData()
        print(self.chapterData)
    }
    
    private func fetchChapters() {
        do {
            let chaptersFromCoreData = try CoreDataManager.shared.context.fetch(Chapters.fetchRequest())
            
            self.chapterData = []
            
            let chapters = chaptersFromCoreData
            for chapter in chapters {
                let chapterData = ChapterData(chapterId: chapter.chapterID ?? "", chapterName: chapter.chapterName ?? "")
                self.chapterData.append(chapterData)
                print(chapter.chapterName ?? "")
            }
        } catch {
            debugPrint("Error")
        }
    }
    
    // MARK: - Realm
    private func setupModelsUsingRealm() {
        if let path = Bundle.main.path(forResource: "Chapters", ofType: "json") {
            
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let jsonData = try Data(contentsOf: fileUrl)
                
                let decoder = JSONDecoder()
                let chapters = try decoder.decode([ChapterList].self, from: jsonData)
                
                // Append chapters to chapterList
                self.chapterList.append(contentsOf: chapters)
                self.view.reloadData()
                
                // Persist data to Realm
                let realm = RealmManager.realm
                try realm.write {
                    realm.add(chapters)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            print("Chapters.json file not found.")
        }
    }
    
    func loadChaptersUsingRealm() {
        self.setupModelsUsingRealm()
        print(self.chapterList)
    }
}

extension ViewModel: ViewControllerProtocol {
    
}
