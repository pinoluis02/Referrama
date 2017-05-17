//
//  Networking.swift
//  ArchitectTest
//
//  Created by Luis Perez on 4/11/17.
//  Copyright © 2017 Luis Perez. All rights reserved.
//

import Foundation


class Networking{
    
    static let sharedInstance = Networking()
    
    var cookies: [HTTPCookie]?
    
    public func get( request: URLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "GET", completion: completion)
    }
    
    public func post( request: URLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "POST", completion: completion)
    }
    
    public func put( request: URLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "PUT", completion: completion)
    }
    
    public func delete( request: URLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "DELETE", completion: completion)
    }
    
    private func dataTask( request: URLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        var request = request
        request.httpMethod = method
//        let session = URLSession(configuration: URLSessionConfiguration.default)
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
//                    Networking.sharedInstance.setCookies(response: response)
                    completion(true, json as AnyObject)
                } else {
                    completion(false, json as AnyObject)
                }
            }
            }.resume()
    }
    
    private func setCookies(response: URLResponse) {
        let cookieHeaderField = ["Set-Cookie": "key=value"]
//        let cookies = HTTPCookieStorage.shared.cookies(for: response.url!)
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: response.url!)
        HTTPCookieStorage.shared.setCookies(cookies, for: response.url, mainDocumentURL: response.url)
//        self.cookies = cookies
        print("Cookies:\(cookies)")
    }
    
    public func clientURLRequest(path: String, params: [String: AnyObject]? = nil, token: String? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: path)!, cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        if let params = params {
//            var paramString = ""
//            for (key, value) in params {
//                let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//                let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//                paramString += "\(escapedKey)=\(escapedValue)&"
//            }
            
            do{
                let body = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                request.httpBody = body
            } catch let error {
                print(error)
            }
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
//            request.httpBody = paramString.data(using: String.Encoding.utf8)
        }
        
//        if let token = token {
//            request.addValue("Bearer "+token, forHTTPHeaderField: "Authorization")
//        }
//        if let cookies = HTTPCookieStorage.shared.cookies {
//            let headers = HTTPCookie.requestHeaderFields(with: cookies)
//            request.allHTTPHeaderFields = headers
//
////            request.setV alue(cookies, forHTTPHeaderField: "Set-Cookie")
//        }

            request.addValue("allow", forHTTPHeaderField: "Authorization")
        
        return request
    }
}


//let headers = [
//    "authorization": "allow",
//    "content-type": "application/json",
//    "cache-control": "no-cache"
//]
//let parameters = ["generated_phone": "+14703130474"] as [String : Any]
//do {
//    let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
//    
//    let request = NSMutableURLRequest(url: NSURL(string: "https://qs1l6iwb53.execute-api.us-east-1.amazonaws.com/prod/v1/api/referralcodes")! as URL,
//                                      cachePolicy: .useProtocolCachePolicy,
//                                      timeoutInterval: 10.0)
//    request.httpMethod = "POST"
//    request.allHTTPHeaderFields = headers
//    request.httpBody = postData as Data
//    
//    let session = URLSession.shared
//    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//        if (error != nil) {
//            print(error)
//        } else {
//            let httpResponse = response as? HTTPURLResponse
//            print(httpResponse)
//        }
//    })
//    
//    dataTask.resume()
//} catch{}
//
