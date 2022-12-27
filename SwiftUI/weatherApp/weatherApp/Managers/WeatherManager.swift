//
//  WeatherManager.swift
//  weatherApp
//
//  Created by 富永開陽 on 2022/09/17.
//

import Foundation
import CoreLocation

class WeatherManager {
    
    let myAPI = "19b97447d08b5303028072031d369dd4"
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(myAPI)&units=metric") else {
            fatalError("URLの取得に失敗しました。")
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("天気情報の取得に失敗しました。")
        }
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decodedData
    }
    
    func getCityWeather(cityName: String) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(myAPI)") else {
            fatalError("URLの取得に失敗しました。")
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("天気情報の取得に失敗しました。")
        }
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decodedData
    }
}

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }
    struct WeatherResponse: Decodable {
         var id: Double
         var main: String
         var description: String
         var icon: String
     }

     struct MainResponse: Decodable {
         var temp: Double
         var feels_like: Double
         var temp_min: Double
         var temp_max: Double
         var pressure: Double
         var humidity: Double
     }

     struct WindResponse: Decodable {
         var speed: Double
         var deg: Double
     }
}

extension ResponseBody.MainResponse {
 var feelsLike: Double { return feels_like }
 var tempMin: Double { return temp_min }
 var tempMax: Double { return temp_max }
}
