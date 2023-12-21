//
//  IAPManager.swift
//  POCDemo
//
//  Created by Chakshu Dawara on 21/12/23.
//

import Foundation
import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = IAPManager()
    
    private var products = [SKProduct]()
    
    private var productBeingPurchased: SKProduct?
    
    enum Product: String, CaseIterable {
        case removeAds = "Nickelfox.POCDemo.removeAds"
        case unlock = "Nickelfox.POCDemo.unlock"
    }
    
    // Fetch Products from Apple
    public func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap { $0.rawValue }))
        request.delegate = self
        request.start()
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        guard let product = products.first else { return }
        
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        guard request is SKProductsRequest else { return }
        print("Product Fetch Request Failed")
    }
    
    func purchase(product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else { return }
        self.productBeingPurchased = product
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                self.handlePurchase(transaction.payment.productIdentifier)
                break
            case .failed:
                break
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func handlePurchase(_ id: String) {
        
    }
}
