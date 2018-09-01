//
//  CommonClassResponse.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 24/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import Foundation

struct CommonClassResponse {
    
    var studentLocModel = [StudentLocModel]()
    
    init(json: JSON) {
        
        guard let results = json["results"] as? [JSON] else {print("results😩");return}
        
        let resultsArray = results.map {StudentLocModel(json: $0)}.compactMap {$0}
        
        studentLocModel = resultsArray
        
    }
    
}
