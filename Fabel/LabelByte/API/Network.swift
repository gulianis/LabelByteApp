//
//  Network.swift
//  LabelByte
//
//  Created by Sachin Guliani on 3/29/20.
//

import UIKit
import Foundation

let ip = "https://labelbyte.com"

// All functions in this file are POST or GET Requests based on variables
// asked for in the function

func ReceiveToken(_ username: String, _ password: String, completionBlock: @escaping (String) -> Void) {
    // Prepare URL
    //let url = URL(string: "https://www." + ip + "/api/token-auth/")
    let url = URL(string: ip + "/api/token-auth/")
    guard let requestUrl = url else { fatalError() }
    
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = 30.0
    urlconfig.timeoutIntervalForResource = 60.0
    let session = URLSession(configuration: urlconfig)
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    
    // HTTP Request Parameters which will be sent in hTTP Request Body
    let postString = "username=\(username)&password=\(password)"
    
    // Set HTTP Request Body
    request.httpBody = postString.data(using: String.Encoding.utf8)
    
    // Preform HTTP Request
    //let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    let task = session.dataTask(with: request) { (data, response, error) in
        
        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            completionBlock("error")
            return
        }
        
        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            completionBlock(dataString)
        }
    }
    task.resume()
}

func ReceiveImage(_ zipFileName: String, _ imageName: String, completionBlock: ((UIImage?) -> Void)? = nil) {
    // Prepare URL
    //let url = URL(string: "https://www." + ip + "/api/download/")
    let url = URL(string: ip + "/api/download/")
    guard let requestUrl = url else { fatalError() }
    
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = 30.0
    urlconfig.timeoutIntervalForResource = 60.0
    let session = URLSession(configuration: urlconfig)
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    
    let RecievedDataAfterSave = KeyChain.load(key: currentUsername)
    let accessToken = "Token " + KeyChain.convertNSDataToStr(data: RecievedDataAfterSave!)
    
    request.setValue(accessToken, forHTTPHeaderField: "Authorization")
    
    // Set HTTP Request Body
    //request.httpBody = postString.data(using: String.Encoding.utf8)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let jsonData: Foundation.Data
    do {
        jsonData = try JSONSerialization.data(withJSONObject: ["ZipFile": zipFileName, "ImageName": imageName], options: [])
        request.httpBody = jsonData
    } catch {
        print("Error: cannot create JSON from todo")
        return
    }
    
    // download task
    session.downloadTask(with: request) { (url, response, error) in
        guard
            let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
            let url = url
        else {
            return
        }

        do {
            //let file = cache.appendingPathComponent("\(UUID().uuidString)")
            let file = cache.appendingPathComponent("image")
            //print(file.path)
            try FileManager.default.moveItem(atPath: url.path,
                                             toPath: file.path)
            let ImageView: UIImage? = UIImage(contentsOfFile: file.path)
            completionBlock!(ImageView)
        }
        catch {
            print(error.localizedDescription)
        }
    }.resume()
    
}

func ImageRequestCount(_ zipFileName: String, _ imageName: String, completionBlock: @escaping (String) -> Void) {
    // Prepare URL
    //let url = URL(string: "https://www." + ip + "/api/download-count/")
    let url = URL(string: ip + "/api/download-count/")
    guard let requestUrl = url else { fatalError() }
    
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = 30.0
    urlconfig.timeoutIntervalForResource = 60.0
    let session = URLSession(configuration: urlconfig)
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    
    let RecievedDataAfterSave = KeyChain.load(key: currentUsername)
    let accessToken = "Token " + KeyChain.convertNSDataToStr(data: RecievedDataAfterSave!)
    
    request.setValue(accessToken, forHTTPHeaderField: "Authorization")
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let jsonData: Foundation.Data
    do {
        jsonData = try JSONSerialization.data(withJSONObject: ["ImageName": imageName, "ZipFile": zipFileName], options: [])
        request.httpBody = jsonData
    } catch {
        print("Error: cannot create JSON from todo")
        return
    }
    
    // Preform HTTP Request
    let task = session.dataTask(with: request) { (data, response, error) in
        
        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            completionBlock("Error")
            return
        }
        
        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            completionBlock(dataString)
            return
        }
    }
    task.resume()
}

func SendCoordinates(_ coordinateData: [String: String], completionBlock: @escaping (String) -> Void) {
    // Prepare URL
    //let url = URL(string: "https://www." + ip + "/api/save_labels/")
    let url = URL(string: ip + "/api/save_labels/")
    guard let requestUrl = url else { fatalError() }
    
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = 30.0
    urlconfig.timeoutIntervalForResource = 60.0
    let session = URLSession(configuration: urlconfig)
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    
    // HTTP Request Parameters which will be sent in hTTP Request Body
    // let postString = "username=\(username)&password=\(password)"
    
    // Set HTTP Request Body
    //request.httpBody = postString.data(using: String.Encoding.utf8)
    
    let RecievedDataAfterSave = KeyChain.load(key: currentUsername)
    let accessToken = "Token " + KeyChain.convertNSDataToStr(data: RecievedDataAfterSave!)
    
    request.setValue(accessToken, forHTTPHeaderField: "Authorization")
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let jsonData: Foundation.Data
    do {
        jsonData = try JSONSerialization.data(withJSONObject: coordinateData, options: [])
        request.httpBody = jsonData
    } catch {
        print("Error: cannot create JSON from todo")
        return
    }
    
    // Preform HTTP Request
    let task = session.dataTask(with: request) { (data, response, error) in
        
        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            completionBlock("Error")
            return
        }
        
        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            let jsonData = dataString.data(using: .utf8)!
            let dictionary = try? JSONSerialization.jsonObject(with: jsonData)
            if let Data = dictionary as? [String: String] {
                if Data["result"]! == "success" {
                    completionBlock("Success")
                } else {
                    completionBlock("Error")
                }
            }
            return
        }
    }
    task.resume()
}

func GETCoordinates(_ zipFileName: String, _ imageName: String, completionBlock: @escaping (String) -> Void) {
    // Prepare URL
    //let url = URL(string: "https://www." + ip + "/api/getLabel/")
    let url = URL(string: ip + "/api/getLabel/")
    guard let requestUrl = url else { fatalError() }
    
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = 30.0
    urlconfig.timeoutIntervalForResource = 60.0
    let session = URLSession(configuration: urlconfig)
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    
    //var accessToken = "Token cfcbdf09cf877c75fda92524e8c12e667ca90f8f"
    let RecievedDataAfterSave = KeyChain.load(key: currentUsername)
    let accessToken = "Token " + KeyChain.convertNSDataToStr(data: RecievedDataAfterSave!)
    
    request.setValue(accessToken, forHTTPHeaderField: "Authorization")
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let jsonData: Foundation.Data
    do {
        jsonData = try JSONSerialization.data(withJSONObject: ["ImageName": imageName, "ZipFile": zipFileName], options: [])
        request.httpBody = jsonData
    } catch {
        print("Error: cannot create JSON from todo")
        return
    }
    
    // Preform HTTP Request
    let task = session.dataTask(with: request) { (data, response, error) in
        
        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            //completionBlock("Error")
            return
        }
        
        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            completionBlock(dataString)
        }
    }
    task.resume()
}

func GETZipNames(completionBlock: @escaping (String) -> Void) {
    // Prepare URL
    //let url = URL(string: "https://www." + ip + "/api/zipFileName/")
    let url = URL(string: ip + "/api/zipFileName/")
    guard let requestUrl = url else { fatalError() }
    
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = 30.0
    urlconfig.timeoutIntervalForResource = 60.0
    let session = URLSession(configuration: urlconfig)
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "GET"
    
    //var accessToken = "Token cfcbdf09cf877c75fda92524e8c12e667ca90f8f"
    let RecievedDataAfterSave = KeyChain.load(key: currentUsername)
    let accessToken = "Token " + KeyChain.convertNSDataToStr(data: RecievedDataAfterSave!)
    
    request.setValue(accessToken, forHTTPHeaderField: "Authorization")
    
    // Preform HTTP Request
    let task = session.dataTask(with: request) { (data, response, error) in
        
        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            return
        }
        
        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            completionBlock(dataString)
        }
    }
    task.resume()
}

func RecieveImageNames(_ postString: String, completionBlock: @escaping (String) -> Void) {
    // Prepare URL
    //let url = URL(string: "https://www." + ip + "/api/imageName/")
    let url = URL(string: ip + "/api/imageName/")
    guard let requestUrl = url else { fatalError() }
    
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = 30.0
    urlconfig.timeoutIntervalForResource = 60.0
    let session = URLSession(configuration: urlconfig)
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    
    // Set HTTP Request Body
    //request.httpBody = postString.data(using: String.Encoding.utf8)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let jsonData: Foundation.Data
    do {
        jsonData = try JSONSerialization.data(withJSONObject: ["ZipFile": postString], options: [])
        request.httpBody = jsonData
    } catch {
        print("Error: cannot create JSON from todo")
        return
    }
    
    let RecievedDataAfterSave = KeyChain.load(key: currentUsername)
    let accessToken = "Token " + KeyChain.convertNSDataToStr(data: RecievedDataAfterSave!)

    request.setValue(accessToken, forHTTPHeaderField: "Authorization")
    
    // Preform HTTP Request
    let task = session.dataTask(with: request) { (data, response, error) in
        
        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            return
        }
        
        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            completionBlock(dataString)
        }
    }
    task.resume()
}

func UploadZipFile(_ filePath: URL, completionBlock: @escaping (String) -> Void) {
    //let url = URL(string: "https://www" + ip + "/api/uploadZip/")
    let url = URL(string: ip + "/api/uploadZip/")
    guard let requestUrl = url else { fatalError() }
    
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = 30.0
    urlconfig.timeoutIntervalForResource = 60.0
    let session = URLSession(configuration: urlconfig)
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    //request.setValue(filePath.lastPathComponent, forHTTPHeaderField: "filename")
    let value = "attachment; filename=\"\(filePath.lastPathComponent)\""
    request.setValue(value, forHTTPHeaderField: "Content-Disposition")
    request.setValue("application/zip", forHTTPHeaderField: "Content-Type")
    //request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
    let RecievedDataAfterSave = KeyChain.load(key: currentUsername)
    let accessToken = "Token " + KeyChain.convertNSDataToStr(data: RecievedDataAfterSave!)
    request.setValue(accessToken, forHTTPHeaderField: "Authorization")
    
    // Set HTTP Request Body
    //request.httpBody = postString.data(using: String.Encoding.utf8)
    //request.setValue("application/zip", forHTTPHeaderField: "Content-Type")
    let task = session.uploadTask(with: request, fromFile: filePath) { (data, response, error) in
        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            completionBlock("Error")
        }
        
        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            completionBlock(dataString)
        }
        // Gets 206 in response
    }
    //task.resume()
    task.resume()
}

func Register(_ email: String, _ password: String, _ retypePassword: String, completionBlock: @escaping (String) -> Void) {
    // Prepare URL
    //let url = URL(string: "https://www." + ip + "/api/getLabel/")
    let url = URL(string: ip + "/api/registerThroughAPI/")
    guard let requestUrl = url else { fatalError() }
    
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = 30.0
    urlconfig.timeoutIntervalForResource = 60.0
    let session = URLSession(configuration: urlconfig)
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    

    //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    /*
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    let jsonData: Foundation.Data
    do {
        jsonData = try JSONSerialization.data(withJSONObject: ["email": email, "password1": password, "password2": retypePassword], options: [])
        request.httpBody = jsonData
    } catch {
        print("Error: cannot create JSON from todo")
        return
    }
    */
    let dataString = "email=\(email)&password1=\(password)&password2=\(retypePassword)"
    request.httpBody = dataString.data(using: .utf8)

    
    // Preform HTTP Request
    let task = session.dataTask(with: request) { (data, response, error) in
        
        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            completionBlock("Error")
        }
        
        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            completionBlock(dataString)
        }
    }
    task.resume()
}

func ReceiveLabelFile(completionBlock: @escaping (String) -> Void) {
    // Prepare URL
    //let url = URL(string: "https://www." + ip + "/api/zipFileName/")
    let url = URL(string: ip + "/api/downloadLabelThroughAPI/")
    guard let requestUrl = url else { fatalError() }
    
    let urlconfig = URLSessionConfiguration.default
    urlconfig.timeoutIntervalForRequest = 30.0
    urlconfig.timeoutIntervalForResource = 60.0
    let session = URLSession(configuration: urlconfig)
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    
    //var accessToken = "Token cfcbdf09cf877c75fda92524e8c12e667ca90f8f"
    let RecievedDataAfterSave = KeyChain.load(key: currentUsername)
    let accessToken = "Token " + KeyChain.convertNSDataToStr(data: RecievedDataAfterSave!)
    
    request.setValue(accessToken, forHTTPHeaderField: "Authorization")
    
    // Preform HTTP Request
    let task = session.dataTask(with: request) { (data, response, error) in
        
        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            completionBlock("Error")
        }
        
        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            completionBlock(dataString)
        }
    }
    task.resume()
    
}
