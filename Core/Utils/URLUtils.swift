//
//  URLUtils.swift
//  RFBase-iOS
//
//  Created by niall quinn on 28/04/2017.
//  Copyright © 2017 niall quinn. All rights reserved.
//

import Foundation

class URLUtils {
  
  public static func postUrlString() -> String {
    guard let apiKey = RFBase.sharedInstance.apiKey else {
      NSLog("No ApiKey set!")
      return "http://rfbase.herokuapp.com/api/v1/post"
    }
    return "http://rfbase.herokuapp.com/api/v1/post?apiKey=" + apiKey
  }
  
  public static func bioUrlString() -> String {
    guard let apiKey = RFBase.sharedInstance.apiKey else {
      NSLog("No ApiKey set!")
      return "http://rfbase.herokuapp.com/api/v1/bio"
    }
    return "http://rfbase.herokuapp.com/api/v1/bio?apiKey=" + apiKey
  }
  
  public static func calendarUrlString() -> String {
    guard let apiKey = RFBase.sharedInstance.apiKey else {
      NSLog("No ApiKey set!")
      return "http://rfbase.herokuapp.com/api/v1/calendar"
    }
    return "http://rfbase.herokuapp.com/api/v1/calendar?apiKey=" + apiKey
  }
  
  public static func mediaUrlString() -> String {
    guard let apiKey = RFBase.sharedInstance.apiKey else {
      NSLog("No ApiKey set!")
      return "http://rfbase.herokuapp.com/api/v1/media"
    }
    return "http://rfbase.herokuapp.com/api/v1/media?apiKey=" + apiKey
  }
  
  public static func userUrlString(deviceToken: String, pushToken: String) -> String {
    guard let apiKey = RFBase.sharedInstance.apiKey else {
      NSLog("No ApiKey set!")
      return "http://rfbase.herokuapp.com/api/v1/media"
    }
    return "http://rfbase.herokuapp.com/api/v1/user?apiKey=" + apiKey + "&app_user[device_token]=" + deviceToken + "&app_user[push_token]=" + pushToken + "&app_user[device_type]=ios"
  }
  
}
