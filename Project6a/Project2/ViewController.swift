//
//  ViewController.swift
//  Project2
//
//  Created by Vlad Katsubo on 3/10/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var qna = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My Score", style: .done, target: self, action: #selector(myScore))
        
        
        btn1.layer.borderWidth = 1
        btn2.layer.borderWidth = 1
        btn3.layer.borderWidth = 1
        
        btn1.layer.borderColor = UIColor.lightGray.cgColor
        btn2.layer.borderColor = UIColor.lightGray.cgColor
        btn3.layer.borderColor = UIColor.lightGray.cgColor
        
        btn1.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        btn2.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        btn3.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            
            btn1.setImage(UIImage(named: countries[0]), for: .normal)
            btn2.setImage(UIImage(named: countries[1]), for: .normal)
            btn3.setImage(UIImage(named: countries[2]), for: .normal)
            
        var countryTitle: String
        countryTitle = countries[correctAnswer].uppercased()
        var titleLabel = UILabel().self
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = "Choose \(countryTitle)"
        self.navigationItem.titleView = titleLabel
        }
    
    @IBAction func ButtonTapped(_ sender: UIButton) {
        var title: String
        qna += 1
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong!\nThat’s the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
    
        if qna == 10 {
            var fcMessage = "You've answered 10 questions.\n Your final score is \(score)"
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
    @objc func myScore() {
        let sms = UIAlertController(title: "Nice", message: "You current score is \(score).", preferredStyle: .alert)
        sms.addAction(UIAlertAction(title: "Thanks", style: .default))
        present(sms, animated: true)
    }
}
