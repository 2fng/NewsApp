//
//  DetailViewController.swift
//  Project7
//
//  Created by Hua Son Tung on 12/12/2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            body { font-size: 120%; }
            p.alignCenter {
                text-align: justify;
            }
        
        </style>
        </head>
        <body>
        <h3>\(detailItem.title)</h3>
        <p class="alignCenter">\(detailItem.body)</p>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)

    }

}
