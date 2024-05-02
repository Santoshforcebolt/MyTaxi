//
//  SignUpOrHome.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 21/06/23.
//

import SwiftUI

struct SignUpDetailsView: View {
    @StateObject var viewModel : signUpDetailsViewModel
    @EnvironmentObject private var router: Router
    @State var isSheetShowing : Bool = false
    @State var isGenderView : Bool = false
    
    var body: some View {
        GeometryReader { geo in

//            ZStack{
            VStack{
                
                ProfileHeaderView(imagePass: $viewModel.myImage, profile: $viewModel.profile, isEdit: $viewModel.isEdit)
                
                VStack(spacing: 20){
                    TextField("First Name*", text: $viewModel.firstName)
                        .TextFieldStyle(placeholder: "First name")
                        .disabled(viewModel.profile == .homeProfile && !viewModel.isEdit)
                    
                    TextField("Last Name*", text: $viewModel.lastName)
                        .TextFieldStyle(placeholder: "Last Name")
                        .disabled(viewModel.profile == .homeProfile && !viewModel.isEdit)
                    
                    TextField("Phone N0.", text: $viewModel.phoneNumber)
                        .TextFieldStyle(placeholder: "Phone Number")
                        .disabled(true)
                    
                }
                .padding(.top, geo.size.width*0.05)
                
                Button(action: {
                    isSheetShowing.toggle()
                }, label: {
                    HStack{
                        Image(systemName: "calendar")
                            .foregroundColor(Color(red : 233/255, green: 64/255, blue: 87/255))
                        if viewModel.deocodeDater.isEmpty {
                            Text("choose Bathday Date")
                                .foregroundColor(Color(red : 233/255, green: 64/255, blue: 87/255))
                        }
                        else {
                            Text(viewModel.deocodeDater)
                                .foregroundColor(Color(red : 233/255, green: 64/255, blue: 87/255))
                        }
                        Spacer()
                    }.padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 15).fill(Color(red : 233/255, green: 64/255, blue: 87/255)).opacity(0.1)
                        )
                })
                .padding(.top, geo.size.width*0.05)
                .disabled(viewModel.profile == .homeProfile && !viewModel.isEdit)
                .sheet(isPresented: $isSheetShowing) {
                    if #available(iOS 16.0, *) {
                        
                        BirthdateChoose(birthString: "Choose Birthday Date", currentDate: $viewModel.dateFormated, isSheetFalsee: $isSheetShowing, isDate: $viewModel.deocodeDater)
                            .presentationDetents([.height(500),.fraction(0.75)])
                    } else {
                        // Fallback on earlier versions
                    }
                }

                Button(action: {
                    isGenderView.toggle()
                }, label: {
                    HStack{
                        
                        Image("Gender")
                            .resizable()
                            .frame(width: 20,height: 20)
                            .scaledToFit()
                        if !viewModel.iscatogreySelected.isEmpty  {
                            Text("\(viewModel.iscatogreySelected)")
                                .foregroundColor(Color(red : 233/255, green: 64/255, blue: 87/255))
                                .frame(maxWidth: .infinity,alignment : .leading)
                        }
                        else {
                            Text("Choose Gender")
                                .foregroundColor(Color(red : 233/255, green: 64/255, blue: 87/255))
                                .frame(maxWidth: .infinity,alignment : .leading)
                        }
                        
                        
                        
                    }.padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 15).fill(Color(red : 233/255, green: 64/255, blue: 87/255)).opacity(0.1)
                        )
                })
                .disabled(viewModel.profile == .homeProfile && !viewModel.isEdit)
                
                .padding(.top, geo.size.width*0.05)
                
                .sheet(isPresented: $isGenderView) {
                    GenderChoose(iscatogreySelected: $viewModel.iscatogreySelected, isDimiss: $isGenderView)
                        .presentationDetents([.height(UIScreen.main.bounds.height/2),.fraction(0.75)])
                }
                
                if viewModel.profile == .signUpprofile || viewModel.isEdit{
                    Button {
                        if viewModel.profile == .signUpprofile{
                            if viewModel.allFieldFillValidation(){
                                self.router.pushView(route: .homeView)
                                viewModel.DataSaved()
                            }
                            else {
                                print("Please fill the input")
                            }
                        }
                        
                        if viewModel.isEdit {
                            guard let user = AppController.userDetaisl else {return}
                            FirebaseManager.shared.updateUserDetails(user: user, firstName: viewModel.firstName, lastName: viewModel.lastName, gender: viewModel.iscatogreySelected, dateOfBirth: viewModel.deocodeDater, profileImage: viewModel.myImage)
                            viewModel.isEdit.toggle()
                        }
                        
                        
                    } label: {
                        Text("Submit Button")
                            .font(.custom("", size:  16))
                            .foregroundColor(.white)
                            .padding(.vertical,16)
                            .frame(maxWidth: .infinity)
                            .background(
                            Color(red: 0.914, green: 0.251, blue: 0.341))
                            .cornerRadius(15)
                            .animation(.easeInOut, value: self.viewModel.isEdit)
                    }.padding(.top, geo.size.width*0.05)
                    
                    
                }
                else {
                    Button {
                        viewModel.isEdit.toggle()
                        viewModel.profile == .homeProfile
                    } label: {
                        Text("Edit profile")
                            .font(.custom("", size:  16))
                            .foregroundColor(.white)
                            .padding(.vertical,16)
                            .frame(maxWidth: .infinity)
                            .background(
                            Color(red: 0.914, green: 0.251, blue: 0.341))
                            .cornerRadius(15)
                            .animation(.easeInOut, value: self.viewModel.isEdit)
                    }.padding(.top, geo.size.width*0.05)
                    
                }

                
                
            }
            .padding()
            
            .frame(width: geo.size.width,alignment: .center)
                
            
//                if viewModel.isSheetShowing{
//                    Color.black.opacity(0.5)
//
//                }
//            }
            .padding(.top,geo.size.width*0.15)
            
        }
       
    
           
    }
}

struct SignUpDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpDetailsView(viewModel : signUpDetailsViewModel(phoneNumber: "", profile: ProfileDetails.signUpprofile))
    }
}




//Chhoose Birthday Date

struct BirthdateChoose : View {
    let birthString : String
    @Binding var  currentDate : Date
    @Binding var isSheetFalsee : Bool
    @Binding var isDate : String
    var body: some View {
        VStack {
            Text(birthString)
            DatePicker("", selection: $currentDate,displayedComponents: .date)
            
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
           
            
            Button {
                isSheetFalsee.toggle()
                isDate = dateIntoString(date: currentDate)
            } label: {
                Text("Save")
                    .font(.custom("", size:  16))
                    .foregroundColor(.white)
                    .padding(.vertical,16)
                    .padding(.horizontal,32)
                    .frame(width: UIScreen.main.bounds.width*0.85,alignment: .center)
                    .background(
                        Color(red: 0.914, green: 0.251, blue: 0.341))
                    .cornerRadius(15)
                    
            }

        }
        
    }
}



func dateIntoString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "dd/MM/yy"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    let result = dateFormatter.string(from: date)
    return result
}


//For Gender

struct ChooseImButton : Identifiable {
    var id = UUID()
    let catogery : String
    let image : String
}
extension ChooseImButton {
    static func getChooseData() -> [ChooseImButton] {
        let data = [ChooseImButton(catogery: "Man", image: "checkmark"),
                    ChooseImButton(catogery: "Woman", image: "checkmark"),
                    ChooseImButton(catogery: "Other", image: "checkmark")
        ]
        return data
    }
}



struct GenderChoose : View {
    @Binding var iscatogreySelected :String
    @Binding var isDimiss : Bool
    @State var selectedCat : String = ""
    
    var body: some View {
        VStack{
            ForEach(ChooseImButton.getChooseData()) {index in
                Button {
                    selectedCat = index.catogery
                } label: {
                    HStack {
                        Text(index.catogery)
                            .foregroundColor(selectedCat == index.catogery ?   Color.white : Color.primary)
                        Spacer()
                        if selectedCat == index.catogery {
                            Image(systemName: "checkmark")
                                .foregroundColor(selectedCat == index.catogery ? Color.white : Color(red : 173/255, green: 175/255,blue: 187/255))
                                .frame(width: 12.5, height:  8.33)
                        }
                    }
                    .padding(.vertical,16)
                    .padding(.horizontal,20)
                }
                
                .background(
                    RoundedRectangle(cornerRadius: 15).stroke(Color(red: 232/255, green: 230/255, blue: 234/255)))
                .background(RoundedRectangle(cornerRadius: 15).fill(selectedCat == index.catogery ? Color.red : .clear))
            }
            
            
            
            Button {
                withAnimation {
                    isDimiss.toggle()
                    iscatogreySelected = selectedCat
                }
              
            } label: {
                Text("Submit")
                    .font(.custom("", size:  16))
                    .foregroundColor(.white)
                    .padding(.vertical,16)
                    .frame(maxWidth: .infinity)
                    .background(
                    Color(red: 0.914, green: 0.251, blue: 0.341))
                    .cornerRadius(15)
            }
        }
        .padding(.horizontal)
        .onAppear {
            print(isDimiss)
        }
        .onDisappear {
            print(isDimiss)
        }
        
    }
    }




struct ProfileHeaderView: View {
    @State var isSheetOpen : Bool = false
    @State var image : UIImage?
    @Binding var imagePass : UIImage?
    @Binding var profile : ProfileDetails
    @Binding var isEdit : Bool
    var body: some View {
        ZStack (alignment : .bottomTrailing){
            if let  myimage  = imagePass{
                Image(uiImage: myimage)
                    .resizable()
                    .frame(width:  99, height: 99)
                    .cornerRadius(25)
                Image(systemName: "camera.fill")
                    .foregroundColor(.white)
                    .frame(width:  34, height: 34)
                    .background(
                        Circle().stroke(Color.white))
                    .background(
                        Circle().fill(Color.red))
                
                    .onTapGesture {
                        if profile == .homeProfile && isEdit{
                            isSheetOpen.toggle()
                        }
                    }
                
            }
            
            else {
                Image("Girish")
                    .resizable()
                    .frame(width:  99, height: 99)
                    .cornerRadius(25)
                Image(systemName: "camera.fill")
                    .foregroundColor(.white)
                    .frame(width:  34, height: 34)
                    .background(
                        Circle().stroke(Color.white))
                    .background(
                        Circle().fill(Color.red))
                
                    .onTapGesture {
                        if profile == .signUpprofile{
                            isSheetOpen.toggle()
                        }
                    }
            }
            
        }
        .sheet(isPresented: $isSheetOpen) {
            ImagePicker(selectedImage: $imagePass)
                
        }
    }
}
