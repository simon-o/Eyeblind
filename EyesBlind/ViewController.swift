//
//  ViewController.swift
//  EyesBlind
//
//  Created by Antoine Simon on 13/06/2017.
//  Copyright © 2017 Viseo Digital. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer?
    var currentCaptureDevice:AVCaptureDevice!
    var prevLayer:AVCaptureVideoPreviewLayer!
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let captureInput = try AVCaptureDeviceInput.init(device: currentCaptureDevice)
            
            let captureOutput = AVCaptureVideoDataOutput()
            captureOutput.alwaysDiscardsLateVideoFrames = true
            captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInteractive))
            captureSession = AVCaptureSession()
            captureSession.sessionPreset = AVCaptureSession.Preset.high
            
            captureSession.addInput(captureInput)
            captureSession.addOutput(captureOutput)
            prevLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
            prevLayer.frame = view.frame
            prevLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            view.layer.insertSublayer(prevLayer, at: 0)
        }
        catch _{
            print("error")
        }
    }
    
    @IBAction func speak(_ sender: Any) {
        myUtterance = AVSpeechUtterance(string: "Bonjour tout le monde, je vais vous aider à mieux voir autour de vous.")
        myUtterance.rate = 0.5
        synth.speak(myUtterance)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let imageFinal = CIImage.init(cvImageBuffer: imageBuffer!)
    }
}

