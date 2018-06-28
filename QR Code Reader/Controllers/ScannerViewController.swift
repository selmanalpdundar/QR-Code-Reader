//
//  ViewController.swift
//  QR Code Reader
//
//  Created by Selman on 6/28/18.
//  Copyright © 2018 Selman. All rights reserved.
//

import UIKit


import AVFoundation

protocol ResultProtocol{
    func updateQRCodeResultLabe(type : String , value : String)
}

class ScannerViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate  {
    
    var delegate : ResultProtocol?
    
    // videoPreview
    @IBOutlet var videoPreview: UIView!

    
    // Create a capture session
    let avCaptureSession = AVCaptureSession()

    enum error: Error {
        case noCameraAvaiblee
        case videoInputInitFail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        do {
            try scanQRCode()
        } catch {
            print("Failed to scan the QR/Barcode.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }


    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
   
        // check there is any object
        if metadataObjects.count  > 0 {
            // take first object
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            switch machineReadableCode.type {
            case AVMetadataObject.ObjectType.qr :
                avCaptureSession.stopRunning()
                delegate?.updateQRCodeResultLabe(type: "QR Code", value: machineReadableCode.stringValue!)
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            default:
                delegate?.updateQRCodeResultLabe(type: "Error", value: "")
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            }
    
        }
    }
  
    
    //Step 4 create qr code scann function
    func scanQRCode() throws {
        
        // declarate a type device for what progress
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("There is no camere")
            throw error.noCameraAvaiblee
        }

        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("faild to init camera")
            throw error.videoInputInitFail
        }
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let avCaptureVidePreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        
        avCaptureVidePreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVidePreviewLayer.frame = videoPreview.bounds
        self.videoPreview.layer.addSublayer(avCaptureVidePreviewLayer)
        avCaptureSession.startRunning()
        
    }
    


    
}

