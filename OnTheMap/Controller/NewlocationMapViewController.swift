//
//  NewlocationMapViewController.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 30/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit
import MapKit

class NewlocationMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    var address = "'"
    var website = ""
    var coordinates: CLLocationCoordinate2D!
    var userModel = APIServices.shared.userModel
    
    override func viewDidLoad() {
        super.viewDidLoad()

       createAnnotationsForMap()
    }
    
    
    func createAnnotationsForMap() {
        print("First Name = \(APIServices.shared.userModel?.first_name ?? "Notyyy")")
        guard let first = userModel?.first_name else {print(" firstName1😩");return}
        guard let last = userModel?.last_name else {print("last😩");return}
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = "\(first) \(last)"
        annotation.subtitle = website
        
        self.mapView.addAnnotation(annotation)
        
        
    }
    
    func callinglocationPostingApi(first: String, last: String, key: String) {
        APIServices.shared.postStudentLocation(uniqueKey: key, firstName: first, lastName: last, mapString: address, mediaURL: website, latitude: coordinates.latitude, longitude: coordinates.longitude) {(response) in
            switch response {
            case .Success(let data):
                print("objectId = \(data)")
                self.performSegue(withIdentifier: "unwindToHome", sender: self)
                
            case .Error(let error):
                AlertView.showAlert(message: error, UIVIews: self)
            }
        }
    }
    
    func callinglocationUpdateApi(first: String, last: String, key: String) {
        APIServices.shared.toUpdateUserLocation(objectID: APIServices.shared.objectID, uniqueKey: key, firstName: first, lastName: last, mapString: address, mediaURL: website, latitude: coordinates.latitude, longitude: coordinates.longitude) { (response) in
            switch response {
            case .Success(let data):
                print("Message = \(data)")
                self.performSegue(withIdentifier: "unwindToHome", sender: self)
                
            case .Error(let error):
                AlertView.showAlert(message: error, UIVIews: self)
            }
            
        }
    }
    
    @IBAction func finish(_ sender: Any) {
        
      guard let key = userModel?.key else {print("keyNotFound😩");return}
      guard let first = userModel?.first_name else {print(" firstName2😩");return}
      guard let last = userModel?.last_name else {print("last😩");return}
        self.performSegue(withIdentifier: "unwindToHome", sender: self)
        switchMethod(first: first, last: last, key: key)
    }
    
    func switchMethod(first: String, last: String, key: String) {
        
        switch APIServices.shared.overwrite {
        case true:
            print("Updating....")
            callinglocationUpdateApi(first: first, last: last, key: key)
        case false:
            print("Posting....")
            callinglocationPostingApi(first: first, last: last, key: key)
       
        }
        
    }
    
   

}

extension NewlocationMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0, alpha: 1)
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
