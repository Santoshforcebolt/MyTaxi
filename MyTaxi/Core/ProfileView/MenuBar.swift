//
//  MenuBar.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 19/06/23.
//

import SwiftUI
struct MenuBar: View {
    @Binding var isProfile: Bool
    @State private var shouldNavigate: Bool = false
    @State private var selectedMenuItem: MenuViewModel?
    @State private var isDataLoaded = false
    var body: some View {
        ZStack {
            if (AppController.userDetaisl != nil) || isDataLoaded{
                VStack(alignment: .leading) {
                    HStack {
                        MapViewActionButton(imageTitle: "multiply") {
                            withAnimation {
                                isProfile.toggle()
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                        profileSection()
                            .padding([.horizontal, .top])
//                            .transition(.move(edge: .leading))
                        
                    
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(MenuViewModel.menuItems) { item in
                            NavigationLink(destination: getDetailView(for: item), isActive: getBinding(for: item)) {
                                EmptyView()
                            }
                            .hidden()
                            .onAppear {
                                if shouldNavigate {
                                    isProfile = false
                                }
                            }
                            Button(action: {
                                selectedMenuItem = item
                                shouldNavigate = true
                            }) {
                                Text(item.title)
                                    .padding(.vertical)
                                    .padding(.leading)
                                    .bold()
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white.opacity(1))
                                    .cornerRadius(10)
                                    .shadow(radius: 1)
                            }
                            .buttonStyle(PlainButtonStyle())
//                            .transition(.move(edge: .leading))
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                
                .frame(maxHeight: .infinity)
                .navigationBarHidden(true)
            }
            
            else  {
                ProgressView()
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
            }
        }
     .onAppear {
        DispatchQueue.main.async {
            isDataLoaded = true
            FirebaseManager.shared.fetchUserData { data in
                isDataLoaded = false
                let userData = data.first(where:{$0.mobileNumber == AppController.taxiUserDefault.object(forKey: TaxiDefaultKey.phoneNumber.rawValue) as? String ?? ""})
               
                withAnimation(.spring()){
                   
                    AppController.userDetaisl = userData
                }
            }

        }
    }
        
    }
    
    func getDetailView(for menuItem: MenuViewModel) -> some View {
        switch menuItem.id {
        case 0:
            return AnyView(SignUpDetailsView(viewModel: signUpDetailsViewModel(phoneNumber: AppController.userDetaisl?.mobileNumber ?? "", profile: .homeProfile)).navigationBarTitleDisplayMode(.inline))
        case 1:
            return AnyView(RideHistoryView().navigationTitle("Ride History").navigationBarTitleDisplayMode(.inline))
        case 2:
            return AnyView(DetailView(menuItem: menuItem))
        case 3:
            return AnyView(DetailView(menuItem: menuItem))
        default:
            return AnyView(EmptyView())
        }
    }
    
    func getBinding(for menuItem: MenuViewModel) -> Binding<Bool> {
        .init {
            shouldNavigate && selectedMenuItem == menuItem
        } set: { newValue in
            if !newValue {
                selectedMenuItem = nil
            }
        }
    }
}

struct MenuBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct profileSection: View {
    var body: some View {
        VStack(alignment: .center){
            if let data = AppController.userDetaisl{
                Image(uiImage: data.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150,height: 150)
                    .clipShape(Circle())
                
                
                
                Text("\(data.firstName + data.lastName)")
                    .bold()
                    .font(.title2)
            }
        }
        
    }
    
}


struct DetailView: View {
    let menuItem: MenuViewModel
    
    var body: some View {
        VStack {
            Text(menuItem.title)
                .font(.largeTitle)
            Text(menuItem.description)
                .font(.title)
                .foregroundColor(.gray)
        }
        .navigationBarTitle(menuItem.title)
    }
}

struct DetailView2: View {
    let menuItem: MenuViewModel
    @EnvironmentObject private var router: Router
    var body: some View {
        VStack {
            Text("Detail Girish")
                .font(.largeTitle)
            Text(menuItem.title)
                .font(.title)
                .foregroundColor(.gray)
        }
        
        .onTapGesture {
            withAnimation(.spring()) {
                self.router.popToRootView()
                AppController.shared.clearUserState()
            }
            
        }
        .navigationBarTitle(menuItem.title)
    }
}
