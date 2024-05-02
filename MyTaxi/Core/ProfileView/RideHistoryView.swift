//
//  RideHistoryView.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 07/07/23.
//

import SwiftUI

struct RideHistoryView: View {
    
    var body: some View {
        
        VStack{
            Divider()
            ScrollView{
                VStack(alignment: .leading,spacing: 10){
                    
                    if let userRide = AppController.userDetaisl?.ride{
                        ForEach(userRide,id: \.self){ride in
                            HStack(alignment: .top){
                                VStack(alignment: .leading){
                                    Image("UberXIcon")
                                        .resizable()
                                        .frame(width: 40,height: 40)
                                        .alignmentGuide(.top) { _ in
                                            0 // Align to the top
                                        }
                                    
                                    
                                }
                                .frame(height: 100,alignment: .top)
                                
                                VStack(alignment: .leading){
                                    HStack{
                                        Text(AppController.shared.convertTimeString(ride.time) ?? "")
                                    }
                                    HStack{
                                        Text("prime Sedan, ")
                                        Text(ride.riderName)
                                        
                                    }
                                    VStack(alignment: .leading,spacing: 0){
                                        HStack{
                                            Circle()
                                                .foregroundColor(.orange)
                                                .frame(width: 10,height: 10)
                                            Text("Customer Adress")
                                        }
                                        
                                        
                                        Rectangle()
                                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                            .foregroundColor(.black.opacity(0.5))
                                            .frame(width: 2,height: 30)
                                            .padding(.leading,3)
                                        
                                        HStack{
                                            Circle()
                                                .foregroundColor(.black)
                                                .frame(width: 10,height: 10)
                                            Text("Destinations Adress")
                                        }
                                    }
                                }
                                Spacer()
                                
                                VStack{
                                    ZStack(alignment: .top){
                                        VStack{
                                            Text("\(AppController.shared.twoDecimalAfter(ride.price))")
                                            
                                            Image("Girish")
                                                .resizable()
                                                .frame(width: 70,height: 70)
                                                .clipShape(Circle())
                                            
                                                .padding(.vertical,20)
                                        }
                                        
                                        Image("Cancell")
                                            .resizable()
                                            .frame(width: 50,height: 50)
                                            .padding(.top,8)
                                        
                                        
                                    }
                                    
                                    
                                }
                                .padding(.horizontal)
                            }
                            
                            
                        }
                    }
                    
                }
                .padding(.top)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.8))
                        .shadow(color: .black.opacity(0.3), radius: 4)
                )

                .frame(width:UIScreen.main.bounds.width-20,alignment: .center)
                
            }
            
        }
    }
}

struct RideHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RideHistoryView()
    }
}
