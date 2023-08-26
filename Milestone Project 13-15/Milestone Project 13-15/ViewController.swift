//
//  ViewController.swift
//  Milestone Project 13-15
//
//  Created by Vlad Katsubo on 5/22/22.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlCapital = "https://raw.githubusercontent.com/samayo/country-json/0cbe6870e640ff0aed6acc6614c3d37df3d37f40/src/country-by-capital-city.json"
        
        if let urlC = URL(string: urlCapital) {
            if let dataCapital = try? Data(contentsOf: urlC) {
                parse(json: dataCapital)
            }
        }
        
        let urlLanguage = "https://raw.githubusercontent.com/samayo/country-json/master/src/country-by-languages.json"
        
        if let urlL = URL(string: urlLanguage) {
            if let dataLanguage = try? Data(contentsOf: urlL) {
//                parse(json: dataLanguage)
//                print("parsed language")
                print(parse(json: dataLanguage))
            }
        }
        
        let urlDish = "https://raw.githubusercontent.com/samayo/country-json/master/src/country-by-national-dish.json"
        
        if let urlD = URL(string: urlDish) {
            if let dataD = try? Data(contentsOf: urlD) {
                parse(json: dataD)
            }
        }
        
        print(countries[0])
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonCountries = try? decoder.decode([Country].self, from: json) {
            countries += jsonCountries
            tableView.reloadData()
            print(countries)
        }
            
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryName", for: indexPath)
        let eachCountry = countries[indexPath.row]
        cell.textLabel?.text = eachCountry.country
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = DetailViewController()
        dvc.detailItem = countries[indexPath.row]
        navigationController?.pushViewController(dvc, animated: true)
    }
    
}

