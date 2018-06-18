//
//  CategoryViewController.swift
//  What To Do
//
//  Created by abolfazl mallahzadeh on 3/29/1397 AP.
//  Copyright © 1397 abolfazl mallahzadeh. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        //Mark : - TableView DataSource Methods
        
        //Mark : - Data Manipulation Methods
        
        //Mark : - Add New Categories
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
       performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategories() {
        
        do{
            try context.save()
        }catch{
            print("Cannot Save to Categories \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Unable to Load Categoies \(error)")
        }
        tableView.reloadData()
    }
    

}
//Search bar
extension CategoryViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        loadCategories(with: request)


    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCategories()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
