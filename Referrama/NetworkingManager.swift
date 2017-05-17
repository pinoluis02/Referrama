//
//  NetworkingManager.swift
//  Referrama
//
//  Created by Luis on 4/26/17.
//  Copyright © 2017 LuisPerez. All rights reserved.
//

import Foundation


//let urlString = "https://qs1l6iwb53.execute-api.us-east-1.amazonaws.com/prod/v1/api/stores/%@/referralcodes/%@"
let urlString = "https://qs1l6iwb53.execute-api.us-east-1.amazonaws.com/prod/v1/api/"



//58eb060fc6ce1f00097a008c
//5902891f4a02370013386967


// GET - GetReferralCode
// referralcodes/ :code
//{
//        "created_timestamp": "May 9, 2017 1:57 PM",
//        "expiration_date": "May 16, 2017 1:57 PM",
//        "generated_phone": "+14703130474",
//        "last_updated_timestamp": "May 9, 2017 1:57 PM",
//        "referral_code_id": "5911cadcd84065006c7dc81c",
//        "referral_code_pk": 5,
//        "store_id": "59021b5369c9e30013d404ca",
//        "used_count": 0,
//        "verification_code": 781044,
//        "verification_code_display": "78 10 44"
//}


// Cookies
// name = access_token
// value = eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvYmplY3RzIjp7InN0b3JlX2VtYWlsIjoibGFmZXRlQGdtYWlsLmNvbSIsInN0b3JlX2lkIjoiNTkwMjFiNTM2OWM5ZTMwMDEzZDQwNGNhIn0sImV4cCI6MTQ5NDM0MTc3MiwiaXNzIjoicmVmZXJyYWxhcHAifQ.AGMXUYPZL7qoWbjSrdSpFpO5R0YGfu-w61O1a1iKa8U



class NetworkingManager {
    
    static let sharedSession = NetworkingManager()
    
    
    func validateQRCode(qrCode: String, completionHandler: @escaping ( _ status: Bool, _ message: String?) -> Void){
        
        
            let qrCodeSplit = qrCode.components(separatedBy: " ")
            let typeRoute = qrCodeSplit[0]
            let code = qrCodeSplit[1]
            var route = ""
        
            if typeRoute == "1"{
                route = "referralcodes/%@"
            } else{
                route = "originatorcodes/%@"
            }
        
            let url = URL(string: "\(urlString)\(String(format: route, code))")
            let session = URLSession.shared
        
        
            var params = [NSString: AnyObject]()
            params["generated_phone"] = "+14048204571" as AnyObject
        
        
            var request = URLRequest(url: url!)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        
//            do{
//                let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
//                request.httpBody = body
//            } catch let error {
//                print(error)
//            }
        
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                    completionHandler(false, nil)
                } else {
                    do {

                        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject?]
                        OperationQueue.main.addOperation {
                            
                            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                                var message = "Success"
                                if let json = json as? [String: AnyObject?]{
                                 message = json["message"] as? String ?? "Success"
                                }
                                completionHandler(true, message)
                            } else {
                                completionHandler(false, "Fail!")
                            }
                        }
                        
                    } catch let error {
                        print(error)
                        completionHandler(false, nil)
                    }

                }
            })
            task.resume()
        }

        
    }
    
