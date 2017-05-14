//
//  Theme.swift
//  RFBase-iOS
//
//  Created by niall quinn on 13/05/2017.
//  Copyright © 2017 niall quinn. All rights reserved.
//

import Foundation
import UIKit


class UserUtils {
  
  static let sharedInstance = UserUtils()
  
  var push_token: String = ""
  var device_token: String = ""
  
  class func didRegisterForPush(push_token: String) {
    let user = UserUtils.sharedInstance
    user.push_token = push_token
    user.device_token = (UIDevice.current.identifierForVendor?.uuidString)!
    UserUtils.sendToken()
  }
  
  class func sendToken() {
    
    guard let url = URL(string: URLUtils.userUrlString(deviceToken: UserUtils.sharedInstance.device_token, pushToken: UserUtils.sharedInstance.push_token)) else {
      print("Error: cannot create URL")
      return
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.httpMethod = "POST"
    // set up the session
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    // make the request
    let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
      // do stuff with response, data & error here
      
    })
    task.resume()
    
  }
  
}
