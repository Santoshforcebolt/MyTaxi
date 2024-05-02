//
//  HomeView.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 13/06/23.
//

import SwiftUI

struct HomeView: View {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    @State private var showLocationOnSearchView = false
    @State var mapState : MapViewState = .noInput
    @EnvironmentObject var locationVM : LocationSearchViewModel
    @State private var isDataLoaded = false
    @State var isProfileView : Bool = false
   
    var body: some View {
        
        ZStack(alignment: .center) {
            ZStack(alignment: .leading) {
                ZStack(alignment: .bottomTrailing) {
                    ZStack(alignment: .top) {
                        UberMapViewReprentable(mapState: $mapState)
                            .ignoresSafeArea()
                        if mapState == .searchingForLocation {
                            LocationSearchView(mapState: $mapState)
                        }
                        else if mapState == .noInput
                        {
                            LocationSearchActivationView()
                                .padding(.top,height*0.08)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        mapState = .searchingForLocation
                                    }
                                }
                                .disabled(isProfileView)
                        }
                        if mapState == .noInput{
                            MapViewActionButton(imageTitle: "line.3.horizontal",action: {
                                withAnimation(.spring()){
                                    isProfileView .toggle()
                                }
                            })
                            .padding(.leading)
                            .padding(.top,4)
                        }
                        else if mapState == .locationSelected{
                            MapViewActionButton(imageTitle: "arrow.left",action: {
                                withAnimation{
                                    mapState = .noInput
                                }
                            })
                            .padding(.leading)
                        }
                    }
                    .sheet(isPresented: Binding<Bool>(
                        get: {
                            mapState == .locationSelected
                        },
                        set: { newValue in
                            if !newValue {
                                mapState = .noInput
                                locationVM.selectedLocationCoordinate = nil
                                // Perform any necessary actions when the sheet is dismissed
                            }
                        }
                    )) {
                        RideView(destinationName : locationVM.destinationName)
                            .presentationDetents([.large,.height(locationVM.isRideSheet ? 350 : 500)])
                            .presentationCornerRadius(20)
                            .presentationBackgroundInteraction(.enabled(upThrough: .large))
                    }
                    
                    if mapState == .noInput{
                        VStack{
                            Image(systemName: "location.fill")
                                .aspectRatio(contentMode: .fit)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                        }
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding()
                        .position(x: width - 50, y:  height*0.8)
                        .onTapGesture {
                            locationVM.fetchCurrentLocation()
                        }
                    }
                }
                .onReceive(LocationManager.shared.$userLocation) { location in
                    if let location = location{
                        print("DEBUG : UserLOCation in homeview is\(location)")
                        self.locationVM.userLocation = location
                    }
        
                }
                .onTapGesture {
                    withAnimation {
                        isProfileView = false
                    }
                }
                
                
                if isProfileView{
                   // Display the menu bar only when the data is loaded
                                   MenuBar(isProfile: $isProfileView)
                                       .frame(width: UIScreen.main.bounds.width * 0.7)
                                       .background(.white)
                                       .transition(.slide)
                                // Display a loading indicator while the data is being fetched
                    
                }
               
            }.disabled(!isDataLoaded)
            
            if !isDataLoaded{
                IndicatorView()
                   
            }
            
            
        }
        .onAppear {
           DispatchQueue.main.async {
               FirebaseManager.shared.fetchUserData { data in
                   let userData = data.first(where:{$0.mobileNumber == AppController.taxiUserDefault.object(forKey: TaxiDefaultKey.phoneNumber.rawValue) as? String ?? ""})
                  
                   withAnimation(.spring()){
                       self.isDataLoaded = true
                       AppController.userDetaisl = userData
                      
                   }
               }
               
           }
    }
        
    }
}

struct HomeView_Previews: PreviewProvider  {
    static var previews: some View {
        HomeView().environmentObject(LocationSearchViewModel())
    }
}

