//
//  WikipediaViewController.swift
//  Project 16
//
//  Created by Vlad Katsubo on 5/25/22.
//

import WebKit
import UIKit

class WikipediaViewController: UIViewController {
    
    
    var webView: WKWebView!
    var wikiRequest: String?
    
    var parseText = wikiText(text: [:])
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let wikiRequest = wikiRequest else { return }
                   
        let fullPath = "https://en.wikipedia.org/w/api.php?action=parse&page=\(wikiRequest)&format=json&section=1"
        
        if let url = URL(string: fullPath) {
            if let data = try? Data(contentsOf: url){
                parse(json: data)
            }
        }
            
        if let htmlToLoad = parseText.text["*"] {
            webView.loadHTMLString(htmlToLoad, baseURL: nil)
        }
        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let wikiTextContent = try? decoder.decode(wikiParse.self, from: json) {
            parseText = wikiTextContent.parse
        }
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
