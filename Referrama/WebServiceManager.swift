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
    let baseURLString = "http://api.com"
    
    //MARK: LOGIN
    func login(email: String, password: String, completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let loginObject = ["email": email, "password": password]
        
        Networking.sharedInstance.post(request: Networking.sharedInstance.clientURLRequest(path: "\(baseURLString)/auth", params: loginObject as [String : AnyObject])) { (success, object) -> () in
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
    
    //MARK: GET
    func getRPComments(completion: @escaping (_ success: Bool, _ message: String?, _ RPComment: RPComment?) -> ()) {
        Networking.sharedInstance.get(request: Networking.sharedInstance.clientURLRequest(path: "\(baseURLString)/rpcomments")) { (success, object) -> () in
                if success {
                    if let object = object, let jsonArray = object["rpcomments"] as? [[String: AnyObject]]{
                        
                        for item in jsonArray {
                            let parsedComment = RPComment.rpcommentFrom(json: item)
                            
                            DispatchQueue.main.async {
                                completion(true, nil, parsedComment)
                            }
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
    func deleteRPCommentBy(id: Int, completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        Networking.sharedInstance.delete(request: Networking.sharedInstance.clientURLRequest(path: "\(baseURLString)/rpcomments/\(id)")) { (success, object) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    completion(true, nil)
                } else {
                    var message = "there was an error Deleting"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    completion(true, message)
                }
            })
        }
    }

    
}
