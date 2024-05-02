//
//  CounteryCode.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 20/06/23.
//

import Foundation


func flag(from country:String) -> String {
    let base : UInt32 = 127397
    var s = ""
    for v in country.uppercased().unicodeScalars {
        s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }
    return s
}
//For Country  resgion code
struct Country: Codable, Identifiable {
    let id = UUID()
    let name: String
    let dial_code: String
    let code: String
}

// Function to put United States at the top of the list
