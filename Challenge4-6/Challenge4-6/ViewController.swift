//
//  ViewController.swift
//  Challenge4-6
//
//  Created by Vlad Katsubo on 3/25/22.
//

import UIKit

class ViewController: UITableViewController {
    var productList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Domoed 0.1"
        
        // Here i've created two items for rightBarButtonItems placeholder
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(productAdd))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareShoppingList))
        navigationItem.rightBarButtonItems = [share,add]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshList))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath)
        cell.textLabel?.text = productList[indexPath.row]
        return cell
    }
    
    // func to add a product using UITextField from 5th project.
    @objc func productAdd() {
        let ac = UIAlertController(title: "Add Your Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "+Add", style: .default){
            [weak self, weak ac] action in
            guard let product = ac?.textFields?[0].text else { return }
            self?.submit(product)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    // func to submit product to the array that would be shown in the tableView
    func submit(_ product: String){
        productList.insert(product, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .middle)
        return
    }
    // additional func for list sharing
    @objc func shareShoppingList(){
        let shoppingListString = productList.joined(separator: "\n")
        let sc = UIActivityViewController(activityItems: [shoppingListString], applicationActivities: [])
        sc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(sc, animated: true)
    }
    
    // remove all products
    @objc func refreshList() {
        productList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
}

