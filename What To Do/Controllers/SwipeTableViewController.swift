//
//  SwipeTableViewController.swift
//  What To Do
//
//  Created by abolfazl mallahzadeh on 3/30/1397 AP.
//  Copyright © 1397 abolfazl mallahzadeh. All rights reserved.
//

import UIKit
import SwipeCellKit
class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self        
        return cell
    }
    //SwipeCell Delegate Methods
    
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                
                self.updateModel(at: indexPath)
                
//               
            }
            
            // customize the action appearance
            deleteAction.image = UIImage(named: "Trash Icon")
            
            return [deleteAction]
        }
        
        
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
            return options
        }
    func updateModel(at indexPath: IndexPath){
     print("Item Deleted")
    }
    }

