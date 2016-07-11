//
//  MakeView.swift
//  Kitchen
//
//  Created by Hikaru Watanabe on 3/1/16.
//  Copyright © 2016 Hikaru Watanabe. All rights reserved.
//

import UIKit

class MakeView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
  weak var recipeViewController: RecipeViewController! = nil
  var scrollView: UIScrollView! = nil
  var leftView: UIView! = nil
  var rightView: UIView! = nil
  
  var servingButton: UIButton! = nil
  var dropDownView: UIView! = nil
  var labelsToShift: [UILabel]! = [UILabel]()
  var pickerView: UIPickerView! = nil
  var serving: Int = 1
  
  //Variable for bug handler
  var notFirstLoad: Bool = false
  
  /**
   In makeView function, it first identifies orientation and determine views' positions. Then call each make function to create each component of recipe information. Then finally, it find height and attach appropriate subview(s) to recipeViewController.
  */
  
  func makeView(){
    scrollView = UIScrollView(frame: recipeViewController.view.bounds)
    scrollView.delegate = recipeViewController
    if(!recipeViewController.isPortrait){
      //Landscape
      
      //Set the height for each view to 0 since it is unknown at this point
      leftView = UIView(frame: CGRectMake(0, 0, CGFloat(UIScreen.mainScreen().bounds.width/2) - CGFloat(50), 0))
      rightView = UIView(frame: CGRectMake(CGFloat(UIScreen.mainScreen().bounds.width/2) - CGFloat(50), 0, CGFloat(UIScreen.mainScreen().bounds.width/2) + CGFloat(50), 0))
    }
    
    makeTitle()
    makeIngredients()
    makeServe()
    makeTimes()
    makePrep()
    makeInst()
    makeFinish()
    makeNotes()
    makeTags()
    
    self.scrollView.contentSize = CGSize(width:1.0, height: (recipeViewController.UIInfo.tagY_Cor + recipeViewController.UIInfo.tag_Height + 100))
    if(recipeViewController.isPortrait){
      //Portrait
      recipeViewController.view.addSubview(scrollView)
    }else{
      //Landscape
      //Set the size for each view
      leftView.frame = CGRectMake(0, 0, CGFloat(UIScreen.mainScreen().bounds.width/2) - CGFloat(50), (recipeViewController.UIInfo.timeY_Cor + recipeViewController.UIInfo.time_Height + 100))
      rightView.frame = CGRectMake(CGFloat(UIScreen.mainScreen().bounds.width/2) - CGFloat(50), 0, CGFloat(UIScreen.mainScreen().bounds.width/2) + CGFloat(50), (recipeViewController.UIInfo.tagY_Cor + recipeViewController.UIInfo.tag_Height + 100))
      rightView.layer.addBorder(.Left, color: UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1), thickness: 1.0)
      
      recipeViewController.view.addSubview(leftView)
      
      rightView.addSubview(scrollView)
      recipeViewController.view.addSubview(rightView)
    }
  }
  
  // MARK: - Make Functions
  
  //Make & set Title
  func makeTitle(){
    recipeViewController.UIInfo.titleX_Cor = 40
    //notFirstLoad for bug handler
    recipeViewController.UIInfo.titleY_Cor = notFirstLoad ? 20 : 80

    notFirstLoad = false
    let title = MakeUI().makeTitleLabel("Recipe Title", xCor: recipeViewController.UIInfo.titleX_Cor, yCor: recipeViewController.UIInfo.titleY_Cor)
    recipeViewController.UIInfo.title_Height = title.frame.height
    recipeViewController.UIInfo.title_Width = title.frame.width

    if(recipeViewController.isPortrait){
      //Portrait
      scrollView.addSubview(title)
    }else{
      leftView.addSubview(title)
    }
  }
  /*
  //Make & set Ingredient
  func makeIngredients(){
    recipeViewController.UIInfo.ingredientX_Cor = 40
    recipeViewController.UIInfo.ingredientY_Cor = recipeViewController.UIInfo.titleY_Cor + recipeViewController.UIInfo.title_Height + 20
    
    let title = MakeUI().makeTitleLabel("Ingredients", xCor: recipeViewController.UIInfo.ingredientX_Cor, yCor: recipeViewController.UIInfo.ingredientY_Cor)
    recipeViewController.UIInfo.ingredient_Width = title.frame.width
    recipeViewController.UIInfo.ingredient_Height = title.frame.height
    
    let text = "1 tablespoon olive oil, plus more for drizzling\n1 leek, white and pale green parts thinly sliced\n4 cups low-sodium chicken stock or water\n1 bunch broccoli, chopped (6 cups)\n6 ounces baby spinach (6 cups)\n1/3 cup freshly grated Parmesan\n2 tablespoons tahini\n4 slices rustic bread, toasted\n2 avocados, sliced\n1/4 cup radish sprouts\n1 lemon, cut into wedges"
    let ingredients = MakeUI().makeLabel(text, xCor: recipeViewController.UIInfo.ingredientX_Cor, yCor: recipeViewController.UIInfo.ingredientY_Cor + recipeViewController.UIInfo.ingredient_Height, maxWidth: recipeViewController.UIInfo.maxWidth)
    recipeViewController.UIInfo.ingredient_Width += ingredients.frame.width
    recipeViewController.UIInfo.ingredient_Height += ingredients.frame.height
    
    if(recipeViewController.isPortrait){
      //Portrait
      scrollView.addSubview(title)
      scrollView.addSubview(ingredients)
    }else{
      //Landscape
      leftView.addSubview(title)
      leftView.addSubview(ingredients)
    }

  }
  */
  
  //Make & set Ingredient
  func makeIngredients(){
    recipeViewController.UIInfo.ingredientX_Cor = 40
    recipeViewController.UIInfo.ingredientY_Cor = recipeViewController.UIInfo.titleY_Cor + recipeViewController.UIInfo.title_Height + 20
    
    let title = MakeUI().makeTitleLabel("Ingredients", xCor: recipeViewController.UIInfo.ingredientX_Cor, yCor: recipeViewController.UIInfo.ingredientY_Cor)
    recipeViewController.UIInfo.ingredient_Width = title.frame.width
    recipeViewController.UIInfo.ingredient_Height = title.frame.height
    
    
    var text: String!;
    var ingredients: UILabel!;
    var ingredientsTable: UIView!;
    //TODO:- GROUP ID MUST BE RECEIVED IN SetView
    let groupID: Int? = 3;
    
    if(groupID != nil){
      //GroupId != nil
      recipeViewController.UIInfo.ingredientX_Cor += 10
      recipeViewController.UIInfo.ingredientY_Cor += 10
      ingredientsTable = ingredientTable();
    }else{
      //GroupId == nil
      text = "1 tablespoon olive oil, plus more for drizzling\n1 leek, white and pale green parts thinly sliced\n4 cups low-sodium chicken stock or water\n1 bunch broccoli, chopped (6 cups)\n6 ounces baby spinach (6 cups)\n1/3 cup freshly grated Parmesan\n2 tablespoons tahini\n4 slices rustic bread, toasted\n2 avocados, sliced\n1/4 cup radish sprouts\n1 lemon, cut into wedges"
      ingredients = MakeUI().makeLabel(text, xCor: recipeViewController.UIInfo.ingredientX_Cor, yCor: recipeViewController.UIInfo.ingredientY_Cor + recipeViewController.UIInfo.ingredient_Height, maxWidth: recipeViewController.UIInfo.maxWidth)
    }
    
    recipeViewController.UIInfo.ingredient_Width += groupID != nil ? ingredientsTable.frame.size.width : ingredients.frame.width
    recipeViewController.UIInfo.ingredient_Height +=  groupID != nil ? ingredientsTable.frame.size.height : ingredients.frame.height
    
    if(recipeViewController.isPortrait){
      //Portrait
      scrollView.addSubview(title)
      if(groupID != nil){
        scrollView.addSubview(ingredientsTable)
      }else{
        scrollView.addSubview(ingredients)
      }
    }else{
      //Landscape
      leftView.addSubview(title)
      if(groupID != nil){
        leftView.addSubview(ingredientsTable)
      }else{
        leftView.addSubview(ingredients)
      }
    }
    
  }
  
  /*
   Table itself is UIView, and its cells are two UILabels
   */
  func ingredientTable() -> UIView{
    let tableWidth = recipeViewController.isPortrait ? scrollView.frame.width - 220 : rightView.frame.width - 160
    let ingredientsView = UIView(frame: CGRectMake(recipeViewController.UIInfo.ingredientX_Cor, recipeViewController.UIInfo.ingredientY_Cor + recipeViewController.UIInfo.ingredient_Height, tableWidth, 0))
    
    //Make cell UILabels
    let numberOfGroup = 3
    var height: CGFloat = 0;
    var totalHeight: CGFloat = 0;
    for(var i = 0; i < numberOfGroup; i++){
      //Make Group Label
      let group: UILabel = UILabel(frame: CGRectMake(0, height, tableWidth, 0))
      group.text = " Chicken Sauce"
      group.numberOfLines = 0
      group.font = group.font.fontWithSize(20)
      group.sizeToFit()
      height += group.frame.height
      
      //Make Group detail label
      let detail:UILabel = UILabel(frame: CGRectMake(0, height, tableWidth, 0))
      detail.numberOfLines = 0
      detail.text = "  Water: 180ml\n  Salt: 20g\n  Hot Sauce: 10ml"
      detail.font = detail.font.fontWithSize(16)
      detail.sizeToFit()
      height += detail.frame.height
      
      //Add to ingredientsView as subview. Backgroud color will be differed by even and odd number.
      let cell: UIView = UIView(frame: CGRectMake(0, totalHeight, tableWidth, height))
      totalHeight += height
      height = 0
      if(i%2 != 0){
        //For every each odd cell, make the cell color non-white
        cell.backgroundColor = UIColor(red: 162/255, green: 0, blue: 0, alpha: 0.15)
      }else{
        cell.backgroundColor = UIColor.whiteColor()
      }
      
      //Add layer to cell
      if(i == 0 && (i+1) >= numberOfGroup){
        //There is only one table cell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1).CGColor
      }else if(i == 0){
        //There are more than one cell and this is the first cell
        cell.layer.addBorder(.Left, color: UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1), thickness: 1.0)
        cell.layer.addBorder(.Top, color: UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1), thickness: 1.0)
        cell.layer.addBorder(.Right, color: UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1), thickness: 1.0)
      }else if((i+1) >= numberOfGroup){
        //There are more than one cell and this is the last cell
        cell.layer.addBorder(.Left, color: UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1), thickness: 1.0)
        cell.layer.addBorder(.Bottom, color: UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1), thickness: 1.0)
        cell.layer.addBorder(.Right, color: UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1), thickness: 1.0)
      }else{
        //There are more than once cell and this is non-first/last cell
        cell.layer.addBorder(.Left, color: UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1), thickness: 1.0)
        cell.layer.addBorder(.Right, color: UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1), thickness: 1.0)
      }
      
      
      cell.addSubview(group)
      cell.addSubview(detail)
      ingredientsView.addSubview(cell)
    }
    ingredientsView.frame = CGRectMake(recipeViewController.UIInfo.ingredientX_Cor, recipeViewController.UIInfo.ingredientY_Cor + recipeViewController.UIInfo.ingredient_Height, tableWidth, totalHeight)
    return ingredientsView
  }
  
  
  
  
  
  //Make & set Serving sizes
  func makeServe(){
    recipeViewController.UIInfo.serveX_Cor = 40
    recipeViewController.UIInfo.serveY_Cor = recipeViewController.isPortrait ?  recipeViewController.UIInfo.ingredientY_Cor + recipeViewController.UIInfo.ingredient_Height + 20 : 80
    
    let title = MakeUI().makeTitleLabel("Serving", xCor: recipeViewController.UIInfo.serveX_Cor, yCor: recipeViewController.UIInfo.serveY_Cor)
    recipeViewController.UIInfo.serve_Width = title.frame.width
    recipeViewController.UIInfo.serve_Height = title.frame.height
    
    let text = "Serving Size: "
    let serve = MakeUI().makeLabel(text, xCor: recipeViewController.UIInfo.serveX_Cor, yCor: recipeViewController.UIInfo.serveY_Cor + recipeViewController.UIInfo.serve_Height, maxWidth: recipeViewController.UIInfo.maxWidth)
    recipeViewController.UIInfo.serve_Width += serve.frame.width
    recipeViewController.UIInfo.serve_Height += serve.frame.height
    
    // Display serving size with UIButton at right beside text. Cliking will enable user to change its quantity
    if(dropDownView != nil){
      exitPicker()
    }
    serveButton()
    scrollView.addSubview(title)
    scrollView.addSubview(serve)
  }
  
  func serveButton(){
    servingButton = UIButton(frame: CGRectMake(recipeViewController.UIInfo.serveX_Cor + 110, recipeViewController.UIInfo.serveY_Cor + 33, 45, 25))
    servingButton.setTitle("\(serving)", forState: UIControlState.Normal)
    servingButton.backgroundColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 0.8)
    servingButton.layer.cornerRadius = 5
    servingButton.addTarget(self, action: #selector(MakeView.dropDown(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    scrollView.addSubview(servingButton)
  }
  
  
  //Make & set Times
  func makeTimes(){
    recipeViewController.UIInfo.timeX_Cor = 40
    recipeViewController.UIInfo.timeY_Cor = recipeViewController.UIInfo.serveY_Cor + recipeViewController.UIInfo.serve_Height + 20
    
    let title = MakeUI().makeTitleLabel("Time", xCor: recipeViewController.UIInfo.timeX_Cor, yCor: recipeViewController.UIInfo.timeY_Cor)
    recipeViewController.UIInfo.time_Width = title.frame.width
    recipeViewController.UIInfo.time_Height = title.frame.height
    
    let text = "Total time: 0h\nPrep Time: 0h\nCook Time: 0h\nFinal Time:0h"
    let time = MakeUI().makeLabel(text, xCor: recipeViewController.UIInfo.timeX_Cor, yCor: recipeViewController.UIInfo.timeY_Cor + recipeViewController.UIInfo.time_Height, maxWidth: recipeViewController.UIInfo.maxWidth)
    recipeViewController.UIInfo.time_Width += time.frame.width
    recipeViewController.UIInfo.time_Height += time.frame.height
    
    scrollView.addSubview(title)
    scrollView.addSubview(time)
    
    labelsToShift.append(title)
    labelsToShift.append(time)
  }
  
  //Make & set PrepSteps
  func makePrep(){
    recipeViewController.UIInfo.prepX_Cor = 40
    recipeViewController.UIInfo.prepY_Cor = recipeViewController.UIInfo.timeY_Cor + recipeViewController.UIInfo.time_Height + 20
    
    let title = MakeUI().makeTitleLabel("Preparetion Steps", xCor: recipeViewController.UIInfo.prepX_Cor, yCor: recipeViewController.UIInfo.prepY_Cor)
    recipeViewController.UIInfo.prep_Width = title.frame.width
    recipeViewController.UIInfo.prep_Height = title.frame.height
    
    var text = ""
    for(var i = 0; i < 5/*recipeViewController.recipe.prepSteps!.count*/; i++){
      if(i != 0){
        text += "\n"
      }
      text += "\(i+1). \(recipeViewController.recipe.prepSteps![i])"
    }
   //let text = "1. Heat oil in a medium saucepan over medium-high heat. Add leek and cook until tender, about 4 minutes. Add stock; bring to a boil. Add broccoli and cook, covered, until bright green and tender, about 2 minutes."
    
    let prep = MakeUI().makeLabel(text, xCor: recipeViewController.UIInfo.prepX_Cor, yCor: recipeViewController.UIInfo.prepY_Cor + recipeViewController.UIInfo.prep_Height, maxWidth: recipeViewController.UIInfo.maxWidth)
    recipeViewController.UIInfo.prep_Width += prep.frame.width
    recipeViewController.UIInfo.prep_Height += prep.frame.height
    
    scrollView.addSubview(title)
    scrollView.addSubview(prep)
    
    labelsToShift.append(title)
    labelsToShift.append(prep)
  }
  
  //Make & set RecipeInstructions
  func makeInst(){
    recipeViewController.UIInfo.instX_Cor = 40
    recipeViewController.UIInfo.instY_Cor = recipeViewController.UIInfo.prepY_Cor + recipeViewController.UIInfo.prep_Height + 20
    
    let title = MakeUI().makeTitleLabel("Instructions", xCor: recipeViewController.UIInfo.instX_Cor, yCor: recipeViewController.UIInfo.instY_Cor)
    recipeViewController.UIInfo.inst_Width = title.frame.width
    recipeViewController.UIInfo.inst_Height = title.frame.height
    
    let text = "1.Remove from heat. Stir in spinach, Parmesan, and tahini. Let cool slightly. Season with salt and pepper.\n2.Working in batches, puree soup in a blender until smooth."
    let inst = MakeUI().makeLabel(text, xCor: recipeViewController.UIInfo.instX_Cor, yCor: recipeViewController.UIInfo.instY_Cor + recipeViewController.UIInfo.inst_Height, maxWidth: recipeViewController.UIInfo.maxWidth)
    recipeViewController.UIInfo.inst_Width += inst.frame.width
    recipeViewController.UIInfo.inst_Height += inst.frame.height
    
    scrollView.addSubview(title)
    scrollView.addSubview(inst)
    
    labelsToShift.append(title)
    labelsToShift.append(inst)
  }
  
  //Make & set Finish Steps
  func makeFinish(){
    recipeViewController.UIInfo.finishX_Cor = 40
    recipeViewController.UIInfo.finishY_Cor = recipeViewController.UIInfo.instY_Cor + recipeViewController.UIInfo.inst_Height + 20
    
    let title = MakeUI().makeTitleLabel("Finish Steps", xCor: recipeViewController.UIInfo.finishX_Cor, yCor: recipeViewController.UIInfo.finishY_Cor)
    recipeViewController.UIInfo.finish_Width = title.frame.width
    recipeViewController.UIInfo.finish_Height = title.frame.height

    //let text = "1. Top bread with avocado and radish sprouts. Season with salt and pepper, squeeze with lemon, and drizzle with oil."
    var text = ""
    for(var i = 0; i < 5/*recipeViewController.recipe.prepSteps!.count*/; i++){
      if(i != 0){
        text += "\n"
      }
      text += "\(i+1). \(recipeViewController.recipe.finishingSteps![i])"
    }
    let finish = MakeUI().makeLabel(text, xCor: recipeViewController.UIInfo.finishX_Cor, yCor: recipeViewController.UIInfo.finishY_Cor + recipeViewController.UIInfo.finish_Height, maxWidth: recipeViewController.UIInfo.maxWidth)
    recipeViewController.UIInfo.finish_Width += finish.frame.width
    recipeViewController.UIInfo.finish_Height += finish.frame.height
    
    scrollView.addSubview(title)
    scrollView.addSubview(finish)
    
    labelsToShift.append(title)
    labelsToShift.append(finish)
  }
  
  //Make & set Notes
  func makeNotes(){
    recipeViewController.UIInfo.noteX_Cor = 40
    recipeViewController.UIInfo.noteY_Cor = recipeViewController.UIInfo.finishY_Cor + recipeViewController.UIInfo.finish_Height + 20
    
    let title = MakeUI().makeTitleLabel("Notes", xCor: recipeViewController.UIInfo.noteX_Cor, yCor: recipeViewController.UIInfo.noteY_Cor)
    recipeViewController.UIInfo.note_Width = title.frame.width
    recipeViewController.UIInfo.note_Height = title.frame.height
    
    let text = "There is nothing to note."
    let note = MakeUI().makeLabel(text, xCor: recipeViewController.UIInfo.noteX_Cor, yCor: recipeViewController.UIInfo.noteY_Cor + recipeViewController.UIInfo.note_Height, maxWidth: recipeViewController.UIInfo.maxWidth)
    recipeViewController.UIInfo.note_Width += note.frame.width
    recipeViewController.UIInfo.note_Height += note.frame.height
    
    scrollView.addSubview(title)
    scrollView.addSubview(note)
    
    labelsToShift.append(title)
    labelsToShift.append(note)
  }
  
  //Make & set Tags
  func makeTags(){
    recipeViewController.UIInfo.tagX_Cor = 40
    recipeViewController.UIInfo.tagY_Cor = recipeViewController.UIInfo.noteY_Cor + recipeViewController.UIInfo.note_Height + 20
    
    let title = MakeUI().makeTitleLabel("Tags", xCor: recipeViewController.UIInfo.tagX_Cor, yCor: recipeViewController.UIInfo.tagY_Cor)
    recipeViewController.UIInfo.tag_Width = title.frame.width
    recipeViewController.UIInfo.tag_Height = title.frame.height
    
    let text = "Chicken, Broccoli, Cheese, Mayo, Egg"
    let tag = MakeUI().makeLabel(text, xCor: recipeViewController.UIInfo.tagX_Cor, yCor: recipeViewController.UIInfo.tagY_Cor + recipeViewController.UIInfo.tag_Height, maxWidth: recipeViewController.UIInfo.maxWidth)
    recipeViewController.UIInfo.tag_Width += tag.frame.width
    recipeViewController.UIInfo.tag_Height += tag.frame.height
    
    scrollView.addSubview(title)
    scrollView.addSubview(tag)
    
    labelsToShift.append(title)
    labelsToShift.append(tag)
  }
  
  // MARK:- DROP DOWN
  func dropDown(sender: UIButton){
    if(dropDownView == nil){
      //Need to open drop down
      let subViewWidth = recipeViewController.isPortrait ? scrollView.frame.width-100 : rightView.frame.width - 80
      dropDownView = UIView(frame: CGRectMake(recipeViewController.UIInfo.serveX_Cor,recipeViewController.UIInfo.serveY_Cor+60, subViewWidth, 180))
      dropDownSpace(true)
      scrollView.addSubview(dropDownView)
      // Nest picker onto the dropDownView
      nestPicker(subViewWidth)
    }else{
      //User clicked quantity button again while picker is open; close the picker.
      exitPicker()
    }
  }
  
  func dropDownSpace(makeSpace: Bool){
    let value: CGFloat  = makeSpace ? 200 : -200
    for(var i = 0; i<labelsToShift.count; i++){
      labelsToShift[i].frame.origin = CGPoint(x: labelsToShift[i].frame.origin.x, y: labelsToShift[i].frame.origin.y + value)
    }
  }
  
  func nestPicker(width: CGFloat){
    pickerView = UIPickerView(frame: CGRectMake(1,1,width-3,150-3))
    pickerView.clipsToBounds = true
    pickerView.layer.borderWidth = 1
    pickerView.layer.borderColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1).CGColor
    pickerView.dataSource = self
    pickerView.delegate = self
    pickerView.selectRow(serving-1, inComponent: 0, animated: true)
    
    // Detect double tap to select picker value
    let doubleTapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(MakeView.pickerSelected(_:)))
    doubleTapGesture.numberOfTapsRequired = 2
    pickerView.addGestureRecognizer(doubleTapGesture)
    
    // Select button for picker
    let selectButton = UIButton(frame: CGRectMake(1, 148, width-3, 30))
    selectButton.setTitle("Select", forState: .Normal)
    selectButton.backgroundColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1)
    selectButton.addTarget(self, action: #selector(MakeView.pickerSelected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    
    self.dropDownView.addSubview(selectButton)
    self.dropDownView.addSubview(pickerView)
  }
  
  func pickerSelected(sender: UIButton? = nil){
    // Since exitPicker updates serving value, it needs to confirm that exitPicker is called to select quantity, not from orientation change.
    exitPicker(true)
  }
  
  func exitPicker(selected: Bool = false){
    if(selected){
      serving = pickerView.selectedRowInComponent(0) + 1
      servingButton.setTitle("\(serving)", forState: UIControlState.Normal)
      // TODO: - Update quantity
    }
    for subView in dropDownView.subviews{
      subView.removeFromSuperview()
    }
    dropDownSpace(false)
    dropDownView = nil
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 100
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(row + 1)"
  }

}

/**
 Author: Adam Waite
 This extension and the function are brought from GitHub: http://stackoverflow.com/questions/17355280/how-to-add-a-border-just-on-the-top-side-of-a-uiview?answertab=votes#tab-top
 */
extension CALayer {
  
  func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
    
    let border = CALayer()
    
    switch edge {
    case UIRectEdge.Top:
      border.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), thickness)
      break
    case UIRectEdge.Bottom:
      border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness)
      break
    case UIRectEdge.Left:
      border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame))
      break
    case UIRectEdge.Right:
      border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame))
      break
    default:
      break
    }
    
    border.backgroundColor = color.CGColor;
    
    self.addSublayer(border)
  }
}




