//
//  ViewController.swift
//  Milestone Project 7-9. Hangman
//
//  Created by Vlad Katsubo on 4/5/22.
//

import UIKit

class ViewController: UIViewController {
    
    var hangWord: UILabel! // label for hang score
    var wordLabel: UILabel! // label for guessing word

    let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]// for custom keyboard
    
    var hangmanWords = [String]()//array for words from txt file
    var guessWord = String()//dunno
    
    var maskWordArray = [String]()//array fore letters of maskWord
    var maskWord = ""//original word stores here to change it for ?symbol

    var englishLetters = [UIButton]()//for buttons of letters array
    var activatedLetters = [UIButton]()//to hide activated buttons
    
    var hangedWord = Array("HANGED!")//attempted to use array of letters to lighten up each one after subtracting score
    var score = 0
    
    // indicator of remained lives
    var lives = 7 {
        didSet {
            hangWord.text = "You have \(lives) attempts remained"
            if lives == 0 {
                let fc = UIAlertController(title: "YOU LOST!", message: "Try Again", preferredStyle: .alert)
                fc.addAction(UIAlertAction(title: "OK", style: .default, handler: playAgain))
                present(fc, animated: true)
            }
        }
    }
    
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        hangWord = UILabel()
        hangWord.translatesAutoresizingMaskIntoConstraints = false
        hangWord.textAlignment = .center
        hangWord.text = "You have \(lives) attempts remained"
        hangWord.font = UIFont.systemFont(ofSize: 24)
        hangWord.textColor = .black
        view.addSubview(hangWord)
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.text = "GUESS ME"
        wordLabel.font = UIFont.systemFont(ofSize: 54)
        view.addSubview(wordLabel)
        
        let lettersView = UIView()
        lettersView.translatesAutoresizingMaskIntoConstraints = false
        lettersView.layer.borderWidth = 0.7
        lettersView.layer.borderColor = UIColor.systemMint.cgColor
        view.addSubview(lettersView)
        
        NSLayoutConstraint.activate([
            hangWord.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hangWord.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75),
            
            lettersView.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            lettersView.heightAnchor.constraint(equalToConstant: 250),
            lettersView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            lettersView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -75),
            lettersView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        // dumb cycles to create keyboard
            for letter in letters[0...9] {
                let englishLetterButton = UIButton(type: .system)
                englishLetterButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
                englishLetterButton.setTitle("\(letter.uppercased())", for: .normal)
                englishLetterButton.layer.borderWidth = 0.3
                englishLetterButton.layer.borderColor = UIColor.systemGray.cgColor
                englishLetterButton.addTarget(self, action: #selector(engbtnTapped), for: .touchUpInside)
                let row = 0
                let width = 34
                let height = 83
                let frame = CGRect(x: letters.firstIndex(of: letter)! * width, y: row * height, width: width, height: height)
                englishLetterButton.frame = frame
                lettersView.addSubview(englishLetterButton)
                englishLetters.append(englishLetterButton)
            }
            for letter in letters[10...18] {
                let englishLetterButton = UIButton(type: .system)
                englishLetterButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
                englishLetterButton.setTitle("\(letter.uppercased())", for: .normal)
                englishLetterButton.layer.borderWidth = 0.3
                englishLetterButton.layer.borderColor = UIColor.systemGray.cgColor
                englishLetterButton.addTarget(self, action: #selector(engbtnTapped), for: .touchUpInside)
                let row = 1
                let width = 38
                let height = 83
                let frame = CGRect(x: ((letters.firstIndex(of: letter)!) - 10) * width, y: row * height, width: width, height: height)
                englishLetterButton.frame = frame
                lettersView.addSubview(englishLetterButton)
                englishLetters.append(englishLetterButton)
            }
            for letter in letters[19...25] {
                let englishLetterButton = UIButton(type: .system)
                englishLetterButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
                englishLetterButton.setTitle("\(letter.uppercased())", for: .normal)
                englishLetterButton.layer.borderWidth = 0.3
                englishLetterButton.layer.borderColor = UIColor.systemGray.cgColor
                englishLetterButton.addTarget(self, action: #selector(engbtnTapped), for: .touchUpInside)
                let row = 2
                let width = 49
                let height = 83
                let frame = CGRect(x: ((letters.firstIndex(of: letter)!) - 19) * width, y: row * height, width: width, height: height)
                englishLetterButton.frame = frame
                lettersView.addSubview(englishLetterButton)
                englishLetters.append(englishLetterButton)
            }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            loadLevel()
    }

    // get txt fiel and words
    func loadLevel() {
        if let wordsFileURL = Bundle.main.url(forResource: "HangmanWords", withExtension: "txt"){
            if let hangWords = try? String(contentsOf: wordsFileURL){
                hangmanWords = hangWords.components(separatedBy: "\n")
                guessWord = hangmanWords.randomElement()!
                lives = 7
                //cycle that appending every letter from a random word to an array
                for _ in guessWord {
                    maskWordArray.append("?")
                }
                // then making string from this array
                maskWord = maskWordArray.joined(separator: "")
                // displaying string as wordLabel in the center of the screen
                wordLabel.text = maskWord
                print(guessWord)
                
            }
        }
            
    }
    //hide letter when button from keyboard tapped.
    @objc func engbtnTapped(_ sender: UIButton) {
        guard var buttonTitle = sender.titleLabel?.text else { return }
        activatedLetters.append(sender)
        sender.isHidden = true
        
        var wordArray = Array(guessWord)
        var usedButton = String(buttonTitle.lowercased())
        var usedButtonChar = Character(buttonTitle.lowercased())

        //for score counting and changing label of lives count
        if !guessWord.contains(usedButton){
            lives -= 1
        }

        //
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            //enumerated loop which is checking tapped letter from keyboard in an array of guessing word
            for (index, letter) in wordArray.enumerated() {
    //            var strLetter = String(letter)
                    if letter == usedButtonChar {
                        print(index)
                        print(letter)
                        
                        //if it finds a letter in a guessing word it changes masked word "?" symbol to a letter using its position which we got from an "index" loop variable.
                        DispatchQueue.main.async {
                            self?.maskWordArray[index] = usedButton
                            self?.maskWord = (self?.maskWordArray.joined(separator: ""))!
                            //changes UILabel to show guessed letter
                            self?.wordLabel.text = self?.maskWord
                            //checking if player guessed every letter
                            if self?.wordLabel.text! == self?.guessWord {
                                let wc = UIAlertController(title: "Congratulations", message: "You Won!\nWanna play another one?", preferredStyle: .alert)
                                wc.addAction(UIAlertAction(title: "Yes", style: .default, handler: self?.playAgain))
                                self?.present(wc, animated: true)
                            }
                        }
                        
                    }
                }
            
        }
        
    }
    
    @objc func playAgain(action: UIAlertAction) {
        maskWordArray.removeAll()
        
        for letter in activatedLetters {
            letter.isHidden = false
        }
        
        activatedLetters.removeAll()
        
        
        
        loadLevel()
    }
}
        
//            if guessWord.contains(usedButton) {
//                guard var letInd = wordArray.firstIndex(of: usedButtonChar) else { return }
//                letInd = Int(letInd)
//                print(letInd)
//
//                maskWordArray[letInd] = usedButton
//                maskWord = maskWordArray.joined(separator: "")
//                wordLabel.text = maskWord
//            }
        

        
        
//        for letter in guessWord {
//            guard var letterIndex = wordArray.firstIndex(of: usedButtonChar) else { return }
//            letterIndex = Int(letterIndex)
//            print(letterIndex)
//        }

                
        //            let strLetter = String(letter)
  

