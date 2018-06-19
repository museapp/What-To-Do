//
//  Category.swift
//  What To Do
//
//  Created by abolfazl mallahzadeh on 3/29/1397 AP.
//  Copyright © 1397 abolfazl mallahzadeh. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    var items = List<Item>()
}
