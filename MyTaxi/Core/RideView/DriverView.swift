//
//  DriverView.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 07/07/23.
//

import SwiftUI

struct DriverView: View {
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text("Meet your Driver at ") // add location
                        .fontWeight(.semibold)
                }
                Spacer()
                Text("10 \nmin") // time when driver coming
                .foregroundColor(.white)
                .padding(.all)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
            Divider()
                .padding(.top,5)
            VStack{
                HStack{
                    Image("Girish")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    VStack{
                        Text("Girish")
                            .bold()
                        HStack(spacing : 0){
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.yellow)
                            Text("4.8")
                                
                        }
                    }
                    
                    Spacer()
                    
                    VStack{
                        Image("UberXIcon")
                            .resizable()
                            .frame(width: 70,height: 70)
                            
                        HStack{
                            Text("Wagnor -") // vichlemodel
                                .opacity(0.8)
                                .fontWeight(.semibold)
                            Text("RJ45SJ5655") // vichle number
                                .bold()
                        }
                    }
                    
                }
                Text("Code - \(AppController.shared.generatePIN())")
                    .bold()
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical,5)
            Button {
                
            } label: {
                Text("Cancel Ride Ride")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width*0.9, height: 50, alignment: .center)
                    .background(.blue)
                    .cornerRadius(6)
                
            }
        }
    }
}

struct DriverView_Previews: PreviewProvider {
    static var previews: some View {
        DriverView()
    }
}
