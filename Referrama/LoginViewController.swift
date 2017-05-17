//
//  LoginViewController.swift
//  Referrama
//
//  Created by Luis on 5/9/17.
//  Copyright © 2017 LuisPerez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var switchRememberMe: UISwitch!
    @IBOutlet weak var switchEnableTouchID: UISwitch!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtUsername.text = "lafete@gmail.com"
        self.txtPassword.text = "givemefood"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func attemptToLogin(_ sender: Any) {
        if let email = self.txtUsername.text, let pass = self.txtPassword.text{
            WebServiceManager.sharedInstance.login(email: email, password: pass, completion: {(success, message) in
                if success{
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeViewController")
                    self.present(vc, animated: true, completion: nil)
                } else{
                    self.showAlert(title: "Error", message: "There was a problem authenticating")
                }
            
            })
        }
        
    }

    
    // MARK: Alert function
    func showAlert(title: String, message: String){
        
        let alertWithActions: UIAlertController = UIAlertController(title: title,
                                                                    message: message,
                                                                    preferredStyle: UIAlertControllerStyle.alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: {
                                                        alertAction in
                                                        alertWithActions.dismiss(animated: true, completion: nil)
                                                        self.dismiss(animated: true, completion: nil)
        })
        alertWithActions.addAction(okAction)
        present(alertWithActions, animated: true, completion: nil)
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
