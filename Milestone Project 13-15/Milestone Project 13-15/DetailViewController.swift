//
//  DetailViewController.swift
//  Milestone Project 13-15
//
//  Created by Vlad Katsubo on 5/22/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Country?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
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
        <h1 style="text-align:center"><b>\(detailItem.country)</b></h1>
        <p style="padding-left: 10px;"><b>Capital city:</b> \(detailItem.city ?? "")</p>
        <p style="padding-left: 10px;"><b>Languages:</b> \(detailItem.languages ?? [String]())</p>
        <p style="padding-left: 10px;"><b>National dish:</b> \(detailItem.dish ?? "")</p>
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
