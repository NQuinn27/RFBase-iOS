//
//  ErrorView.swift
//  RFBase-iOS
//
//  Created by niall quinn on 14/04/2017.
//  Copyright © 2017 niall quinn. All rights reserved.
//

import UIKit

public class ErrorView: UIView {
  var titleLabel: UILabel!
  var messageLabel: UILabel!
  var retryButton: UIButton!
  
  public var error: Error? {
    didSet {
      titleLabel.text = error?.title
      messageLabel.text = error?.message
      
      titleLabel.sizeToFit()
      messageLabel.frame.size.width = self.frame.size.width
      
      let centerY = frame.size.height / 2
      var currentY = centerY - 65
      
      titleLabel.frame = CGRect(x: 10, y: centerY - 65, width: frame.size.width-20, height: titleLabel.frame.size.height)
      currentY += titleLabel.frame.size.height + 10
      
      messageLabel.frame = CGRect(x: 10, y: currentY, width: frame.size.width-20, height:messageLabel.frame.size.height)
      currentY += messageLabel.frame.size.height + 10
      retryButton.frame = CGRect(x: 0, y: currentY, width: frame.size.width, height: 20)
    }
  }
  
  override public init(frame: CGRect) {
    
    super.init(frame: frame)
    
    titleLabel = UILabel()
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 1
    titleLabel.font = UIFont.systemFont(ofSize: 28)
    
    messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 66))
    messageLabel.textAlignment = .center
    messageLabel.numberOfLines = 3
    //		messageLabel.lineBreakMode = .byWordWrapping
    messageLabel.font = UIFont.systemFont(ofSize: 18)
    messageLabel.textColor = .gray
    
    retryButton = UIButton(type: .system)
    retryButton.titleLabel?.textAlignment = .center
    retryButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
    
    retryButton.setTitle("Retry", for: .normal)
    
    addSubview(titleLabel)
    addSubview(messageLabel)
    addSubview(retryButton)
    
    backgroundColor = .white
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

