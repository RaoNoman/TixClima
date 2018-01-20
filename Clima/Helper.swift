//
//  Helper.swift
//  Clima
//
//  Created by Rao Noman on 1/7/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

func matches(for regex: String, in text: String) -> [String] {
    
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let nsString = text as NSString
        let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
        return results.map { nsString.substring(with: $0.range)}
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}
func convertToFahrenheit(temperature: Int) -> Int {
    return ((temperature * 9) / 5) + 32
}
func convertToCelsius(fahrenheit: Int) -> Int {
    return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
}
