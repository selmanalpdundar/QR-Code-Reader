//
//  WebViewController.swift
//  QR Code Reader
//
//  Created by Selman on 6/28/18.
//  Copyright © 2018 Selman. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, ResultProtocol{
   
    

    @IBOutlet var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scanPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showScanner", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showScanner" {
            let destinationVC = segue.destination as! ScannerViewController
            destinationVC.delegate = self
        }
    }
    
    func updateQRCodeResultLabe(type: String, value: String) {
        print(type)
        resultLabel.text = "Type of Code : " + type + " and Value of Code : " + value
    }
}
