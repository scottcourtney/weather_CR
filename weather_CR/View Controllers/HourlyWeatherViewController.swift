//
//  HourlyWeatherViewController.swift
//  weather_CR
//
//  Created by Scott Courtney on 3/31/22.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var realFeelLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    
    
}

class HourlyWeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hourlyTableView: UITableView!
    @IBOutlet weak var locationBtn: UIButton!
    
    var results: WeatherResult?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        results = Weather.shared.weather
        self.hourlyTableView.reloadData()
        locationBtn.setTitle((results?.location.name ?? "") + ", " + (self.results?.location.region ?? ""), for: .normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationBtn.setTitle((results?.location.name ?? "") + ", " + (self.results?.location.region ?? ""), for: .normal)
        hourlyTableView.delegate = self
        hourlyTableView.dataSource = self
        results = Weather.shared.weather
    }
    
    // Table View Functionality
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.forecast.forecastday[0].hour.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourlyCells", for: indexPath) as! HourlyTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let time = dateFormatter.date(from: results?.forecast.forecastday[0].hour[indexPath.row].time ?? "")
        dateFormatter.dateFormat = "h a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        cell.timeLbl.text = dateFormatter.string(from: time!)
        
        let url = URL(string: results?.forecast.forecastday[0].hour[indexPath.row].condition.icon ?? "")
        let lastPath = url?.lastPathComponent
        cell.weatherImg.image = UIImage(named: lastPath ?? "")
        
        let hourlyTemp = Int(round(results?.forecast.forecastday[0].hour[indexPath.row].tempF ?? 0))
        cell.tempLbl.text = String(hourlyTemp) + "º"
        
        let feelslikeF = Int(round(results?.forecast.forecastday[0].hour[indexPath.row].feelslikeF ?? 0))
        cell.realFeelLbl.text = "RealFeel " + String(feelslikeF) + "º"
        
        return cell
    }
    
}
