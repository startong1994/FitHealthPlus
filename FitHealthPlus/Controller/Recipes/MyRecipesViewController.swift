//
//  MyRecipesViewController.swift
//  FitHealth+
//
//  Created by xu daitong on 10/22/20.
//  Copyright © 2020 xu daitong. All rights reserved.
//

import UIKit
import Firebase

class MyRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    
    // View for sort feature
    var containerView = UIView()
    
    //Database
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    
    // Variables
    var listRecipes = [recipeItem]()
    var myIndex = 0
    var choice = 0
    var searchingItems = [recipeItem]()
    var searching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "My Recipes"
        self.tabBarController?.tabBar.isHidden = true
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        setUpSearchBar()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    
        //code to get data from local UserDefault data, get name when it is loaded
        guard let username = defaults.dictionary(forKey: "CurrentUser")!["name"]else{
            print("name not found")
            return
        }
        //Get data from the firestore database and populate the tableview
        db.collection("Recipe").document(username as! String).collection("My Recipes").addSnapshotListener { (QuerySnapshot, error) in
            if let err = error {
                debugPrint("Error Fetching docs:  \(err)")
            } else {
                self.listRecipes = []
                for document in QuerySnapshot!.documents {
                    //let data = document.data()
                    let recipeName = document.get("name") as? String ?? "Item"
                    let ckTime = document.get("cookTime") as? String ?? "Item"
                    let servingSize = document.get("servings") as? String ?? "Item"
                    let categoryPicker = document.get("category") as? String ?? "None"
                    let itemCalories = document.get("calories") as? Int ?? 0
                    let itemCarb = document.get("carb") as? Int ?? 0
                    let ingr = document.get("ingredients") as? String ?? "Item"
                    let dir = document.get("directions") as? String ?? "Item"
                    let itemCholesterol = document.get("cholesterol") as? Int ?? 0
                    let itemFat = document.get("fat") as? Int ?? 0
                    let itemFiber = document.get("fiber") as? Int ?? 0
                    let itemProtein = document.get("protein") as? Int ?? 0
                    let itemSodium = document.get("sodium") as? Int ?? 0
                    let itemSugar = document.get("sugar") as? Int ?? 0
                    
                    let newItem = recipeItem(
                        name: recipeName,
                                  cookTime: ckTime,
                                  servings: servingSize,
                                  category: categoryPicker,
                                  ingredients: ingr,
                                  directions:dir,
                                  calories: itemCalories,
                                  fat: itemFat,
                                  sodium: itemSodium,
                                  carb: itemCarb,
                                  fiber: itemFiber,
                                  sugar: itemSugar,
                                  protein:itemProtein,
                                  cholesterol: itemCholesterol
                    )
                    
                    self.listRecipes.append(newItem)
                }
                DispatchQueue.main.async {
                    self.recipeTableView.reloadData()
                }
            }
        }
    }
   /*
   override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // UIMenu for the Sort menu
        let sortByMenu = UIMenu(title: "Test", options: .displayInline, children: [
            UIAction(title: "A-Z",handler: {[sortByName] _ in sortByName()}),
            UIAction(title: "Z-A",handler: {[sortZtoA] _ in sortZtoA()}),
            UIAction(title: "Category",handler: {[sortByCategory] _ in sortByCategory()}),
            UIAction(title: "Calories",handler: {[sortByCalorie] _ in sortByCalorie()})
        ])
        
        let sortButton = UIBarButtonItem(title: "Sort", primaryAction: nil, menu: sortByMenu)
        sortButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [addButton, sortButton]
    }
    
    
     // Sort By Function for A-Z
     @objc func sortByName(){
         listRecipes = listRecipes.sorted(by: { $0.name < $1.name})
         recipeTableView.reloadData()
     }
     
     // Sort By Function for Z-A
     @objc func sortZtoA(){
         listRecipes = listRecipes.sorted(by: { $0.name > $1.name})
         recipeTableView.reloadData()
     }
     
     // Sort By Function for Calories
     @objc func sortByCalorie(){
         listRecipes = listRecipes.sorted(by: { $0.calories < $1.calories})
         recipeTableView.reloadData()
     }
     
     // Sort By Category
     @objc func sortByCategory(){
         listRecipes = listRecipes.sorted(by: { $0.category < $1.category})
         recipeTableView.reloadData()
     }
     
     // added code by Daitong Xu, deselectRow,
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         tableView.deselectRow(at: indexPath, animated: true)
     }
    */
    
    /*
    // Segue for the edit view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath = recipeTableView.indexPath(for: cell) {
                let vc = segue.destination as! EditRecipeViewController
                vc.getName = listRecipes[indexPath.row].name
                vc.getCategory = listRecipes[indexPath.row].category
                vc.ingredients = listRecipes[indexPath.row].ingredients
                vc.getCalories = listRecipes[indexPath.row].calories
                vc.getSugar = listRecipes[indexPath.row].sugar
                vc.getProtein = listRecipes[indexPath.row].protein
                vc.getFiber = listRecipes[indexPath.row].fiber
                vc.getCarb = listRecipes[indexPath.row].carb
                vc.getCholesterol = listRecipes[indexPath.row].cholestrol
                vc.getFat = listRecipes[indexPath.row].fat
                vc.getSodium = listRecipes[indexPath.row].sodium
                vc.servings = listRecipes[indexPath.row].servings
                vc.directions = listRecipes[indexPath.row].directions
                vc.cookTime = listRecipes[indexPath.row].cookTime
                
            }
        }
    }
    */
    
    // search bar set up function
    func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        //searchController.navigationItem.hidesSearchBarWhenScrolling = true
        let searchBar = UISearchBar(frame: CGRect.init(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["Name", "Categories"]
        searchController.searchBar.delegate = self
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemTeal
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
    }
    
    // filtered results for search query
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            searching = false
            searchingItems = listRecipes
            recipeTableView.reloadData()
        }else{
            searching = true
            filterTableView(index: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    // search bar cancel action
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        recipeTableView.reloadData()
    }
    
    //search bar
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchingItems.count
        }
        return listRecipes.count
        
    }
    
    // add data to table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipes = tableView.dequeueReusableCell(withIdentifier: "recipes", for: indexPath) as! recipeCell
        if searching{
            let itemsInCell = searchingItems[indexPath.row]
            recipes.recipeName.text = itemsInCell.name
            recipes.recipeCategory.text = "Categories: " + String(itemsInCell.category)
            
        }else{
            let itemsInCell = listRecipes[indexPath.row]
            recipes.recipeName.text = itemsInCell.name
            recipes.recipeCategory.text = "Categories: " + String(itemsInCell.category)
            
        }
        //cell.pantryCellView.layer.cornerRadius = cell.pantryCellView.frame.height / 2
        return recipes
    }
    
    //filter table based on scope button of search bar
    func filterTableView(index: Int, text: String) {
        switch index {
        case 0:
            searching = true
            searchingItems = listRecipes.filter({ $0.name.lowercased().prefix(text.count) == text.lowercased()})
            recipeTableView.reloadData()
        case 1:
            searching = true
            searchingItems = listRecipes.filter({ $0.category.lowercased().prefix(text.count) == text.lowercased()})
            recipeTableView.reloadData()
        case 2:
            searching = true
            searchingItems =  listRecipes.filter({ String($0.calories).lowercased().prefix(text.count) == text.lowercased()})
            recipeTableView.reloadData()
        default:
            print("no type")
        }
    }
    
    //delete item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let docName = listRecipes[indexPath.row].name
            guard let username = defaults.dictionary(forKey: "CurrentUser")!["name"]else{
                print("name not found")
                return
            }
            db.collection("Recipe").document(username as! String).collection("My Recipes").document(docName).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed")
                }
                
            }
            listRecipes.remove(at: indexPath.row)
            recipeTableView.reloadData()
        }
    }
    
    //unwind seque for add vc and edit vc
    @IBAction func unWindToList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? AddRecipeViewController, let item = sourceViewController.item{
            let newIndexPath = IndexPath(row: listRecipes.count, section: 0)
            listRecipes.append(item)
            recipeTableView.insertRows(at: [newIndexPath], with: .automatic)
            
        }
    }
}

// Class for the Pantry cell view
class recipeCell: UITableViewCell{

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeCategory: UILabel!
    
    
}
