//
//  ViewController.swift
//  Milestone Project 10-12 TableView
//
//  Created by Vlad Katsubo on 5/10/22.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var photoAlbum = [Photos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        
        title = "Imajiz"
        let defaults = UserDefaults.standard
        if let savedPhotos = defaults.object(forKey: "photoAlbum") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                photoAlbum = try jsonDecoder.decode([Photos].self, from: savedPhotos)
            } catch {
                print("Failed to load")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoAlbum.count
    }
    
    @objc func addPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let photo = info[.originalImage] as? UIImage else { return }
        let photoName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(photoName)
        
        if let jpegData = photo.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let photoNew = Photos(name: "New Photo", image: photoName)
        photoAlbum.append(photoNew)
        save()
        tableView.reloadData()
        
        dismiss(animated: true)
        tableView.reloadData()
        
        let nc = UIAlertController(title: "Name your photo", message: nil, preferredStyle: .alert)
        nc.addTextField()
        nc.addAction(UIAlertAction(title: "Done", style: .default) {
            [weak self, weak nc] _ in
            guard let caption = nc?.textFields?[0].text else { return }
            photoNew.name = caption
            self?.save()
            self?.tableView.reloadData()
        })
        nc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(nc, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewPhoto", for: indexPath)
        
        let photo = photoAlbum[indexPath.row]
        cell.textLabel?.text = photo.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photoAlbum[indexPath.row]
        let path = getDocumentsDirectory().appendingPathComponent(photo.image)
        
        if let dc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            dc.path = path
            dc.photoName = photo.name
            navigationController?.pushViewController(dc, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(photoAlbum) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photoAlbum")
        } else {
               print("Failed to save Data")
            }
        
        }
}

