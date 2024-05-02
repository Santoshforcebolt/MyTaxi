//
//  AppContainer.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 22/06/23.
//

import SwiftUI

struct AppContainer: View {
    @ObservedObject var router = Router()
    @StateObject var locationViewModel = LocationSearchViewModel()
    var body: some View {
        let _  = print(AppController.shared.varificationID)
        NavigationStack(path: $router.navigationPath) {
            VStack{
                if !AppController.shared.varificationID.isEmpty {
                    HomeView()
                        .environmentObject(locationViewModel)
                }
                else {
                    SignUpView()
                    
                }
            }
                       .navigationDestination(for: Route.self) { route in
                           switch route {
                           case .appStartView:
                               SignUpView()
                           case .homeView:
                               HomeView().navigationBarBackButtonHidden(true).environmentObject(LocationSearchViewModel())
                           case .enterMobileView:
                               EnterMobileNumber().navigationBarBackButtonHidden(true)
                           case .VerifyCodeView( let phNumber):
                               EnterCodeView(vm: EnterCodeViewModel(mobileNumber: phNumber))
                           case .signUpDetails(let phNumber, let profile):
                               SignUpDetailsView(viewModel: signUpDetailsViewModel(phoneNumber: phNumber, profile: profile)).navigationBarBackButtonHidden(true)
                           }
                       }
               }.environmentObject(router)
    }
}

struct AppContainer_Previews: PreviewProvider {
    static var previews: some View {
        AppContainer()
    }
}
