//
//  ViewController.swift
//  Project1
//
//  Created by Vlad Katsubo on 2/25/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    let userDefaults = UserDefaults.standard
                override func viewDidLoad() {
                super.viewDidLoad()
                title = "Storm Viewer"
                navigationController?.navigationBar.prefersLargeTitles = true
                
//                performSelector(inBackground: #selector(loadNSSL), with: nil)
//                performSelector(onMainThread: #selector(reloadView), with: nil, waitUntilDone: false)
                    loadNSSL()
                    tableView.reloadData()
            }
    
    @objc func loadNSSL() {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            for item in items {
                if item.hasPrefix("nssl") {
                    pictures.append(item)
                }
            }
            let sortedPics = pictures.sorted {$0 < $1}
            pictures = sortedPics
        }
    
        @objc func reloadView() {
            tableView.reloadData()
        }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many tableView cells should be created
        return pictures.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
            // what text would be on tableView cells.
            cell.textLabel?.text = pictures[indexPath.row]
            
            // text for subtitle. contains number of image views for key: "image name" aka "pictures[indexPath.row]"
            if let dvc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                cell.detailTextLabel?.text = "Views \(dvc.userDefaultsDVC.integer(forKey:pictures[indexPath.row]))"
            }
            return cell
        }
    
        // What should app do when u tap on the cell?
        // It checks if viewcontroller with id "Detail" is exists and if yes gives properties from DetailViewController some values.
        //
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                vc.selectedImage = pictures[indexPath.row]
                vc.selectedPictureNumber = (pictures.firstIndex(of: pictures[indexPath.row])!)
                vc.totalPictures = pictures.count
                navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

