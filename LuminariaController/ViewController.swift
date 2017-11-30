//
//  ViewController.swift
//  ArduinoController
//
//  Created by jatin patel on 10/06/16.
//  Copyright © 2016 JatinPatel. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,StreamDelegate,UIWebViewDelegate {
    
    let webView = UIWebView()
    
    var inputStream:  InputStream!
    var outputStream:  OutputStream!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        initCommunication()
    }
    
    func initCommunication() {
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(nil, "10.200.175.136" as CFString!, 80, &readStream, &writeStream)
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        self.inputStream.delegate = self
        self.outputStream.delegate = self
        
        self.inputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        self.outputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        self.inputStream.open()
        self.outputStream.open()
        
    }
    
    func outputStringToServer(_ str: String) {
        
        let data: Data = str.data(using: String.Encoding.utf8)!
        outputStream.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
    }
    
    @IBAction func tapped_2(_ sender: AnyObject) {
        outputStringToServer("pin=2")
    }
    
    @IBAction func tapped_3(_ sender: AnyObject) {
        outputStringToServer("pin=3")
    }
    
    @IBAction func tapped_4(_ sender: AnyObject) {
        outputStringToServer("pin=4")
    }
    
    @IBAction func tapped_5(_ sender: AnyObject) {
        outputStringToServer("pin=5")
    }
    
    @IBAction func tapped_6(_ sender: AnyObject) {
        outputStringToServer("pin=6")
    }
    
    @IBAction func tapped_7(_ sender: AnyObject) {
        outputStringToServer("pin=7")
    }
    
    @IBAction func tapped_8(_ sender: AnyObject) {
        outputStringToServer("pin=8")
    }
    
    @IBAction func tapped_9(_ sender: AnyObject) {
        outputStringToServer("pin=9")
    }
    
    //
}



