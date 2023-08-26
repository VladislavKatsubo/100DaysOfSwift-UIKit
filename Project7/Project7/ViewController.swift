//
//  ViewController.swift
//  Project7
//
//  Created by Vlad Katsubo on 3/26/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    //Challenge
    var filteredPetitions = [Petition]()
    var originalPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Challenge button for info about API source
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .done, target: self, action: #selector(creditsTo))
        //Challenge button for searching
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(findThis))
        //Challenge button to return to the not-filtered results
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshView))
        //two items for leftBarButtonItems
        navigationItem.leftBarButtonItems = [refresh, search]
        
        let urlString: String
        //It's about how to choose what URL should be parsed and showed on which View
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://hackingwithswift.com/samples/petitions-2.json"
        }
        
        // checking if URL is exist and parsing json from data path
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    @objc func refreshView() {
        filteredPetitions.removeAll(keepingCapacity: true)
        petitions = originalPetitions
        tableView.reloadData()
    }
    
    //Challenge
    @objc func findThis() {
        let sc = UIAlertController(title: "Search", message: "Type what you want to find..", preferredStyle: .alert)
        sc.addTextField()
        
        let submitAction = UIAlertAction(title: "Find", style: .default){
            [weak self, weak sc] action in
            guard let searchTerm = sc?.textFields?[0].text else { return }
            self?.find(searchTerm)
        }
        
        sc.addAction(submitAction)
        present(sc, animated: true)
    }
    
    //Challenge
    func find(_ searchTerm: String){
        let loweredST = searchTerm.lowercased()
        
        for petition in petitions {
            if petition.body.lowercased().contains(loweredST) {
                filteredPetitions.append(petition)
                petitions = filteredPetitions
                tableView.reloadData()
            }
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Error", message: "Problem loading the feed. Check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    // parsing of Data which was created using custom data types Petiton and Petitions
   func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
            originalPetitions = petitions
        }
    }
        
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    //saved petition by row into an variable and saved their title and body to the tableViewCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    // pushing data to the second ViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    //Challenge
    @objc func creditsTo() {
        let cc = UIAlertController(title: "Credits", message: "All the data comes from\n\"We The People\"\n API of the Whitehouse", preferredStyle: .alert)
        cc.addAction(UIAlertAction(title: "Thanks!", style: .default))
        present(cc, animated: true)
    }
    
}

