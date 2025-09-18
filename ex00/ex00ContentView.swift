//
//  ex00ContentView.swift
//  Module02
//
//  Created by Joseph Lu on 9/2/25.
//

import SwiftUI
import CoreLocationUI

struct ex00ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            // Search suggestions overlay
            if viewModel.showSearchSuggestions {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.clearSuggestions()
                    }
                VStack {
                    Spacer()
                        .frame(height: 30)
                    List(viewModel.suggestions) { suggestion in
                        Text(suggestion.displayName)
                            .onTapGesture {
                                viewModel.selectCity(suggestion)
                            }
                    }
                    .background(Color(.systemBackground))
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            
            // Main content - show tabs only when not searching
            if !viewModel.isSearching {
                VStack(spacing: 0) {
                    TabView(selection: $viewModel.selectedTab) {
//                        Text("Currently View")
//                            .tag(0)
//                        Text("Today View")
//                            .tag(1)
//                        Text("Weekly View")
//                            .tag(2)
                        weatherTabView(title: "Currently", tab: 0)
                            .tag(0)

                        weatherTabView(title: "Today", tab: 1)
                            .tag(1)

                        weatherTabView(title: "Weekly", tab: 2)
                            .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("weather_app")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.blue, for: .navigationBar)
        .toolbarBackground(.visible, for: .bottomBar)
        .toolbarBackground(Color.blue, for: .bottomBar)
        .searchable(text: $viewModel.searchText, prompt: "Search countries or cities")
        .onSubmit(of: .search) {
            viewModel.submitSearch()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                LocationButton(.currentLocation) {
                    viewModel.requestCurrentLocation()
                }
                .symbolVariant(.fill)
                .foregroundColor(.white)
                .labelStyle(.iconOnly)
            }
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button("Currently") {
                        viewModel.selectTab(0)
                    }
                    .font(.system(size: 25))
                    .foregroundColor(viewModel.selectedTab == 0 ? .black : .white)
                    Spacer()
                    Button("Today") {
                        viewModel.selectTab(1)
                    }
                    .font(.system(size: 25))
                    .foregroundColor(viewModel.selectedTab == 1 ? .black : .white)
                    Spacer()
                    Button("Weekly") {
                        viewModel.selectTab(2)
                    }
                    .font(.system(size: 25))
                    .foregroundColor(viewModel.selectedTab == 2 ? .black : .white)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func weatherTabView(title: String, tab: Int) -> some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .padding()

//            if $viewModel.isLoadingWeather {
//                ProgressView("Loading weather...")
//                    .padding()
//            } else if let error = viewModel.weatherError {
//                Text(error)
//                    .font(.caption)
//                    .foregroundColor(.red)
//                    .multilineTextAlignment(.center)
//                    .padding()
//            } else {
//                // Display weather data based on selected tab
//                switch tab {
//                case 0: // Currently
//                    currentWeatherView()
//                case 1: // Today
//                    todayWeatherView()
//                case 2: // Weekly
//                    weeklyWeatherView()
//                default:
//                    EmptyView()
//                }
//            }
//
//            if !viewModel.coordinatesText.isEmpty {
//                Text(viewModel.coordinatesText)
//                    .font(.headline)
//                    .foregroundColor(.blue)
//                    .padding()
//            }
//
//            if let error = viewModel.locationError {
//                Text(error)
//                    .font(.caption)
//                    .foregroundColor(.red)
//                    .multilineTextAlignment(.center)
//                    .padding()
//            }
//
//            if !viewModel.selectedLocation.isEmpty {
//                Text(viewModel.selectedLocation)
//                    .font(.title2)
//                    .padding()
//            }
        }
    }

//    private func currentWeatherView() -> some View {
//        VStack(spacing: 10) {
//            if let weather = $viewModel.currentWeather {
//                if let temp = weather.temperature {
//                    Text("\(Int(temp))°C")
//                        .font(.system(size: 60, weight: .thin))
//                }
//
//                HStack(spacing: 20) {
//                    if let windSpeed = weather.windSpeed {
//                        Text("Wind: \(Int(windSpeed)) km/h")
//                            .font(.subheadline)
//                    }
//                    if let humidity = weather.humidity {
//                        Text("Humidity: \(Int(humidity))%")
//                            .font(.subheadline)
//                    }
//                }
//                .foregroundColor(.secondary)
//            } else {
//                Text("Select a city to see current weather")
//                    .font(.headline)
//                    .foregroundColor(.secondary)
//            }
//        }
//        .padding()
//    }
//
//    private func todayWeatherView() -> some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 15) {
//                ForEach($viewModel.todayWeather) { hourData in
//                    VStack(spacing: 5) {
//                        Text("\(hourData.hour):00")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//
//                        Text("\(Int(hourData.temperature))°")
//                            .font(.headline)
//                            .fontWeight(.medium)
//                    }
//                    .padding(.vertical, 8)
//                    .padding(.horizontal, 12)
//                    .background(Color.blue.opacity(0.1))
//                    .cornerRadius(8)
//                }
//            }
//            .padding(.horizontal)
//        }
//        .padding(.vertical)
//    }
//
//    private func weeklyWeatherView() -> some View {
//        VStack(spacing: 10) {
//            ForEach(viewModel.weeklyWeather) { dayData in
//                HStack {
//                    Text(dayData.day)
//                        .font(.headline)
//                        .frame(width: 60, alignment: .leading)
//
//                    Spacer()
//
//                    HStack(spacing: 10) {
//                        Text("\(Int(dayData.maxTemperature))°")
//                            .font(.headline)
//                            .fontWeight(.medium)
//
//                        Text("\(Int(dayData.minTemperature))°")
//                            .font(.headline)
//                            .fontWeight(.light)
//                            .foregroundColor(.secondary)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.vertical, 8)
//                .background(Color.blue.opacity(0.05))
//                .cornerRadius(8)
//            }
//        }
//        .padding()
//    }
}



#Preview {
    NavigationView {
        ex00ContentView()
    }
}
