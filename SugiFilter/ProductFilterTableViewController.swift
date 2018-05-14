//
//  ProductFilterTableViewController.swift
//  SugiFilter
//
//  Created by Sugi Pringgandani on 14/05/18.
//  Copyright © 2018 Sugi Pringgandani. All rights reserved.
//

import UIKit
import SwiftRangeSlider
import RxSwift
import RxCocoa

class ProductFilterTableViewController: UITableViewController {
    
    @IBOutlet weak var priceRangeSlider: RangeSlider!
    @IBOutlet weak var isWholesaleSwitch: UISwitch!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSliderValueChangedEvent()
        setupStaticTableViewWithAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initComponentValue()
    }
    
    // update price range label
    private func updatePriceRangeLabel() {
        self.minPriceLabel.text = "Rp. \(self.priceRangeSlider.lowerValue.formattedWithSeparator)"
        self.maxPriceLabel.text = "Rp. \(self.priceRangeSlider.upperValue.formattedWithSeparator)"
    }
    
    // set slider value changed event, and update price range label
    private func setupSliderValueChangedEvent() {
        self.updatePriceRangeLabel()
        priceRangeSlider
            .rx
            .controlEvent(UIControlEvents.valueChanged)
            .subscribe(onNext: { [unowned self] in
                self.updatePriceRangeLabel()
            })
            .addDisposableTo(disposeBag)
    }
    
    // setting up static table view with action, when selecting store type & tapping apply button
    private func setupStaticTableViewWithAction() {
        self.tableView
            .rx
            .itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
                if indexPath.section == 1 {
                    let cell = self.tableView.cellForRow(at: indexPath)
                    if cell?.accessoryType == .checkmark {
                        cell?.accessoryType = .none
                    } else {
                        cell?.accessoryType = .checkmark
                    }
                    
                } else if indexPath.section == 2 {
                    self.saveProductFilterParameter()
                    ProductViewModel.sharedInstance.refreshProductsDataWithFilters(
                        priceMin: ProductFilterSharedData.priceMin,
                        priceMax: ProductFilterSharedData.priceMax,
                        isWholesale: ProductFilterSharedData.isWholesale,
                        isOfficial: ProductFilterSharedData.isOfficial,
                        fShop: ProductFilterSharedData.fShop
                    )
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    // saving filter parameters at static shared data
    private func saveProductFilterParameter() {
        ProductFilterSharedData.isWholesale = self.isWholesaleSwitch.isOn
        ProductFilterSharedData.priceMax = self.priceRangeSlider.upperValue
        ProductFilterSharedData.priceMin = self.priceRangeSlider.lowerValue
        
        let goldMerchantCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1))
        let officialStoreCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 1))
        
        ProductFilterSharedData.isOfficial = officialStoreCell?.accessoryType == .checkmark
        ProductFilterSharedData.fShop = goldMerchantCell?.accessoryType == .checkmark ? 2 : 0
    }
    
    // initialize filter parameter components with static shared data
    private func initComponentValue() {
        self.isWholesaleSwitch.isOn = ProductFilterSharedData.isWholesale
        self.priceRangeSlider.upperValue = ProductFilterSharedData.priceMax
        self.priceRangeSlider.lowerValue = ProductFilterSharedData.priceMin
        self.updatePriceRangeLabel()
        
        let goldMerchantCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1))
        let officialStoreCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 1))
        
        goldMerchantCell?.accessoryType = ProductFilterSharedData.fShop == 2 ? .checkmark : .none
        officialStoreCell?.accessoryType = ProductFilterSharedData.isOfficial ? .checkmark : .none
    }
    
    // reset button action when tapped
    @IBAction func resetButtonWhenTapped(_ sender: UIBarButtonItem) {
        ProductFilterSharedData.resetToInitialValues()
        self.initComponentValue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
