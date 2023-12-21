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
}

class ViewController: UIViewController {
    
    @IBOutlet weak var sampleLabel: UILabel!
    
    var viewModel: ViewControllerProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
//        self.viewModel.loadChaptersUsingRealm()
        self.viewModel.loadChaptersUsingCoreData()
    }
    
    private func setupViewModel() {
        self.viewModel = ViewModel(self)
    }
}

extension ViewController: ViewModelProtocol {
    
}
