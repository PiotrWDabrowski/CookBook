//
//  MasterViewController.swift
//  CookBook
//
//  Created by Piotr Dąbrowski on 27/10/16.
//  Copyright © 2016 Piotr Dąbrowski. All rights reserved.
//

import UIKit

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class MasterViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var recipes = [Recipe]()
    var filteredRecipes = [Recipe]()
    
    override func viewDidLoad() {
        self.initSearchBar()
        
        NetworkManager.sharedInstance.fetchRecipes(self.recipes.count, completion: { (recipes: [Recipe]?) in
            if recipes != nil {
                self.recipes = recipes!
            }
            self.tableView.reloadData()
        });
        
        super.viewDidLoad()
    }
    
    // MARK: - SearchBar support
    
    func initSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredRecipes = recipes.filter { recipe in
            return recipe.agreggatedString().lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredRecipes.count
        }
        return recipes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MasterTableViewCell = tableView.dequeueReusableCellWithIdentifier("RecipeGeneralCell", forIndexPath: indexPath) as! MasterTableViewCell
        
        let recipe: Recipe
        if searchController.active && searchController.searchBar.text != "" {
            recipe = self.filteredRecipes[indexPath.row]
        } else {
            recipe = self.recipes[indexPath.row]
        }
        
        cell.tag = indexPath.row
        cell.recipeTextLabel!.text = recipe.title
        cell.recipeDetailedTextLabel!.text = recipe.detailedDescription
        cell.recipeImage.image = nil
        
        return cell
    }
}