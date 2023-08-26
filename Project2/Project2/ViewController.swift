//
//  ViewController.swift
//  Project2
//
//  Created by Vlad Katsubo on 3/10/22.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
// buttons which was created in IB are added via Ctrl+Drag.
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!

    var countries = [String]()
    var score = 0
    var correctAnswer = 0
// Challenge
    var qna = 0
    
//    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
    // Challenge
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Score", style: .done, target: self, action: #selector(myScore))
        
    
        btn1.layer.borderWidth = 1
        btn2.layer.borderWidth = 1
        btn3.layer.borderWidth = 1
        
        btn1.layer.borderColor = UIColor.lightGray.cgColor
        btn2.layer.borderColor = UIColor.lightGray.cgColor
        btn3.layer.borderColor = UIColor.lightGray.cgColor
        
    // something from youtube comments which helped to remove insets
        btn1.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        btn2.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        btn3.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        
        askQuestion()
        
        registerLocalNotifications()
        
        for i in 1...7 {
            comeAgainNotification(at: i)
        }
        
    }
    
    func registerLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Good decision")
            } else {
                print("Bad decision")
            }
        }
    }
    
    
    
    func comeAgainNotification(at weekday: Int) {
    registerCategories()
            
        let center = UNUserNotificationCenter.current()
            
        let content = UNMutableNotificationContent()
        content.title = "What the flag of your country looks like?"
        content.body = "Come and try to guess world flags"
        content.categoryIdentifier = "comeAgain"
        content.userInfo = ["returningData":"returned"]
        content.sound = .default
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday
        dateComponents.hour = 20
        dateComponents.minute = 24
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let open = UNNotificationAction(identifier: "wannaPlay", title: "I will guess", options: .foreground)
        let category = UNNotificationCategory(identifier: "comeAgain", actions: [open], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["returningData"] as? String {
            print(customData)
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
            case "wannaPlay":
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
            default:
                break
            }
        }
        completionHandler()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        
        // Array shuffles here
            countries.shuffle()
        // random country chosen
            correctAnswer = Int.random(in: 0...2)
        // shuffled countries' images sets to buttons
            btn1.setImage(UIImage(named: countries[0]), for: .normal)
            btn2.setImage(UIImage(named: countries[1]), for: .normal)
            btn3.setImage(UIImage(named: countries[2]), for: .normal)
        
        // creating of title with a country that we should guess.
        var countryTitle: String
        countryTitle = countries[correctAnswer].uppercased()
        let titleLabel = UILabel().self
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = "Choose \(countryTitle)"
        self.navigationItem.titleView = titleLabel
        }
    
    // how button tap is working
    @IBAction func ButtonTapped(_ sender: UIButton) {
        
        UIButton.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 10, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
        
        UIButton.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = .identity
        })
        
        
        var title: String
        qna += 1
        // if number of button (sender.tag) equals to randomly chosen number from 0 to 2 then OK
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong!\nThat’s the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
    // challenge
        if qna == 10 {
            let fcMessage = "You've answered 10 questions.\n Your final score is \(score)"
            let fc = UIAlertController(title: "Great", message: fcMessage, preferredStyle: .alert)
            fc.addAction(UIAlertAction(title: "Got it!", style: .default, handler: askQuestion))
            present(fc, animated: true)
            qna = 0
            score = 0
            
        }
        
        let ac = UIAlertController(title: title, message: "You score is now \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
        
    }
    
    // Challenge button
    @objc func myScore() {
        let sms = UIAlertController(title: "Nice", message: "You current score is \(score).", preferredStyle: .alert)
        sms.addAction(UIAlertAction(title: "Thanks", style: .default))
        present(sms, animated: true)
    }
    
}
