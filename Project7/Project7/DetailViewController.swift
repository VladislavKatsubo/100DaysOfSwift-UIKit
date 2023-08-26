//
//  DetailViewController.swift
//  Project7
//
//  Created by Vlad Katsubo on 3/27/22.
//

import UIKit
//we need this for loadHTMLString method
import WebKit


class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        //here we are saying that our ViewController would be a webView
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }

      
        // some html to beatify JSON data 
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        </head>
        <style>
        p {
            text-align: justify;
            font-size: 22px;
            padding: 10px;
        }
        </style>
        <body>
        <h1 style="text-align:center"><b>\(detailItem.title)</b></h1>
        <br>
        <p>\(detailItem.body)</p>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
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
