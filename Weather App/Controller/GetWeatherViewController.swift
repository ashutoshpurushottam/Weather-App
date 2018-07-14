//
//  GetWeatherViewController.swift
//  Weather App
//
//  Created by Ashutosh Purushottam on 13/07/18.
//  Copyright © 2018 Ashutosh Purushottam. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredCityName(cityName: String)
}

class GetWeatherViewController: UIViewController {
    
    var delegate: ChangeCityDelegate!
    
    @IBOutlet weak var cityNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getWeatherPressed(_ sender: Any) {
        if let enteredCityName = cityNameTextField.text {
            delegate?.userEnteredCityName(cityName: enteredCityName)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

