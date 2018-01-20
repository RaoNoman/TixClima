//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController,CLLocationManagerDelegate,changeCityName {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    
    

   
    //TODO: Declare instance variables here
    
    let locationManager = CLLocationManager()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
 // data weather model
    let weatherData = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        //alphaView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let cityDefault = UserDefaults.standard.object(forKey: "cityName") as? String{
            UserChangeCityLabelName(city: cityDefault)
            print("done")
            print(cityDefault)
        }
        UIView.animate(withDuration: 1) {
            self.alphaView()
            self.weatherIcon.alpha = 0.9
            self.cityLabel.alpha = 0.9
            self.temperatureLabel.alpha = 0.9
        }
    }
    func alphaView(){
        self.weatherIcon.alpha = 0
        self.cityLabel.alpha = 0
        self.temperatureLabel.alpha = 0
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url:String,parametrs : [String:String]){
        Alamofire.request(url, method: .get , parameters : parametrs).responseJSON { (response) in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value)
                print(weatherJSON)
                self.updateWeather(json: weatherJSON)
            }else{
                print("Error")
            }
        }
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    func updateWeather(json: JSON){
        if let tempResult = json["main"]["temp"].double{
            weatherData.temperature = Int(tempResult - 273.15)
            weatherData.city = json["name"].stringValue
            weatherData.condition = json["weather"][0]["id"].intValue
            weatherData.WeatherIconName = weatherData.updateWeatherIcon(condition: weatherData.condition)
            updateUIWithWeatherData()
        }
        else{
            cityLabel.text = "Weather Unavailable"
        }
        
    }
    
    
    //Write the updateWeatherData method here:
    
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    func updateUIWithWeatherData(){
        cityLabel.text = weatherData.city
        temperatureLabel.text = "\(weatherData.temperature)°"
        weatherIcon.image = UIImage(named: weatherData.WeatherIconName)
    }
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            let longitute = String(location.coordinate.longitude)
            let latitute = String(location.coordinate.latitude)
           
            let params : [String:String] = ["lat": latitute , "lon":longitute , "appid": APP_ID]
            getWeatherData(url: WEATHER_URL , parametrs : params)
            
        }
    }
    
    //Write the didFailWithError method here:
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location not available"
        
    }
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
   
    //Write the userEnteredANewCityName Delegate method here:
    func UserChangeCityLabelName(city: String) {
        
        let queryParam : [String:String] = ["q":city , "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parametrs: queryParam)
        updateUIWithWeatherData()
        print(city)
    }

    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let destination = segue.destination as? ChangeCityViewController
               destination?.delagete = self
            
            
        }
    }
    
    @IBAction func segmentTempChange(_ sender: UISwitch) {
        let temCel = weatherData.temperature
        if sender.isOn{
            print("on")
           temperatureLabel.text = "\(temCel)°"
        }else{
           
            temperatureLabel.text = "\(convertToFahrenheit(temperature: temCel))F"
        }
        
    }
    
}


