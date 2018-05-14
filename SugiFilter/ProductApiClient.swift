//
//  ProductApiClient.swift
//  SugiFilter
//
//  Created by Sugi Pringgandani on 14/05/18.
//  Copyright © 2018 Sugi Pringgandani. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Moya_ObjectMapper

struct ProductApiClient {
    
    private let provider = RxMoyaProvider<ProductApi>()
    
    // request products data, and return response as observable
    func getProducts(req: ProductRequest) -> Observable<ProductResponse> {
        return provider
            .request(.getProduct(request: req))
            .mapObject(ProductResponse.self)
            .retry(3)
    }
    
    
    
}

