//
//  ProductViewModel.swift
//  SugiFilter
//
//  Created by Sugi Pringgandani on 14/05/18.
//  Copyright © 2018 Sugi Pringgandani. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class ProductViewModel {
    
    typealias ProductCollectionViewCellData = (imageUrl: String, productName: String, price: String)
    let productsObservable = BehaviorSubject<[ProductCollectionViewCellData]>(value: [])
    let productApiClient = ProductApiClient()
    let disposeBag = DisposeBag()
    
    var products: [ProductCollectionViewCellData] = []
    
    var startIndexProducts = 0
    
    private static var _instance: ProductViewModel? = nil
    static var sharedInstance: ProductViewModel {
        if _instance == nil {
            _instance = ProductViewModel()
        }
        
        return _instance!
    }
    
    private init() {
        refreshInitialProductsData()
    }
    
    // request the data at initial run of the app
    func refreshInitialProductsData() {
        self.refreshProductsDataWithFilters()
    }
    
    // requesting products data with filters applied
    func refreshProductsDataWithFilters(priceMin: Double = 0.0,
                                        priceMax: Double = 10000000.0,
                                        isWholesale: Bool = true,
                                        isOfficial: Bool = true,
                                        fShop: Int = 2,
                                        start: Int = 0,
                                        rows: Int = 10) {
        
        self.startIndexProducts = 0
        self.products.removeAll()
        
        var req = ProductRequest()
        req.priceMin = Int(priceMin)
        req.priceMax = Int(priceMax)
        req.isWholesale = isWholesale
        req.isOfficial = isOfficial
        req.fShop = fShop
        req.start = start
        req.rows = rows
        
        productApiClient.getProducts(req: req)
            .subscribe(onNext: { [unowned self] res in
                let formattedView = res.data.map {
                    return (
                        imageUrl: $0.imageUri700!,
                        productName: $0.name!,
                        price: $0.price!
                    )
                }
                
                self.productsObservable.onNext(formattedView)
                }, onError: { err in
                    self.productsObservable.onNext([])
            })
            .addDisposableTo(disposeBag)
    }
    
    // request products data infinity, to be shown at product grid
    func refreshProductsDataInfinity(priceMin: Double = 0.0,
                                     priceMax: Double = 10000000.0,
                                     isWholesale: Bool = true,
                                     isOfficial: Bool = true,
                                     fShop: Int = 2,
                                     start: Int = 0,
                                     rows: Int = 10) {
        
        startIndexProducts += 10
        
        var req = ProductRequest()
        req.priceMin = Int(priceMin)
        req.priceMax = Int(priceMax)
        req.isWholesale = isWholesale
        req.isOfficial = isOfficial
        req.fShop = fShop
        req.start = startIndexProducts
        req.rows = rows
        
        productApiClient.getProducts(req: req)
            .subscribe(onNext: { [unowned self] res in
                let formattedView = res.data.map {
                    return (
                        imageUrl: $0.imageUri700!,
                        productName: $0.name!,
                        price: $0.price!
                    )
                }
                
                self.products.append(contentsOf: formattedView)
                self.productsObservable.onNext(self.products)
                }, onError: { err in
                    self.productsObservable.onNext([])
            })
            .addDisposableTo(disposeBag)
    }
}

