//
//  QRCodeViewController.swift
//  Referrama
//
//  Created by Luis Rufino Perez Romero on 4/23/17.
//  Copyright © 2017 LuisPerez. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPhone" {
            let destinationVC = segue.destination as! GenerateQRCodeViewController
            destinationVC.typeService = .Phone
        }
        
        if segue.identifier == "showEmail" {
            let destinationVC = segue.destination as! GenerateQRCodeViewController
            destinationVC.typeService = .Email
        }
    }
 

}
