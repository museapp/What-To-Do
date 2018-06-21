//
//  ViewController.swift
//  What To Do
//
//  Created by abolfazl mallahzadeh on 3/27/1397 AP.
//  Copyright © 1397 abolfazl mallahzadeh. All rights reserved.
//

import UIKit
import RealmSwift
import  ChameleonFramework
class ToDoListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    var itemResults: Results<Item>?
    var colourgrade: CGFloat = 0.5
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
   let realm = try! Realm()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      
        
        
//        loadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        title = selectedCategory!.name
         guard let coloutHex = selectedCategory?.backgroundColour else {fatalError()}
        updateNavbar(withHexCode: coloutHex)
            
        }
            
    override func viewWillDisappear(_ animated: Bool) {
       updateNavbar(withHexCode: "FF5733")
    }
            
    func updateNavbar(withHexCode colourHexCode:String ){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.barTintColor = navBarColour
        searchBarOutlet.barTintColor = navBarColour
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        
        
    }
    


    
    // popoylate how many rows our table have
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
        
    }
    
    
    //pupulate the table with the items availble at the itemArray
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = itemResults?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.backgroundColour)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(CGFloat(itemResults!.count)/CGFloat(colourgrade))){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.itemResults?[indexPath.row]{
            
            //super.updateModel(at: indexPath)
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }
            catch{
                print("Cannot Delete Item \(error)")
            }
            //           tableView.reloadData()
        }
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




