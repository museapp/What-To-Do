//
//  ViewController.swift
//  What To Do
//
//  Created by abolfazl mallahzadeh on 3/27/1397 AP.
//  Copyright © 1397 abolfazl mallahzadeh. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController {

    var itemResults: Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
   let realm = try! Realm()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        loadData()
        
    }

    
    // popoylate how many rows our table have
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
        
    }
    
    
    //pupulate the table with the items availble at the itemArray
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemResults?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            //ternary opration
            //also you can remove ==true to shorten the code
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items Added"
        }
        
        return cell
    }
    
    //tableview methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemResults?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
            }
            }catch{
                print("Error Saving done Status \(error)")
            }
        }
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //additems
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDO", message: "Add New Task", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new", style: .default) { (action) in

            if let currentCategory = self.selectedCategory {
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                }
                catch{
                    print("cannot save to items \(error)")
                }
                self.tableView.reloadData()
            }
            
        
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new task"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    func loadData(){
        
        itemResults = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
  
}
    //Mark: - Search bar Methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemResults = itemResults?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}


