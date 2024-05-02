//
//  LocationManager.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 13/06/23.
//

import Foundation
import CoreLocation
class LocationManager : NSObject,ObservableObject {
   
    private let locationManager = CLLocationManager()
    private var completion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?
    static let shared = LocationManager()
    @Published var userLocation : CLLocationCoordinate2D?
    override  init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
  
    
    func getCurrentLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
            self.completion = completion
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }

}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let  location = locations.first else {
            return
        }
        self.userLocation = location.coordinate
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        completion?(.success(location.coordinate))
        completion = nil
       
    }
    func searchNearbyRiders(completion: @escaping (Result<[(title: String, coordinate: CLLocationCoordinate2D)], Error>) -> Void) {
            guard let userLocation = userLocation else {
                // Handle error when user location is not available
                completion(.failure(NSError(domain: "Location not available", code: 0, userInfo: nil)))
                return
            }
            
            // Use the userLocation to search for nearby riders using an API or database query
            
            // Example: Generate a sample list of nearby rider coordinates
        let nearbyRiders: [(title : String,coordinate: CLLocationCoordinate2D)] = [
            (title : "Rider1", coordinate : CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)),
            (title : "Rider2", coordinate :  CLLocationCoordinate2D(latitude: userLocation.latitude - 0.004, longitude: userLocation.longitude - 0.0001)),
                
                ]
        
          
            completion(.success(nearbyRiders))
        }
}
