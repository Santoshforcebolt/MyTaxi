//
//  LocationSearchViewModel.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 13/06/23.
//

import Foundation
import MapKit

class LocationSearchViewModel : NSObject,ObservableObject{
    
//    Mark : properties
    @Published var result = [MKLocalSearchCompletion]()
    @Published  var selectedLocationCoordinate : CLLocationCoordinate2D?
    private let searchCompleter = MKLocalSearchCompleter()
    @Published var currentLocationAddress: String = ""
    @Published var destinationName : String = ""
    @Published var destinationTime : String = ""
    private let locationManager = LocationManager()
    @Published var isRideSheet : Bool = false
    @Published var rideType : RiderType = .car
    
    var userLocation : CLLocationCoordinate2D?
    var queryFragment : String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    func selectLocation(_ location : MKLocalSearchCompletion){
        locationSearch(forLocoSearchComplition: location) { response, err in
            guard let item = response?.mapItems.first else {return}
            let coordinate = item.placemark.coordinate
           
            self.selectedLocationCoordinate = coordinate
            
            DispatchQueue.main.async {
                self.avrageTimeToDestination()
            }
        }
    }
    
    func locationSearch(forLocoSearchComplition  localSearch : MKLocalSearchCompletion, completion : @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func fetchCurrentLocation() {
            locationManager.getCurrentLocation { result in
                switch result {
                case .success(let coordinate):
                    self.selectedLocationCoordinate = coordinate
                case .failure(let error):
                    print("Failed to fetch current location: \(error.localizedDescription)")
                }
            }
        }
    func avrageTimeToDestination() {
       
        guard let  destCoordinte = selectedLocationCoordinate else {return }
        guard let userCoordinate = self.userLocation else {return }
       
        calculateTravelTime(source: userCoordinate, destination: destCoordinte) { (time, error) in
            if let error = error {
                print("Error calculating travel time: \(error.localizedDescription)")
                return
            }
            
            if let time = time {
                let minutes = Int(time / 60)
                print("Estimated travel time: \(minutes) minutes")
                let destinationTimeF = calculateDestinationTime(durationMinutes: minutes)
                self.destinationTime = destinationTimeF
            
            } else {
                print("Unable to calculate travel time.")
            }
        }
    }
    
    func computeRiderPrice() -> Double {
        guard let  destCoordinte = selectedLocationCoordinate else {return 0.0}
        guard let userCoordinate = self.userLocation else {return 0.0}
        let userLocationFirst = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let destination = CLLocation(latitude: destCoordinte.latitude, longitude: destCoordinte.longitude)
        let tripDestinationInMeters = userLocationFirst.distance(from: destination)
        return tripDestinationInMeters
    }
    
    func calculateTravelTime(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping (TimeInterval?, Error?) -> Void) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let request = MKDirections.Request()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let route = response?.routes.first else {
                completion(nil, nil)
                return
            }
            
            let travelTime = route.expectedTravelTime
            completion(travelTime, nil)
        }
    }
}

//Mark : MKLocalSearchCompleterDelegate

extension LocationSearchViewModel : MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.result = completer.results
    }
}

func getTime(date: Date = Date(), formatD : String = "hh:mm:ss a") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = formatD // Format the time as HH:mm:ss (24-hour format)
    return formatter.string(from: date)
}

func calculateDestinationTime(currentTime: Date = Date(), durationMinutes: Int) -> String {
    let calendar = Calendar.current
    let destinationTime = calendar.date(byAdding: .minute, value: durationMinutes, to: currentTime)!
   let currentTime = getTime(date: destinationTime)
    return currentTime
}

