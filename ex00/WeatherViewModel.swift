//
//  WeatherViewModel 2.swift
//  Module02
//
//  Created by Joseph Lu on 9/18/25.
//


//
//  WeatherViewModel.swift
//  Module02
//
//  Created by Joseph Lu on 9/18/25.
//

import Foundation
import Combine
import CoreLocation

final class WeatherViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published private(set) var suggestions: [City] = []
    @Published var selectedTab: Int = 0
    @Published var selectedLocation: String = ""
    
    // Location-related properties
    @Published var coordinatesText: String = ""
    @Published var locationError: String?
    
    let weatherService = WeatherAPIService()
    let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    var showSearchSuggestions: Bool {
        !suggestions.isEmpty && isSearching
    }
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        // Subscribe to search text changes with debounce
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                Task {
                    await self?.searchCities(for: searchText)
                }
            }
            .store(in: &cancellables)
        
        // Subscribe to location manager updates
        locationManager.$coordinatesText
            .assign(to: \.coordinatesText, on: self)
            .store(in: &cancellables)
        
        locationManager.$locationError
            .assign(to: \.locationError, on: self)
            .store(in: &cancellables)
    }
    
    @MainActor
    private func searchCities(for query: String) async {
        guard !query.isEmpty else {
            suggestions = []
            return
        }
        
        // Use the return value from searchCities instead of calling private method
        suggestions = await weatherService.searchCities(for: query)
    }
    
    func selectCity(_ city: City) {
        searchText = city.name
        selectedLocation = city.displayName
        suggestions = []
    }
    
    func selectTab(_ tab: Int) {
        selectedTab = tab
    }
    
    func requestCurrentLocation() {
        selectedLocation = "Getting current location..."
        locationManager.requestAllowOnceLocationPermission()
    }
    
    func submitSearch() {
        selectedLocation = searchText
        suggestions = []
        print("Search submitted: \(searchText)")
    }
    
    func clearSuggestions() {
        suggestions = []
    }
}
