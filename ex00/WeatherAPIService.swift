//
//  WeatherAPIService.swift
//  Module02
//
//  Created by Joseph Lu on 9/14/25.
//

import Foundation
import OpenMeteoSdk
import Combine

struct City: Codable, Identifiable {
    let id: Int
    let name: String
    let country: String
    let admin1: String? //region/state
    let latitude: Double?
    let longitude: Double?
    
    var displayName: String {
        var components: [String] = [name]
        if let admin1 = admin1, !admin1.isEmpty {
            components.append(admin1)
        }
        components.append(country)
        return components.joined(separator: ", ")
    }
}

struct GeocodingResponse: Codable {
    let results: [City]?
}

class WeatherAPIService {
    
    // MARK: - City Search Methods
    
    func searchCities(for query: String) async -> [City] {
        guard !query.isEmpty else {
            return []
        }
        
        // TODO: Replace with actual API call
        // Uncomment the following lines when ready to use real API:
        /*
        let baseURL = "https://geocoding-api.open-meteo.com/v1/search"
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode query")
            return []
        }
        
        let urlString = "\(baseURL)?name=\(encodedQuery)&count=5&language=en"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return []
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(GeocodingResponse.self, from: data)
            return response.results ?? []
        } catch {
            print("Error fetching cities: \(error)")
            return []
        }
        */
        
        // For now, return mock data filtered by query
        let mockCities = getMockCities()
        let lowercaseQuery = query.lowercased()
        
        return mockCities.filter { city in
            city.name.lowercased().contains(lowercaseQuery) ||
            city.country.lowercased().contains(lowercaseQuery) ||
            (city.admin1?.lowercased().contains(lowercaseQuery) ?? false)
        }
    }
    
    // MARK: - Weather Data Methods
    
    func getCurrentWeather(for city: City) async -> WeatherData? {
        guard let latitude = city.latitude, let longitude = city.longitude else {
            print("Missing coordinates for city: \(city.name)")
            return nil
        }
        
        // TODO: Implement actual weather API call using OpenMeteoSdk
        /*
        do {
            let weather = try await WeatherApiResponse.fetch(
                url: "https://api.open-meteo.com/v1/forecast",
                latitude: latitude,
                longitude: longitude,
                current: [.temperature2m, .weatherCode, .windSpeed10m, .humidity],
                timezone: "auto"
            )
            
            return WeatherData(
                temperature: weather.current?.temperature2m,
                weatherCode: weather.current?.weatherCode,
                windSpeed: weather.current?.windSpeed10m,
                humidity: weather.current?.humidity
            )
        } catch {
            print("Error fetching weather: \(error)")
            return nil
        }
        */
        
        // For now, return mock weather data
        return WeatherData(
            temperature: Double.random(in: 15...30),
            weatherCode: Int.random(in: 0...3),
            windSpeed: Double.random(in: 5...20),
            humidity: Double.random(in: 30...80)
        )
    }
    
    func getTodayWeather(for city: City) async -> [HourlyWeatherData]? {
        guard let latitude = city.latitude, let longitude = city.longitude else {
            print("Missing coordinates for city: \(city.name)")
            return nil
        }
        
        // TODO: Implement actual hourly weather API call
        /*
        do {
            let weather = try await WeatherApiResponse.fetch(
                url: "https://api.open-meteo.com/v1/forecast",
                latitude: latitude,
                longitude: longitude,
                hourly: [.temperature2m, .weatherCode],
                timezone: "auto"
            )
            
            // Process hourly data for today only
            return processHourlyData(weather.hourly)
        } catch {
            print("Error fetching today's weather: \(error)")
            return nil
        }
        */
        
        // For now, return mock hourly data
        return getMockHourlyData()
    }
    
    func getWeeklyWeather(for city: City) async -> [DailyWeatherData]? {
        guard let latitude = city.latitude, let longitude = city.longitude else {
            print("Missing coordinates for city: \(city.name)")
            return nil
        }
        
        // TODO: Implement actual weekly weather API call
        /*
        do {
            let weather = try await WeatherApiResponse.fetch(
                url: "https://api.open-meteo.com/v1/forecast",
                latitude: latitude,
                longitude: longitude,
                daily: [.temperature2mMax, .temperature2mMin, .weatherCode],
                timezone: "auto"
            )
            
            return processDailyData(weather.daily)
        } catch {
            print("Error fetching weekly weather: \(error)")
            return nil
        }
        */
        
        // For now, return mock weekly data
        return getMockWeeklyData()
    }
    
    // MARK: - Mock Data
    
    private func getMockCities() -> [City] {
        return [
            City(id: 1, name: "New York", country: "US", admin1: "NY", latitude: 40.7128, longitude: -74.0060),
            City(id: 2, name: "Paris", country: "FR", admin1: "Île-de-France", latitude: 48.8566, longitude: 2.3522),
            City(id: 3, name: "London", country: "GB", admin1: "England", latitude: 51.5074, longitude: -0.1278),
            City(id: 4, name: "Tokyo", country: "JP", admin1: "Tokyo", latitude: 35.6762, longitude: 139.6503),
            City(id: 5, name: "Sydney", country: "AU", admin1: "New South Wales", latitude: -33.8688, longitude: 151.2093),
            City(id: 6, name: "Beijing", country: "CN", admin1: "Beijing", latitude: 39.9042, longitude: 116.4074),
            City(id: 7, name: "Seoul", country: "KR", admin1: "Seoul", latitude: 37.5665, longitude: 126.9780),
            City(id: 8, name: "Mexico City", country: "MX", admin1: "Distrito Federal", latitude: 19.4326, longitude: -99.1332),
            City(id: 9, name: "Cairo", country: "EG", admin1: "Cairo", latitude: 30.0444, longitude: 31.2357),
            City(id: 10, name: "Osaka", country: "JP", admin1: "Osaka", latitude: 34.6937, longitude: 135.5023),
            City(id: 11, name: "Dhaka", country: "BD", admin1: "Dhaka", latitude: 23.8103, longitude: 90.4125),
            City(id: 12, name: "Manila", country: "PH", admin1: "Region IV-A", latitude: 14.5995, longitude: 120.9842),
        ]
    }
    
    private func getMockHourlyData() -> [HourlyWeatherData] {
        let hours = Array(0...23)
        return hours.map { hour in
            HourlyWeatherData(
                hour: hour,
                temperature: Double.random(in: 15...30),
                weatherCode: Int.random(in: 0...3)
            )
        }
    }
    
    private func getMockWeeklyData() -> [DailyWeatherData] {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        return days.map { day in
            DailyWeatherData(
                day: day,
                maxTemperature: Double.random(in: 20...35),
                minTemperature: Double.random(in: 10...20),
                weatherCode: Int.random(in: 0...3)
            )
        }
    }
}

// MARK: - Weather Data Models

struct WeatherData {
    let temperature: Double?
    let weatherCode: Int?
    let windSpeed: Double?
    let humidity: Double?
}

struct HourlyWeatherData: Identifiable {
    let id = UUID()
    let hour: Int
    let temperature: Double
    let weatherCode: Int
}

struct DailyWeatherData: Identifiable {
    let id = UUID()
    let day: String
    let maxTemperature: Double
    let minTemperature: Double
    let weatherCode: Int
}
