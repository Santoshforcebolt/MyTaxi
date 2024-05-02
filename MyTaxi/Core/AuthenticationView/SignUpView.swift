//
//  SignUpView.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 20/06/23.
//

import SwiftUI

struct SignUpView: View {
   
    @EnvironmentObject private var router: Router
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            VStack{
                ZStack(alignment: .top){
                    Image("3644592")
                        .resizable()
                        .frame(maxWidth: .infinity,maxHeight : .infinity)
                        .frame(width: width,height: height*0.6)
                    
                    Text("Welcome To CA Ride")
                        .bold()
                        .font(.system(size: 25))
                }
                
                Text("Thank you for choosing TaxiApp, your reliable transportation solution.")
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading){
                    Text("Explor new ways to  travel with CA-Ride")
                        .fontWeight(.bold)
                        .font(.system(size: 25))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                        
                }
                .frame(maxWidth: .infinity,alignment : .leading)
                .padding(.horizontal)
                .padding(.top,1)
                VStack(spacing: 20){
                    Button {
                        router.pushView(route: .enterMobileView)
                    } label: {
                        Text("Continue with Phone Number")
                            .padding()
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(10)
                            
                    }
                    
                    Text("By continuing, you agree that you have read and accept our T&C and Privacy policy")
                        .fixedSize(horizontal: false, vertical: true)
                        .fontWeight(.medium)
                        .opacity(0.5)
                        .multilineTextAlignment(.leading)
                }.padding(.horizontal)
                Spacer()
            }
            .frame(width: width)
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}


