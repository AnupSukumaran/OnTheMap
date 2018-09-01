//
//  OnTheMapViewController.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 27/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import MapKit

class OnTheMapViewController: UIViewController {

    var studentLocModel =  APIServices.shared.studentLocModel
    var annotations = [MKPointAnnotation]()
   
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndic: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       callingUserInfoAPI()
       
    }
    
    override func viewDidLayoutSubviews() {
        callingStudentLocationAPI()
    }
    
   
    
    func callingUserInfoAPI() {
        activityIndic.startAnimating()
        APIServices.shared.getUserInfo { (response) in
            switch response {
            case .Success(let data):
                print("data = \(data.first_name!)")
                APIServices.shared.userModel = data
                self.activityIndic.stopAnimating()
                
            case .Error(let error):
                self.activityIndic.stopAnimating()
                AlertView.showAlert(message: error, UIVIews: self)
            }
        }
    }
    
    func createAnnotations() {
        
        for dict in studentLocModel {
            
            let lat = CLLocationDegrees(dict.latitude ?? 0.0)
            let long = CLLocationDegrees(dict.longitude ?? 0.0)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dict.firstName ?? "[No First Name]"
            let last = dict.lastName ?? "[No Last Name]"
            let mediaURL = dict.mediaURL ?? "[No Media URL]"
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            self.annotations.append(annotation)
            
            
        }
        
        self.mapView.addAnnotations(annotations)
        
    }
    
    private func callingStudentLocationAPI() {
        
        APIServices.shared.getAllStudentLocation { (response) in
            switch response{
            case .Success(let data):
                print("data = \(data.studentLocModel[0].latitude!)")
               
                APIServices.shared.studentLocModel = data.studentLocModel
                self.studentLocModel = data.studentLocModel
                self.createAnnotations()
                self.toGetObjectID()
               
            case .Error(let error):
                AlertView.showAlert(message: error, UIVIews: self)
            }
        }
        
    }
    
    func toGetObjectID() {
        let filteredStudents = studentLocModel.filter{$0.uniqueKey == APIServices.shared.userModel!.key }
        
        if let objectid = filteredStudents[0].objectId {
            APIServices.shared.objectID = objectid
        } else {print("objectid Not found😩")}
    }
    
    
    @IBAction func logoutActon(_ sender: Any) {
        activityIndic.startAnimating()
        APIServices.shared.logOutFunc {
            self.activityIndic.stopAnimating()
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
        
        self.mapView.removeAnnotations(annotations)
        
        createAnnotations()
        
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

extension OnTheMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("maoAnnoations")
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
}
