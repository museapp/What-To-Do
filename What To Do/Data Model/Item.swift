//
//  Item.swift
//  What To Do
//
//  Created by abolfazl mallahzadeh on 3/29/1397 AP.
//  Copyright © 1397 abolfazl mallahzadeh. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
