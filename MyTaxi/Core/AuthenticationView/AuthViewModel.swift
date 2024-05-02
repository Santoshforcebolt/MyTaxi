//
//  AuthViewModel.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 22/06/23.
//

import Foundation


class AuthViewModel : ObservableObject {
    @Published var selectedCountry : String = "+91"
    @Published var enterphoneNumber : String = ""
    @Published var isPhoneCode : Bool = false
    @Published var isEnterCode : Bool = false
    let countryViewModel = CountryViewModel()
    
    
}
