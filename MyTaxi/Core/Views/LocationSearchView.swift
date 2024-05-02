//
//  LocationSearchView.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 13/06/23.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText : String = ""
    @State private var destinationLocationText : String = ""
    @Binding var mapState : MapViewState
    @EnvironmentObject var vm : LocationSearchViewModel
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                searchView()
                    .padding(.top,72)
                Divider()
                    .padding(.vertical)
                
                listView()
            }
            MapViewActionButton(imageTitle: "arrow.left",action: {
                withAnimation{
                    mapState = .noInput
                 
                }
            })
                .padding(.leading)
            
        }
        .background(.white)
        
    }
    @ViewBuilder
    func searchView()->some View {
        HStack{
            VStack{
                    Circle()
                    .fill(Color(.systemGray3))
                        .frame(width: 6,height: 6)
                    
                   Rectangle()
                        .fill(Color.black)
                        .frame(width: 1,height: 24)
                Circle()
                    .fill(Color.black)
                    .frame(width: 6,height: 6)
            }
            
            VStack{
                TextField("Current Location", text: $vm.currentLocationAddress)
                    .padding(.leading,10)
                    .frame(height: 32)
                    .background(Color(.systemGroupedBackground))
                    .padding(.trailing)
                    
                
                TextField("Where to?", text: $vm.queryFragment)
                    .padding(.leading,10)
                    .frame(height: 32)
                    .background(Color(.systemGray4))
                    .padding(.trailing)
            }
            
        }
        .padding(.horizontal)
    }
    
    func listView() -> some View {
        ScrollView{
            VStack {
                ForEach(vm.result,id: \.self){result in
                  
                    LocationSearchResult(title: result.title, subTitle: result.subtitle)
                        .onTapGesture {
                            vm.selectLocation(result)
                            withAnimation(.spring()) {
                                mapState = .locationSelected
                                self.vm.destinationName = "\(result.title)"
                            }
                        }
                }
            }
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
   
    static var previews: some View {
        LocationSearchView(mapState: .constant(.searchingForLocation)).environmentObject(LocationSearchViewModel())
    }
}

