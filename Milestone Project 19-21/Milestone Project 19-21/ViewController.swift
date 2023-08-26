//
//  ViewController.swift
//  Milestone Project 19-21
//
//  Created by Vlad Katsubo on 6/6/22.
//

import UIKit

class ViewController: UITableViewController {

    var oneNote = Note.init(name: "", text: "")
    var allNotes = [Note]()
    
    let defaults = UserDefaults.standard
    
    var indexOfNote: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "My Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewNote))
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.21, green: 0.95, blue: 0.80, alpha: 0.3)
        
        load()
        
    }
    
    @objc func createNewNote() {
        let nac = UIAlertController(title: "Name your note", message: nil, preferredStyle: .alert)
        nac.addTextField()
        nac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak nac] _ in
            guard var name = nac?.textFields?[0].text else { return } //checl if there are some text in TextField
            let note = Note(name: name, text: "") //create custom type object using entered note name
            self?.allNotes.insert(note, at: 0) // add this note to the top of the array of Notes (like Date sorting)
            self?.oneNote = note // bring created note to the scope
            self?.save() // save array of Notes to the UserDefaults
            
            if let nvc = self?.storyboard?.instantiateViewController(withIdentifier: "Note") as? NoteViewController { // check for ViewController
                let indexPath = IndexPath(row: 0, section: 0) // insert new note at the top of the screen
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
                self?.tableView.reloadData()
                
//                nvc.noteName = note.name // send some data
                nvc.oneNote = note // send some data
                nvc.indexOfNote = indexPath
                self?.navigationController?.pushViewController(nvc, animated: true) // pop it
                
                
                
            }
        }
        
        nac.addAction(submitAction)
        present(nac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = allNotes[indexPath.row].name
        cell.detailTextLabel?.text = allNotes[indexPath.row].text
        cell.textLabel?.isHighlighted = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let nvc = storyboard?.instantiateViewController(withIdentifier: "Note") as? NoteViewController {
//            nvc.noteName = allNotes[indexPath.row].name
            nvc.oneNote = allNotes[indexPath.row]
            indexOfNote = indexPath
            nvc.indexOfNote = indexPath
            print(indexPath)
            navigationController?.pushViewController(nvc, animated: true)
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
    
    func load() {
        if let savedNotes = defaults.object(forKey: "allNotes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                allNotes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Failed to load" ) }
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            allNotes.remove(at: indexPath.row)
            save()
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.endUpdates()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let savedNotes = defaults.object(forKey: "allNotes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                allNotes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Failed to load" ) }
        }
        tableView.reloadData()
    }

}

