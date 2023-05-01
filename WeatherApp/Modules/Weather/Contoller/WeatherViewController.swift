//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Melih Yuvacı on 30.04.2023.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var feelsView: UIView!
    @IBOutlet private weak var windView: UIView!
    @IBOutlet private weak var humidityView: UIView!
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var todayLabel: UILabel!
    
    //MARK: - Properties
    
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    var selectedCity:String?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Action
    
    @IBAction func citiesButtonClicked(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(identifier: "CitiesViewController") as? CitiesViewController{
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - Configure

extension WeatherViewController {
    
    func configure (){
        feelsView.layer.cornerRadius = 20.0
        feelsView.clipsToBounds = true
        windView.layer.cornerRadius = 20.0
        windView.clipsToBounds = true
        humidityView.layer.cornerRadius = 20.0
        humidityView.clipsToBounds = true

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
    }
    
    func dateFormat() -> String{
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "'Today,' d MMMM"
        dateFormatter.locale = Locale(identifier: "en_US") // İngilizce olarak ay adını kullanmak için
        let formattedDate = dateFormatter.string(from: today)
        return formattedDate
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManage: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(weather.temperatureString)°"
            self.conditionImageView.image = UIImage(named: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.humidityLabel.text = "\(weather.humidityString)%"
            self.feelsLikeLabel.text = "\(weather.feelsLikeString)°"
            self.windLabel.text = "\(weather.windString) km/h"
            self.todayLabel.text = self.dateFormat()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}



//MARK: - CLLocationManager

extension WeatherViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            if selectedCity != nil  {
                weatherManager.fetchWeather(cityName: selectedCity ?? "")
            }else{
                weatherManager.fetchWeather(latitude: lat, longitude: lon)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

