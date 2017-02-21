//
//  WebViewController.swift
//  Home Again
//
//  Created by John Gabriel Breshears on 2/21/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    
    var webView: WKWebView!
    
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www1.nyc.gov/account/registerWithName.htm?lang=en&target=aHR0cHM6Ly9hMDY5LWFjY2Vzcy5ueWMuZ292L3NpdGVtaW5kZXJhZ2VudC9mb3Jtcy9yZWRpcmVjdC5mY2M/VFlQRT0zMzU1NDQzMyZSRUFMTU9JRD0wNi0wMDA2MjM4Ny1lMzM5LTE1OTItOGE4OS0wNDllYWMxMDkwNWQmR1VJRD0xJlNNQVVUSFJFQVNPTj0wJk1FVEhPRD1HRVQmU01BR0VOVE5BTUU9LVNNLSUyYmd2UzYxTFZabnJJWGNvVlRnMHlwRHUzZ2NUWFd0bjYyVWNqblFzZmQ2QVliRG1uM0NnRjMxMFhMTXRnYTZ1byZUQVJHRVQ9LVNNLUhUVFBTJTNhJTJmJTJmYTA2OS0tYWNjZXNzJTJlbnljJTJlZ292JTJmQUNDRVNTTllDJTJmYW55YyUyZkFOWUNTU09SZWRpcmVjdCUyZWpzcCUzZnRva2VuJTNkLS0zMTI3ODk3MTY2MTQxMTQ1NzkyLSUyNmxhbmctJTNEZW4=&fromKiosk=true")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}
