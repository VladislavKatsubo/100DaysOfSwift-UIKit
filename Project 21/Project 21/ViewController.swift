//
//  ViewController.swift
//  Project 21
//
//  Created by Vlad Katsubo on 6/4/22.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleTapped))
        
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    @objc func scheduleTapped() {
        scheduleLocal(after: 5)
    }
    
    @objc func scheduleLocal(after timeInterval: TimeInterval) {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse get the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let reminder = UNNotificationAction(identifier: "reminder", title: "Remind me later...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, reminder], intentIdentifiers: [])

        center.setNotificationCategories([category])
    }
    
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            // pull out the buried userInfo dictionary
            let userInfo = response.notification.request.content.userInfo

            if let customData = userInfo["customData"] as? String {
                print("Custom data received: \(customData)")

                switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    // the user swiped to unlock
                    print("Default identifier")
                    let ac = UIAlertController(title: "You've swiped", message: "Get some rest..", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Thanks", style: .default))
                    present(ac, animated: true)
                    
                case "show":
                    // the user tapped our "show more info…" button
                    print("Show more information…")
                    let ac = UIAlertController(title: "You've tapped button", message: "Get some rest..", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Thanks", style: .default))
                    present(ac, animated: true)
                case "reminder":
                    scheduleLocal(after: 25)
                    
                default:
                    break
                }
            }

            // you must call the completion handler when you're done
            completionHandler()
        }
        
        
    }

