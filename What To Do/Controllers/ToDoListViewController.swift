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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
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
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
   
        return cell
    }
    
    //tableview methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()
        
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
            self.saveData()
        
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new task"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        }catch{
            print("Unable to Encode the Data \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Unable to decode the data \(error)")
            }
        }
        self.tableView.reloadData()
    }
}

