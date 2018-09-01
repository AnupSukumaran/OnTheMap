//
//  StudentTableViewCell.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 29/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var link: UILabel!
    
    func config(studentLocModel: StudentLocModel) {
        
        let first = studentLocModel.firstName ?? "[No First Name]"
        let last = studentLocModel.lastName ?? "[No Last Name]"
        let linkTo = studentLocModel.mediaURL ?? "[No Media URL]"
        
        self.studentName.text = "\(first) \(last)"
        self.link.text = linkTo
        
    }

}
