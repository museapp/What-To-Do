//
//  ViewController.swift
//  What To Do
//
//  Created by abolfazl mallahzadeh on 3/27/1397 AP.
//  Copyright © 1397 abolfazl mallahzadeh. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
   
    //CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        loadData()
        
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //additems
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDO", message: "Add New Task", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        
        do{
           try context.save()
        }catch{
          print("Cannot Save to DataBase \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest() , predicate:NSPredicate? = nil){

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//        request.predicate = compoundPredicate
        do{
        itemArray = try context.fetch(request)
        }catch{
            print("Unable to Load Database \(error)")
        }
        tableView.reloadData()
    }
  
}
    //Mark: - Search bar Methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request, predicate: predicate)

        
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
    

