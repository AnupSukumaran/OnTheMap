//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 27/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController {
    
    var studentLocModel = [StudentLocModel]()
    
    @IBOutlet weak var studentsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.studentLocModel = APIServices.shared.studentLocModel
    }
    
    
    

    
    @IBAction func logoutActon(_ sender: Any) {
        APIServices.shared.logOutFunc {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func AddLocationAction(_ sender: Any) {
        
        guard !toCheckUserAlredyExists() else {
            
            let message = "User \(APIServices.shared.userModel!.first_name!) \(APIServices.shared.userModel!.last_name!) has already posted a student location. would you like to overwrite their location?"
            
            AlertView.showAlert2(message: message, UIVIews: self) {
                self.callingAddLocationVC()
                APIServices.shared.overwrite = true
            }
            return
            
        }
        
        callingAddLocationVC()
        
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        
        studentsTable.reloadData()
        
    }
    
    func callingAddLocationVC() {
        let vc = storyBRD.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        
        
        
        let nav = UINavigationController(rootViewController: vc)
        
        
        present(nav, animated: true, completion: nil)
        
    }
    
    func toCheckUserAlredyExists() -> Bool {
        
        let firstNames = studentLocModel.map{ $0.firstName }.compactMap{$0}
        let lastNames = studentLocModel.map{$0.lastName}.compactMap{$0}
        
        guard let first = APIServices.shared.userModel?.first_name else {print(" no first names😩"); return false}
        guard let last = APIServices.shared.userModel?.last_name else {print("no last name😩");return false}
        
        if firstNames.contains(first) && lastNames.contains(last) {
            return true
        } else {
            return false
        }
        
    }


}

extension LocationListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("studentModel = \(studentLocModel.count)")
        return studentLocModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath) as! StudentTableViewCell
        
        cell.config(studentLocModel: studentLocModel[indexPath.row])
        
        return cell
    }
    
  
}

extension LocationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let urlString = studentLocModel[indexPath.row].mediaURL else {print("mediaURL😩");return}
        
        guard urlString.hasPrefix("https://") || urlString.hasPrefix("http://") else {
            
            AlertView.showAlert(message: "not a valid link ", UIVIews: self)
            print("Not validURLs")
            return
            
        }
        
        guard let url = URL(string: urlString) else {
            
            AlertView.showAlert(message: "not a valid link ", UIVIews: self)
            print("Not validURLs")
            return
            
        }
       
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
