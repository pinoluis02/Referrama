//
//  ReferalCode.swift
//  Referrama
//
//  Created by Luis on 5/9/17.
//  Copyright © 2017 LuisPerez. All rights reserved.
//

import Foundation


class ReferalCode {
    
    
//    "created_timestamp": "May 9, 2017 1:57 PM",
    //        "expiration_date": "May 16, 2017 1:57 PM",
    //        "generated_phone": "+14703130474",
    //        "last_updated_timestamp": "May 9, 2017 1:57 PM",
    //        "referral_code_id": "5911cadcd84065006c7dc81c",
    //        "referral_code_pk": 5,
    //        "store_id": "59021b5369c9e30013d404ca",
    //        "used_count": 0,
    //        "verification_code": 781044,
    //        "verification_code_display": "78 10 44"
    
    var referralCodeId = String()
    var storeId = String()
    var createdTimestamp: String?
    var expirationDate: String?
    var generatedPhone: String?
    var usedCount: Int?

    
    struct Keys{
        static let referralCodeId = "referral_code_id"
        static let storeId = "store_id"
        static let createdTimestamp = "created_timestamp"
        static let expirationDate = "expiration_date"
        static let generatedPhone = "generated_phone"
        static let usedCount = "used_count"
        static let lastUpdatedTimestamp = "last_updated_timestamp"
        static let referralCodePk = "referral_code_pk"
        static let verificationCode = "verification_code"
        static let verificationCodeDisplay = "verification_code_display"
    }
    
    init(){
        
    }
    
    func objToJson() -> [String: AnyObject]{
        var params:[String: AnyObject] = [String: AnyObject]()
        params[Keys.referralCodeId] = self.referralCodeId as AnyObject?
        params[Keys.storeId] = self.expirationDate as AnyObject?
        params[Keys.expirationDate] = self.expirationDate as AnyObject?
        params[Keys.generatedPhone] = self.expirationDate as AnyObject?
        params[Keys.usedCount] = self.expirationDate as AnyObject?
        params[Keys.createdTimestamp] = self.expirationDate as AnyObject?
        return params
    }
    
    
    class func jsonToObj(json: [String: AnyObject]) -> ReferalCode{
        let referalCode = ReferalCode()
        referalCode.referralCodeId   = json[Keys.referralCodeId] as? String ?? ""
        referalCode.storeId          = json[Keys.storeId] as? String ?? ""
        referalCode.expirationDate   = json[Keys.expirationDate] as? String ?? ""
        referalCode.generatedPhone   = json[Keys.generatedPhone] as? String ?? ""
        referalCode.usedCount        = json[Keys.usedCount] as? Int ?? 0
        referalCode.createdTimestamp = json[Keys.createdTimestamp] as? String ?? ""
        return referalCode
    }

    
}
