//
//  RecipeIngredients.swift
//  Kitchen
//
//  Created by Hikaru Watanabe on 3/29/16.
//  Copyright © 2016 Hikaru Watanabe. All rights reserved.
//

import UIKit

class RecipeIngredients{
  //variables
  var recipeIngredientID: Int!
  var recipeID: Int!
  var ingredientID: Int!
  var measurementID: Int!
  var quantity: Float!
  var ingredientInstruction: String!
  var isWholeIngredient: Int!
  var isRoundUp: Int!
  
  //instantiations
  var measurements: Measurements!
  var ingredients: [Ingredients]!
  
  init(){
    measurements = nil
    ingredients = nil
  }
  
}
