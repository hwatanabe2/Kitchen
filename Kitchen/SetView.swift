//
//  SetView.swift
//  Kitchen
//
//  Created by Hikaru Watanabe on 3/1/16.
//  Copyright © 2016 Hikaru Watanabe. All rights reserved.
//

import UIKit

class SetView{
  weak var recipeViewController: RecipeViewController! = nil
  var completionHandlers: CompletionHandlers = CompletionHandlers()
  var getRecipe: GetRecipe = GetRecipe()
  var progressView: UIProgressView!
  var progressLabel: UILabel!
  
  var recipeIngredientsComplete: Bool
  var recipeTypesComplete: Bool
  var recipeInstructionComplete: Bool
  var prepStepsComplete: Bool
  var finishingStepsComplete: Bool
  var recipeNotesComplete: Bool
  var prepNotesComplete: Bool
  var finishingNotesComplete: Bool
  var recipeTagsComplete: Bool
  var ingredientsComplete: Bool
  
  var getRecipeInfoFailed: Bool = false{
    didSet{
      getRecipeInfoFailed = false
      print("Get recipe information failed")
      setView()
    }
  }
  
  init(){
    recipeIngredientsComplete = false
    recipeTypesComplete = false
    recipeInstructionComplete = false
    prepStepsComplete = false
    finishingStepsComplete = false
    recipeNotesComplete = false
    prepNotesComplete = false
    finishingNotesComplete = false
    recipeTagsComplete = false
    ingredientsComplete = false
  }
  
  // MARK: - Progress Controls
  /**
   While API calls taking place, it displays progress in the process.
   */
  func createProgressControls(){
    //Progress Bar
    progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
    progressView.transform = CGAffineTransformMakeScale(2.0, 4.5)
    progressView.progressTintColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1)
    progressView.center = recipeViewController.view.center
    recipeViewController.view.addSubview(progressView!)
    
    // Add Label
    progressLabel = UILabel(frame: CGRectMake(recipeViewController.view.center.x - 39, recipeViewController.view.center.y - 60, 120, 50))
    progressLabel.font = progressLabel.font.fontWithSize(30)
    recipeViewController.view.addSubview(progressLabel!)
  }
  
  func startProgressBar(){
    createProgressControls()
  }
  
  func updateProgressBar(){
    progressView.progress += 0.1 // 1 * 10 = 100 since there are ten API calls
    progressLabel.text = "\(progressView.progress * 100) %"
  }
  
  func endProgressBar(){
    progressView.hidden = true
    progressLabel.hidden = true
  }
  
  // MARK: - Set Functions
  /**
   Every time one of the API call ends, it updates the progress bar, and if all the calls are done then go to MakeView to display received data.
   */
  func isAllSet(){
    updateProgressBar()
    if(recipeIngredientsComplete
      && recipeTypesComplete
      && recipeInstructionComplete
      && prepStepsComplete
      && finishingStepsComplete
      && recipeNotesComplete
      && prepNotesComplete
      && finishingNotesComplete
      && recipeTagsComplete
      && ingredientsComplete)
    {
      endProgressBar()
      recipeViewController.makeView.makeView()
      // Enable navigation feedback button
      recipeViewController.navigation.rightBarButtonItem?.enabled = true
      recipeViewController.navigation.leftBarButtonItem?.enabled = true
    }
  }
  
  /**
   Checks if all the recipe data are ready. If not, start API calls. If all the data are already availabe then just directly go to MakeView.
   */
  func setView(){
    
    //Check if data for this recipes hasn't been loaded. If not, then GET. Else just view it
    if(recipeViewController.recipe.recipeIngredients == nil
      || recipeViewController.recipe.recipeTypes == nil
      || recipeViewController.recipe.recipeInstructions == nil
      || recipeViewController.recipe.prepSteps == nil
      || recipeViewController.recipe.finishingSteps == nil
      || recipeViewController.recipe.recipeNotes == nil
      || recipeViewController.recipe.prepNotes == nil
      || recipeViewController.recipe.finishingNotes == nil
      || recipeViewController.recipe.recipeTags == nil
      || recipeViewController.recipe.ingredients == nil)
    {
      completionHandlers.setView = self
      startProgressBar()
      setRecipeIngredients()
      setRecipeTypes()
      setRecipeInstructions()
      setPrepSteps()
      setFinishingSteps()
      setRecipeNotes()
      setPrepNotes()
      setFinishingNotes()
      setRecipeTags()
      setIngredients()
    }else{
      if(recipeViewController.isPortrait && !recipeViewController.initialSet && !recipeViewController.rotated){
        //MARK:- bug handler. There is a bug in makeView that is if a recipe is selected by user after first selection, makeView makes extra space at the top for the portrait.
        recipeViewController.makeView.notFirstLoad = true
      }
      
      recipeViewController.makeView.makeView()
      // Enable navigation feedback button
      recipeViewController.navigation.rightBarButtonItem?.enabled = true
      recipeViewController.navigation.leftBarButtonItem?.enabled = true
    }
  }
  
  func setRecipeIngredients(){
    recipeViewController.recipe.recipeIngredients = [RecipeIngredients]()
    getRecipe.information(recipeViewController.recipe.recipeID, url: "http://jsonplaceholder.typicode.com/posts", setView: self, completionHandler: completionHandlers.setRecipeIngredients)
  }
  
  func setRecipeTypes(){
    recipeViewController.recipe.recipeTypes = RecipeTypes()
    getRecipe.information(recipeViewController.recipe.recipeID, url: "http://jsonplaceholder.typicode.com/posts", setView: self, completionHandler: completionHandlers.setRecipeTypes)
  }

  func setRecipeInstructions(){
    recipeViewController.recipe.recipeInstructions = [RecipeInstructions]()
    getRecipe.information(recipeViewController.recipe.recipeID, url: "http://jsonplaceholder.typicode.com/posts", setView: self, completionHandler: completionHandlers.setRecipeInstructions)
  }
  
  func setPrepSteps(){
    recipeViewController.recipe.prepSteps = [PrepSteps]()
    getRecipe.information(recipeViewController.recipe.recipeID, url: "http://jsonplaceholder.typicode.com/posts", setView: self, completionHandler: completionHandlers.setPrepSteps)
  }
  
  func setFinishingSteps(){
    recipeViewController.recipe.finishingSteps = [FinishingSteps]()
    getRecipe.information(recipeViewController.recipe.recipeID, url: "http://jsonplaceholder.typicode.com/posts", setView: self, completionHandler: completionHandlers.setFinishingSteps)
  }
  
  func setRecipeNotes(){
    recipeViewController.recipe.recipeNotes = [RecipeNotes]()
    getRecipe.information(recipeViewController.recipe.recipeID, url: "http://jsonplaceholder.typicode.com/posts", setView: self, completionHandler: completionHandlers.setRecipeNotes)
  }
  
  func setPrepNotes(){
    recipeViewController.recipe.prepNotes = [PrepNotes]()
    getRecipe.information(recipeViewController.recipe.recipeID, url: "http://jsonplaceholder.typicode.com/posts", setView: self, completionHandler: completionHandlers.setPrepNotes)
  }

  func setFinishingNotes(){
    recipeViewController.recipe.finishingNotes = [FinishingNotes]()
    getRecipe.information(recipeViewController.recipe.recipeID, url: "http://jsonplaceholder.typicode.com/posts", setView: self, completionHandler: completionHandlers.setFinishingNotes)
  }
  
  func setRecipeTags(){
    recipeViewController.recipe.recipeTags = [RecipeTags]()
    getRecipe.information(recipeViewController.recipe.recipeID, url: "http://jsonplaceholder.typicode.com/posts", setView: self, completionHandler: completionHandlers.setRecipeTags)
  }
  
  func setIngredients(){
    recipeViewController.recipe.ingredients = [Ingredients]()
    getRecipe.information(recipeViewController.recipe.recipeID, url: "http://jsonplaceholder.typicode.com/posts", setView: self, completionHandler: completionHandlers.setIngredients)
  }
}
