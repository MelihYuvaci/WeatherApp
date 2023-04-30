//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Melih Yuvacı on 30.04.2023.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var feelsView: UIView!
    @IBOutlet weak var windView: UIView!
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feelsView.layer.cornerRadius = 20.0 // Köşe yarıçapını belirleyin
        feelsView.clipsToBounds = true
        
        windView.layer.cornerRadius = 20.0 // Köşe yarıçapını belirleyin
        windView.clipsToBounds = true
        
        humidityView.layer.cornerRadius = 20.0 // Köşe yarıçapını belirleyin
        humidityView.clipsToBounds = true

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
    }
    

    @IBAction func citiesButtonClicked(_ sender: UIBarButtonItem) {

    }
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManage: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(named: weather.conditionName)
            self.cityLabel.text = weather.cityName
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
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
 
