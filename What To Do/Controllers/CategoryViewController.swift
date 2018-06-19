//
//  CategoryViewController.swift
//  What To Do
//
//  Created by abolfazl mallahzadeh on 3/29/1397 AP.
//  Copyright © 1397 abolfazl mallahzadeh. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categoryArray: Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        //Mark : - TableView DataSource Methods
        
        //Mark : - Data Manipulation Methods
        
        //Mark : - Add New Categories
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Cannot Save to Categories \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()

    }
    

}
//Search bar
extension CategoryViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        categoryArray = categoryArray?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)

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
