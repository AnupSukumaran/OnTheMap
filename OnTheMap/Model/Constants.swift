//
//  Constants.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 27/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation
import UIKit


let storyBRD = UIStoryboard(name: "Main", bundle: nil)

struct Constants {
    
    static let baseUrlSession = "https://www.udacity.com/api/session"
    static let baseUrlStudentLoc = "https://parse.udacity.com/parse/classes/StudentLocation"
    
    static let parseAppIdValue = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let restApiIdValue = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    static let parseAppIDKey = "X-Parse-Application-Id"
    static let parseRestAPIKey = "X-Parse-REST-API-Key"
    
    static let signUpURL = "https://auth.udacity.com/sign-up"
    
}


struct StudentKeys {
    
    static let objectId = "objectId"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let uniqueKey = "uniqueKey"
    static let mediaURL = "mediaURL"
    static let mapString = "mapString"
    static let createdAt = "createdAt"
    static let updatedAt = "updatedAt"
    
}

struct usersKeys {
    
    static let last_name = "last_name"
    static let first_name = "first_name"
    static let key = "key"
    
    
}


