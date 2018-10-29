//
//  WebViewController.swift
//  HakkyungLee-Lab4_v2
//
//  Created by Hakkyung on 2018. 10. 21..
//  Copyright © 2018년 Hakkyung Lee. All rights reserved.
//
//  Reference:
//  webView indicator: https://stackoverflow.com/questions/49189213/create-activity-indicator-when-navigate-in-webview-using-webkit-in-swift-4

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var theWebView: WKWebView!
    @IBOutlet weak var theSpinner: UIActivityIndicatorView!
    var myURLRequest: URLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        theWebView.navigationDelegate = self
        theWebView.load(myURLRequest!)
        theSpinner.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        theSpinner.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        theSpinner.stopAnimating()
        theSpinner.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
