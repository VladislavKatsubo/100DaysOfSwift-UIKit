//
//  ViewController.swift
//  Project13
//
//  Created by Vlad Katsubo on 5/12/22.
//


import CoreImage
import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var imageView: UIImageView! // some outlets to manage storyboard items in code
    @IBOutlet var intensity: UISlider!
    @IBOutlet var radius: UISlider!
    @IBOutlet var changeFilterButton: UIButton!
    
    
    var currentImage: UIImage!
    
    
    var context: CIContext! //The first is a Core Image context, which is the Core Image component that handles rendering. We create it here and use it throughout our app, because creating a context is computationally expensive so we don't want to keep doing it.
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.alpha = 0
        
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")//initial filter
        
        changeFilterButton.setTitle(currentFilter.name, for: .normal)//challenge - change "change filter" button's name according to chosen filter.
    }
    
    @objc func importPicture() { // for Add button
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func applyProcessing() {
        
        let inputKeys = currentFilter.inputKeys //takes all "input keys" of a given filter. Then checks if it contains one of the keys below and choose slider which will change filter's value.
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey) //challenge to add another one UISlider which will maintain radius-related filters.
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        
        guard let image = currentFilter.outputImage else { return }
        
        if let cgImg = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgImg)
            imageView.image = processedImage
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.imageView.alpha = 0
            self.imageView.alpha = 1
        })
        applyProcessing()
    }
    

    @IBAction func intensityChanged(_ sender: Any) { // UISlider action
        applyProcessing()
    }
    
    @IBAction func radiusChanged(_ sender: Any) { // UISlider action
        applyProcessing()
    }
    
    
    
    @IBAction func changeFilter(_ sender: UIButton) { // Alert controller which were user can choose a filter.
        
        let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
        
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return } // checks if there is an image in scope
        guard let actionTitle = action.title else { return } // checks if a filter was chosen
        
        currentFilter = CIFilter(name: actionTitle)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        changeFilterButton.setTitle(actionTitle, for: .normal)
        
        applyProcessing() //applies chosen filter to the image with
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else { //checks if there an image
            let ec = UIAlertController(title: "No Image!", message: "Import some image using plus button on the top right corner.", preferredStyle: .alert)
            ec.addAction(UIAlertAction(title: "OK", style: .default))
            present(ec, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil) // saves image to the library
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
}

