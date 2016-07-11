//
//  ViewController.swift
//  Kitchen
//
//  Created by Hikaru Watanabe on 1/22/16.
//  Copyright © 2016 Hikaru Watanabe. All rights reserved.
//

import UIKit


///ViewController for an initial display. It contains navigation, search bar, recipe table view, segment control, tags, and ingredients
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  //MARK: - Variables
  @IBOutlet weak var navigation: UINavigationItem!
  var completionHandlers: CompletionHandlers!
  var recipeTableView: UITableView = UITableView()
  var segmentController = UISegmentedControl()
  var searchHit: Bool = false
  var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 300, 20))
  
  // Loading response
  var progressIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
  
  //recipe List for displaying in table.
  var recipes: [Recipe]! = [Recipe]()
  
  //array used for search filter
  var searchRecipes: [Recipe]? = nil
  
  
  //holder for tags and ingredients button, and currently pressed button's index
  struct tagIngredient{
    var currPressedTagIndex: Int? = nil         //Currently pressed tag button's index
    var currPressedIngredientIndex: Int? = nil  //Currently pressed ingredient button's index
    var tagButtons = [UIButton]()               //Array that holds all the tag buttons displayed on the screen
    var ingredientsButtons = [UIButton]()       //Array that holds all the ingredient buttons displayed on the screen
  }
  
  var topButtons: tagIngredient? = nil
  
  //tableview elements
  var maxDisplay: Int = 10
  var currentPage: Int = 1
  var numOfRecipes: Int?
  var lastPageDisplay: Int?
  var numPages: Int?
  var pageMultiplier: Int = 0
  
  var tableX_Cor: CGFloat = 50
  var tableY_Cor: CGFloat = 130
  var table_Width: CGFloat = 350
  var table_Height: CGFloat = 600
  
  //Note: for numSegments, it needs to add 4 for << < > >>
  var maxNumSegments: Int = 5
  var numSegments: Int = 5
  var needPageSet: Bool = false
  
  var segX_Cor: CGFloat = 0
  var segY_Cor: CGFloat = 0
  var seg_Width: CGFloat = 0
  var seg_Height: CGFloat = 0
  
  //Tag variables
  var tagText = UILabel()
  var ingredientsText = UILabel()
  
  var tagX_Cor: CGFloat = 550
  var tagY_Cor: CGFloat = 160
  var tag_Width: CGFloat = 150
  var tag_Height: CGFloat = 100
  
  var ingreX_Cor: CGFloat = 800
  var ingreY_Cor: CGFloat = 160
  var ingre_Width: CGFloat = 500
  var ingre_Height: CGFloat = 100
  
  //Check if orientation changed in segue. If so, then it needs to reposition all the UIs corresponding to changed orientation.
  var returnFromRecipeView: Bool = false {
    didSet{
      if(returnFromRecipeView){
        didRotateFromInterfaceOrientation(UIApplication.sharedApplication().statusBarOrientation)
        returnFromRecipeView = false
      }
    }
  }
  
  var recipeGetFailed: Bool = false{
    didSet{
      recipeGetFailed = true
      viewDidLoad()
    }
  }
  
  
  //MARK: - viewDidLoad and didReceiveMemoryWarning
  /**
  Configure tap interaction for keyboard and instantiate completion handler before calling GetRecipe.recipeList function.
  */
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Turn on loadingIndicator
    progressIndicator.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
    progressIndicator.center = view.center
    view.addSubview(progressIndicator)
    progressIndicator.bringSubviewToFront(view)
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    progressIndicator.startAnimating()
    
    completionHandlers = CompletionHandlers()
    completionHandlers.recipeViewController = self
    
    //Size format
    sizeInfoUpdate()
    
    //Screen touch interaction.
    //viewTapped for dismiss keyboard keyboard is displayed
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped))
    tap.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tap)
    
    //Get recipe list, and create UIs in completionhandler
    let getRecipe: GetRecipe = GetRecipe()
    getRecipe.viewController = self
    getRecipe.recipeList(10, numRecipes: 10, completionHandler: completionHandlers.setRecipeList)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //MARK: - Navigation + SearchBar
  /**
  Set navigation title, and configure navigation font color.
  Also, create search bar at right hand side of the navigation bar.
  */
  func navigationSetup(){
    navigation.title = "UIKitchen"
    navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    searchBar.delegate = self
    let searchButton = UIBarButtonItem(customView: searchBar)
    searchBar.placeholder = "Search recipe"
    self.navigation.rightBarButtonItem = searchButton
    self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    
  }
  
  /**
   After editting search bar, the function checks if there is a match with what user tied to search.
   If there is not matching recipe(s), then call back to original recipes.
   */
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    if let emptySearch = searchRecipes{
      if(emptySearch.count == 0 && searchHit){
        searchHit = false
        unselectButton()
        searchRecipes = nil
        reloadMainPage()
      }
    }
  }
  
  /**
   When user hits enter/search, this function will be called after searchBar.
   If there is a matiching recipe(s), it calls reloadMainPage() to reload the view.
   */
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    if(searchRecipes!.count == 0 || searchRecipes == nil){
      return
    }
    //At this point, it is sure that there are at least one or more recipes hit.
    searchHit = true
    
    reloadMainPage()
    searchBar.endEditing(true)
  }

  /**
   When user hits enter/search, this function is called to see if there are matching recieps.
   If there are matching recipes, store the recipes into searchRecieps.
   */
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    searchRecipes = recipes.filter({ (text) -> Bool in
      let tmp: NSString = text.title
      let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
      return range.location != NSNotFound
    })
  }
  
  
  //MARK: - Recipe Table View
  /**
   It creates table view of listing recipes.
   */
  func tableViewSetup(){
    // let tblView = UIView(frame: CGRectZero)
    recipeTableViewConfig()
    self.recipeTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    // recipeTableView.tableFooterView = tblView
    // recipeTableView.tableFooterView!.hidden = true
    recipeTableView.backgroundColor = UIColor.clearColor()
    recipeTableView.rowHeight = (table_Height/CGFloat(maxDisplay)) - 5
    recipeTableView.scrollEnabled = false
    self.view.addSubview(recipeTableView)
  }
  
  /**
   Sets the number of rows
   */
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    //If not the last page, return maxDiplay
    //else lastPageDisplay
    if(currentPage != numPages){
      return maxDisplay
    }else{
      return lastPageDisplay!
    }
  }
  
  /**
   Creates cell for the table view.
   */
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
    let cell: UITableViewCell = self.recipeTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
    cell.textLabel?.lineBreakMode = .ByWordWrapping
    cell.textLabel?.numberOfLines = 0
    cell.textLabel?.text = searchRecipes == nil ?
      recipes[(currentPage - 1) * maxDisplay + indexPath.row].title : searchRecipes![(currentPage - 1) * maxDisplay + indexPath.row].title
    cell.textLabel!.font = UIFont.systemFontOfSize(22.0)
    cell.layer.borderColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1).CGColor
    cell.layer.borderWidth = 1.2
    cell.layer.cornerRadius = 1
    return cell;
  }
  
  /**
   Arrives this function when user clicks the recipe in the list.
   */
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    tableView.cellForRowAtIndexPath(indexPath)?.contentView.backgroundColor = UIColor.whiteColor()
    self.performSegueWithIdentifier("tableViewSegue", sender: nil)
  }
  
  /**
   Configures the recipe table view.
   */
  func recipeTableViewConfig(){
    automaticallyAdjustsScrollViewInsets = false
    recipeTableView.frame = CGRectMake(tableX_Cor, tableY_Cor, table_Width, table_Height)
    recipeTableView.delegate = self
    recipeTableView.dataSource = self
  }
  
  /**
   Make a space for table view title.
   */
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {	
    return "      "
  }

  /**
   Set title for the recipe table view.
   */
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label: UILabel = UILabel()
    label.text = "Recipe"
    label.textAlignment = .Center
    label.font = label.font.fontWithSize(22)
    label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    label.backgroundColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1)
    label.layer.cornerRadius = 1
    label.layer.masksToBounds = true
    return label
  }

  
  
  
  
  //MARK: - Segmented Control
  /**
   Configures segment control.
   */
  func segmentSetup(){
    //Chaing segment's default text colors and tint color
    UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1)], forState: UIControlState.Normal)
    UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 1)], forState: UIControlState.Selected)
    UISegmentedControl.appearance().tintColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1)
    
    createRecipePageIndex()
    self.view.addSubview(segmentController)
  }
  
  /**
   Creates a segment for recipe table view.
   */
  func createRecipePageIndex(){
    //segment frame size
    segmentController.frame = CGRectMake(segX_Cor, segY_Cor, seg_Width, seg_Height)
    
    //creating segments
    segmentControllerInsert()
    
    //initially selected segment
    segmentController.selectedSegmentIndex = 2
    
    //handler
    //Notice: segmentPressed has : because function segmentPressed has an argument
    segmentController.addTarget(self, action: #selector(ViewController.segmentPressed(_:)), forControlEvents: UIControlEvents.ValueChanged)
  }
  
  /**
   Creates buttons for the segment.
   */
  func segmentControllerInsert(){
    var i: Int = 2;
    var j: Int = 0;
    var segTitle: String?
    var isLastPageSet: Bool = false
    var temp: Int?
    if((currentPage == numPages) && (numPages != 1)){
      temp = currentPage
      while(currentPage % maxNumSegments != 1){
        currentPage -= 1
      }
      isLastPageSet = true
    }
    segmentController.insertSegmentWithTitle("<<", atIndex: 0, animated: true)
    segmentController.insertSegmentWithTitle("<", atIndex: 1, animated: true)
    for(i = 2; i < numSegments + 2; i++, j++){
      if(currentPage+j > numPages){
        break
      }
      segTitle = "\(currentPage+j)"
      segmentController.insertSegmentWithTitle(segTitle!, atIndex: i, animated: true)
    }
    segmentController.insertSegmentWithTitle(">", atIndex: i, animated: true)
    segmentController.insertSegmentWithTitle(">>", atIndex: i+1, animated: true)
    if(isLastPageSet){
      currentPage = temp!
      //isLastPageSet = false
    }
  }
  
  /**
   Handles action after user clicks on one of the buttons of the segment
   */
  func segmentPressed(sender: UISegmentedControl){
    switch(sender.selectedSegmentIndex){
      case 0: //<<
        if(currentPage == 1){
          //Already at first page. Set seg-selected to 2, which is 1, and just return
          segmentController.selectedSegmentIndex = 2
          return
        } else{
          //It does not go into nested if statement if: Not at the first page yet segments set displayed contains the first page. Ex) 1 2 ... 4 5 and currently at 4
          
          if(currentPage > numSegments){
            pageMultiplier = 0
            needPageSet = true
          }
          currentPage = 1
        }
        pageSetChangeSetUp()
        segmentController.selectedSegmentIndex = 2
        break
      case 1: //<
        
        if(currentPage <= numSegments){
          //case: first page in current set
          if(currentPage == 1){
            //sub-case: already at the first page
            segmentController.selectedSegmentIndex = 2
            return
          }else {
            //sub-case: not at the first page
            currentPage = 1
          }
        }else{
          //first page not in the current set of pages; need previous pages set
          currentPage = currentPage - maxNumSegments
          while(currentPage % maxNumSegments != 1){
            currentPage -= 1
          }
          pageMultiplier -= 1
          needPageSet = true
        }
        pageSetChangeSetUp()
        segmentController.selectedSegmentIndex = 2
        break
      case (numSegments + 2):// >
        if(numPages! == 1){
          segmentController.selectedSegmentIndex = numSegments + 1
          return
        }
        if((numPages! == maxNumSegments) || ((numPages! - (numPages! % maxNumSegments)) < currentPage) || ((numPages! - (numPages! % maxNumSegments)) < currentPage + maxNumSegments) && (numPages! % maxNumSegments == 0)){
          //Case: already at the last page set
          if(currentPage == numPages!){
            //sub-case: already at the last page
            segmentController.selectedSegmentIndex = numSegments + 1
            return
          }else{
            //sub-case: not at the last page
            currentPage = numPages!
            segmentController.selectedSegmentIndex = numSegments + 1
          }
        }else{
          //case: next page set exist
          currentPage = currentPage + maxNumSegments
          while(currentPage % maxNumSegments != 1){
            currentPage -= 1
          }
          pageMultiplier += 1
          needPageSet = true
          pageSetChangeSetUp()
          segmentController.selectedSegmentIndex = 2
        }
        break
      case (numSegments + 3):// >>
        if(numPages! == 1){
          segmentController.selectedSegmentIndex = numSegments + 1
          return
        }
        if(currentPage == numPages!){
          //Already at the last page
          segmentController.selectedSegmentIndex = numSegments + 1
          return
        } else{
          //It does go into nested if statement if: there is next page set exist
          if((numPages! != maxNumSegments) && ((numPages! - (numPages! % maxNumSegments)) >= currentPage)){
            needPageSet = true
            pageMultiplier = (numPages! % maxNumSegments) == 0 ? (numPages! / maxNumSegments) - 1 : (numPages! / maxNumSegments)
          }
          currentPage = numPages!
        }
        pageSetChangeSetUp()
        segmentController.selectedSegmentIndex = numSegments + 1
        break
      default:
        currentPage = (sender.selectedSegmentIndex - 1) + (pageMultiplier * maxNumSegments)
        break
      
    }
    self.recipeTableView.reloadData()
  }
  
  
  
  
  
  //MARK: - Tags + Ingredients
  /**
   Sets up for tags and ingredients
   */
  func tagSetup(){
    topButtons = tagIngredient()
    
    tagText = UILabel(frame: CGRectMake(tagX_Cor, tagY_Cor, tag_Width, tag_Height))
    ingredientsText = UILabel(frame: CGRectMake(ingreX_Cor, ingreY_Cor, ingre_Width,ingre_Height))
    
    tagText.adjustsFontSizeToFitWidth = true
    ingredientsText.adjustsFontSizeToFitWidth = true
    
    tagText.text = "Top Tags"
    ingredientsText.text = "Top Ingredients"
    
    tagText.font = tagText.font.fontWithSize(25)
    ingredientsText.font = ingredientsText.font.fontWithSize(25)
    
    
    tagText.textColor = UIColor(red: 129/255.0, green: 0, blue: 0, alpha: 1)
    ingredientsText.textColor = UIColor(red: 129/255.0, green: 0, blue: 0, alpha: 1)
    
    self.view.addSubview(tagText)
    self.view.addSubview(ingredientsText)
  }
  
  func topTen(){
    // TODO: - Replace next two items when API available
    let topTags: [String] = ["Kimchi", "Wings", "Pizza", "RoastBeef", "Fish", "Strawberry Cake", "Lemon", "Samgyopsal", "Banana Pie", "Cherry Crush", "Hamburger", "Steak", "Sandwich", "Cold Sub", "Ice cream", "Fried Rice", "Salad"]
    let topIngredients: [String] = ["Chicken", "Banana", "Beef", "Fish", "Pork", "Cabbage", "Cherry", "Beef", "Lamb", "Coconut", "Pineapple", "Olives", "Red Onions", "Potato", "Yellow Pepper", "Spinach", "Shrimp", "Apple"]
    
    var stackTry:Stack<String> = pushToStack(topTags)
    topMake(stackTry, type: "tag")
    
    stackTry.reset()
    stackTry = pushToStack(topIngredients)
    topMake(stackTry, type: "ingredient")
  }
  
  /**
   Creates tags and ingredients.
   */
  func topMake(var stackTry: Stack<String>, type: String){
    var heightLeft = 0 //initial: 10
    var widthLeft  = 0 //initial: 15
    var widthPadding: CGFloat = 0
    var x_Cor: CGFloat = 0
    var y_Cor: CGFloat = 0
    var i = 0
    var temp: String?
    var tempStack:Stack<String> = Stack<String>()
    var buttons = [UIButton]()
    var buttonPressed: Selector
    
    if(type == "tag"){
      x_Cor = tagX_Cor
      y_Cor = tagY_Cor
      buttonPressed = #selector(ViewController.tagPressed(_:))
    }else{
      x_Cor = ingreX_Cor
      y_Cor = ingreY_Cor
      buttonPressed = #selector(ViewController.ingredientPressed(_:))
    }
    
    while(heightLeft <= 15 && !stackTry.empty()){
      widthLeft = 0
      while(widthLeft <= 18 && !stackTry.empty()){
        while(true){
          temp = stackTry.pop()
          if(temp!.characters.count <= 18 - widthLeft){
            break
          }
          tempStack.push(temp!)
          temp = nil
          if(stackTry.empty()){
            break
          }
        }
        if(temp == nil){
          break
        }
        
        buttons.append((UIButton(frame: CGRectMake(x_Cor + (CGFloat(widthPadding)), y_Cor + CGFloat(heightLeft * 45) + 80, 0, 0))))
        buttons[i].backgroundColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1)
        buttons[i].setTitle(" \(temp!) ", forState:UIControlState.Normal)
        buttons[i].addTarget(self, action: buttonPressed, forControlEvents: UIControlEvents.TouchUpInside)
        buttons[i].sizeToFit()
        buttons[i].layer.cornerRadius = 5
        buttons[i].layer.borderWidth = 1
        buttons[i].layer.borderColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1).CGColor
        self.view.addSubview(buttons[i])
        widthLeft += temp!.characters.count
        widthPadding += buttons[i].frame.size.width + 10
        temp = nil
        i += 1
      }
      if(stackTry.empty() && tempStack.empty()){
        break
      }
      while(!tempStack.empty()){
        stackTry.push(tempStack.pop())
      }
      heightLeft += 1
      widthPadding = 0
    }
    
    if(type == "tag"){
      topButtons!.tagButtons = buttons
    }else{
      topButtons!.ingredientsButtons = buttons
    }
  }
  
  /**
   Action that is taken after user clicked on one of the tags.
   */
  func tagPressed(sender: UIButton){
    //check if pressed button is pressed again. If so, undo
    let prevButton: Int? = topButtons!.currPressedTagIndex
    
    //unselect previous choice, if there is
    unselectButton()
    
    //select
    if (prevButton != topButtons!.tagButtons.indexOf(sender)!){
      sender.backgroundColor = UIColor(red: 129/255.0, green: 0, blue: 0, alpha: 1)
      topButtons!.currPressedTagIndex = topButtons!.tagButtons.indexOf(sender)!
    }
    
    if let tagIndex: Int = topButtons!.currPressedTagIndex{
      let tagSearchKey = topButtons!.tagButtons[tagIndex].titleLabel!.text!
      tagSearch(tagSearchKey)
    }else{
      searchRecipes = nil
      reloadMainPage()
    }
    
  }
  
  /**
   Get recipes with tag "tagSearchKey"
   */
  func tagSearch(tagSearchKey: String){
    // TODO: - Make API call
    searchBar.text = "" //Before search by tag, empty the search bar string
    searchRecipes = [Recipe]()
    //THIS IS FAKE RECIPE SET IN ORDER TO ENABLE functionality
    for index in 0..<111{
      let recipe: Recipe = Recipe()
      recipe.title = "\(index)Kimchi"
      searchRecipes?.append(recipe)
    }
    reloadMainPage()
  }

  /**
   Action that is taken after user clicked on one of the ingredients.
   */
  func ingredientPressed(sender: UIButton){
    //check if pressed button is pressed again. If so, undo
    let prevButton: Int? = topButtons!.currPressedIngredientIndex
    
    //unselect previous choice, if there is
    unselectButton()
    //select
    if (prevButton != topButtons!.ingredientsButtons.indexOf(sender)!){
      sender.backgroundColor = UIColor(red: 129/255.0, green: 0, blue: 0, alpha: 1)
      topButtons!.currPressedIngredientIndex = topButtons!.ingredientsButtons.indexOf(sender)!
    }
    
    if let ingreIndex = topButtons!.currPressedIngredientIndex{
      let ingreSearchkey = topButtons!.ingredientsButtons[ingreIndex].titleLabel!.text!
      ingreSearch(ingreSearchkey)
    }else{
      searchRecipes = nil
      reloadMainPage()
    }
  }
  
  func ingreSearch(ingreSearchkey: String){
    // TODO: - Make API call
    searchBar.text = "" //Before search by ingredient, empty the search bar string
    searchRecipes = [Recipe]()
    //THIS IS FAKE RECIPE SET IN ORDER TO ENABLE functionality
    for index in 0..<555{
      let recipe: Recipe = Recipe()
      recipe.title = "\(index)Kimchi"
      searchRecipes?.append(recipe)
    }
    reloadMainPage()
  }
  
  /**
   Unselect either tag or ingredient that is currently pressed.
   */
  func unselectButton(){
    if let unselectIndex = topButtons!.currPressedTagIndex{
      topButtons!.tagButtons[unselectIndex].backgroundColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1)
      topButtons!.currPressedTagIndex = nil
      return
    }
    
    if let unselectIndex = topButtons!.currPressedIngredientIndex{
      topButtons!.ingredientsButtons[unselectIndex].backgroundColor = UIColor(red: 162/255.0, green: 0, blue: 0, alpha: 1)
      topButtons!.currPressedIngredientIndex = nil
    }
  }
  

  
  
  
  //MARK: - Others
  /**
   Handles calculationst to recognize appropriate number of recipes.
   */
  func calcRecipeInfo(){
    // How many recipes
    numOfRecipes = (searchRecipes != nil) ? self.searchRecipes!.count : self.recipes.count
    
    //How many recipes will be displayed in the last page
    lastPageDisplay = ((numOfRecipes! % maxDisplay) == 0) ? maxDisplay : numOfRecipes! % maxDisplay
    
    //Need to reset current page for the case when searched
    currentPage = 1
    
    //number of pages
    if(numOfRecipes < maxDisplay){
      numPages = 1
    } else if(lastPageDisplay != maxDisplay){
      numPages = (numOfRecipes!/maxDisplay) + 1
    }else{
      numPages = (numOfRecipes!/maxDisplay)
    }
    
    if(numPages! < maxNumSegments){
      numSegments = numPages!
    }
  }
  
  /**
   Handles orientation rotate.
   */
  override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    var i = 0
    var tempTagButtons = [UIButton]()
    var tempIngredientsButtons = [UIButton]()
    for button in topButtons!.tagButtons{
      tempTagButtons.append(button)
      tempTagButtons[i].frame.origin.x = tempTagButtons[i].frame.origin.x - (tagX_Cor)
      tempTagButtons[i].frame.origin.y = tempTagButtons[i].frame.origin.y - (tagY_Cor)
      i += 1
    }
    i = 0
    for button in topButtons!.ingredientsButtons{
      tempIngredientsButtons.append(button)
      tempIngredientsButtons[i].frame.origin.x = tempIngredientsButtons[i].frame.origin.x - (ingreX_Cor)
      tempIngredientsButtons[i].frame.origin.y = tempIngredientsButtons[i].frame.origin.y - (ingreY_Cor)
      i+=1
    }

    sizeInfoUpdate()
    
    recipeTableView.rowHeight = (table_Height/CGFloat(maxDisplay)) - 5
    for cell in recipeTableView.visibleCells{
      if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)){
        cell.textLabel!.font = UIFont.systemFontOfSize(22.0)
      }else{
        cell.textLabel!.font = UIFont.systemFontOfSize(22.0)
      }
    }
    recipeTableView.frame = CGRectMake(tableX_Cor, tableY_Cor, table_Width, table_Height)
    segmentController.frame = CGRectMake(segX_Cor, segY_Cor, seg_Width, seg_Height)
    tagText.frame = CGRectMake(tagX_Cor, tagY_Cor, tag_Width, tag_Height)
    
    ingredientsText.frame = CGRectMake(ingreX_Cor, ingreY_Cor, ingre_Width,ingre_Height)
    for(i = 0; i < topButtons!.tagButtons.count; i++){
      tempTagButtons[i].frame.origin.x = tempTagButtons[i].frame.origin.x + (tagX_Cor)
      tempTagButtons[i].frame.origin.y = tempTagButtons[i].frame.origin.y + (tagY_Cor)
      topButtons!.tagButtons[i] = tempTagButtons[i]
    }
    for(i = 0; i < topButtons!.ingredientsButtons.count; i++){
      tempIngredientsButtons[i].frame.origin.x = tempIngredientsButtons[i].frame.origin.x + (ingreX_Cor)
      tempIngredientsButtons[i].frame.origin.y = tempIngredientsButtons[i].frame.origin.y + (ingreY_Cor)
      topButtons!.ingredientsButtons[i] = tempIngredientsButtons[i]
    }

  }

  /**
   Change index in segment.
   */
  func pageSetChangeSetUp(){
    if(needPageSet){
      if((numPages! - (numPages! % maxNumSegments)) < currentPage){
        numSegments = numPages! % maxNumSegments
      }else{
        numSegments = maxNumSegments
      }
      segmentController.removeAllSegments()
      segmentControllerInsert()
      needPageSet = false
    }
  }
  
  /**
   If search result is 0, it reloads main page.
   */
  func reloadMainPage(){
    calcRecipeInfo()
    needPageSet = true
    pageSetChangeSetUp()
    segmentController.selectedSegmentIndex = 2
    self.recipeTableView.reloadData()
  }

  /**
   Exits search when screen other than keyboard is tapped.
   */
  func viewTapped(){
    searchBar.resignFirstResponder()
  }
  
  /**
   Pushes given string array elements on to stack.
   */
  func pushToStack(toPush: [String]) -> Stack<String>{
    var i = toPush.count - 1
    var stack = Stack<String>()
    for(; i >= 0; i--){
      stack.push(toPush[i])
    }
    return stack
  }
  
  /**
   Sets UI positions based on current orientation. Positions are set for ipad-Retina
   */
  func sizeInfoUpdate(){
  if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)){
      //Portrait
      tableX_Cor =  40
      tableY_Cor =  70
      table_Width = 360
      table_Height = 880
    
      maxNumSegments = 5
      segX_Cor = 37.5
      segY_Cor = 945
      seg_Width = 365
      seg_Height = 35
    
      tagX_Cor = 460
      tagY_Cor = 50
      tag_Width = 200
      tag_Height = 100
    
      ingreX_Cor = 460
      ingreY_Cor = 500
      ingre_Width = 200
      ingre_Height = 100
    } else{
      //Landscape
      tableX_Cor = 20
      tableY_Cor = 70
      table_Width = 460
      table_Height = 680
    
      maxNumSegments = 5
      segX_Cor = 19
      segY_Cor = 735
      seg_Width = 465
      seg_Height = 25
    
      tagX_Cor = 510
      tagY_Cor = 80
      tag_Width = 200
      tag_Height = 100
    
      ingreX_Cor = 750
      ingreY_Cor = 80
      ingre_Width = 200
      ingre_Height = 100
    }
  }
  
  /**
   When user presses recipe in the recipe table view, it prepares and jumps to respective RecipeViewController.
   */
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "tableViewSegue"){
      
      let recipeViewController = segue.destinationViewController as! RecipeViewController
      recipeViewController.recipeSelectionView = self
      
      let cell = recipeTableView.cellForRowAtIndexPath(recipeTableView.indexPathForSelectedRow!)
      recipeViewController.recipe = searchRecipes == nil ? recipes[recipeTableView.indexPathForSelectedRow!.row + ((currentPage-1)*maxDisplay)] : searchRecipes![recipeTableView.indexPathForSelectedRow!.row + ((currentPage-1)*maxDisplay)]

      let recipeTitle = cell!.textLabel!.text!
      recipeViewController.recipe.title = recipeTitle
    }
  }
  
}