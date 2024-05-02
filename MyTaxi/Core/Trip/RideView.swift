//
//  RideView.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 15/06/23.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
struct RideView: View {
    let geo = UIScreen.main.bounds
    @State var rideId : String = RideModel.getData()[0].title ?? ""
    @EnvironmentObject var viewModel : LocationSearchViewModel
    var destinationName : String = "hey"
    @State private var isStart = false
    @State private var isQRCodeVisible = false
    @State private var isDriverGet = false
    
    var body: some View {
        if !isQRCodeVisible{
            VStack {
                HStack{
                    VStack{
                        Circle()
                            .fill(Color(.systemGray3))
                            .frame(width: 8,height: 8)
                        
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 1,height: 24)
                        Circle()
                            .background(Color(.systemGray4))
                            .frame(width: 8,height: 8)
                    }
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("Current Location")
                                .font(.system(size: 16,weight: .semibold))
                            Spacer()
                            Text("\(getTime())")
                                .foregroundColor(.gray)
                                .font(.system(size: 14,weight: .bold))
                        }
                        .padding(.bottom)
                        HStack{
                            Text("\(destinationName)")
                                .font(.system(size: 16,weight: .bold))
                            
                            Spacer()
                            Text("\(viewModel.destinationTime)")
                                .foregroundColor(.gray)
                                .font(.system(size: 14,weight: .bold))
                        }
                        
                    }
                    .padding(.leading)
                    
                }
                .padding(.horizontal)
                
                Divider()
                    .background(.black)
                    .padding(.horizontal,15)
                VStack{
                    VStack{
                        
                        Text("Suggest Riders")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity,alignment: .leading)
                        
                        ScrollView (.horizontal,showsIndicators: false){
                            
                            HStack{
                                ForEach(RideModel.getData(), id: \.self){ index in
                                    
                                    VStack(alignment: .leading){
                                        Image(index.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                        VStack(alignment: .leading, spacing: 4){
                                            Text(index.title ?? "")
                                                .font(.system(size: 14,weight: .semibold))
                                            Text("$\(AppController.shared.twoDecimalAfter(RideModel.computedPrice(for: viewModel.computeRiderPrice(), for: index.priceX, baseFare: index.price)))")
                                                .font(.system(size: 14,weight: .semibold))
                                        }
                                        
                                        .padding()
                                    }
                                    .frame(width: geo.size.width*0.3,height: geo.size.width*0.37)
                                    .scaleEffect(rideId == index.title ? 1.2 : 1.0)
                                    .foregroundColor(rideId == index.title ? .white : .black)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .fill(Color(rideId == index.title ? .systemBlue : .systemGroupedBackground))
                                    )
                                    
                                    .onTapGesture {
                                        withAnimation(.spring()){
                                            rideId = index.title ?? ""
                                            switch rideId {
                                            case  "UberX" : viewModel.rideType = .car
                                            case  "Uber Black" :
                                                viewModel.rideType = .car
                                            case  "D-Bike" :
                                                viewModel.rideType = .bike
                                                
                                            default: break
                                                
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            .frame(width: geo.size.width,alignment : .center)
                        }
                    }
                    
                    HStack{
                        Text("Visa")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(6)
                            .background(.blue)
                            .cornerRadius(6)
                            .padding(.leading)
                            .foregroundColor(.white)
                        
                        Text("**** 1234")
                        
                            .fontWeight(.bold)
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .imageScale(.medium)
                            .padding()
                    }
                    .frame(height: 50)
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(6)
                    .padding(.horizontal,11)
                    
                    Divider()
                        .padding(.vertical,4)
                    Button {
                        isQRCodeVisible.toggle()
                        withAnimation {
                            viewModel.isRideSheet.toggle()
                        }
                        
                                            FirebaseManager.shared.addRideToUser(userID: AppController.userDetaisl?.id ?? "", ride: Ride(time: getTime(formatD: "yyyy-MM-dd'T'HH:mm:ssZ"), price: 20.0, riderName: "Abhishek", latitude: "3245999", longitude: "0.1223456"))
                    } label: {
                        Text("Confirm Ride")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: geo.size.width*0.95, height: 50, alignment: .center)
                            .background(.blue)
                            .cornerRadius(6)
                        
                    }
                    
                }
            }
            .background(.white)
           
        }
        else {
            if !isDriverGet {
                ConnectingDriverView(isStart: $isStart, driverGet: $isDriverGet, arrivingTime: viewModel.destinationTime)
            }
            else {
                DriverView()
            }
        }
        
      
        
    }
    
}
struct RideView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(LocationSearchViewModel())
//        RideView(destinationName: "").environmentObject(LocationSearchViewModel())
//        HomeView().environmentObject(LocationSearchViewModel())
//                LocationSearchView(mapState: .constant(.searchingForLocation)).environmentObject(LocationSearchViewModel())
    }
}




