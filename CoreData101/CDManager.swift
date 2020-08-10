//
//  CDManager.swift
//  CoreData101
//
//  Created by Muhammad Tafani Rabbani on 10/08/20.
//  Copyright © 2020 Muhammad Tafani Rabbani. All rights reserved.
//

import UIKit
import CoreData

struct DataType {
    var name1 : String
    var name2 : String
    var photo : Data
}

class CDManager:NSObject{
    
    var dataType = DataType(name1: "", name2: "", photo: Data())
    
    override init() {
        super.init()
        self.readData()
    }
    
    func readData(){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MData")
        
        do{
            let res = try context.fetch(fetchRequest)
            
            if res.count > 0{
                let a = res[0] as! NSManagedObject
                
                guard let name1 = a.value(forKey: "name1") else{
                    return
                }
                self.dataType.name1 = name1 as! String
                
                guard let name2 = a.value(forKey: "name2")else{
                    return
                }
                self.dataType.name2 = name2 as! String
                
                guard let mPhoto = a.value(forKey: "photo") else {
                    return
                }
                self.dataType.photo =  mPhoto as! Data
                
            }else{
                saveData()
                print("Empty")
            }
            
        }
        catch{
            
        }
    }
    
    
    func saveData(){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "MData", into: context)
        
        entity.setValue(dataType.name1, forKey: "name1")
        entity.setValue(dataType.name2, forKey: "name2")
        entity.setValue(dataType.photo, forKey: "photo")
    }
    
    func updateData(onSuccess:@escaping ()->Void){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MData")
        
        
        do{
            let res = try context.fetch(fetchRequest)
        
            if res.count > 0{
                let up = res[0] as! NSManagedObject
                up.setValue(dataType.name1, forKey: "name1")
                up.setValue(dataType.name2, forKey: "name2")
                up.setValue(dataType.photo, forKey: "photo")
                try context.save()
                onSuccess()
            }else{
                saveData()
            }
            
        }
        catch{
            
        }
    }
    
    func deleteData(){
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          let context = appDelegate.persistentContainer.viewContext
          let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MData")
          
          do{
              let result = try context.fetch(request)
              if result.count > 0 {
                  let result_awal = result[0] as! NSManagedObject
              
                  context.delete(result_awal)
                  try context.save()
              }else{
                  print("Empty")
                  saveData()
              }
          }
          catch{
              print("Something wrong")
          }
      }
}
