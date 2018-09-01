//
//  UserModel.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 30/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation


class UserModel {
    
    let first_name: String?
    let last_name: String?
    let key: String?
    
    init?(json: JSON) {
        
        let first_name = json[usersKeys.first_name] as? String
        let last_name = json[usersKeys.last_name] as? String
        let key = json[usersKeys.key] as? String
        
        self.first_name = first_name
        self.last_name = last_name
        self.key = key
        
    }
    
}
