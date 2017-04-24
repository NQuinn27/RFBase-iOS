//
//  PostsController.swift
//  RFBase-iOS
//
//  Created by niall quinn on 14/04/2017.
//  Copyright © 2017 niall quinn. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Turbolinks
import SafariServices

class BioController: UINavigationController {
  fileprivate let url = URL(string: "http://192.168.1.5:3000/api/v1/bio")!
  fileprivate let webViewProcessPool = WKProcessPool()
  
  fileprivate var application: UIApplication {
    return UIApplication.shared
  }
  
  fileprivate lazy var webViewConfiguration: WKWebViewConfiguration = {
    let configuration = WKWebViewConfiguration()
    configuration.userContentController.add(self, name: "postIndex")
    configuration.processPool = self.webViewProcessPool
    configuration.applicationNameForUserAgent = "Bio"
    return configuration
  }()
  
  fileprivate lazy var session: Session = {
    let session = Session(webViewConfiguration: self.webViewConfiguration)
    session.delegate = self
    return session
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presentVisitableForSession(session, url: url)
  }
  
  fileprivate func presentVisitableForSession(_ session: Session, url: URL, action: Action = .Advance) {
    let visitable = BioViewController(url: url)
    visitable.edgesForExtendedLayout = []
    if action == .Advance {
      pushViewController(visitable, animated: true)
    } else if action == .Replace {
      popViewController(animated: false)
      pushViewController(visitable, animated: false)
    }
    
    session.visit(visitable)
  }
  
  fileprivate func presentNumbersViewController() {
    
  }
  
  fileprivate func presentAuthenticationController() {
    
  }
}

extension BioController: SessionDelegate {
  func session(_ session: Session, didProposeVisitToURL URL: Foundation.URL, withAction action: Action) {
    if URL.path == "/numbers" {
      presentNumbersViewController()
    } else {
      presentVisitableForSession(session, url: URL, action: action)
    }
  }
  
  func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
    NSLog("ERROR: %@", error)
    guard let demoViewController = visitable as? BioViewController, let errorCode = ErrorCode(rawValue: error.code) else { return }
    
    switch errorCode {
    case .httpFailure:
      let statusCode = error.userInfo["statusCode"] as! Int
      switch statusCode {
      case 401:
        presentAuthenticationController()
      case 404:
        demoViewController.presentError(.HTTPNotFoundError)
      default:
        demoViewController.presentError(Error(HTTPStatusCode: statusCode))
      }
    case .networkFailure:
      demoViewController.presentError(.NetworkError)
    }
  }
  
  func sessionDidStartRequest(_ session: Session) {
    application.isNetworkActivityIndicatorVisible = true
  }
  
  func sessionDidFinishRequest(_ session: Session) {
    application.isNetworkActivityIndicatorVisible = false
  }
}


extension BioController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if let message = message.body as? String {
      let alertController = UIAlertController(title: "Turbolinks", message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alertController, animated: true, completion: nil)
    }
  }
}
