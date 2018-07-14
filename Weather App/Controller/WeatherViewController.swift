//
//  ViewController.swift
//  Weather App
//
//  Created by Ashutosh Purushottam on 06/07/18.
//  Copyright © 2018 Ashutosh Purushottam. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "093b23a7277b6c6d7674543074b337e3"
    let ABSOLUTE_ZERO = 273.15
    
    // Instance variables
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    //MARK: - Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String: String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        cityLabel.text = "Location is not available."
    }
    
    //MARK: - Get weather information from API
    
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters)
            .responseJSON {
                response in
                if response.result.isSuccess {
                    print("Success in fetching information")
                    let weatherJSON : JSON = JSON(response.result.value!)
                    self.updateWeatherData(json: weatherJSON)
                    print(weatherJSON)
                } else {
                    print("Error \(response.result.error.debugDescription)")
                    self.cityLabel.text = "Connection issues."
                }
        }
    }
    
    //MARK: - Parsing JSON
    func updateWeatherData(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - ABSOLUTE_ZERO)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWithWeatherData()
        } else {
            cityLabel.text = "Weather not available"
        }
    }
    
    //MARK: - Update UI
    func updateUIWithWeatherData() {
        cityLabel.text  = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    //MARK: - Change City Delegate
    func userEnteredCityName(cityName: String) {
        let params: [String: String] = ["q" : cityName, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    //MARK: - Perform Segueue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! GetWeatherViewController
            destinationVC.delegate = self
            
        }
    }


}

