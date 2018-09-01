//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 29/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var websiteTF: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var coordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTF.delegate = self
        websiteTF.delegate = self
        
        self.locationTF.text = "kaloor"
        self.websiteTF.text = "http://www.google.com"
        
        self.scrollView.isScrollEnabled = false
    }
    
    
    

  private func findLocation(place: String)  {
    
        let address = place
        let geoCoder = CLGeocoder()
    
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            
            guard error == nil else {
                AlertView.showAlert(message: (error?.localizedDescription)!, UIVIews: self); return
            }
            
            guard let placemarks = placemarks, let location = placemarks.first?.location else {print("loca😩");return}
            
            self.coordinates = location.coordinate
           self.performSegue(withIdentifier: "findLocation", sender: nil)
        }
        
    }
    
    func validation() -> Bool {
        
        if (locationTF.text?.isEmpty)! || (websiteTF.text?.isEmpty)! {
            print("false")
            return false
        } else {
            print("true")
            return checkEnterLinkFormat()
        }
        
    }
    
    
    func checkEnterLinkFormat() -> Bool{
        
        guard websiteTF.text!.hasPrefix("https://") || websiteTF.text!.hasPrefix("http://") else {
            
            AlertView.showAlert(message: "Invalid Link. Include HTTP(S):// ", UIVIews: self)
            print("Not validURLs")
            return false
            
        }
        return true
    }
    
    
 
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("dataa")
        let vc = segue.destination as! NewlocationMapViewController

        vc.website = self.websiteTF.text!
        vc.coordinates = self.coordinates
        
        vc.address = self.locationTF.text!
    }
    
    
    @IBAction func findLocation(_ sender: Any) {
        
                guard validation() == true else
                { AlertView.showAlert(message: "Empty Address or Website", UIVIews: self);return }

                findLocation(place: self.locationTF.text!)
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        self.locationTF.resignFirstResponder()
        self.websiteTF.resignFirstResponder()
    }
    

}

extension AddLocationViewController: UITextFieldDelegate {
    
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


