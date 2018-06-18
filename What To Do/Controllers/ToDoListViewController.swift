//
//  ViewController.swift
//  What To Do
//
//  Created by abolfazl mallahzadeh on 3/27/1397 AP.
//  Copyright © 1397 abolfazl mallahzadeh. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find "
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find Mike & james"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Mike and kill"
        itemArray.append(newItem3)
       
        
        
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
            itemArray = items
        }
    }

    
    // popoylate how many rows our table have
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //pupulate the table with the items availble at the itemArray
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //ternary opration
        //also you can remove ==true to shorten the code
        cell.accessoryType = item.done == true ? .checkmark : .none
   
        return cell
    }
    
    //tableview methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    //additems
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDO", message: "Add New Task", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new", style: .default) { (action) in
           
            let newItem = Item()
            newItem.title = textField.text!
           self.itemArray.append(newItem)
           self.tableView.reloadData()
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new task"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

