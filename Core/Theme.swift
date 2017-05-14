//
//  Theme.swift
//  RFBase-iOS
//
//  Created by niall quinn on 28/04/2017.
//  Copyright © 2017 niall quinn. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class Theme {
  
  var primaryColor: UIColor = UIColor.white
  var primaryInverseColor: UIColor = UIColor.black
  
  static let sharedInstance = Theme()
  
  init(json: JSON) {
    Theme.sharedInstance.primaryColor = ColorUtils.hexStringToUIColor(hex: json["primary_color"].stringValue)
    Theme.sharedInstance.primaryInverseColor = ColorUtils.hexStringToUIColor(hex: json["primary_inverse_color"].stringValue)
    UserDefaults.standard.set(json["primary_inverse_color"].stringValue, forKey: "PrimaryInverseColor")
    UserDefaults.standard.set(json["primary_color"].stringValue, forKey: "PrimaryColor")
  }
  
  private init() {
    if let primary =  UserDefaults.standard.string(forKey: "PrimaryColor") {
      primaryColor = ColorUtils.hexStringToUIColor(hex: primary)
    }
    if let primaryInv = UserDefaults.standard.string(forKey: "PrimaryInverseColor") {
      primaryInverseColor = ColorUtils.hexStringToUIColor(hex: primaryInv)
    }
  }
}
