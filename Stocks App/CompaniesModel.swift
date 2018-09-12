//
//  CompaniesModel.swift
//  Stocks App
//
//  Created by User on 12.09.2018.
//  Copyright © 2018 Alex Ivashko. All rights reserved.
//

import Foundation

protocol CompanyModelProtocol {
    var companyNameArray: [String] {get set}
    func getCompanyNameForIndex(index: Int) -> String
}


class CompaniesModel: CompanyModelProtocol {
    var companyNameArray: [String]
    
    init() {
        companyNameArray = [];
    }

    func getCompanyNameForIndex(index: Int) -> String {
        return companyNameArray[index];
    }
    
    
    
    private func requestQuote(for symbol: String) {
        
        let url = URL(string: "https://api.iextrading.com/1.0/stock/\(symbol)/quote")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
                else {
                    print("Network Error")
                    return
            }
            self.parseQuote(data: data)
        }
        dataTask.resume()
    }
    private func parseQuote(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String,
                let companySymbol = json["symbol"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double
                else {
                    print("Invalid JSON format")
                    return
            }
            DispatchQueue.main.async {
                self.view.displayStock(companyName: companyName,
                                       symbol: companySymbol,
                                       price: price,
                                       priceChange: priceChange)
            }
            print("Company name is: '\(companyName)'")
        } catch {
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
}
