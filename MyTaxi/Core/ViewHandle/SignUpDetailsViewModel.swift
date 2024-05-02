//
//  SignUpDetailsViewModel.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 22/06/23.
//

import Foundation

import SwiftUI

enum  ProfileDetails  {
    case signUpprofile
    case homeProfile
}


class signUpDetailsViewModel : ObservableObject{
   
    @Published var dateFormated : Date = Date()
    @Published  var deocodeDater : String  = ""
    @Published var firstName : String = ""
    @Published var lastName : String = ""
    @Published var phoneNumber : String
    @Published var myImage : UIImage?
    @Published var iscatogreySelected :String = ""
    @Published var profile : ProfileDetails
    @Published var isEdit : Bool = false
    
    init(phoneNumber : String, profile : ProfileDetails){
        self.phoneNumber = phoneNumber
        self.profile = profile
        self.DataPass(profile)
    }
    
    func DataSaved(){
        guard let image = myImage else {
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 1.0) else{return}
        
        AppController.shared.saveUserState(firstName: self.firstName, secondname: self.lastName, PhoneNumber: self.phoneNumber, imageURL: imageData, gender: self.iscatogreySelected)
        
        guard let image = self.myImage else{return}
        FirebaseManager.shared.storeUserData(user: User(image: image, mobileNumber: self.phoneNumber, firstName: self.firstName, lastName: self.lastName, gender: self.iscatogreySelected, dateOfBirth: self.deocodeDater))
        AppController.shared.varificationID =  AppController.verficationID
        print(AppController.shared.isUserSignedin)
    }
    
    func allFieldFillValidation()->Bool{
        if !firstName.isEmpty && !lastName.isEmpty && !iscatogreySelected.isEmpty && !self.deocodeDater.isEmpty && myImage != nil{
            return true
        }
        
        return false
    }
    
    func DataPass(_ profile : ProfileDetails){
        guard let data = AppController.userDetaisl else {return}
        if profile == .homeProfile{
            self.firstName = data.firstName
            self.lastName = data.lastName
            self.iscatogreySelected = data.gender
            self.phoneNumber = data.mobileNumber
            self.myImage = data.image
            self.deocodeDater = data.dateOfBirth
        }
    }
    
    
//    func
}




