//
//  ResponseFromDevice.swift
//  ArduinoController
//
//  Created by jatin patel on 11/06/16.
//  Copyright © 2016 JatinPatel. All rights reserved.
//

import UIKit

class ResponseFromDevice: NSObject, UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}

