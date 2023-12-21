//
//  ViewController.swift
//  POCDemo
//
//  Created by Chakshu Dawara on 20/12/23.
//

import UIKit

protocol ViewControllerProtocol: AnyObject {
    func loadChaptersUsingRealm()
    func loadChaptersUsingCoreData()
    var chapterData: [ChapterData] { get }
    var chapterList: [ChapterList] { get }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var sampleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ViewControllerProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
        self.setupTableView()
        self.viewModel.loadChaptersUsingRealm()
    }
    
    private func setupViewModel() {
        self.viewModel = ViewModel(self)
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension ViewController: ViewModelProtocol {
    
    func reloadData() {
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.chapterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let chapter = self.viewModel.chapterList[indexPath.row]
        cell.textLabel?.text = "\(chapter.chapterId) -> \(chapter.chapterName)"
        return cell
    }
}
