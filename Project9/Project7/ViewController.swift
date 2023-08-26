//
//  ViewController.swift
//  Project7
//
//  Created by Vlad Katsubo on 3/26/22.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var originalPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .done, target: self, action: #selector(creditsTo))
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(findThis))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshView))
        navigationItem.leftBarButtonItems = [refresh, search]
        
        performSelector(inBackground: #selector(fetchJson), with: nil)
    }
    
    @objc func fetchJson() {
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    parse(json: data)
                    return
                    }
            }
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    
        @objc func refreshView() {
            filteredPetitions.removeAll(keepingCapacity: true)
            petitions = originalPetitions
            tableView.reloadData()
        }
    
        @objc func findThis() {
        let sc = UIAlertController(title: "Search", message: "Type what you want to find..", preferredStyle: .alert)
        sc.addTextField()
        
        let submitAction = UIAlertAction(title: "Find", style: .default) {
            [weak self, weak sc] action in
            guard let searchTerm = sc?.textFields?[0].text else { return }
            self?.find(searchTerm)
        }
        
        sc.addAction(submitAction)
        present(sc, animated: true)
    }
    
   @objc func find(_ searchTerm: String){
       
       DispatchQueue.global().async { [weak self] in
           let loweredST = searchTerm.lowercased()
           
           for petition in self!.petitions {
               if petition.body.lowercased().contains(loweredST) {
                   self?.filteredPetitions.append(petition)
                   self?.petitions = self!.filteredPetitions
               }
           }
               DispatchQueue.main.async {
                self?.tableView.reloadData()
               }
       }
        
    }
    
    @objc func showError() {
            let ac = UIAlertController(title: "Error", message: "Problem loading the feed. Check your connection and try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    
   func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            originalPetitions = petitions
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func creditsTo() {
        let cc = UIAlertController(title: "Credits", message: "All the data comes from\n\"We The People\"\n API of the Whitehouse", preferredStyle: .alert)
        cc.addAction(UIAlertAction(title: "Thanks!", style: .default))
        present(cc, animated: true)
    }
}
