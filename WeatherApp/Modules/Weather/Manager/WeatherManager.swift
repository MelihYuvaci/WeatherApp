//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Melih Yuvacı on 30.04.2023.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func  didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError (error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=187474c8de07cfa406755d05bf4f0420&units=metric&lang=tr"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequst(with: urlString)
        print(urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequst(with: urlString)
        print(urlString)
    }
    
    func performRequst(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData =  data{
                    if let weather = parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather:weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let feelsLike = decodedData.main.feelsLike
            let wind = decodedData.wind.speed
            let humidity = decodedData.main.humidity
            let description = decodedData.weather[0].description
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, feelsLike: feelsLike, wind: wind, humidity: humidity, description: description)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
  
}
