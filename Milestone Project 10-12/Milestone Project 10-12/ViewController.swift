//
//  ViewController.swift
//  Milestone Project 10-12
//
//  Created by Vlad Katsubo on 5/8/22.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var photoAlbum = [Photos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhoto))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAlbum.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as? PhotoCell
        else {
            fatalError("There is no Photos")
        }
        
        let photo = photoAlbum[indexPath.item]
        cell.caption.text = photo.name
        
        let path = getDocumentsDirectory().appendingPathComponent(photo.image)
        cell.photoView.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    
    @objc func addNewPhoto() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let photo = info[.originalImage] as? UIImage else { return }
        let photoName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(photoName)
        
        if let jpegData = photo.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let photoCell = Photos(name: "Unknown", image: photoName)
        photoAlbum.append(photoCell)
        collectionView.reloadData()
        
        dismiss(animated: true)
        
        let nc = UIAlertController(title: "Name your photo", message: nil, preferredStyle: .alert)
        nc.addTextField()
        nc.addAction(UIAlertAction(title: "Done", style: .default) {
            [weak self, weak nc] _ in
            guard let caption = nc?.textFields?[0].text else { return }
            photoCell.name = caption
            self?.collectionView.reloadData()
        })
        nc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(nc, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photoAlbum[indexPath.item]
        let path = getDocumentsDirectory().appendingPathComponent(photo.image)
        print(photo.image)
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.path = path
            vc.photoName = photo.name
            navigationController?.pushViewController(vc, animated: true)
        }
            
    }
    
}

