//
//  PostsController.swift
//  RFBase-iOS
//
//  Created by niall quinn on 25/04/2017.
//  Copyright © 2017 niall quinn. All rights reserved.
//

import UIKit
import WebKit
import Turbolinks

class CalendarController: UINavigationController {
  fileprivate let url = URL(string:"http://rfbase.herokuapp.com/api/v1/calendar")!
  fileprivate let webViewProcessPool = WKProcessPool()
  
  fileprivate var application: UIApplication {
    return UIApplication.shared
  }
  
  fileprivate lazy var webViewConfiguration: WKWebViewConfiguration = {
    let configuration = WKWebViewConfiguration()
    configuration.userContentController.add(self, name: "rfbase")
    configuration.processPool = self.webViewProcessPool
    configuration.applicationNameForUserAgent = "RFBase"
    return configuration
  }()
  
  fileprivate lazy var session: Session = {
    let session = Session(webViewConfiguration: self.webViewConfiguration)
    session.delegate = self
    return session
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationBar.barTintColor = UIColor(red:0.19, green:0.69, blue:0.84, alpha:1.00)
    self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    self.navigationBar.tintColor = UIColor.white
    presentVisitableForSession(session, url: url)
  }
  
  fileprivate func presentVisitableForSession(_ session: Session, url: URL, action: Action = .Advance) {
    let visitable = CalendarViewController(url: url)
  
    if action == .Advance {
      pushViewController(visitable, animated: true)
    } else if action == .Replace {
      popViewController(animated: false)
      pushViewController(visitable, animated: false)
    }
    
    session.visit(visitable)
  }
}

extension CalendarController: SessionDelegate {
  func session(_ session: Session, didProposeVisitToURL URL: Foundation.URL, withAction action: Action) {
    presentVisitableForSession(session, url: URL, action: action)
  }
  
  func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
    NSLog("ERROR: %@", error)
    guard let viewController = visitable as? NewsViewController, let errorCode = ErrorCode(rawValue: error.code) else { return }
    
    switch errorCode {
    case .httpFailure:
      let statusCode = error.userInfo["statusCode"] as! Int
      switch statusCode {
      case 404:
        viewController.presentError(.HTTPNotFoundError)
      default:
        viewController.presentError(Error(HTTPStatusCode: statusCode))
      }
    case .networkFailure:
      viewController.presentError(.NetworkError)
    }
  }
  
  func sessionDidStartRequest(_ session: Session) {
    application.isNetworkActivityIndicatorVisible = true
  }
  
  func sessionDidFinishRequest(_ session: Session) {
    application.isNetworkActivityIndicatorVisible = false
  }
}

extension CalendarController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if let message = message.body as? String {
      let alertController = UIAlertController(title: "Turbolinks", message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alertController, animated: true, completion: nil)
    }
  }
}
