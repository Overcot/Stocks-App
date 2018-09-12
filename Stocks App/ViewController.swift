//
//  ViewController.swift
//  Stocks App
//
//  Created by Alex Ivashko on 12.09.2018.
//  Copyright © 2018 Alex Ivashko. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {

    

    

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyNamePicker: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let companies: [String: String] = ["Apple":"AAPL",
                                               "Microsoft":"MSFT",
                                               "Google":"GOOG",
                                               "Amazon":"AMZN",
                                               "Facebook":"FB"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companyNamePicker.dataSource = self
        self.companyNamePicker.delegate = self
        
        self.activityIndicator.hidesWhenStopped = true
        
        self.requestQuoteUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }
    private func requestQuoteUpdate() {
        self.activityIndicator.startAnimating()
        self.companyNameLabel.text = "-"
        let selectedRow = self.companyNamePicker.selectedRow(inComponent: 0)
        let selectedSymbol = Array(self.companies.values)[selectedRow]
        requestQuote(for: selectedSymbol)
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
                let companyName = json["companyName"] as? String
            else {
                print("Invalid JSON format")
                return
            }
            DispatchQueue.main.async {
                self.displayStockInfo(companyName: companyName)
            }
            print("Company name is: '\(companyName)'")
        } catch {
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    private func displayStockInfo(companyName: String) {
        self.activityIndicator.stopAnimating()
        self.companyNameLabel.text = companyName
    }
}

