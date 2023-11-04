//
//  Recipe+Ext.swift
//  Ritual
//
//  Created by Tyler Rhodes on 11/1/23.
//

import Foundation
import CoreData

extension Recipe: BaseModel {
    
    static var all: NSFetchRequest<Recipe> {
        let request = Recipe.fetchRequest()
        request.sortDescriptors = []
        return request
    }
}
