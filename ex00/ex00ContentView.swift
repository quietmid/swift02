//
//  ex00ContentView.swift
//  Module02
//
//  Created by Joseph Lu on 9/2/25.
//

import SwiftUI
import CoreLocationUI

struct ex00ContentView: View {
    @State private var searchField = ""
    @State private var savedSearchedText = ""
    @State private var selectedTab = 0
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                VStack {
                    Text("Currently")
                        .font(.largeTitle)
                        .padding()
                    // Spacer()
                    if !locationManager.coordinatesText.isEmpty {
                        Text(locationManager.coordinatesText)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    
                    if let error = locationManager.locationError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    if !savedSearchedText.isEmpty {
                        Text(savedSearchedText)
                            .font(.title2)
                            .padding()
                    }
                }
                .tag(0)
                
                VStack {
                    Text("Today")
                        .font(.largeTitle)
                        .padding()
//                    Spacer()
                    if !locationManager.coordinatesText.isEmpty {
                        Text(locationManager.coordinatesText)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    
                    if let error = locationManager.locationError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    if !savedSearchedText.isEmpty {
                        Text(savedSearchedText)
                            .font(.title2)
                            .padding()
                    }
                }
                .tag(1)
                
                VStack {
                    Text("Weekly")
                        .font(.largeTitle)
                        .padding()
//                    Spacer()
                    if !locationManager.coordinatesText.isEmpty {
                        Text(locationManager.coordinatesText)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    
                    if let error = locationManager.locationError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    if !savedSearchedText.isEmpty {
                        Text(savedSearchedText)
                            .font(.title2)
                            .padding()
                    }
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationTitle("weather_app")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.blue, for: .navigationBar)
        .toolbarBackground(.visible, for: .bottomBar)
        .toolbarBackground(Color.blue, for: .bottomBar)
        .searchable(text: $searchField, prompt: "Search countries or cities")
        .onSubmit(of: .search) {
            savedSearchedText = searchField
            print("Search submitted: \(searchField)")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                LocationButton(.currentLocation) {
                    locationManager.requestAllowOnceLocationPermission()
                    savedSearchedText = "Getting current location ... "
                    print("fidning current location ... ")
                }
                .symbolVariant(.fill)
                .foregroundColor(.white)
                .labelStyle(.iconOnly)
//                Button(action: locateMe) {
//                    Image(systemName: "globe")
//                        .foregroundColor(.white)
//                        .font(.system(size: 20))
//                }
            }
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button("Currently") {
                        selectedTab = 0
                    }
                    .font(.system(size: 25))
                    .foregroundColor(selectedTab == 0 ? .black : .white)
                    Spacer()
                    Button("Today") {
                        selectedTab = 1
                    }
                    .font(.system(size: 25))
                    .foregroundColor(selectedTab == 1 ? .black : .white)
                    Spacer()
                    Button("Weekly") {
                        selectedTab = 2
                    }
                    .font(.system(size: 25))
                    .foregroundColor(selectedTab == 2 ? .black : .white)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
//    private func locateMe() {
//        locationManager.getCurrentLocation()
//        savedSearchedText = "Geolocation"
//        print("finding current location...")
//    }
}



#Preview {
    NavigationView {
        ex00ContentView()
    }
}
