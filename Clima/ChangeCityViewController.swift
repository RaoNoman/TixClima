//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit


//Write the protocol declaration here:
protocol changeCityName {
    func UserChangeCityLabelName(city:String)
}

class ChangeCityViewController: UIViewController {
    
    
    
    //Declare the delegate variable here:
    var delagete : changeCityName?
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        let cityDef = UserDefaults.standard
        //1 Get the city name the user entered in the text field
            let cityName = changeCityTextField.text!
        
        
        // matches regix with global with match helper function
            let matched = matches(for: "[a-z]", in: cityName)
        if matched.isEmpty{
            print("check",matched)
            
        }else
        {
          cityDef.set(cityName, forKey: "cityName")
            //2 If we have a delegate set, call the method userEnteredANewCityName
            delagete?.UserChangeCityLabelName(city: cityName)
            
            //3 dismiss the Change City View Controller to go back to the WeatherViewController
            dismiss(animated: true , completion: nil)
            
        }
        
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
