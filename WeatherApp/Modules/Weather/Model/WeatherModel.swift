//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Melih Yuvacı on 30.04.2023.
//

import Foundation

struct WeatherModel {
    
    let conditionId: Int
    let cityName: String
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    let feelsLike : Double
    var feelsLikeString : String {
        return String(format: "%.1f", feelsLike)
    }
    let wind : Double
    var windString : String {
        return String(format: "%.1f", wind)
    }
    let humidity : Int
    var humidityString : String {
        return String(format: "%.1f", humidity)
    }
    
    let description : String
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud.fog"
        }
    }
}
