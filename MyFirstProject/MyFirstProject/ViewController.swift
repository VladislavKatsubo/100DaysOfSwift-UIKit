//
//  ViewController.swift
//  MyFirstProject
//
//  Created by Vlad Katsubo on 3/14/22.
//

import UIKit

class ViewController: UITableViewController {
// array for countires
    var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flug 'em all!"
        navigationController?.navigationBar.prefersLargeTitles = true
// same as in project 1
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
// wanted to append items' names from Assets catalogue to countries array. failed
        for item in items {
            if item.contains("@2x.png") {
                let itemParsed = item.replacingOccurrences(of: "@2x.png", with: "")
                let itemUppr = itemParsed.uppercased()
                countries.append(itemUppr)
            }
        }
// i think it's useless part. I can just sort countries itself and not to use sortedCountries...
        let sortedCountries = countries.sorted{$0 < $1}
        countries = sortedCountries
        print(countries)
    }
// that's how many rows i need
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
// that's what would be in that rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row]
        return cell
    }
// that what would happen after selection of any table row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = "\(countries[indexPath.row].lowercased() + ".png")"
            // 3: now push it onto the navigation controller
            vc.countryName = "\(countries[indexPath.row])"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

