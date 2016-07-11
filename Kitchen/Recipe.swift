//
//  Recipe.swift
//  Kitchen
//
//  Created by Hikaru Watanabe on 3/29/16.
//  Copyright © 2016 Hikaru Watanabe. All rights reserved.
//

import UIKit

class Recipe{
  
  //Variables of Recipe
  var recipeID: Int!
  var recipeTypeID: Int!
  var title: String!
  var defaultServingSize: Int!
  var prepTime: Int!
  var cookTime: Int!
  var totalTime: Int!
  var finishingTime: Int!
  var orderNumber: Int!
  
  //Instantiations
  var recipeIngredients: [RecipeIngredients]? = nil
  var recipeTypes: RecipeTypes? = nil
  var prepSteps: [PrepSteps]? = nil
  var finishingSteps: [FinishingSteps]? = nil
  var recipeNotes:[RecipeNotes]? = nil
  var prepNotes: [PrepNotes]? = nil
  var finishingNotes: [FinishingNotes]? = nil
  var recipeTags: [RecipeTags]? = nil
  var ingredients: [Ingredients]? = nil
  var recipeInstructions: [RecipeInstructions]? = nil
  
}
