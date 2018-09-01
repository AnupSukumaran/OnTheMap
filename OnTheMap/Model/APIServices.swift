//
//  APIServices.swift
//  OnTheMap
//
//  Created by Sukumar Anup Sukumaran on 23/08/18.
//  Copyright © 2018 TechTonic. All rights reserved.
//

import UIKit

class APIServices: NSObject {
    
   static let shared = APIServices()
    
    var overwrite: Bool = false
    
    var session = URLSession.shared
    
    var sessionDetails:SessionModel!
    
    var userModel:UserModel?
    
    var studentLocModel = [StudentLocModel]()
    
    var username = ""
    var objectID = ""
    
    //MARK: func To MakeQuery Items For Url
    private func urlWithParameters(urlString: String, _ parameters: JSON, withPathExtension: String? = nil) -> URL? {
        
        var urlForm = URLComponents(string: urlString)
        urlForm?.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let qItem = URLQueryItem(name: key, value: "\(value)")
            urlForm?.queryItems?.append(qItem)
        }
        
        return urlForm?.url
        
    }
    //MARK: func For Get Method
    
    func getMethod(request: URLRequest, completionBlk: @escaping(Result<AnyObject>) -> ()) -> URLSessionDataTask {
        

        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {print("Error 😩");return}
            guard let data = data else {print("data😩");return}
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionBlk(.Error("Error :( status code -> \((response as! HTTPURLResponse).statusCode)"))
                return
            }
            
            self.convertDataToObject(data, completionBlk: completionBlk)
            
        }
        
        task.resume()
        
        return task
    }
    
    //MARK: func For Post Method
    func postMethod( request: URLRequest, jsonBody: String, completionBlk: @escaping(Result<AnyObject>) -> ()) -> URLSessionDataTask {
        
        
        var request = request
        request.httpMethod = "POST"
       
        
        request.httpBody = jsonBody.data(using: .utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {print("Error 😩");return}
            guard let data = data else {print("data😩");return}
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionBlk(.Error("Error :( status code -> \((response as! HTTPURLResponse).statusCode)"))
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            self.convertDataToObject(newData, completionBlk: completionBlk)
            
        }
       task.resume()
       
        return task
    }
    
    func postMethod2( request: URLRequest, jsonBody: String, completionBlk: @escaping(Result<AnyObject>) -> ()) -> URLSessionDataTask {
        
        
        var request = request
        request.httpMethod = "POST"
        
        
        request.httpBody = jsonBody.data(using: .utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {print("Error 😩");return}
            guard let data = data else {print("data😩");return}
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionBlk(.Error("Error :( status code -> \((response as! HTTPURLResponse).statusCode)"))
                return
            }
            
            self.convertDataToObject(data, completionBlk: completionBlk)
            
        }
        task.resume()
        
        return task
    }
    
    
    func putMethod( request: URLRequest, jsonBody: String, completionBlk: @escaping(Result<AnyObject>) -> ()) -> URLSessionDataTask {
        
        
        var request = request
        request.httpMethod = "PUT"
        
        
        request.httpBody = jsonBody.data(using: .utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {print("Error 😩");return}
            guard let data = data else {print("data😩");return}
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionBlk(.Error("Error :( status code -> \((response as! HTTPURLResponse).statusCode)"))
                return
            }
            
            self.convertDataToObject(data, completionBlk: completionBlk)
            
        }
        task.resume()
        
        return task
    }
    
    
    //MARK: func To make JSONSerialization objects
    private func convertDataToObject(_ data: Data, completionBlk: @escaping(Result<AnyObject>) -> ()) {
        
        var parsedResult: AnyObject! = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
             completionBlk(.Success(parsedResult))
        } catch let error  {
            completionBlk(.Error(error.localizedDescription))
        }
        
       
    }
   
    
    ////////////////////////////////////////////

    //MARK: func To Call Login API
    func logInAPI(username: String, password: String, completionBlk: @escaping(Result<SessionModel>) -> ()) {
        
        let jsonBody = "{\"udacity\":{\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        guard let url = URL(string: Constants.baseUrlSession) else {print("url😩");return }
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let _ = postMethod(request: request, jsonBody: jsonBody) { (response) in
           
            switch response {
            case .Success(let data):
                print("dataNew = \(data)")
                let jsonData = data as! JSON
                
                var account = JSON()
                
                guard let acc = jsonData["account"] as? JSON, let sessionData = jsonData["session"] as? JSON else {
                    guard let error = jsonData["error"] as? String else {return}
                    DispatchQueue.main.async {
                        completionBlk(.Error(error))
                    }
                    return
                }
                account = acc
                
                for (key, value) in sessionData {
                    account.updateValue(value, forKey: key)
                }
                
                guard let sessionModel = SessionModel(json: account) else {print(" sessionFailed😩");return}
                
                DispatchQueue.main.async {
                    completionBlk(.Success(sessionModel))
                }
                
                
                
            case .Error(let error):
                print("error = \(error)")
                 DispatchQueue.main.async {
                    completionBlk(.Error(error))
                }
                
            }
        }
   
    }
    
    //MARK: func To Call LogOut API
    
    func logOutFunc(completionBLK: @escaping() -> ()) {
        
        var request = URLRequest(url: URL(string: Constants.baseUrlSession)!)
        
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {print("error😩");return}
            guard let data = data else {print("data😩");return}
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("ERROR => \((response as! HTTPURLResponse).statusCode)")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            self.convertDataToObject(newData, completionBlk: { (response) in
                
                switch response {
                case .Success(_):
                   
                    DispatchQueue.main.async {
                        completionBLK()
                    }
                    
                case .Error(let error):
                    print("erorr = \(error)")
                }
                
            })
            
        }
        
        task.resume()
    }
    
    func getAllStudentLocation(completionBlk: @escaping(Result<CommonClassResponse>) -> ()) {
        
        
        guard let url = URL(string: Constants.baseUrlStudentLoc) else {print("url😩");return }
        
        let params = ["limit": 100]
        guard  let newURL = urlWithParameters(urlString: Constants.baseUrlStudentLoc, params as JSON) else {return}
        var request = URLRequest(url: newURL)
        
        request.addValue(Constants.parseAppIdValue, forHTTPHeaderField: Constants.parseAppIDKey)
        request.addValue(Constants.restApiIdValue, forHTTPHeaderField: Constants.parseRestAPIKey)
        
        let _ = getMethod(request: request) { (response) in
            switch response {
            case .Success(let data):

                
                let studentsData = CommonClassResponse(json: data as! JSON)
                
                DispatchQueue.main.async {
                    completionBlk(.Success(studentsData))
                }
                
                
            case .Error(let error):
                DispatchQueue.main.async {
                     completionBlk(.Error(error))
                }
               
            }
        }
        
    }
    
    func postStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionBLK: @escaping(Result<String>) -> ()) {
        
        print("{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}")
        
        var request = URLRequest(url: URL(string: Constants.baseUrlStudentLoc)!)
        
        request.addValue(Constants.parseAppIdValue, forHTTPHeaderField: Constants.parseAppIDKey)
        request.addValue(Constants.restApiIdValue, forHTTPHeaderField: Constants.parseRestAPIKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        let _ = postMethod2(request: request, jsonBody: jsonBody) { (response) in
            switch response {
            case .Success(let data):
                
                let jsonData = data as! JSON
                guard let objectId = jsonData[StudentKeys.objectId] as? String else {
                    completionBLK(.Error("Failed to post location"))
                    return
                }
                DispatchQueue.main.async {
                    completionBLK(.Success(objectId))
                }
                
                
            case .Error(let error):
                DispatchQueue.main.async {
                    completionBLK(.Error(error))
                }
                
            }
        }
    }
    
    func getUserInfo(completionBLK: @escaping(Result<UserModel>) -> ()) {
        
        guard let uniqueID = APIServices.shared.sessionDetails.key else {return}
        print("UniqurID = \(uniqueID)")
        let userDetailsURL = "https://www.udacity.com/api/users/\(uniqueID)"
        
        guard let url = URL(string: userDetailsURL) else {print("url😩");return }

        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {print("Error 😩");return}
            guard let data = data else {print("data😩");return}
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            self.convertDataToObject(newData, completionBlk: { (response) in
                switch response {
                case .Success(let data):
                    
                    let jsonData = data as! JSON
                    
                    guard let user = jsonData["user"] as? JSON else {print("UserData😩");return}
                    
                    guard let modelData = UserModel(json: user) else {print("data missing😩");return}
                    
                    DispatchQueue.main.async {
                         completionBLK(.Success(modelData))
                    }
                   
                    
                case .Error(let error):
                    DispatchQueue.main.async {
                         completionBLK(.Error(error))
                    }
                   
                }
            })
        }
        
        task.resume()
        
    }
    
    func toUpdateUserLocation(objectID: String,uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionBLK: @escaping(Result<String>) -> ()) {
        
        let urlString = Constants.baseUrlStudentLoc + "/\(objectID)"
        guard let url = URL(string: urlString) else {print("url😩");return }
        
        var request = URLRequest(url: url)
        
        request.addValue(Constants.parseAppIdValue, forHTTPHeaderField: Constants.parseAppIDKey)
        request.addValue(Constants.restApiIdValue, forHTTPHeaderField: Constants.parseRestAPIKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        let _ = putMethod(request: request, jsonBody: jsonBody) { (response) in
            switch response {
            case .Success(_):
               completionBLK(.Success("Updated Location"))
                
            case .Error(let error):
               completionBLK(.Error(error))
            }
        }
        
    }
    
    
}
