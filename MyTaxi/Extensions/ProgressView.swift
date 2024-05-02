//
//  ProgressView.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 10/07/23.
//

import SwiftUI

struct IndicatorView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack{
        
            BouncingBallsProgressView(ballCount: 5, animationDuration: 0.6, delayIncrement: 0.3,colorScheme : colorScheme)
                .frame(width: 10, height: 20)
            Text("Please Wait")
            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
        }
        
        .padding(.horizontal,30)
        .padding(.vertical)
        .background(colorScheme == .dark ? Color.white.opacity(1) : Color.black.opacity(1))
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView()
    }
}



struct BouncingBallView: View {
    let size: CGFloat
    let animationDuration: Double
    let delay: Double
    let colorScheme : ColorScheme
    @State private var animating = false
    
    var body: some View {
        Circle()
            .fill(colorScheme == .dark ? Color.black : Color.white)
            .frame(width: size, height: size)
            .scaleEffect(animating ? 0.6 : 1.0)
            .offset(y: animating ? -size / 2 : 0)
            .animation(
                Animation.easeInOut(duration: animationDuration)
                    .delay(delay)
                    .repeatForever(autoreverses: true)
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    animating = true
                }
            }
    }
}

struct BouncingBallsProgressView: View {
    let ballCount: Int
    let animationDuration: Double
    let delayIncrement: Double
    let colorScheme : ColorScheme
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 10) {
                ForEach(0..<ballCount) { index in
                    BouncingBallView(size: geometry.size.height, animationDuration: animationDuration, delay: Double(index) * delayIncrement, colorScheme: colorScheme)
                }
            }
            .frame(width: geometry.size.width,alignment: .center)
        }
        .aspectRatio(contentMode: .fit)
    }
}

