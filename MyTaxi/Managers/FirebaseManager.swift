//
//  FirebaseManager.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 23/06/23.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseFirestore
import FirebaseStorage

struct User {
    var id : String = ""
    var image: UIImage
    var mobileNumber: String
    var firstName: String
    var lastName: String
    var gender: String
    var dateOfBirth : String
    var ride : [Ride]?
}

struct Ride : Hashable{
    let time: String
    let price: Double
    let riderName: String
    let latitude : String
    let longitude : String
    
}




class FirebaseManager : ObservableObject{
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    func getOtp(_ country : String){
        PhoneAuthProvider.provider().verifyPhoneNumber(country, uiDelegate: nil){ verificationID,error in
            if let error = error {
                print("Error sending OTP:", error.localizedDescription)
                return
            }
            
            if let verificationID = verificationID {
                AppController.verficationID = verificationID
                print(AppController.verficationID)
            }
        }
    }
    
    func verifyOtp(_ Otp : String,phoneNumber : String,completion: @escaping (Bool) -> Void) {
        let credentail = PhoneAuthProvider.provider().credential(withVerificationID: AppController.verficationID, verificationCode: Otp)
        
        Auth.auth().signIn(with: credentail){(authresult, error) in
            if let error = error{
                print("Error signing in with OTP:", error.localizedDescription)
                completion(false)
                return
            }
            let currentUserInstance = Auth.auth().currentUser
            
            completion(true)
            
        }
    }
    
    
//
    func storeUserData(user: User) {
        // Convert the UIImage to Data
        guard let imageData = user.image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to Data")
            return
        }
        
        // Create a unique document ID for the user
        let userDocRef = db.collection("users").document()
        
        // Create a storage reference for the image
        let storageRef = Storage.storage().reference().child("images/\(userDocRef.documentID).jpg")
        
        // Upload the image to Firebase Storage
        let uploadTask = storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image:", error.localizedDescription)
                return
            }
            
            // Once the image is uploaded, store the other user data in Firestore
            let userData: [String: Any] = [
                "id" : userDocRef.documentID,
                "mobileNumber": user.mobileNumber,
                "firstName": user.firstName,
                "lastName": user.lastName,
                "gender": user.gender,
                "imageURL": storageRef.fullPath,
                "dateOfBirth" : user.dateOfBirth,
                "rides" : []
                // Store the image URL for retrieval
            ]
            
            userDocRef.setData(userData) { error in
                if let error = error {
                    print("Error storing user data:", error.localizedDescription)
                } else {
                    print("User data stored successfully")
                }
            }
        }
        
        // Optionally, you can monitor the upload progress using uploadTask.progress
    }
//    Fetch userData
    
    func fetchUserData(completion: @escaping ([User]) -> Void) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user data:", error.localizedDescription)
                completion([])
                return
            }
            
            var users: [User] = []
            
            if let documents = snapshot?.documents {
                for document in documents {
                    guard let mobileNumber = document.data()["mobileNumber"] as? String,
                          let firstName = document.data()["firstName"] as? String,
                          let lastName = document.data()["lastName"] as? String,
                          let gender = document.data()["gender"] as? String,
                          let imageURL = document.data()["imageURL"] as? String,
                          let id = document.data()["id"] as? String,
                          let dateOfBirth = document.data()["dateOfBirth"] as? String,
                          let ridesData = document.data()["rides"] as? [[String: Any]] else {
                        continue
                    }
                    
                    // Retrieve the image from Firebase Storage using the imageURL
                    let storageRef = Storage.storage().reference().child(imageURL)
                    storageRef.getData(maxSize: 5 * 1024 * 1024) { imageData, error in
                        if let error = error {
                            print("Error fetching image data:", error.localizedDescription)
                            return
                        }
                        
                        if let imageData = imageData,
                           let image = UIImage(data: imageData) {
                            
                            var rides: [Ride]? = nil
                            if !ridesData.isEmpty {
                                rides = []
                                for rideData in ridesData {
                                    if let time = rideData["time"] as? String,
                                       let price = rideData["price"] as? Double,
                                       let riderName = rideData["riderName"] as? String,
                                       let latitude = rideData["latitude"] as? String,
                                       let longitude = rideData["longitude"] as? String {
                                        let ride = Ride(time: time, price: price, riderName: riderName, latitude: latitude, longitude: longitude)
                                        rides?.append(ride)
                                    }
                                }
                            }
                            
                            let user = User(id: id, image: image, mobileNumber: mobileNumber, firstName: firstName, lastName: lastName, gender: gender, dateOfBirth: dateOfBirth, ride: rides)
                            users.append(user)
                        }
                        
                        // Check if all users have been retrieved and call the completion handler
                        if users.count == documents.count {
                            completion(users)
                        }
                    }
                }
            } else {
                completion([])
            }
        }
    }

//    Update
    
    func updateUserDetails(user: User, firstName: String, lastName: String, gender: String, dateOfBirth: String, profileImage: UIImage?) {
        let userID = user.id

        var updatedData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "gender": gender,
            "dateOfBirth": dateOfBirth
        ]

        // Check if profile image is updated
        if let profileImage = profileImage {
            // Upload the new profile image to Firebase Storage
            let imageFileName = "\(userID).jpg"
            let storageRef = Storage.storage().reference().child("images/\(imageFileName)")
            if let imageData = profileImage.jpegData(compressionQuality: 0.8) {
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        print("Error uploading profile image:", error.localizedDescription)
                        return
                    }
                    
                    // Get the download URL of the uploaded image
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print("Error getting download URL:", error.localizedDescription)
                            return
                        }
                        
//                        if let downloadURL = url?.absoluteString {
                            // Update the download URL in the updated data
                        updatedData["imageURL"] = storageRef.fullPath

                            // Update the user details in Firebase Firestore
                            let userRef = self.db.collection("users").document(userID)
                            userRef.updateData(updatedData) { error in
                                if let error = error {
                                    print("Error updating user details:", error.localizedDescription)
                                    return
                                }

                                // Update AppController.userDetails with the updated user details
                                AppController.userDetaisl?.firstName = firstName
                                AppController.userDetaisl?.lastName = lastName
                                AppController.userDetaisl?.gender = gender
                                AppController.userDetaisl?.dateOfBirth = dateOfBirth
                                AppController.userDetaisl?.image = profileImage

                                print("User details updated successfully")
                            }
//                        }
                    }
                }
            }
        } else {
            // Update the user details in Firebase Firestore
            let userRef = db.collection("users").document(userID)
            userRef.updateData(updatedData) { error in
                if let error = error {
                    print("Error updating user details:", error.localizedDescription)
                    return
                }

                // Update AppController.userDetails with the updated user details
                AppController.userDetaisl?.firstName = firstName
                AppController.userDetaisl?.lastName = lastName
                AppController.userDetaisl?.gender = gender
                AppController.userDetaisl?.dateOfBirth = dateOfBirth

                print("User details updated successfully")
            }
        }
    }
    
//    Added ride In existing
    
    // Updated addRideToUser function
    func addRideToUser(userID: String, ride: Ride) {
        let rideData: [String: Any] = [
            "time": ride.time,
            "price": ride.price,
            "riderName": ride.riderName,
            "latitude": ride.latitude,
            "longitude": ride.longitude
        ]
        
        let userRef = db.collection("users").document(userID)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if var existingRides = document.data()?["rides"] as? [[String: Any]] {
                    existingRides.append(rideData)
                    userRef.updateData(["rides": existingRides]) { error in
                        if let error = error {
                            print("Error adding ride to user:", error.localizedDescription)
                        } else {
                            print("Ride added to user successfully")
                        }
                    }
                } else {
                    userRef.updateData(["rides": [rideData]]) { error in
                        if let error = error {
                            print("Error adding ride to user:", error.localizedDescription)
                        } else {
                            print("Ride added to user successfully")
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }

}
