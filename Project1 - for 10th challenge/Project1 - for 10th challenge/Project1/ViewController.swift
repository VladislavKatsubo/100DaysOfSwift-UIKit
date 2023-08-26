//
//  ViewController.swift
//  Project1
//
//  Created by Vlad Katsubo on 2/25/22.
//

import UIKit

class ViewController: UICollectionViewController {
    
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
                
            }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            pictures.count
        }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NuCell", for: indexPath) as? NewCell else {
            fatalError("Unable to dequeue NewCell")
        }
        
        cell.ImageCell.image = UIImage(named: pictures[indexPath.item])
//        cell.ImageCell.image = UIImage(contentsOfFile: pictures[indexPath.item])
        
        cell.ImageCell.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.ImageCell.layer.borderWidth = 2
        cell.ImageCell.layer.cornerRadius = 3
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.brown.cgColor
        cell.layer.backgroundColor = UIColor.white.cgColor
        
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = (pictures.firstIndex(of: pictures[indexPath.row])!)
            vc.totalPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pictures.count
//        }
    
    
//        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
//            cell.textLabel?.text = pictures[indexPath.row]
//            return cell
//        }
    
    
//        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
//                vc.selectedImage = pictures[indexPath.row]
//                vc.selectedPictureNumber = (pictures.firstIndex(of: pictures[indexPath.row])!)
//                vc.totalPictures = pictures.count
//                navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    
}

