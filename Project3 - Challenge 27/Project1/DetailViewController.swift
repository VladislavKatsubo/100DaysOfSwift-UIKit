//
//  DetailViewController.swift
//  Project1
//
//  Created by Vlad Katsubo on 2/26/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedPictureNumber = 0
    var totalPictures = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var images = [String]()
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }

        title = "Picture \(selectedPictureNumber + 1) of \(totalPictures)"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    @objc func shareTapped() {
        
        guard let canvasSize = imageView.image?.size else { return }
//        print(canvasSize)
        
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        
        let imageWatermarked = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 48),
                .foregroundColor : UIColor.white.cgColor,
                .paragraphStyle: paragraphStyle
            ]
            
            guard let imageToDraw = UIImage(named: selectedImage!) else { return }
            imageToDraw.draw(at: CGPoint(x: 0, y: 0))
            
            let string = "This is Watermark!"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(in: CGRect(x: 32, y: 332, width: 300, height: 150))
            
        }
        
        let imageName = selectedImage ?? "img"
        let vc = UIActivityViewController(activityItems: [imageWatermarked, imageName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    //            guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else
    //                {
    //                    print("No image found")
    //                    return
    //                }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
