//
//  RFBase.swift
//  RFBase-iOS
//
//  Created by niall quinn on 14/04/2017.
//  Copyright © 2017 niall quinn. All rights reserved.
//

import UIKit

class RFBase: NSObject {
  private static var shared: RFBase = {
    let core = RFBase()
    return core
  }()
  
  public var apiKey: String?
  public var baseUrl: URL?
  
  
  public class func sharedCore() -> RFBase {
    return shared
  }
  
  public static func with(apiKey: String, baseUrlString: String) {
    let core = shared
    core.apiKey = apiKey
    core.baseUrl = URL(string: baseUrlString)
  }
  
  public static func with(apiKey: String) {
    let core = shared
    core.apiKey = apiKey
  }
  

}
