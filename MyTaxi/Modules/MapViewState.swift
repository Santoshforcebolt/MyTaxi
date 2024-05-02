//
//  MapViewState.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 14/06/23.
//

import Foundation

enum MapViewState {
    case noInput
    case locationSelected
    case searchingForLocation
}


struct RideModel : Hashable{
    let id  = UUID().uuidString
    var image = "UberXIcon"
    let title : String?
    let price : Double
    let priceX : Double
    static func getData()->[RideModel] {
        return [
            RideModel(title: "UberX", price: 5, priceX: 1.5),
            RideModel(image : "uber-black",title: "Uber Black", price: 20, priceX: 2.0),
            RideModel(image : "motorbike",title: "D-Bike", price: 2, priceX: 0.75),
        ]
    }
    
    static func computedPrice(for distanceInMeters : Double, for fareX : Double, baseFare : Double)->Double{
        let distanceInMiles = distanceInMeters/1600
        return distanceInMiles * fareX + baseFare
    }
    
}
