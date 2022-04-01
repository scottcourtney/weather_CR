//
//  locationFinder.swift
//  weather_CR
//
//  Created by Scott Courtney on 3/31/22.
//

import Foundation
import Alamofire
import CoreLocation


private var locationManager = CLLocationManager()
private var geocoder = CLGeocoder()

// Call the weather api
func fetchWeatherData(location: String, completionHandler:@escaping ( _ success: Bool, _ resultVal: WeatherResult) -> Void) {
    
    AF.request(WEATHERURL + FORECASTPATH + "?key=" + WEATHERKEY + "&q=" + location + "&days=10&aqi=no&alerts=no").responseJSON {(response) in
        guard let data = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let weatherResponse = try decoder.decode(WeatherResult.self, from: data)
                        completionHandler(true, weatherResponse)

                    } catch let error {
                        print(error)
                    }
    }
}
