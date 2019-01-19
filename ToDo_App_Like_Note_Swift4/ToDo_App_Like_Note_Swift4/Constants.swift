//
//  Constants.swift
//  ToDo_App_Like_Note_Swift4
//
//  Created by DeEp KapaDia on 19/06/18.
//  Copyright © 2018 DeEp KapaDia. All rights reserved.
//

import Foundation

var ToDoList:[String]?


func SaveData(todoList:[String]){
    
    
    UserDefaults.standard.set(todoList, forKey: "ToDoList")
    
    
}


func FetchData() -> [String]? {
    
    if let ToDo = UserDefaults.standard.array(forKey: "ToDoList") as? [String] {
        
        return ToDo
        
    }else{
        
        return nil
        
    }
    
}
