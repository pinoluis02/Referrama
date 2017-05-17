//
//  WebServiceManager.swift
//  ArchitectTest
//
//  Created by Luis Perez on 4/11/17.
//  Copyright © 2017 Luis Perez. All rights reserved.
//

import Foundation


class WebServiceManager{
    
    static let sharedInstance = WebServiceManager()
    var token: String?
    let baseURLString = "https://qs1l6iwb53.execute-api.us-east-1.amazonaws.com/prod/v1/api"
    
    //MARK: LOGIN
    func login(email: String, password: String, completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let loginObject = ["store_email": email, "password": password]
        
        Networking.sharedInstance.post(request: Networking.sharedInstance.clientURLRequest(path: "\(baseURLString)/login", params: loginObject as [String : AnyObject])) { (success, object) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    completion(true, nil)
                } else {
                    var message = "there was an error"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    completion(false, message)
                }
            })
        }
    }
    
    //MARK: GET - GetReferralCode
    func getRPComments(qrCode: String, completion: @escaping (_ success: Bool, _ message: String?, _ referalCode: ReferalCode?) -> ()) {
        Networking.sharedInstance.get(request: Networking.sharedInstance.clientURLRequest(path: "\(baseURLString)/referralcodes/\(qrCode)")) { (success, object) -> () in
                if success {
                    if let object = object as? [String: AnyObject] {
                        let parsedReferalCode = ReferalCode.jsonToObj(json: object)
                            
                            DispatchQueue.main.async {
                                completion(true, nil, parsedReferalCode)
                            }
                    }else{
                        DispatchQueue.main.async {
                            completion(false, nil, nil)
                        }
                    }
                } else {
                    var message = "there was an error"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    DispatchQueue.main.async {
                        completion(false, message, nil)
                    }
                }
            }
        }
    
    //MARK: DELETE
//    func deleteRPCommentBy(id: Int, completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
//        Networking.sharedInstance.delete(request: Networking.sharedInstance.clientURLRequest(path: "\(baseURLString)/rpcomments/\(id)")) { (success, object) -> () in
//            DispatchQueue.main.async(execute: { () -> Void in
//                if success {
//                    completion(true, nil)
//                } else {
//                    var message = "there was an error Deleting"
//                    if let object = object, let passedMessage = object["message"] as? String {
//                        message = passedMessage
//                    }
//                    completion(true, message)
//                }
//            })
//        }
//    }
    
    
    
    //MARK: PUT - useOriginatorCode
    func useOriginatorCode(qrCode: String, completion: @escaping ( _ status: Bool, _ message: String?) -> Void){
        let route = parseQRCode(qrCodeString: qrCode)
        let url = "\(baseURLString)/\(route)"
        
        Networking.sharedInstance.put(request: Networking.sharedInstance.clientURLRequest(path: url)) { (success, object) -> () in
            if success {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                var message = "there was an error"
                if let object = object, let passedMessage = object["message"] as? String {
                    message = passedMessage
                }
                DispatchQueue.main.async {
                    completion(false, message)
                }
            }
        }
    }
    
    //MARK: PUT - useReferralCode
    func useReferralCode(qrCode: String, completion: @escaping ( _ status: Bool, _ message: String?) -> Void){
        
        let route = parseQRCode(qrCodeString: qrCode)
        let url = "\(baseURLString)/\(route)"
        
        Networking.sharedInstance.put(request: Networking.sharedInstance.clientURLRequest(path: url)) { (success, object) -> () in
            if success {
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
            } else {
                var message = "there was an error"
                if let object = object, let passedMessage = object["message"] as? String {
                    message = passedMessage
                }
                DispatchQueue.main.async {
                    completion(false, message)
                }
            }
        }
    }
    
    //MARK: Helper func to parse QRCode
    // example: 1 fgeryt54y5y45
    func parseQRCode(qrCodeString: String) -> String{
        
        let qrCodeSplit = qrCodeString.components(separatedBy: " ")
        let typeRoute = qrCodeSplit[0]
        let code = qrCodeSplit[1]
        var route = ""
        
        if typeRoute == "1"{
            route = "referralcodes"
        } else{
            route = "originatorcodes"
        }
        
        return "\(route)/\(code)"
    }
    
    //MARK: POST - GenerateReferralCode
    func generateReferralCode(phone: String, completion: @escaping ( _ status: Bool, _ message: String?) -> Void){
        
        let url = "\(baseURLString)/referralcodes"
        let params = ["generated_phone": phone] as [String : Any]
        
        Networking.sharedInstance.post(request: Networking.sharedInstance.clientURLRequest(path: url, params: params as [String : AnyObject])) { (success, object) -> () in
            if success {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                var message = "there was an error"
                if let object = object, let passedMessage = object["message"] as? String {
                    message = passedMessage
                }
                DispatchQueue.main.async {
                    completion(false, message)
                }
            }
        }
    }


    
}
