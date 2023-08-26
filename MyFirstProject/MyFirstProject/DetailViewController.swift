//
//  DetailViewController.swift
//  MyFirstProject
//
//  Created by Vlad Katsubo on 3/16/22.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedImage: String?
    var countryName: String?
    
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(selectedImage != nil, "IF there is no selectedImage = crash the App")
        
        title = countryName ?? "Flug"
        // button to share flag
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))
        // code snippet to load an image into UIImageView from Storyboard
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
            imageView.layer.backgroundColor = UIColor.systemGray4.cgColor
        }
        
        
    }
    // function to share flag and name of the country
    @objc func shareFlag() {
        guard let image = UIImage(named: selectedImage ?? "No image") else {
            print("No Image!")
            return
        }
        
        let text = selectedImage ?? "img"
        let sharingFlag = UIActivityViewController(activityItems: [image, text], applicationActivities: [])
        sharingFlag.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(sharingFlag, animated: true)
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
