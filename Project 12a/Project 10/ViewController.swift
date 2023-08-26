//
//  ViewController.swift
//  Project 10
//
//  Created by Vlad Katsubo on 4/11/22.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person]{
                people = decodedPeople
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        
        let person = people[indexPath.item]
        cell.Name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.ImageView.image = UIImage(contentsOfFile: path.path)
        
        cell.ImageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.ImageView.layer.borderWidth = 2
        cell.ImageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let dc = UIAlertController(title: "What do you wanna do?", message: nil, preferredStyle: .alert)
        
            dc.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in // can someone tell me in simple words what it does?
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
            })
        
            dc.addAction(UIAlertAction(title: "Rename", style: .default) {
                [weak self] _ in
                    let ac = UIAlertController(title: "Choose name", message: nil, preferredStyle: .alert)
                    ac.addTextField()
                    ac.addAction(UIAlertAction(title: "Rename", style: .default) {
                        [weak self, weak ac] _ in
                        guard let newName = ac?.textFields?[0].text else { return }
                        person.name = newName
                        self?.save()
                        self?.collectionView.reloadData()
                    })
                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    self?.present(ac, animated: true)
            })
        
            present(dc, animated: true)
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
        //So: line 1 is what converts our array into a Data object, then lines 2 and 3 save that data object to UserDefaults. You now just need to call that save() method when we change a person's name or when we import a new picture.
    }
    
    
    
    
    //        let ac = UIAlertController(title: "What you want to do?", message: nil, preferredStyle: .alert)
    //        ac.addTextField()
    //        ac.addAction(UIAlertAction(title: "Rename", style: .default) {
    //            [weak self, weak ac] _ in
    //            guard let newName = ac?.textFields?[0].text else { return }
    //            person.name = newName
    //            self?.collectionView.reloadData()
    //        })
    //        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    //        present(ac, animated: true)
}

