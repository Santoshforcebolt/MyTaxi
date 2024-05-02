//
//  UberMapViewReprenstable.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 13/06/23.
//

import Foundation
import SwiftUI
import MapKit
struct UberMapViewReprentable : UIViewRepresentable {
    
    let mapview = MKMapView()
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    @Binding var mapState : MapViewState
    let locationManager = LocationManager.shared
    func makeUIView(context: Context) -> some UIView {
        mapview.delegate = context.coordinator
        mapview.isRotateEnabled  = false
        mapview.showsUserLocation = true
        mapview.userTrackingMode = .follow
        DispatchQueue.main.async {
                // Center the map on the user's location
                if let userLocation = mapview.userLocation.location?.coordinate {
                    let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    mapview.setRegion(region, animated: false)
                }
            }
        
        return mapview
    }
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUser()
            
        case .locationSelected:
            if let coordinate = locationViewModel.selectedLocationCoordinate {
                context.coordinator.addAndSelectAnnonations(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinaitons: coordinate)
                context.coordinator.searchAndDisplayNearbyRiders()
                
            }
            break
        case .searchingForLocation:
            break
        }
        
//        if mapState == .locationSelected{
//            context.coordinator.clearMapViewAndRecenterOnUser()
//        }
    }
    
    
    

}

extension UberMapViewReprentable {
    class MapCoordinator : NSObject, MKMapViewDelegate{
        let parent : UberMapViewReprentable
        var userLocaitonCoordinate : CLLocationCoordinate2D?
        var currentRegion : MKCoordinateRegion?
        let geocoder = CLGeocoder()
        var riderAnnotations: [Int: RiderAnnotation] = [:]
        var timer: Timer?
        init(parent: UberMapViewReprentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocaitonCoordinate = userLocation.coordinate
            if currentRegion == nil {
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.currentRegion = region
                parent.mapview.setRegion(region, animated: true)
            }
        }
        
//        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//            self.userLocaitonCoordinate = userLocation.coordinate
//            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//            self.currentRegion = region
//            parent.mapview.setRegion(region, animated: true)
//
////            fetchAddress(for: userLocation.coordinate) { address in
////                            if let address = address {
////                                self.parent.locationViewModel.currentLocationAddress = address
////                            }
////                        }
//
//
//        }
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           
            let polyline = MKPolylineRenderer(overlay: overlay)
                polyline.strokeColor = .systemBlue
                polyline.lineWidth = 6
            return polyline
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else { return nil }
            
            if let riderAnnotation = annotation as? RiderAnnotation {
                let identifier = "riderAnnotation"
                
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKImageViewAnnotationView
                if annotationView == nil {
                    annotationView = MKImageViewAnnotationView(annotation: riderAnnotation, reuseIdentifier: identifier)
                } else {
                    annotationView?.annotation = riderAnnotation
                }
                
                
                if parent.locationViewModel.rideType == .bike {
                    annotationView?.image = UIImage(named: "motorbike")?.resizeImage(targetSize: CGSize(width: 40, height: 40))
                } else if parent.locationViewModel.rideType == .car {
                    annotationView?.image = UIImage(named: "UberXIcon")?.resizeImage(targetSize: CGSize(width: 40, height: 40))
                }
                
                return annotationView
            }
            
            // Return nil for other types of annotations
            return nil
        }
        
//        Mark Helpers
        
        func addAndSelectAnnonations(withCoordinate coordinate : CLLocationCoordinate2D){
            parent.mapview.removeAnnotations(parent.mapview.annotations)
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            
            self.parent.mapview.addAnnotation(anno)
            self.parent.mapview.selectAnnotation(anno, animated: true)
            
            
        }
        func configurePolyline(withDestinaitons coordinate : CLLocationCoordinate2D){
            guard let userLocation = self.userLocaitonCoordinate else {return}
            if let overlays = parent.mapview.overlays as? [MKPolyline] {
                    parent.mapview.removeOverlays(overlays)
        }
            
            getDestinationsRoute(from: userLocation, to: coordinate) { route in
                self.parent.mapview.addOverlay(route.polyline)
                let react = self.parent.mapview.mapRectThatFits(route.polyline.boundingMapRect,edgePadding: .init(top: 20, left: 32, bottom: 700, right: 32))
                self.parent.mapview.setRegion(MKCoordinateRegion(react), animated: true)
            }
        }
        
        
        func getDestinationsRoute(from userLocation : CLLocationCoordinate2D, to desitnation : CLLocationCoordinate2D, completion : @escaping (MKRoute)->Void){
             let userPlaceMark = MKPlacemark(coordinate: userLocation)
             let destPlaceMark = MKPlacemark(coordinate: desitnation)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlaceMark)
            request.destination = MKMapItem(placemark: destPlaceMark)
            let dircetion = MKDirections(request: request)
            dircetion.calculate { response, error in
                if let error = error {
                    print("Faild to get directions", error.localizedDescription)
                    return
                }
                guard let route = response?.routes.first else {return}
                
                completion(route)
                
            }
            
            
        }
        
        func clearMapViewAndRecenterOnUser(){
            parent.mapview.removeAnnotations(parent.mapview.annotations)
            parent.mapview.removeOverlays(parent.mapview.overlays)
            if let currentRegion = currentRegion {
                parent.mapview.setRegion(currentRegion, animated: true)
            }
            
            timer?.invalidate()
                timer = nil
        }
        
        func fetchAddress(for coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
                    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    geocoder.reverseGeocodeLocation(location) { placemarks, error in
                        if let error = error {
                            print("Failed to reverse geocode location: \(error.localizedDescription)")
                            completion(nil)
                            return
                        }

                        if let placemark = placemarks?.first {
                         let address = "\(placemark.name ?? ""), \(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? ""), \(placemark.postalCode ?? ""), \(placemark.country ?? "")"

                            completion(address)
                        } else {
                            completion(nil)
                        }
                    }
                }
        
        
        
        func searchAndDisplayNearbyRiders() {
            parent.locationManager.searchNearbyRiders { result in
                    switch result {
                    case .success(let nearbyRiders):
                        // Add rider annotations to the map
                        self.addRiderAnnotations(nearbyRiders)
                        self.startUpdatingRiderCoordinates()
                        print("Failed to retrieve nearby riders:")
                    case .failure(let error):
                        // Handle error when unable to retrieve nearby riders
                        print("Failed to retrieve nearby riders:", error.localizedDescription)
                    }
                }
            }
        
        private func addRiderAnnotations(_ riders: [(title: String, coordinate: CLLocationCoordinate2D)]) {
            for (index, rider) in riders.enumerated() {
                let annotation = RiderAnnotation(title : rider.title, coordinate : rider.coordinate)
                parent.mapview.addAnnotation(annotation)
                riderAnnotations[index] = annotation
            }
        }
        
        private func startUpdatingRiderCoordinates() {
                    // Start the timer to update rider coordinates
                    timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
                        self?.updateRiderCoordinates()
                    }
                }
        
        private func updateRiderCoordinates() {
                    // Update the coordinates of the rider annotations randomly
                    for (index, annotation) in riderAnnotations {
                        // Generate new random coordinates (example)
                        
                        let newLatitude = annotation.coordinate.latitude + Double.random(in: -0.0004...0.0004)
                        let newLongitude = annotation.coordinate.longitude + Double.random(in: -0.0001...0.0001)
                        let newCoordinate = CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
                        
                        // Update the annotation's coordinate
                        DispatchQueue.main.async {
                            annotation.updateCoordinate(newCoordinate)
                        }
                        
                        // Update the annotation on the map
                        parent.mapview.view(for: annotation)?.annotation = annotation
                    }
                }
        
    }
}


extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        
        return resizedImage
    }
}


class RiderAnnotation: NSObject, MKAnnotation {
    let title: String?
    var coordinate: CLLocationCoordinate2D
     // Add a property to specify the type of the rider annotation
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
    
    func updateCoordinate(_ newCoordinate: CLLocationCoordinate2D) {
           self.coordinate = newCoordinate
       }
}

enum RiderType {
    case bike
    case car
}


class MKImageViewAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            guard let annotation = annotation else { return }
            canShowCallout = false
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
