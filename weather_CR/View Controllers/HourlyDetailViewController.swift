//
//  HourlyDetailViewController.swift
//  weather_CR
//
//  Created by Scott Courtney on 4/2/22.
//

import UIKit


class HourlyDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var realFeelLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    
}


class HourlyDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hourlyDetailTableView: UITableView!
    @IBOutlet weak var dateLbl: UILabel!
    
    var results: WeatherResult?
    var indexPathPassed = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourlyDetailTableView.delegate = self
        hourlyDetailTableView.dataSource = self
        results = Weather.shared.weather
        
        //setup date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: results?.forecast.forecastday[indexPathPassed].date ?? "")
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateLbl.text = dateFormatter.string(from: date!)
    }
    
    // Table View Functionality
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.forecast.forecastday[indexPathPassed].hour.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourlyDetailCells", for: indexPath) as! HourlyDetailTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let time = dateFormatter.date(from: results?.forecast.forecastday[indexPathPassed].hour[indexPath.row].time ?? "")
        dateFormatter.dateFormat = "h a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        cell.timeLbl.text = dateFormatter.string(from: time!)
        
        let url = URL(string: results?.forecast.forecastday[indexPathPassed].hour[indexPath.row].condition.icon ?? "")
        let lastPath = url?.lastPathComponent
        cell.weatherImg.image = UIImage(named: lastPath ?? "")
        
        let hourlyTemp = Int(round(results?.forecast.forecastday[indexPathPassed].hour[indexPath.row].tempF ?? 0))
        cell.tempLbl.text = String(hourlyTemp) + "º"
        
        let feelslikeF = Int(round(results?.forecast.forecastday[indexPathPassed].hour[indexPath.row].feelslikeF ?? 0))
        cell.realFeelLbl.text = "RealFeel " + String(feelslikeF) + "º"
        
        return cell
    }
    
}
