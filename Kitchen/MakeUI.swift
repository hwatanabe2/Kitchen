//
//  MakeUI.swift
//  Kitchen
//
//  Created by Hikaru Watanabe on 2/29/16.
//  Copyright © 2016 Hikaru Watanabe. All rights reserved.
//

import UIKit
class MakeUI{
  
  func makeTitleLabel(title: String, xCor: CGFloat, yCor: CGFloat) -> UILabel{
    let label: UILabel = UILabel(frame: CGRectMake(xCor, yCor, 0, 0))
    label.text = title
    label.font = label.font.fontWithSize(30)
    label.textColor = UIColor(red: 162/255, green: 0, blue: 0, alpha: 1)
    label.sizeToFit()
    return label
  }

  
  func makeLabel(text: String, xCor: CGFloat, yCor: CGFloat, maxWidth: CGFloat, fontSize: CGFloat = 0) -> UILabel{
    let label: UILabel = UILabel(frame: CGRectMake(xCor, yCor, maxWidth, 0))
    label.text = text
    label.lineBreakMode = NSLineBreakMode.ByWordWrapping
    label.numberOfLines = 0
    label.sizeToFit()
    if(fontSize > 0){
      label.font = label.font.fontWithSize(fontSize)
    }
    return label
  }
}