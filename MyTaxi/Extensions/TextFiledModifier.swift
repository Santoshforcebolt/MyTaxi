//
//  TextFiledModifier.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 21/06/23.
//

import Foundation

import SwiftUI


struct TextFiledSpcer: ViewModifier {
    let placeholder : String
    @State private var width = CGFloat.zero
    @State private var labelWidth = CGFloat.zero
    func body(content: Content) -> some View {
        content
            .lineLimit(0)
            .padding()
            .background{
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .trim(from: 0, to: 0.55)
                        .stroke(.black, lineWidth: 1)
                    RoundedRectangle(cornerRadius: 15)
                        .trim(from: 0.565 + (0.45 * (labelWidth / width)), to: 1)
                        .stroke(Color.black, lineWidth: 1)
                    Text(placeholder)
                        .foregroundColor(.black)
                        .overlay( GeometryReader { geo in Color.clear.onAppear { labelWidth = geo.size.width }})
                        .padding(2)
                        .font(.caption)
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity,
                               alignment: .topLeading)
                        .offset(x: 20, y: -10)
                    
                }
                
            }
            .overlay( GeometryReader { geo in Color.clear.onAppear { width = geo.size.width }})

    }
}
extension View {
    func TextFieldStyle(placeholder : String) -> some View {
        modifier(TextFiledSpcer(placeholder: placeholder))
    }
}
