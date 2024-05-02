//
//  LocationSearchActivationView.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 13/06/23.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        HStack{
            Rectangle()
                .fill(Color.black)
                .frame(width: 8,height: 8)
                .padding(.horizontal)
            Text("Where to?")
                .foregroundColor(Color(.darkGray))
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 64,height: 50)
        
        .background(
        Rectangle()
            .fill(Color.white).cornerRadius(10)
            .shadow(color: .black,radius: 6)
            
        )
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}
