//
//  ViewController.swift
//  Project5
//
//  Created by Vlad Katsubo on 3/20/22.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // "plus" button added to NavigationController
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        // если есть файл с именем старт и расширением тхт - добавить в массив allWords содержимое.
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty { // или добавить одно слово, если в файле ничего нет
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    // функция начинает игру и стирает все из массива использованных слов, перезагружая тейбл вью
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    // what would be in the cells?
    // words that were used(made) from the title word. usedWords array is being appended after "submit" func if all "ifs" proceeded
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    // function for "plus" button to try to made a word from title.
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        // closure which is using self and ac with weak capturing to not to create strong reference cycle. submitAction is
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        let errorTitle: String
        let errorMessage: String
       
        
        
// submit "ifs" in order to check if the word is:
    // is the same as the title
    if isTheSame(word: lowerAnswer){
        // is letters from prompted word used once
        if isPossible(word: lowerAnswer){
            // is already exists in the usedWords array
            if isOriginal(word: lowerAnswer){
                // is even possible English words
                if isReal(word: lowerAnswer){
                    usedWords.insert(lowerAnswer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                        errorTitle = "Word not recognized"
                        errorMessage = "You can't just make them up"
                        showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
                    }
                    
            } else {
                    errorTitle = "Word already used"
                    errorMessage = "Be more original!"
                    showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
                }
            
        } else {
            guard let title = title else { return }
                errorTitle = "Word not possible"
                errorMessage = "You can't spell that word from \(title.lowercased())."
                showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
        }
    } else {
        errorTitle = "Word is the same as title"
        errorMessage = "Be more original! x2"
        showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
        }
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false}
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word.lowercased())
    }
    
    func isReal(word: String) -> Bool {
        if word.utf16.count < 3 {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isTheSame(word: String) -> Bool {
        if word == title {
            return false
        }
            return true
    }
    // Refactor all the else statements we just added so that they call a new method called showErrorMessage(). This should accept an error message and a title, and do all the UIAlertController work from there.
    
    //Challenge
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}

