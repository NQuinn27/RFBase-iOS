//
//  Error.swift
//  RFBase-iOS
//
//  Created by niall quinn on 14/04/2017.
//  Copyright © 2017 niall quinn. All rights reserved.
//

public struct Error {
  static let HTTPNotFoundError = Error(title: "Page Not Found", message: "There doesn’t seem to be anything here.")
  static let NetworkError = Error(title: "Can’t Connect", message: "Popdeem can’t connect to the server!. Please check your internet connection and try again")
  static let UnknownError = Error(title: "Unknown Error", message: "An unknown error occurred.")
  
  public let title: String
  public let message: String
  
  public init(title: String, message: String) {
    self.title = title
    self.message = message
  }
  
  public init(HTTPStatusCode: Int) {
    self.title = "Server Error"
    self.message = "The server returned an HTTP \(HTTPStatusCode) response."
  }
}
