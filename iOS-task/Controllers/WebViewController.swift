//
//  WebViewController.swift
//  iOS-task
//
//  Created by Toya on 2022/05/26.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var urlString: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: urlString) else {
            return
        }
        let urlRequest = URLRequest(url: url)
        
        webView.load(urlRequest)
        
    }
    

}
