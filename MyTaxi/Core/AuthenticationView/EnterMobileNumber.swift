//
//  EnterMobileNumber.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 20/06/23.
//

import SwiftUI
import FirebaseAuth
struct EnterMobileNumber: View {
    @StateObject var ViewModel =  AuthViewModel()
    @FocusState private var isKeyBoardShowing : Bool
    @EnvironmentObject private var router: Router
    @StateObject var firebaseManager = FirebaseManager()
    var body: some View {
            GeometryReader { geo  in
                VStack{
                    HStack{
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .bold()
                            .onTapGesture {
                                if ViewModel.isEnterCode{
                                    withAnimation {
                                        ViewModel.isEnterCode.toggle()
                                    }
                                }
                                
                            }
                        Spacer()
                        Text(!ViewModel.isEnterCode ? "Mobile Number" : "Verify Number" )
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        Spacer()
                    }.padding()
                    Divider()
                    if !ViewModel.isEnterCode{
                        VStack{
                            Text("Please enter your valid phone number. We will send you a 6-digit code to verify your account. ")
                                .bold()
                                .font(.system(size: 18))
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top)
                                .padding(.horizontal)
                            
                            HStack {
                                HStack {
                                    CountryCodeAndFlag(selectedCountry: $ViewModel.selectedCountry)
                                    Rectangle()
                                        .stroke(Color(red: 232/255, green: 230/255, blue: 234/255),lineWidth: 1)
                                        .frame(width: 1, height: 18)
                                }
                                
                                TextField("Enter phone Number", text: $ViewModel.enterphoneNumber)
                                    .keyboardType(.numberPad)
                                    .padding(.trailing)
                                    .focused($isKeyBoardShowing)
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer()
                                            
                                            Button("Done") {
                                                isKeyBoardShowing = false
                                            }
                                        }
                                    }
                                
                            }
                            .padding(.vertical,10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15).stroke(Color(red: 232/255, green: 230/255, blue: 234/255)))
                            .padding(.top)
                            .padding(.horizontal)
                            
                            Button {
                                if ViewModel.enterphoneNumber.count != 10{
                                    ViewModel.isEnterCode = false
                                }
                                else {
                                    ViewModel.isEnterCode = true
                                    let counteryCode = ViewModel.selectedCountry + ViewModel.enterphoneNumber
                                    firebaseManager.getOtp(counteryCode)
                                   
                                }
                                
                            } label: {
                                Text("Continue")
                                    .padding()
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.8))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                
                            }
                            .padding(.top)
                        }
                        
                    }
                    else {
                        EnterCodeView(vm :  EnterCodeViewModel(mobileNumber: "\(ViewModel.selectedCountry + ViewModel.enterphoneNumber)"))
                            .animation(.easeIn, value: ViewModel.isEnterCode)
                    }
                    
                }
                .frame(width : geo.size.width)
            }
           
            
            
           
            
        
        .onAppear {
            if let defaultCountry = ViewModel.countryViewModel.countries.first(where: { $0.code == "IN" }) {
                self.ViewModel.selectedCountry = defaultCountry.dial_code
            }
        }
    }
        
        
    func CountryCodeAndFlag(selectedCountry: Binding<String>) -> some View {
        Picker("", selection: selectedCountry) {
            ForEach(ViewModel.countryViewModel.countries, id: \.id) { country in
                HStack {
                    Text("\(flag(from: country.code)) \(country.dial_code)")
                        .font(.system(size: 24))
                }
                .tag(country.dial_code)
            }
        }
        
    }
    
}

struct EnterMobileNumber_Previews: PreviewProvider {
    static var previews: some View {
        EnterMobileNumber()
    }
}



class CountryViewModel: ObservableObject {
    @Published var countries: [Country] = []

    init() {
        loadCountries()
    }

    private func loadCountries() {
        // Load and parse the JSON data
        guard let fileURL = Bundle.main.url(forResource: "Countrries", withExtension: "json") else { return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            self.countries =    try decoder.decode([Country].self, from: data)
        } catch {
            print("Error loading countries data: \(error)")
           
        }
    }
}
