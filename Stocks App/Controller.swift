//
//  Controller.swift
//  Stocks App
//
//  Created by User on 12.09.2018.
//  Copyright © 2018 Alex Ivashko. All rights reserved.
//

import Foundation

protocol ControllerProtocol {
    func numberOfCompanies() -> Int;
    func getCompanyNameForIndex(index: Int) -> String;
    func displayStockInfo();
    
    
}


class Controller :ControllerProtocol {
    let model = CompaniesModel()
    func getCompanyNameForIndex(index: Int) -> String {
        return model.getCompanyNameForIndex(index:index)
    }
    
    func numberOfCompanies() -> Int {
        return model.companyNameArray.count
    }
    
    func displayStockInfo() {
        //self.view.show(companyName: String, symbol: String, price: Double, priceChange: Double)
    }
}
