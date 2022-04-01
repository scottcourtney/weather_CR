//
//  TodayWeatherViewController.swift
//  weather_CR
//
//  Created by Scott Courtney on 3/31/22.
//

import UIKit
import Alamofire
import CoreLocation

class TodayWeatherViewController: UIViewController, UISearchBarDelegate {
    private var locationManager = CLLocationManager()
    private var geocoder = CLGeocoder()
    
    var results: WeatherResult?
    
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var currentTempLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var realfeelLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        self.searchBar.isHidden = true
        self.locationBtn.setTitle("", for: .normal)
        self.currentTempLbl.text = ""
        self.realfeelLbl.text = ""
        
        determineMyCurrentLocation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
        self.searchBar.isHidden = true
    }
    
    
    func updateUI() {
        self.locationBtn.setTitle((self.results?.location.name ?? "") + ", " + (self.results?.location.region ?? "") + " ⌄", for: .normal)
        locationBtn.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
        if results != nil {
            let url = URL(string:self.results?.current.condition.icon ?? "")
            let lastPath = url?.lastPathComponent
            self.weatherImg.image = UIImage(named: lastPath ?? "")
            let currentTemp = Int(round(self.results?.current.tempF ?? 0))
            let realFeelTemp = Int(round(self.results?.current.feelslikeF ?? 0))
            
            self.currentTempLbl.text = String(currentTemp) + "º"
            self.realfeelLbl.text = "RealFeel " + String(realFeelTemp) + "º"
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            searchBar.setImage(UIImage(systemName: "location"), for: .bookmark, state: .normal)
        }
        print("searchText",searchText)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        determineMyCurrentLocation()
        self.searchBar.endEditing(true)
        self.searchBar.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
        self.searchBar.isHidden = true
        if searchBar.text == nil { return } else {
            Utils.shared.showSpinner(message: "Fetching Data", view: self.view)
            
            fetchWeatherData(location: String(searchBar.text!)) { (success, resultVal) in
                if success == true
                {
                    print(resultVal)
                    self.results = resultVal
                    DispatchQueue.main.async {
                        Utils.shared.hideSpinner(view: self.view)
                        self.updateUI()
                        
                    }
                }
                else {
                    print("Error fetching data")
                }
                
            }
        }
    }
    
    @objc func showSearchBar() {
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "location"), for: .bookmark, state: .normal)
        if self.searchBar.isHidden {
            self.searchBar.isHidden = false
        } else {
            self.searchBar.isHidden = true
        }
        print("Button Pressed")
    }
    
}


extension TodayWeatherViewController: CLLocationManagerDelegate {
    
    func determineMyCurrentLocation()
    {
        Utils.shared.showSpinner(message: "Fetching Data", view: self.view)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if let error = error {
                print(error)
            }
            
            guard let placemark = placemarks?.first else { return }
            guard let zipCode = placemark.postalCode else { return }
            
            fetchWeatherData(location: String(zipCode)) { (success, resultVal) in
                if success == true
                {
                    print(resultVal)
                    self.results = resultVal
                    DispatchQueue.main.async {
                        Utils.shared.hideSpinner(view: self.view)
                        self.updateUI()
                        
                    }
                }
                else {
                    print("Error fetching data")
                }
                
            }
            
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
