//
//  ViewController.swift
//  ArduinoController
//
//  Created by jatin patel on 10/06/16.
//  Copyright © 2016 JatinPatel. All rights reserved.
//

import UIKit
import Speech
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
    
    @IBOutlet weak var micButton: UIButton!
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var comandos: [String] = ["prender", "apagar"]
    var idFocos: [String] = ["uno","dos","tres","cuatro","cinco","seis","siete","ocho"]
    var microfonoEncendido = false
    
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
        
        CFStreamCreatePairWithSocketToHost(nil, "192.168.11.201" as CFString!, 80, &readStream, &writeStream)
        
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
    
    @IBAction func micButtonPressed(_ sender: Any) {
        if microfonoEncendido {
            stopRecording()
        }else{
            self.microfonoEncendido = true
            self.micButton.setImage(#imageLiteral(resourceName: "microOn"), for: .normal)
            SFSpeechRecognizer.requestAuthorization {
                [unowned self] (authStatus) in
                switch authStatus {
                case .authorized:
                    do {
                        try self.startRecording()
                    } catch let error {
                        print("There was a problem starting recording: \(error.localizedDescription)")
                    }
                case .denied:
                    print("Speech recognition authorization denied")
                case .restricted:
                    print("Not available on this device")
                case .notDetermined:
                    print("Not determined")
                }
            }
        }
    }
    
    func startRecording() throws{
        print("startRecording")
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        // 2
        node.removeTap(onBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024,
                        format: recordingFormat) { [unowned self]
                            (buffer, _) in
                            self.request.append(buffer)
        }
        
        // 3
        audioEngine.prepare()
        try audioEngine.start()
        recognitionTask = speechRecognizer?.recognitionTask(with: request) {
            [unowned self]
            (result, _) in
            if let transcription = result?.bestTranscription {
                print(transcription.formattedString)
                for comando in self.comandos {
                    if transcription.formattedString.lowercased().range(of:comando) != nil {
                        for idFoco in self.idFocos{
                            if transcription.formattedString.lowercased().range(of:idFoco) != nil {
                                self.stopRecording()
                                self.sendServer(idFoco: idFoco)
                                print(idFoco)
                            }
                        }
                        print(comando)
                    }
                }
            }
        }
    }
    
    func stopRecording() {
        print("stopRecording")
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
        microfonoEncendido = false
        micButton.setImage(#imageLiteral(resourceName: "microOff"), for: .normal)
    }
    
    func sendServer(idFoco: String){
        //del 2 al 9
        var nFoco = idFocos.index(of: idFoco)!
        nFoco = nFoco+2
        //outputStringToServer("pin=\(nFoco)")
        let alertaVC = UIAlertController(title: "Exito!", message: "Ya lo prendí :)", preferredStyle: .alert)
        let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertaVC.addAction(okAccion)
        self.present(alertaVC, animated: true, completion: nil)
        //Alamofire.request("http://192.168.11.15/?pin=\(nFoco)").responseJSON{ response in
          //  print("Result : \(response.result)")
            //if let json = response.result.value {
            //  print("JSON: \(json)")
            //}
        //}
    }
    
    @IBAction func foc1(_ sender: Any) {
        outputStringToServer("pin=2")
    }
    
    @IBAction func foc2(_ sender: Any) {
        outputStringToServer("pin=3")
    }
    
    @IBAction func foc3(_ sender: Any) {
        outputStringToServer("pin=4")
    }
    
    @IBAction func foc4(_ sender: Any) {
        outputStringToServer("pin=5")
    }
    
    @IBAction func foc5(_ sender: Any) {
        outputStringToServer("pin=6")
    }
    
    @IBAction func foc6(_ sender: Any) {
        outputStringToServer("pin=7")
    }
    
    @IBAction func foc7(_ sender: Any) {
        outputStringToServer("pin=8")
    }
    
    @IBAction func foc8(_ sender: Any) {
        outputStringToServer("pin=9")
    }
    
}
