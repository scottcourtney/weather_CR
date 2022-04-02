//
//  Weather.swift
//  weather_CR
//
//  Created by Scott Courtney on 4/1/22.
//

import Foundation

//Singleton to share data between views

class Weather {
    static let shared = Weather()
    var weather: WeatherResult?
}
