//
//  GenerateQRCodeViewController.swift
//  Referrama
//
//  Created by Luis on 5/8/17.
//  Copyright © 2017 LuisPerez. All rights reserved.
//

import UIKit
import MessageUI

enum typeService: String{
    case Phone, Email
}

class GenerateQRCodeViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    
    var typeService: typeService?
    var textMessage = "Forward this code to your friends and get rewarded when it is used"
    var qrCode = String()
    
    @IBOutlet weak var txtInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.typeService == .Phone{
            self.txtInput.placeholder = "+1123-456-7890"
            self.txtInput.keyboardType = .phonePad
        }
        if self.typeService == .Email{
            self.txtInput.placeholder = "example@domain.com"
            self.txtInput.keyboardType = .emailAddress
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAndDismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func sendCodeToUser(_ sender: Any) {
        
        guard let input = self.txtInput.text, input.characters.count > 0 else {
            showAlert(title: "Warning!", message: "Please insert input.")
            return
        }
        
        guard let type = self.typeService else{
            return
        }
        
        if type == .Email{
            //TODO: Validate Email
            sendTo(email: input)
        }
        
        if type == .Phone{
            //TODO: Validate Phone
            WebServiceManager.sharedInstance.generateReferralCode(phone: input, completion: { (success, message) in
                if success{
                    print("Message was sent")
                    self.showAlert(title: "Success", message: "Message sent! :)")
                } else{
                    print("Message failed")
                    self.showAlert(title: "Success", message: "Message failed! :(")
                }
            })
//            sendTo(phone: input)
        }
    }
    
    // MARK: send To Phone
    func sendTo(phone: String){
       
        let messageVC = MFMessageComposeViewController()
        messageVC.body = textMessage
        messageVC.recipients = [phone]
        messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: false, completion: nil)
    }
    
    // MARK: Delegate messageCompose Callback - didFinishWith
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            showAlert(title: "Success", message: "Message failed! :(")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
            showAlert(title: "Success", message: "Message sent! :)")
            self.dismiss(animated: false, completion: nil)
        default:
            break;
        }
    }
    
    // MARK: send To Email
    func sendTo(email: String){
        
        let composer = MFMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            composer.mailComposeDelegate = self
            composer.setToRecipients([email])
            composer.setSubject("Test Mail")
            composer.setMessageBody(textMessage, isHTML: false)
            present(composer, animated: true, completion: nil)
        }
    }
    
    // MARK: mailCompose Delegate Callback - didFinishWithResult
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        switch (result.rawValue) {
        case MFMailComposeResult.cancelled.rawValue:
            print("Email was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.failed.rawValue:
            print("Email failed")
            showAlert(title: "Success", message: "Email failed! :(")
            self.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent.rawValue:
            print("Email was sent")
            self.dismiss(animated: true, completion: nil)
            showAlert(title: "Success", message: "Email sent! :)")
            self.dismiss(animated: false, completion: nil)
        default:
            break;
        }
        
        
//        // Dismiss the mail compose view controller.
//        controller.dismiss(animated: true, completion: nil)
//        showAlert(title: "Success", message: "Message sent! :)")
//        self.dismiss(animated: false, completion: nil)
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
