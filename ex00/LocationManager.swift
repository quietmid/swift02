//
//  LocationManager.swift
//  Module02
//
//  Created by Joseph Lu on 9/11/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: String?
    @Published var coordinatesText: String = ""
    @Published var hasLocationAccess: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        authorizationStatus = manager.authorizationStatus
        updateLocationAccessStatus()
    }
    
    func requestAllowOnceLocationPermission() {
        switch authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            locationError = "Location access is denied. Please enter a city/country name in the search bar"
            coordinatesText = "Location  access not avaiable"
        @unknown default:
            locationError = "Unknown location authorization status"
        }
    }
    
    private func updateLocationAccessStatus() {
        hasLocationAccess = authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            locationError = "Failed to get location data"
            return
        }
        
        DispatchQueue.main.async {
            self.location = latestLocation
            let lat = latestLocation.coordinate.latitude
            let lon = latestLocation.coordinate.longitude
            self.coordinatesText = "Lat: \(String(format: "%.6f", lat)), Lon: \(String(format: "%.6f", lon))"
            self.locationError = nil
            print("Location updated: \(lat), \(lon)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = "Location error: \(error.localizedDescription)"
            self.coordinatesText = "Location access not avaiable"
            print("Location error: \(error.localizedDescription)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            self.updateLocationAccessStatus()
            
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                print("Location permission granted")
                self.locationError = nil
                // Automatically get location when permission is granted
                self.manager.requestLocation()
            case .denied, .restricted:
                print("Location permission denied")
                self.locationError = "Location access denied. Please enter a city name to get weather."
                self.coordinatesText = "Location access denied"
            case .notDetermined:
                print("Location permission not determined")
                self.locationError = nil
                self.coordinatesText = ""
            @unknown default:
                self.locationError = "Unknown location authorization status"
            }
        }
    }
    
}
