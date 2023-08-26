//
//  ViewController.swift
//  Project1
//
//  Created by Vlad Katsubo on 2/25/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
                override func viewDidLoad() {
                super.viewDidLoad()
                title = "Storm Viewer"
                navigationController?.navigationBar.prefersLargeTitles = true
                
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
                    
                // challenge
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
            }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
            cell.textLabel?.text = pictures[indexPath.row]
            return cell
        }
    
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                vc.selectedImage = pictures[indexPath.row]
                vc.selectedPictureNumber = (pictures.firstIndex(of: pictures[indexPath.row])!)
                vc.totalPictures = pictures.count
                navigationController?.pushViewController(vc, animated: true)
        }
    }
        @objc func shareApp() {
            let myApp = "Hey! Here is my App.\n Go and try it"
            let dc = UIActivityViewController(activityItems: [myApp], applicationActivities: [])
            dc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(dc, animated: true)
    }
}

