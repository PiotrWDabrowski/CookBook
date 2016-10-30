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

extension UIView {
    func showActivityIndicatory() -> UIActivityIndicatorView
    {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        activityIndicator.center = CGPointMake(self.frame.width/2, self.frame.height/2)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.White
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        return activityIndicator
    }
}

protocol RecipeSelectionDelegate: class {
    func selectRecipe(newRecipe: Recipe)
}

class MasterViewController: UITableViewController {
    
    weak var delegate: RecipeSelectionDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    var recipes = [Recipe]()
    var filteredRecipes = [Recipe]()
    var isLoadingMore : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSearchBar()
        self.loadMore()
        self.refreshControl?.addTarget(self, action: #selector(MasterViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.isLoadingMore = false
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
        return self.activeRecipeArray().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MasterTableViewCell = tableView.dequeueReusableCellWithIdentifier("RecipeGeneralCell", forIndexPath: indexPath) as! MasterTableViewCell
        
        let recipe: Recipe = self.activeRecipeArray()[indexPath.row]
        
        cell.tag = indexPath.row
        cell.recipeTextLabel!.text = recipe.title
        cell.recipeDetailedTextLabel!.text = recipe.detailedDescription
        cell.recipeImage.image = nil
        cell.recipeImage.backgroundColor = UIColor.lightGrayColor()
        
        let indicator : UIActivityIndicatorView = cell.recipeImage.showActivityIndicatory()
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            ImageManager.sharedInstance.fetchImage(recipe.imageUrl) { (image: UIImage) in
                if (cell.tag == indexPath.row) {
                    dispatch_async(dispatch_get_main_queue(),{
                        indicator.stopAnimating()
                        cell.recipeImage.image = image
                    })
                }
            }
        })
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (self.recipes.count-1 == indexPath.row) {
            self.loadMore()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedRecipe = self.activeRecipeArray()[indexPath.row]
        self.delegate?.selectRecipe(selectedRecipe)
        
        if let detailViewController = self.delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
    
    func loadMore() {
        if (self.isLoadingMore) {
            return
        }
        self.isLoadingMore = true
        ObjectManager.sharedInstance.fetchRecipes(self.recipes.count, completion: { (recipes: [Recipe]?) in
            if recipes != nil {
                if (recipes?.count > 0) {
                    self.recipes.appendContentsOf(recipes!)
                    self.tableView.reloadData()
                }
            }
            self.isLoadingMore = false
        });
    }
    
    func refresh(sender:AnyObject)
    {
        if (self.recipes.count == 0) {
            self.loadMore()
        }
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func activeRecipeArray() -> [Recipe] {
        if searchController.active && searchController.searchBar.text != "" {
            return self.filteredRecipes
        }
        return self.recipes
    }
}