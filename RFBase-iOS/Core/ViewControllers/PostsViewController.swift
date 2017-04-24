//
//  PostsViewController.swift
//  RFBase-iOS
//
//  Created by niall quinn on 14/04/2017.
//  Copyright © 2017 niall quinn. All rights reserved.
//

import Turbolinks
import UIKit

class PostsViewController: Turbolinks.VisitableViewController {
  lazy var errorView: ErrorView = {
    let view =  ErrorView(frame: self.view.frame)
    view.retryButton.addTarget(self, action: #selector(retry(_:)), for: .touchUpInside)
    return view;
  }()
  
  func presentError(_ error: Error) {
    errorView.error = error
    view.addSubview(errorView)
  }
  
  func installErrorViewConstraints() {
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: [ "view": errorView ]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: [ "view": errorView ]))
  }
  
  func retry(_ sender: AnyObject) {
    errorView.removeFromSuperview()
    reloadVisitable()
  }
  
  override func visitableDidRender() {
    title = "News"
  }
}

