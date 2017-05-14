//
//  RFBase.swift
//  RFBase-iOS
//
//  Created by niall quinn on 28/04/2017.
//  Copyright © 2017 niall quinn. All rights reserved.
//

import Foundation
import SwiftyJSON

class RFBase {
  
  static let sharedInstance = RFBase()
  
  var apiKey: String?
  
  init(apiKey: String) {
    RFBase.sharedInstance.apiKey = apiKey
    fetchTheme()
  }
  
  public func fetchTheme() {
    let themeUrl = "http://rfbase.herokuapp.com/api/v1/theme?apiKey=" + RFBase.sharedInstance.apiKey!
    guard let url = URL(string: themeUrl) else {
      return
    }
    let urlRequest = URLRequest(url: url)
    let session = URLSession.shared
    let task = session.dataTask(with: urlRequest) {(data, response, error) in
      guard error == nil else {
        print("error calling GET on /theme")
        print(error)
        return
      }
      guard data != nil else {
        return
      }
      let json = JSON(data: data!)
      let theme = Theme(json: json)
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ThemeUpdate"), object: nil)
    }
    task.resume()
  }
    
  private init(){}
  
}
  
