//
//  MenuDataModel.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 19/06/23.
//

import Foundation




struct MenuViewModel : Hashable,Identifiable{
    
        var id: Int 
        var  title: String
        var description: String
    
    static let menuItems  : [MenuViewModel] = [
        MenuViewModel(id: 0, title: "Profile", description: "Description 1"),
        MenuViewModel(id: 1, title: "Ride History", description: "Description 2"),
        MenuViewModel(id: 2, title: "Help", description: "Description 3"),
        MenuViewModel(id: 3, title: "About Us", description: "Description 4")
    ]
    
}

