//
//  DailyWeatherViewController.swift
//  weather_CR
//
//  Created by Scott Courtney on 3/31/22.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    
}

class DailyWeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var locationBtn: UIButton!
    
    var results: WeatherResult?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        results = Weather.shared.weather
        locationBtn.setTitle((results?.location.name ?? "") + ", " + (self.results?.location.region ?? ""), for: .normal)
        self.dailyTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        results = Weather.shared.weather
        locationBtn.setTitle((results?.location.name ?? "") + ", " + (self.results?.location.region ?? ""), for: .normal)
        
    }
    
    // Table View functionality
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.forecast.forecastday.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCells", for: indexPath) as! DailyTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: results?.forecast.forecastday[indexPath.row].date ?? "")
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        cell.dateLbl.text = dateFormatter.string(from: date!)
        
        let url = URL(string: results?.forecast.forecastday[indexPath.row].day.condition.icon ?? "")
        let lastPath = url?.lastPathComponent
        cell.weatherImg.image = UIImage(named: lastPath ?? "")
        
        let temp = Int(round(results?.forecast.forecastday[indexPath.row].day.avgtempF ?? 0))
        cell.tempLbl.text = String(temp) + "º"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HourlyDetailViewController") as! HourlyDetailViewController
            
//        vc.skyLabelString = weatherData?.list[indexPath.row].weather[0].main
//        vc.descSkyLabelString = weatherData?.list[indexPath.row].weather[0].description
//        vc.tempLabelString =  measurementFormatter.string(from: temp.converted(to: .fahrenheit))
//        vc.feelsLikeLabelString = measurementFormatter.string(from: feelsLike.converted(to: .fahrenheit))
        vc.indexPathPassed = indexPath.row
        self.present(vc, animated: true, completion: nil)
        
    }
}
