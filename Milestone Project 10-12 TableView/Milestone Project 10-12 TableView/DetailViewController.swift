//
//  DetailViewController.swift
//  Milestone Project 10-12 TableView
//
//  Created by Vlad Katsubo on 5/10/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet var photoView: UIImageView!
    
    var path: URL?
    var photoName = "New Photo"

    override func viewDidLoad() {
        super.viewDidLoad()

        if let photoPath = path {
            photoView.image = UIImage(contentsOfFile: photoPath.path)
        }
        
        title = photoName
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
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
