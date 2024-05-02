//
//  LocalNotificatins.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 07/07/23.
//

import Foundation
import NotificationCenter
class LocalNotifications  {
    // Send a local notification with the given title, body, and time
    static let shared = LocalNotifications()
    
    // Send a local notification with the given title and body
    func sendLocalNotification(after timeInterval: TimeInterval = 1, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending local notification: \(error.localizedDescription)")
            } else {
                print("Local notification scheduled successfully")
            }
        }
    }
    
}
