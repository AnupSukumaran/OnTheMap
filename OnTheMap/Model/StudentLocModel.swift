//
//  StudentLocModel.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 28/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation


class StudentLocModel {
    
    let objectId: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let uniqueKey: String?
    let mediaURL: String?
    let mapString: String?
    let createdAt: String?
    let updatedAt: String?
    
    init?(json: JSON) {
        
        let objectId = json[StudentKeys.objectId] as? String
        let firstName = json[StudentKeys.firstName] as? String
        let lastName = json[StudentKeys.lastName] as? String
        let latitude = json[StudentKeys.latitude] as? Double
        let longitude = json[StudentKeys.longitude] as? Double
        let uniqueKey = json[StudentKeys.uniqueKey] as? String
        let mediaURL = json[StudentKeys.mediaURL] as? String
        let mapString = json[StudentKeys.mapString] as? String
        let createdAt = json[StudentKeys.createdAt] as? String
        let updatedAt = json[StudentKeys.updatedAt] as? String
        
        
        self.objectId = objectId
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.uniqueKey = uniqueKey
        self.mediaURL = mediaURL
        self.mapString = mapString
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
    }
    
    
}
