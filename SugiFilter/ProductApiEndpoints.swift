//
//  ProductApiEndpoints.swift
//  SugiFilter
//
//  Created by Sugi Pringgandani on 14/05/18.
//  Copyright © 2018 Sugi Pringgandani. All rights reserved.
//

import Foundation
import Moya

enum ProductApi {
    case getProduct(request: ProductRequest)
}

extension ProductApi: TargetType {
    
    var baseURL: URL { return URL(string: "https://ace.tokopedia.com/search/v2.5")! }
   /* https://ace.tokopedia.com/search/v2.5/product?q=samsung&pmin=10000&pmax=100000&wholesale=true&official=true&fshop=2&start=0&rows=10*/
    var path: String {
        switch self {
        case .getProduct(_):
            return "/product"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProduct(_):
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case .getProduct(let request):
            return [
                "q": request.query,
                "pmin": request.priceMin,
                "pmax": request.priceMax,
                "wholesale": request.isWholesale,
                "official": request.isOfficial,
                "fshop": request.fShop,
                "start": request.start,
                "rows": request.rows
            ]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getProduct(_):
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .request
    }
}

