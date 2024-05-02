//
//  MapViewActionButton.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 13/06/23.
//

import SwiftUI

struct MapViewActionButton: View {
    let imageTitle : String
    var foreGroundColor : Color = .black
    var action: () ->Void = {}
    var body: some View {
        
        Button (action: action){
            Image(systemName: imageTitle)
                .font(.title2)
                .foregroundColor(foreGroundColor)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color : .black,radius: 6)
        }
        .frame(maxWidth: .infinity,alignment: .leading)
    
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(imageTitle: "")
    }
}
