//
//  ViewController.swift
//  Milestone Project - Meme Generator
//
//  Created by Vlad Katsubo on 6/19/22.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet var imageView: UIImageView!
    var originalImage: UIImage?
    var memeDone = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        
        
    }
    
    // MARK: - Picking photo
    @objc func addPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    
    // MARK: - Finished picking photo, adding it into UIImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        dismiss(animated: true)
        
        imageView.image = image
        originalImage = image
    }
    
    
    @IBAction func saveImage(_ sender: Any) {
    }
    
    
    @IBAction func shareImage(_ sender: Any) {
        guard let image = imageView.image else { return }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(vc, animated: true)
    }
    
    
    @IBAction func addMemeText(_ sender: Any) {
        guard imageView.image != nil else { return }
        
        if memeDone == true {
            imageView.image = originalImage
        }
        
        let tc = UIAlertController(title: "Text at the top", message: nil, preferredStyle: .alert)
        tc.addTextField()
        
        tc.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let topText = tc.textFields?[0].text else { return }
            self?.writeToImage(line: topText,position: "top")
            self?.dismiss(animated: true)
            self?.addBottomLine()
        })
        tc.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.addBottomLine()
        })
        present(tc, animated: true)
    }
    
    func addBottomLine() {
        let bc = UIAlertController(title: "Text at the bottom", message: nil, preferredStyle: .alert)
        bc.addTextField()
        bc.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let botText = bc.textFields?[0].text else { return }
            self?.writeToImage(line: botText, position: "bot")
        })
        bc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(bc, animated: true)
    }
    
    func writeToImage(line: String, position: String) {
        guard let canvasSize = imageView.image?.size else { return }
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
            
        let image = renderer.image { ctx in
            
            let photo = imageView.image!
            photo.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byCharWrapping
            
//            imageView.image!.size.height / 10
            
            let attrs: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: canvasSize.height / 8),
                .font: UIFont.boldSystemFont(ofSize: canvasSize.height / 7),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -3,
                .paragraphStyle: paragraphStyle
                ]
            
            let attributedString = NSAttributedString(string: line, attributes: attrs)
            
            let width: CGFloat = canvasSize.width
            let height: CGFloat = canvasSize.height / 6
            let x = canvasSize.width / 2 - width / 2
            let yTop = canvasSize.height / 9
            let yBot = canvasSize.height - height * 1.5
            
            if position == "top" {
                attributedString.draw(with: CGRect(x: x, y: yTop, width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
            } else {
                attributedString.draw(with: CGRect(x: x, y: yBot, width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
            }
            
            
            
        }
        
        imageView.image = image
        memeDone = true
    }
    
}

