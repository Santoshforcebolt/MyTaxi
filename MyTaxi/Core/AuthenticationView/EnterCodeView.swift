//
//  EnterCodeView.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 21/06/23.
//

import SwiftUI

struct EnterCodeView: View {
    @ObservedObject var vm : EnterCodeViewModel
    @FocusState  var isKeyBoardShowing : Bool
    @EnvironmentObject private var router: Router
    var body: some View {
            VStack{
                VStack {
                    Text("Enter your 6- digit code to verifiy your Number \(vm.mobileNumber)")
                        .bold()
                        .font(.system(size: 20))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    
                    HStack{
                        ForEach(0..<6, id: \.self){index in
                            OtpTextBox(index)
                        }
                    }
                    .background {
                        TextField("", text: $vm.otpTextField.limit(6))
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode)
                            .frame(width: 1,height: 1)
                            .opacity(0.001)
                            .blendMode(.screen)
                            .focused($isKeyBoardShowing)
                           
                    }
                    
                }.contentShape(Rectangle())
                    .onTapGesture {
                        isKeyBoardShowing.toggle()
                    }
                    .padding(.bottom,20)
                    .padding(.top,10)
                
                
                Button {
                    if vm.otpTextField.count == 6{
//                        FirebaseManager.shared.verifyOtp(self.vm.otpTextField, phoneNumber: self.vm.mobileNumber) { val in
//                            if val{
                                vm.isNumberExist { res in
                                    if res{
                                       
                                        AppController.shared.varificationID = AppController.verficationID
                                        print("MyTaxiHelper.verficationID",AppController.verficationID)
                                        AppController.taxiUserDefault.set(self.vm.mobileNumber, forKey: TaxiDefaultKey.phoneNumber.rawValue)
                                        self.router.pushView(route: .homeView)
                                    }
                                    else {
                                        self.router.pushView(route: .signUpDetails(phNumber: self.vm.mobileNumber))
                                    }
                                }
//                            }
                        }
                        
                        
//                    }
                    
                } label: {
                    Text("Verify Code")
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
                
                Spacer()
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button("Done") {
                        isKeyBoardShowing.toggle()
                    }
                }
            }
    }
    
    @ViewBuilder
    func OtpTextBox(_ index : Int)->some View {
        ZStack {
            if vm.otpTextField.count>index {
                let startIndex = vm.otpTextField.startIndex
                let charIndex = vm.otpTextField.index(startIndex, offsetBy: index)
                let chartToString = String(vm.otpTextField[charIndex])
                Text(chartToString)
            }
            else {
                Text("")
            }
        }
        .frame(width: 45,height: 45)
        .background{
            let status = (isKeyBoardShowing && vm.otpTextField.count == index)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(status ? .black : .gray, lineWidth: status ? 1 : 0.5)
        }
        
    }
}

struct EnterCodeView_Previews: PreviewProvider {
    static var previews: some View {
        EnterCodeView(vm: EnterCodeViewModel(mobileNumber: ""))
    }
}

// Extention for as we need only four char in the text fields

extension Binding where Value == String {
    func limit(_ length : Int)->Self {
        if self.wrappedValue.count>length{
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}


class EnterCodeViewModel : ObservableObject {
    var mobileNumber : String
    @Published var otpTextField : String = ""
    @Published var isHome : Bool = false
    @Published var isSignUpDetails = false
//    var varificationId : String
    
    init(mobileNumber: String) {
        self.mobileNumber = mobileNumber
       
    }
    
    func isNumberExist(completion: @escaping (Bool) -> Void) {
        FirebaseManager.shared.fetchUserData { result in
            let data = result.map({ $0.mobileNumber })
            print(data)
            let numberExists = data.contains(self.mobileNumber)
            print(numberExists)
            completion(numberExists)
        }
    }

    
}
