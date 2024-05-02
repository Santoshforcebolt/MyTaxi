//
//  AppController.swift
//  TexiRider
//
//  Created by Girish Dadhich on 22/06/23.
//



import Foundation
import UIKit

class AppController {
    static var shared : AppController{
        let sharedObj = AppController()
        return sharedObj
    }
//    Application Base url
    func twoDecimalAfter(_ value : Double)->String{
        return String(format: "%.2f", value)
    }
    func generatePIN() -> String {
        let pinDigits = 4
        var pin = ""
        
        for _ in 0..<pinDigits {
            let digit = Int.random(in: 0...9)
            pin += "\(digit)"
        }
        
        return pin
    }


    
    static var userDetaisl : User?
    static var rideDetails : Ride?
    static var verficationID : String = ""
    
    static let taxiUserDefault = UserDefaults.standard
    
    //    Which type user Authenticate saved
    
    var varificationID : String {
        didSet {
            AppController.taxiUserDefault.set(varificationID, forKey: TaxiDefaultKey.varificationId.rawValue)
        }
    }
    
    init() {
        self.varificationID = (AppController.taxiUserDefault.object(forKey: TaxiDefaultKey.varificationId.rawValue)) as? String ?? ""
    }
    
//    Save User information
    
    var isUserSignedin : Bool {
        if let firstName = (AppController.taxiUserDefault.object(forKey: TaxiDefaultKey.firstName.rawValue) as? String),
           firstName.isEmpty == false,
           let secondname = (AppController.taxiUserDefault.object(forKey: TaxiDefaultKey.secondname.rawValue) as? String),
           secondname.isEmpty == false,
           let phoneNumber = (AppController.taxiUserDefault.object(forKey: TaxiDefaultKey.phoneNumber.rawValue) as? String),
           phoneNumber.isEmpty == false,
           //FIXME: Pending implementation for device Id
           let imageURL = (AppController.taxiUserDefault.object(forKey: TaxiDefaultKey.imageURL.rawValue) as? String),
           imageURL.isEmpty == false,
            let gender = (AppController.taxiUserDefault.object(forKey: TaxiDefaultKey.gender.rawValue) as? String),
           gender.isEmpty == false
        {
            
            return true
        }
        return false
    }
    
    func saveUserState(firstName: String,
                           secondname: String,
                           PhoneNumber: String,
                       imageURL: Data?, gender : String) {
            Self.taxiUserDefault.set(firstName, forKey: TaxiDefaultKey.firstName.rawValue)
            Self.taxiUserDefault.set(secondname, forKey: TaxiDefaultKey.secondname.rawValue)
            Self.taxiUserDefault.set(PhoneNumber, forKey: TaxiDefaultKey.phoneNumber.rawValue)
            Self.taxiUserDefault.set(imageURL, forKey: TaxiDefaultKey.imageURL.rawValue)
            Self.taxiUserDefault.set(gender, forKey: TaxiDefaultKey.gender.rawValue)
    }
    
//    clear user data
    
    func clearUserState() {
        Self.taxiUserDefault.removeObject(forKey: TaxiDefaultKey.firstName.rawValue)
        Self.taxiUserDefault.removeObject(forKey: TaxiDefaultKey.secondname.rawValue)
        Self.taxiUserDefault.removeObject(forKey: TaxiDefaultKey.phoneNumber.rawValue)
        Self.taxiUserDefault.removeObject(forKey: TaxiDefaultKey.imageURL.rawValue)
        Self.taxiUserDefault.removeObject(forKey: TaxiDefaultKey.gender.rawValue)
        Self.taxiUserDefault.removeObject(forKey: TaxiDefaultKey.varificationId.rawValue)
        Self.taxiUserDefault.synchronize()
    }
    
    func convertTimeString(_ timeString: String) -> String? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MMM dd, hh:mm a"

        if let inputDate = inputDateFormatter.date(from: timeString) {
            let outputDateString = outputDateFormatter.string(from: inputDate)
            return outputDateString
        }
        return nil
    }

}

// Mark : keys for enum

enum TaxiDefaultKey : String{
   case firstName = "firstName"
   case secondname = "secondname"
   case phoneNumber = "phoneNumber"
   case gender = "gender"
   case imageURL = "imageURL"
    case varificationId  = "varificationID"
}


