//
//  LogInViewController.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 23/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTX: UITextField!
    @IBOutlet weak var passwordTX: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

   
    @IBOutlet weak var activityIndic: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTX.text = "anup.sukumaran9@gmail.com"
        self.passwordTX.text = "puna9119"
       
        self.scrollView.isScrollEnabled = false
        self.setDelegatesTX()
    }
    
    
    func setDelegatesTX() {
        self.usernameTX.delegate = self
        self.passwordTX.delegate = self
    }

  


    func loginAPICall() {
        
        guard validation() == true else
        { AlertView.showAlert(message: "Empty Email or Password", UIVIews: self);return }
        activityIndic.startAnimating()
        APIServices.shared.logInAPI(username: usernameTX.text!, password: passwordTX.text!) { (response) in
            switch response {
            case .Success(let data):
                self.activityIndic.stopAnimating()
                APIServices.shared.sessionDetails = data
                self.callTabController()
            
            case .Error(let error):
                self.activityIndic.stopAnimating()
                AlertView.showAlert(message: error, UIVIews: self)
            }
        }
    }
    
    func callTabController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabbarIdentifier") as! UITabBarController
        
        
        self.present(tabbarVC, animated: true, completion: nil)

    }
    
    func validation() -> Bool {
        if (usernameTX.text?.isEmpty)! || (passwordTX.text?.isEmpty)! {
            print("false")
            return false
        } else {
            print("true")
            return true
        }
        
    }
    
    
    
    @IBAction func loginAction(_ sender: Any) {
       loginAPICall()
        
    }
    
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
       self.passwordTX.resignFirstResponder()
        self.usernameTX.resignFirstResponder()
       
    }
    
    @IBAction func SignUpAction(_ sender: Any) {
        
        guard let url = URL(string: Constants.signUpURL) else {
            
            AlertView.showAlert(message: "not a valid link ", UIVIews: self)
            print("Not validURLs")
            return
            
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    

}


extension LogInViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollView.isScrollEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        self.scrollView.isScrollEnabled = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
