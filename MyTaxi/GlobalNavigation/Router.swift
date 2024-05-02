//
//  Router.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 22/06/23.
//


import Foundation
import SwiftUI
import UIKit

enum Route: Hashable {
    case appStartView
    case enterMobileView
    case VerifyCodeView(phNumber : String)
    case signUpDetails(phNumber : String, profile : ProfileDetails = .signUpprofile)
    case homeView
  
}


final class Router: ObservableObject {
    @Published var navigationPath = NavigationPath() {
        willSet(newPath) {
            if newPath.count < navigationPath.count - 1 {
                let animation = CATransition()
                animation.isRemovedOnCompletion = true
                animation.type = .moveIn
                animation.duration = 0.4
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)
            }
        }
    }
    
    func pushView(route: Route) {
        navigationPath.append(route)
    }
    
    func popToRootView() {
        navigationPath = .init()
    }
    
    func popToSpecificView(k: Int) {
        navigationPath.removeLast(k)
    }
    
}
