//
//  CompletionHandlers.swift
//  Kitchen
//
//  Created by Hikaru Watanabe on 4/8/16.
//  Copyright © 2016 Hikaru Watanabe. All rights reserved.
//

import UIKit
import SwiftyJSON
import Darwin

///Contains completion handlers which used in ViewController and SetView
class CompletionHandlers{
  
  weak var recipeViewController: ViewController! = nil
  weak var setView: SetView! = nil

  /**
   CompletionHandler for getting a list of recipes. Instantiate 'numRecipes' of Recipe and append to recipeViewController's recipes.
   Also, it will call funtions that complete rest of recipeViewController's configuration.
   - Parameter recipeList: It is JSON data that contains a list of recipes.
   - Parameter numRecipes: It contains how many JSON data to serialize.
   */
  func setRecipeList(recipeList: JSON, numRecipes: Int){
    //Append numRecipes of Recipe to recipeViewController's recipes.
    for(var i = 0; i < numRecipes; i++){
      let recipe = Recipe()
      
      recipe.recipeID = recipeList[i]["userId"].intValue
      recipe.recipeTypeID = recipeList[i]["id"].intValue
      recipe.title = recipeList[i]["title"].stringValue
      //recipe.defaultServingSize =
      //recipe.prepTime =
      //recipe.cookTime =
      //recipe.totalTime =
      //recipe.finishingTime =
      recipeViewController.recipes.append(recipe)
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    recipeViewController.calcRecipeInfo()
    
    //Turn off progressindicator
    recipeViewController.progressIndicator.stopAnimating()
    
    //recipe
    recipeViewController.tableViewSetup()
    
    //segment
    recipeViewController.segmentSetup()
    
    //Navigatino + SearchBar
    recipeViewController.navigationSetup()
    
    //Tag
    recipeViewController.tagSetup()
    recipeViewController.topTen()
  }
  
  func setRecipeIngredients(recipeIngredients: JSON, setView: SetView){
    for(var i = 0; i < recipeIngredients.count; i++){
      let ingredient = RecipeIngredients()
      ingredient.recipeID = setView.recipeViewController.recipe.recipeID
      ingredient.recipeIngredientID = recipeIngredients[i]["userId"].intValue
      //ingredient.ingredientID
      ingredient.measurementID = recipeIngredients[i]["userId"].intValue
      //ingredient.quantity
      //ingredient.ingredientInstruction
      //ingredient.isWholeIngredient
      //ingredient.isRoundUp
      setView.recipeViewController.recipe.recipeIngredients!.append(ingredient)
    }
    
    setView.recipeIngredientsComplete = true
    setView.isAllSet()
  }
  
  
  func setRecipeTypes(recipeTypes: JSON, setView: SetView){
    let type = RecipeTypes()
    type.recipeTypeID = recipeTypes[0]["userId"].intValue
    type.type = recipeTypes[0]["title"].stringValue
    setView.recipeViewController.recipe.recipeTypes = type
    setView.setRecipeInstructions()
    
    setView.recipeTypesComplete = true
    setView.isAllSet()
  }

  func setRecipeInstructions(recipeInstructions: JSON, setView: SetView){
    for(var i = 0; i < recipeInstructions.count; i++){
      let instruction = RecipeInstructions()
      instruction.recipeID = setView.recipeViewController.recipe.recipeID
      instruction.recipeInstructionID = recipeInstructions[i]["userId"].intValue
      instruction.orderNumber = recipeInstructions[i]["userId"].intValue
      instruction.instruction = recipeInstructions[i]["title"].stringValue
      setView.recipeViewController.recipe.recipeInstructions!.append(instruction)
    }
    
    setView.recipeInstructionComplete = true
    setView.isAllSet()
  }

  func setPrepSteps(recipePrepSteps: JSON, setView: SetView){
    for(var i = 0; i < recipePrepSteps.count; i++){
      let prepStep = PrepSteps()
      prepStep.recipeID = setView.recipeViewController.recipe.recipeID
      prepStep.prepStepID = recipePrepSteps[i]["userId"].intValue
      prepStep.orderNumber = recipePrepSteps[i]["id"].intValue
      prepStep.instruction = recipePrepSteps[i]["title"].stringValue
      setView.recipeViewController.recipe.prepSteps!.append(prepStep)
    }
    
    setView.prepStepsComplete = true
    setView.isAllSet()
  }
  
  func setFinishingSteps(recipeFinishingSteps: JSON, setView: SetView){
    for(var i = 0; i < recipeFinishingSteps.count; i++){
      let finishingSteps = FinishingSteps()
      finishingSteps.recipeID = setView.recipeViewController.recipe.recipeID
      finishingSteps.finishingStepID = recipeFinishingSteps[i]["userId"].intValue
      finishingSteps.orderNumber = recipeFinishingSteps[i]["id"].intValue
      finishingSteps.instruction = recipeFinishingSteps[i]["title"].stringValue
      setView.recipeViewController.recipe.finishingSteps!.append(finishingSteps)
    }
    
    setView.finishingStepsComplete = true
    setView.isAllSet()
  }

  func setRecipeNotes(recipeNotes: JSON, setView: SetView){
    for(var i = 0; i < recipeNotes.count; i++){
      let recipeNote = RecipeNotes()
      recipeNote.recipeID = setView.recipeViewController.recipe.recipeID
      recipeNote.noteID = recipeNotes[i]["userId"].intValue
      //recipeNote.note      //object
      setView.recipeViewController.recipe.recipeNotes!.append(recipeNote)
    }
    
    setView.recipeNotesComplete = true
    setView.isAllSet()
  }

  func setPrepNotes(recipePrepNotes: JSON, setView: SetView){
    for(var i = 0; i < recipePrepNotes.count; i++){
      let recipePrepNote = PrepNotes()
      recipePrepNote.recipeID = setView.recipeViewController.recipe.recipeID
      recipePrepNote.prepNoteID = recipePrepNotes[i]["userId"].intValue
      recipePrepNote.note = recipePrepNotes[i]["title"].stringValue
      setView.recipeViewController.recipe.prepNotes!.append(recipePrepNote)
    }
    
    setView.prepNotesComplete = true
    setView.isAllSet()
  }
  
  func setFinishingNotes(recipeFinishingNotes:JSON, setView: SetView){
    for(var i = 0; i < recipeFinishingNotes.count; i++){
      let finishingNote = FinishingNotes()
      finishingNote.recipeID = setView.recipeViewController.recipe.recipeID
      finishingNote.finishingNoteID = recipeFinishingNotes[i]["userId"].intValue
      finishingNote.note = recipeFinishingNotes[i]["title"].stringValue
      setView.recipeViewController.recipe.finishingNotes!.append(finishingNote)
    }
    
    setView.finishingNotesComplete = true
    setView.isAllSet()
  }
  
  func setRecipeTags(recipeTags: JSON, setView: SetView){
    for(var i = 0; i < recipeTags.count; i++){
      let tag = RecipeTags()
      tag.recipeID = setView.recipeViewController.recipe.recipeID
      tag.recipeID = recipeTags[i]["userId"].intValue
      // tags       
      setView.recipeViewController.recipe.recipeTags!.append(tag)
    }
    
    setView.recipeTagsComplete = true
    setView.isAllSet()
  }

  func setIngredients(recipeIngredients: JSON, setView:SetView){
    for(var i = 0; i < recipeIngredients.count; i++){
      let ingredient = Ingredients()
      ingredient.name = "123"
      setView.recipeViewController.recipe.ingredients!.append(ingredient)
    }
    
    setView.ingredientsComplete = true
    setView.isAllSet()
  }

}




































