//
//  ActionViewController.swift
//  Extension
//
//  Created by Vlad Katsubo on 5/30/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    var savedScripts = [String:String]()
    
    let defaults = UserDefaults.standard
    var nameScript: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedScriptsDict = defaults.object(forKey: "savedJS") as? [String:String] {
            savedScripts = savedScriptsDict
        }
        print(savedScripts)
        
        let saveScripButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveYourScript))
        let savedScriptsList = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(loadSavedScripts))
        navigationItem.leftBarButtonItems = [saveScripButton, savedScriptsList]
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let listOfUsefulScripts = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(exampleScripts))
        navigationItem.rightBarButtonItems = [doneButton, listOfUsefulScripts]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict,error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        
                        if let savedScript = self?.defaults.value(forKey: self!.pageURL) as? String {
                            self?.script.text = savedScript
                        } else {
                            print("There is no value for that key")
                        }
                        
//                        if self?.nameScript != nil {
//                            guard let textScript = self?.defaults.value(forKey: self!.nameScript!) as? String else { return }
//                            self?.script?.text? = textScript
//                        } else {
//
//
//
//                        }
                        
                        
                    }
                    
                    
                }
            }
        }
        
        
        
    }

    
    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider.init(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        
        if let typedText = script.text {
            
            defaults.set(typedText, forKey: pageURL)
            print("I've saved", defaults.value(forKey: pageURL)!)
        } else {
            print("Can't save anything")
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func exampleScripts() {
        let ec = UIAlertController(title: "Here are some scripts", message: nil, preferredStyle: .actionSheet)
        ec.addAction(UIAlertAction(title: "URL", style: .default) { [weak self] _ in
            self?.script.text = "alert(document.URL)"
        })
        ec.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ec, animated: true)

    }
    
    @objc func saveYourScript() {
        
        if let typedText = script.text {
            let sc = UIAlertController(title: "Name and save your script\nto the library", message: "You can use them later", preferredStyle: .alert)
            sc.addTextField()
            sc.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                guard let scriptName = sc.textFields?[0].text else { return }
                self?.savedScripts[scriptName] = typedText
                self?.defaults.set(self?.savedScripts, forKey: "savedJS")
            })
            sc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(sc, animated: true)
            
        }
        
    }
    
    @objc func loadSavedScripts() {
        if let tableView = storyboard?.instantiateViewController(withIdentifier: "Library") as? TableViewController {
            tableView.completion = { [weak self] text in
                DispatchQueue.main.async {
                    self?.script.text = self?.savedScripts[text]
                }
                
            }
            navigationController?.pushViewController(tableView, animated: true)
        }
    }
    
    
}
