//
//  ProductFilterSharedData.swift
//  SugiFilter
//
//  Created by Sugi Pringgandani on 14/05/18.
//  Copyright © 2018 Sugi Pringgandani. All rights reserved.
//

import Foundation

struct ProductFilterSharedData {
    static var priceMin: Double = 0.0
    static var priceMax: Double = 10000000.0
    static var isWholesale: Bool = true
    static var isOfficial: Bool = true
    static var fShop: Int = 2
    
    static func resetToInitialValues() {
        priceMin = 0
        priceMax = 10000000
        isWholesale = true
        isOfficial = true
        fShop = 2
    }
}

