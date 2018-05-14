//
//  ProductViewController.swift
//  SugiFilter
//
//  Created by Sugi Pringgandani on 14/05/18.
//  Copyright © 2018 Sugi Pringgandani. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import Moya_ObjectMapper
import SDWebImage

class ProductViewController: UIViewController {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    let viewModel = ProductViewModel.sharedInstance
    let disposeBag = DisposeBag()
    
    let productCollViewReusableId = "product_cell"
    
    var nextOffset: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    // setting up collection view with initial data & set collection view delegate
    private func setupCollectionView() {
        self.viewModel.refreshInitialProductsData()
        self.viewModel.productsObservable.bind(to: self.productCollectionView.rx.items) { [unowned self] cv, row, el in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = cv.dequeueReusableCell(withReuseIdentifier: self.productCollViewReusableId, for: indexPath) as! ProductCollectionViewCell
            
            cell.productImageView.sd_setImage(with: URL(string: el.imageUrl), placeholderImage: #imageLiteral(resourceName: "Image"))
            cell.productNameLabel.text = el.productName
            cell.productPriceLabel.text = el.price
            
            return cell
            }
            .addDisposableTo(disposeBag)
        
        self.productCollectionView.rx.didEndDragging
            .subscribe(onNext: { [unowned self] _ in
                if (self.productCollectionView.contentOffset.y >= (self.productCollectionView.contentSize.height - self.productCollectionView.frame.size.height)) {
                    //reach bottom
                    self.viewModel.refreshProductsDataInfinity(
                        priceMin: ProductFilterSharedData.priceMin,
                        priceMax: ProductFilterSharedData.priceMax,
                        isWholesale: ProductFilterSharedData.isWholesale,
                        isOfficial: ProductFilterSharedData.isOfficial,
                        fShop: ProductFilterSharedData.fShop
                    )
                }
            })
            .addDisposableTo(disposeBag)
        
        self.productCollectionView.rx.setDelegate(self).addDisposableTo(disposeBag)
    }
    
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.size.width
        
        return CGSize(width: (width / 2) - 1, height: 200.0)
    }
}

