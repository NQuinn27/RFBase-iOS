//
//  BioController.swift
//  RFBase-iOS
//
//  Created by niall quinn on 25/04/2017.
//  Copyright © 2017 niall quinn. All rights reserved.
//
import UIKit
import WebKit
import Turbolinks

class BioController: UINavigationController {
  fileprivate var url = URL(string:"http://rfbase.herokuapp.com/api/v1/bio")!
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
    NotificationCenter.default.addObserver(self, selector: #selector(PostsController.updateTheme), name: NSNotification.Name(rawValue: "ThemeUpdate"), object: nil)
    self.navigationBar.barTintColor = Theme.sharedInstance.primaryColor
    self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Theme.sharedInstance.primaryInverseColor]
    self.navigationBar.tintColor = Theme.sharedInstance.primaryInverseColor
    url = URL(string:URLUtils.bioUrlString())!
    presentVisitableForSession(session, url: url)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    RFBase.sharedInstance.fetchTheme()
  }
  
  func updateTheme() {
    self.navigationBar.barTintColor = Theme.sharedInstance.primaryColor
    self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Theme.sharedInstance.primaryInverseColor]
    self.navigationBar.tintColor = Theme.sharedInstance.primaryInverseColor
    self.view.setNeedsDisplay()
  }
  
  fileprivate func presentVisitableForSession(_ session: Session, url: URL, action: Action = .Advance) {
    let visitable = BioViewController(url: url)
    
    if action == .Advance {
      pushViewController(visitable, animated: true)
    } else if action == .Replace {
      popViewController(animated: false)
      pushViewController(visitable, animated: false)
    }
    
    session.visit(visitable)
  }
}

extension BioController: SessionDelegate {
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

extension BioController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if let message = message.body as? String {
      let alertController = UIAlertController(title: "Turbolinks", message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alertController, animated: true, completion: nil)
    }
  }
}

