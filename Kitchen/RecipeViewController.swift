//
//  RecipeViewController.swift
//  Kitchen
//
//  Created by Hikaru Watanabe on 2/24/16.
//  Copyright © 2016 Hikaru Watanabe. All rights reserved.
//

import UIKit

class RecipeViewController:  UIViewController, UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate{
  
  //////////////////////////////////////////////
  //Reference to main page
  //////////////////////////////////////////////
  weak var recipeSelectionView: ViewController! = nil
  
  //////////////////////////////////////////////
  //Navigation and Report textField
  //////////////////////////////////////////////
  @IBOutlet weak var navigation: UINavigationItem!
  
  //////////////////////////////////////////////
  // Recipe Information
  //////////////////////////////////////////////
  var recipe: Recipe! = nil
  var UIInfo = RecipeViewConfig()
  
  //////////////////////////////////////////////
  //setup logics
  //////////////////////////////////////////////
  var isPortrait: Bool = true
  var initialSet: Bool = true
  var rotated: Bool = false
  
  //////////////////////////////////////////////
  // Instantiations
  //////////////////////////////////////////////
  var setView = SetView()
  var makeView = MakeView()
  
  //////////////////////////////////////////////
  // Report variables
  //////////////////////////////////////////////
  var reportAlertController: UIAlertController!
  var nameTextField: UITextField!
  var reportTextView: UITextView!
  var placeHolderLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setView.recipeViewController = self
    makeView.recipeViewController = self
    didRotateFromInterfaceOrientation(UIApplication.sharedApplication().statusBarOrientation)
  }
  
  override func didReceiveMemoryWarning() {
    
  }

  
  /**
   This function is called in two cases: from viewDidLoad and from orientation change while in the recipe page.
  */
  override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation){
    //Create go back and report button on navigation
    if(initialSet){
      let navBack = UIBarButtonItem(title: "< Go Back", style: .Plain, target: self, action: #selector(RecipeViewController.goBack))
      navigation.leftBarButtonItem = navBack
      navigation.leftBarButtonItem?.enabled = false
      let navReport = UIBarButtonItem(title: "FeedBack", style: .Plain, target: self, action: #selector(RecipeViewController.report))
      navigation.rightBarButtonItem = navReport
      navigation.rightBarButtonItem?.enabled = false
    }else{
      // If initialset is false, it means this page is called from orientation change. By making returnFromRecipeView to true, when user goes back to recipe table view page, it will check orientation status.
      recipeSelectionView.returnFromRecipeView = true;
      rotated = true
    }
    
    for view in self.view.subviews {
      // If view it iterated over subviews, it means this functino is called due to orientation change which means needs to change position and size of subviews; hence, reset by removing all the attached suvbiews.
      view.removeFromSuperview()
    }
    
    //true if portrait else false
    isPortrait = UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)
    UIInfo.maxWidth = isPortrait ? self.view.bounds.width - 80 : self.view.bounds.width/2 - 80

    initialSet = false
    setView.setView()
  }
  
  // MARK: - Navigation: Go back
  func goBack(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  // MARK: - Navigation: Report (feedback)
  
  func report(){
    let alertAttribute: NSAttributedString = NSAttributedString(string: "FeedBack", attributes: [
      NSFontAttributeName: UIFont.systemFontOfSize(25), NSForegroundColorAttributeName: UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1)
      ])
    //let reportAlertController = UIAlertController(title: "Report", message: "If you find anything to report, please write it in the text box below and press send. To cancel report, press cancel.\n\n\n\n\n\n", preferredStyle: .Alert)
    reportAlertController = UIAlertController(title: "", message: "If you find anything to feedback/report, please fill out your name, write details of the report/feedback, and press send. To cancel report, press cancel.\n\n\n\n\n\n\n\n", preferredStyle: .Alert)
    reportAlertController.setValue(alertAttribute, forKey: "attributedTitle")
    
    //Textbox for user name
    nameTextField = UITextField(frame: CGRectMake(20, 120, 230, 25))
    nameTextField.delegate = self
    nameTextField.layer.borderColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1).CGColor
    nameTextField.layer.borderWidth = 1.0
    nameTextField.layer.cornerRadius = 5.0
    nameTextField.font = nameTextField.font!.fontWithSize(15)
    nameTextField.placeholder = " Enter your name here."
    nameTextField.addTarget(self, action: #selector(RecipeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
    reportAlertController.view.addSubview(nameTextField)
    
    //Textbox for feedback
    reportTextView = UITextView(frame: CGRectMake(20, 150, 230, 100))
    reportTextView.delegate = self
    reportTextView.layer.borderColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1).CGColor
    reportTextView.layer.borderWidth = 1.0
    reportTextView.layer.cornerRadius = 5.0
    reportTextView = makeTextViewPlaceHolder(reportTextView)
    reportAlertController.view.addSubview(reportTextView)
    
    //Send
    reportAlertController.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler: { (_) in
      print(self.nameTextField.text)
      print(self.reportTextView.text)
      // TODO: - Send
      
      //Let user know if the report were successfully submitted
      let reportCompleteTitle = NSAttributedString(string: "FeedBack", attributes: [
        NSFontAttributeName: UIFont.systemFontOfSize(25), NSForegroundColorAttributeName: UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1)
        ])
      let message = "Feedback was successfully submitted."
      let reportCompleteAlertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
      reportCompleteAlertController.setValue(reportCompleteTitle, forKey: "attributedTitle")
      reportCompleteAlertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
      self.presentViewController(reportCompleteAlertController, animated: true, completion: nil)
      reportCompleteAlertController.view.tintColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1)
    }))
    reportAlertController.actions[0].enabled = false
    
    
    //Cancel
    reportAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
    
    presentViewController(reportAlertController, animated: true, completion: nil)
    reportAlertController.view.tintColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1)
  }
  
  func makeTextViewPlaceHolder(reportTextView: UITextView) -> UITextView{
    // frame size is equal to that of reportTextViewß
    placeHolderLabel = UILabel(frame: CGRectMake(5, 0, 230, 27))
    placeHolderLabel.text = "Enter feedback/report"
    placeHolderLabel.font = placeHolderLabel.font.fontWithSize(15)
    placeHolderLabel.textColor = UIColor.lightGrayColor()
    placeHolderLabel.textAlignment = NSTextAlignment.Left
    reportTextView.addSubview(placeHolderLabel)
    return reportTextView
  }
  
  func textFieldDidChange(nameTextField: UITextField) {
    if(!nameTextField.text!.isEmpty){
      if(!(reportTextView.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty)){
        reportAlertController.actions[0].enabled = true
      }
    }else{
      reportAlertController.actions[0].enabled = false
    }
  }
  
  func textViewDidChange(reportTextView: UITextView) {
    if(!(reportTextView.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty)){
      // If user typed something, hide the placeholder
      placeHolderLabel.hidden = true
      if(!(nameTextField.text!.isEmpty)){
        reportAlertController.actions[0].enabled = true
      }
    }else{
      // If textbox does not possess any letter on it, show the placeholder
      placeHolderLabel.hidden = false
      reportAlertController.actions[0].enabled = false
    }
  }
  
}


