//
//  GetRecipe.swift
//  Kitchen
//
//  Created by Hikaru Watanabe on 4/7/16.
//  Copyright © 2016 Hikaru Watanabe. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Darwin

class GetRecipe{

  weak var viewController: ViewController?
  weak var setView: SetView?
  
  /*
  let baseURL: String = "CHANGE NEEDED"
  let version: String
  
  init(version: String){
    self.version = version
  }*/
  
  /**
  It gets a list of recipes.
  
  - Parameter pageNumber:        Index that decides which page of recipes.
  - Parameter numRecipes:        A number of recipes to get.
  - Parameter completionHandler: Function that is called after GET operation is done.
  */
  func recipeList(pageNumber: Int, numRecipes: Int = 10, completionHandler: (JSON, Int) -> Void){
    let url: String = "http://jsonplaceholder.typicode.com/posts"
    Alamofire.request(.GET, url).responseJSON{(response) -> Void in
      guard response.result.error == nil else{
        print("Error: unable to get a list of recipes.")
        self.viewController!.recipeGetFailed = true
        return
      }
      if let responseValue = response.result.value{
        let recipeList = JSON(responseValue)
        completionHandler(recipeList, numRecipes)
      }
    }
  }


  //Get recipe's information from given url
  func information(recipeID: Int, url: String, setView: SetView, completionHandler:(JSON, SetView)->Void){
    Alamofire.request(.GET, url).responseJSON{(response) -> Void in
      guard response.result.error == nil else{
        print("Error: unable to get recipe information.")
        return
      }
      if let responseValue = response.result.value{
        let recipeInformation = JSON(responseValue)
        completionHandler(recipeInformation, setView)
      }
    }
  }

  
  
  
  
}
