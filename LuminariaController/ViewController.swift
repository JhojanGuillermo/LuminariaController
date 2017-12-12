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
    
    @IBOutlet weak var foco1: UIButton!
    @IBOutlet weak var foco2: UIButton!
    @IBOutlet weak var foco3: UIButton!
    @IBOutlet weak var foco4: UIButton!
    @IBOutlet weak var foco5: UIButton!
    @IBOutlet weak var foco6: UIButton!
    @IBOutlet weak var foco7: UIButton!
    @IBOutlet weak var foco8: UIButton!
    
    
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
        
        CFStreamCreatePairWithSocketToHost(nil, "10.200.174.187" as CFString!, 3000, &readStream, &writeStream)
        
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
    
    @IBAction func foc1(_ sender: Any) {
        outputStringToServer("http://10.200.170.201/?pin=2")
    }
    
    @IBAction func foc2(_ sender: Any) {
        outputStringToServer("http://10.200.170.201/?pin=3")
    }
    
    @IBAction func foc3(_ sender: Any) {
        outputStringToServer("http://10.200.170.201/?pin=4")
    }
    
    @IBAction func foc4(_ sender: Any) {
        outputStringToServer("http://10.200.170.201/?pin=5")
    }
    
    @IBAction func foc5(_ sender: Any) {
        outputStringToServer("http://10.200.170.201/?pin=6")
    }
    
    @IBAction func foc6(_ sender: Any) {
        outputStringToServer("http://10.200.170.201/?pin=7")
    }
    
    @IBAction func foc7(_ sender: Any) {
        outputStringToServer("http://10.200.170.201/?pin=8")
    }
    
    @IBAction func foc8(_ sender: Any) {
        outputStringToServer("http://10.200.170.201/?pin=9")
    }
    
}
