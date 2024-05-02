//
//  ConnectingDriverView.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 07/07/23.
//

import Foundation
import SwiftUI

struct ConnectingDriverView: View {
    @Binding var isStart : Bool
    @Binding var driverGet : Bool
    var arrivingTime : String
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 10){
                Text("Connecting you to a Driver")
                    .bold()
                Text("Arriving at \(arrivingTime)1: 30")
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity,alignment: .leading)
            Divider()
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: isStart ? 1 : 0.2)
                    .stroke(
                        AngularGradient(gradient: Gradient(colors: [.black, .black, .black]), center: .center),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round,lineJoin: .round,dash: [isStart ? 3 : 0])
                    )
                    .frame(width: 100, height: 100)
            }
            .rotationEffect(.degrees(-90))
            .rotationEffect(.degrees(isStart ? 360 : 0))
            //        .animation(.easeIn(duration: 6.0), value: isStart)
            .padding(.top,20)
            
        }
        .onAppear {
            withAnimation(Animation.default.speed(0.35).repeatForever(autoreverses: false)) {
                isStart = true
                LocalNotifications.shared.sendLocalNotification(title: "Searching rider for you", body: "\(AppController.userDetaisl?.firstName ?? "") wait we are searching best ride for you")
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    isStart = false
                    driverGet = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        LocalNotifications.shared.sendLocalNotification(title: "Driver found Seccufully", body: "driver on the way to pick up you")
                    }
            }
            }
            
            
        }
        
    }
}
