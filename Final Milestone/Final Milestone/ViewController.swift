//
//  ViewController.swift
//  Final Milestone
//
//  Created by Vlad Katsubo on 6/28/22.
//

import UIKit

class ViewController: UICollectionViewController {

    var drivers = [UIImage]()
    var items = [String]()
    
    var cards = Set<CardCell>()
    var teamDriver = [String]()
    
    var score = 0 {
        didSet {
            if score == 10 {
                winMessage()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load images to an array
        
        let fm = FileManager.default

        if let tempItems = try? fm.contentsOfDirectory(atPath: Bundle.main.resourcePath!) {
            for item in tempItems {
                if item.range(of: "formula") != nil {
                    items.append(item)
                }
            }
        }
        
        items.shuffle()
            
    }
        
        //set images to the cells
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as? CardCell else {
            fatalError("No Cards")
        }
        
        cell.Driver.image = UIImage(named: "\(items[indexPath.item])")
        cell.Driver.backgroundColor = .tertiarySystemGroupedBackground
        
        cell.logoImage.image = UIImage(named: "logo.png")
        cell.name = items[indexPath.item]
        
        cell.layer.cornerRadius = 20
        
        return cell
    }
        
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { return }
        var team = cell.name!
        team.removeLast(5)
        team = String(team.suffix(team.count - 8)) as String
        print(team)
        
        animate(object: cell, type: "button")
        
        
        if cell.logoImage.isHidden == false {
            cell.logoImage.isHidden = true
            cell.Driver.isHidden = false
//            let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
//            UIView.transition(with: cell, duration: 1.0, options: transitionOptions, animations: {
//                cell.logoImage.isHidden = true
//            })
//
//            UIView.transition(with: cell, duration: 1.0, options: transitionOptions, animations: {
//                cell.Driver.isHidden = false
//            })
            
            cards.insert(cell)
            teamDriver.append(team)
        } else {
            cell.logoImage.isHidden = false
            cell.Driver.isHidden = true
            cards.remove(cell)
            teamDriver.remove(at: indexPath.startIndex)
        }
        
        if teamDriver.allSatisfy({team == $0}) && teamDriver.count > 1 {
            collectionView.isUserInteractionEnabled = false
            cell.logoImage.isHidden = true
            cell.Driver.isHidden = false
            
            UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut) {
                for card in self.cards {
                    card.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }
            }
            
            UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseInOut) {
                for card in self.cards {
                    card.alpha = 0
                }
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                collectionView.isUserInteractionEnabled = true
                for card in self!.cards {
                    card.layer.isHidden = true
                    card.isUserInteractionEnabled = false
                }
                
                self!.cards.removeAll()
                self!.teamDriver.removeAll()
                
                self!.score += 1
            }
            
            
        } else if cards.count == 2 {
            collectionView.isUserInteractionEnabled = false
            
            cell.logoImage.isHidden = true
            cell.Driver.isHidden = false
                
            animate(object: cell, type: "wrong")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                for card in self!.cards {
                    card.logoImage.isHidden = false
                    card.Driver.isHidden = true
                }
                
                collectionView.isUserInteractionEnabled = true
                
                self!.cards.removeAll()
                self!.teamDriver.removeAll()
            }
            
        }

        
        print(score)
        
    }
        
    
    func animate(object: UIView, type: String) {
        if type == "wrong" {
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.curveEaseInOut) {
                for object in self.cards {
                    object.transform = CGAffineTransform(translationX: 20, y: 0)
                }
            }
            
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.curveEaseInOut) {
                for object in self.cards {
                    object.transform = CGAffineTransform(translationX: -20, y: 0)
                }
            }
            
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.curveEaseInOut) {
                for object in self.cards {
                    object.transform = .identity
                }
            }
        } else if type == "button" {
            UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 10, initialSpringVelocity: 5, options: [], animations: {
                object.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            })
            
            UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
                object.transform = .identity
            })
        }
        
        
    }
    
    func winMessage() {
        collectionView.reloadData()
        let wc = UIAlertController(title: "Gratz!", message: "You Win!", preferredStyle: .alert)
        wc.addAction(UIAlertAction(title: "Nice!", style: .default))
        wc.addAction(UIAlertAction(title: "Play Again?", style: .default) { _ in
            for card in self.cards {
                card.isUserInteractionEnabled = true
            }
            self.cards.removeAll()
            self.teamDriver.removeAll()
            self.collectionView.isUserInteractionEnabled = true
            
            self.collectionView.reloadData()
        })
        present(wc, animated: true)
    }
    
//    @objc func flip() {
//        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
//
//        UIView.transition(with: , duration: 1.0, options: transitionOptions, animations: {
//            self.firstView.isHidden = true
//        })
//
//        UIView.transition(with: , duration: 1.0, options: transitionOptions, animations: {
//            self.secondView.isHidden = false
//        })
//    }
}

