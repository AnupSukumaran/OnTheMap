//
//  SessionModel.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 23/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation

class SessionModel {
    
    let registered: Bool?
    let key: String?
    let id: String?
    let expiration: String?
    
    init?(json: JSON) {
        let registered = json["registered"] as? Bool
        let key = json["key"] as? String
        let id = json["id"] as? String
        let expiration = json["expiration"] as? String
        
        self.registered = registered
        self.key = key
        self.id = id
        self.expiration = expiration
    }
    
}
