//
//  ProductRequest.swift
//  SugiFilter
//
//  Created by Sugi Pringgandani on 14/05/18.
//  Copyright © 2018 Sugi Pringgandani. All rights reserved.
//

import Foundation

struct ProductRequest {
    var query: String = "samsung"
    var priceMin: Int = 0
    var priceMax: Int = 10000000
    var isWholesale: Bool = true
    var isOfficial: Bool = true
    var fShop: Int = 2
    var start: Int = 0
    var rows: Int = 10
}

