//
//  DataController.swift
//  Tyr's Haiku
//
//  Created by Tyr Zong on 11/30/22.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "HaikuModel")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext){
        do{
            try context.save()
            print("Data saved")
        } catch{
            print("Failed to save data")
        }
    }
    
    func addHaiku(line1: String, line2: String, line3: String, title: String, context: NSManagedObjectContext){
        let haiku = Haiku(context: context)
        haiku.id = UUID()
        haiku.date = Date()
        haiku.line1 = line1
        haiku.line2 = line2
        haiku.line3 = line3
        haiku.title = title
        
        save(context: context)
    }
    
    func editHaiku(haiku: Haiku, line1: String, line2: String, line3: String, title: String, context: NSManagedObjectContext){
        haiku.line1 = line1
        haiku.line2 = line2
        haiku.line3 = line3
        haiku.title = title
        
        save(context: context)
    }
}
