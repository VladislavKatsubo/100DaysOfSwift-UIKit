//
//  NoteViewController.swift
//  Milestone Project 19-21
//
//  Created by Vlad Katsubo on 6/6/22.
//

import UIKit

class NoteViewController: UIViewController {

    var oneNote: Note?
    var allNotes = [Note]()
    var indexOfNote: IndexPath?
    let defaults = UserDefaults.standard
    
    @IBOutlet var noteText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeNote))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItems = [trash, share]
        
        if let oneNote = oneNote {
            title = oneNote.name
        }
        
        if let savedNotes = defaults.object(forKey: "allNotes") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                allNotes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("No Data to read")
            }
            
        }
        
        if let index = indexOfNote {
            noteText.text = allNotes[index.row].text
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if oneNote != nil {
            if let noteText = noteText.text {
                if let index = indexOfNote {
                    allNotes[index.row].text = noteText
                    save()
                }
            }
        }
    }
    
    @objc func removeNote() {
        guard let oneNote = oneNote else { return }
        guard let notePosition = allNotes.firstIndex(of: oneNote) else { return }
        
        let dac = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
        
        dac.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
            self.allNotes.remove(at: notePosition)
            self.save()
            self.navigationController?.popToRootViewController(animated: true)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main") as? ViewController
            vc?.allNotes = self.allNotes
        })
        dac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(dac, animated: true)
    }
    
    

    @objc func share() {
//        let shareText = UITextView.text
//        guard let noteText = noteText else { return }
        if let noteText = noteText.text {
            let sc = UIActivityViewController(activityItems: [noteText], applicationActivities: [])
            present(sc, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedNotes = try? jsonEncoder.encode(allNotes) {
            defaults.set(savedNotes, forKey: "allNotes")
        } else {
            printContent("Failed to save Notes")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
