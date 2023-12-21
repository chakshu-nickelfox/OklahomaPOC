//
//  IAPViewController.swift
//  POCDemo
//
//  Created by Chakshu Dawara on 21/12/23.
//

import StoreKit
import UIKit

enum PurchaseState {
    case notPurchased
    case purchased
}

class IAPViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var models = [SKProduct]()
    private var purchaseStates: [PurchaseState] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        self.setupTableView()
        self.fetchProducts()
        self.updatePurchaseStates()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // Add this method to update the purchase states based on the purchased items
    private func updatePurchaseStates() {
        purchaseStates = Array(repeating: .notPurchased, count: models.count)
        for (index, product) in models.enumerated() {
            if UserDefaults.standard.bool(forKey: product.productIdentifier) {
                purchaseStates[index] = .purchased
            }
        }
        tableView.reloadData()
    }
}

extension IAPViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = self.models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(product.localizedTitle) : \(product.localizedDescription) -> \(product.priceLocale.currencySymbol ?? "")\(product.price)"
        // MARK: - Cell Color on purchase state
        switch purchaseStates[indexPath.row] {
        case .notPurchased:
            cell.textLabel?.textColor = UIColor.gray
        case .purchased:
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = self.models[indexPath.row]
        switch purchaseStates[indexPath.row] {
        case .notPurchased:
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        case .purchased:
            print("Product already purchased")
        }
    }
}

extension IAPViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            print("Count: \(response.products.count)")
            self.models = response.products
            self.purchaseStates = Array(repeating: .notPurchased, count: self.models.count)
            self.tableView.reloadData()
        }
    }
    
    enum Product: String, CaseIterable {
        case removeAds = "Nickelfox.POCDemo.removeads"
        case unlock = "Nickelfox.POCDemo.unlock"
    }
    
    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap { $0.rawValue }))
        request.delegate = self
        request.start()
    }
}

extension IAPViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            let productIdentifier = transaction.payment.productIdentifier
            guard let index = self.models.firstIndex(where: { $0.productIdentifier == productIdentifier }) else { return }
            switch transaction.transactionState {
            case .purchasing:
                print("Purchasing")
            case .purchased:
                print("Purchased")
                self.purchaseStates[index] = .purchased
                UserDefaults.standard.set(true, forKey: productIdentifier)
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("Failed")
            case .restored:
                print("Restored")
            case .deferred:
                print("Deferred")
            @unknown default:
                break
            }
        }
    }
}
