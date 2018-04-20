//
//  CoreDataGetting.swift
//  TestTask
//
//  Created by Sergey Gusev on 14.04.2018.
//  Copyright © 2018 Sergey Gusev. All rights reserved.
//

import CoreData
import UIKit
import Foundation
class CoreDataGetting {
    func save(photo: [Photo]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "PhotoCoreData", in: managedContext)!
        
        for item in photo {
            let photoBD = NSManagedObject(entity: userEntity, insertInto: managedContext)
            guard let photoData = UIImageJPEGRepresentation(item.binaryPhoto, 1) else {
                print("jpg error")
                return
            }
            
            photoBD.setValue(photoData, forKeyPath: "data")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    func delete() {
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoCoreData")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        userFetch.returnsObjectsAsFaults = false
        if let result = try? managedContext.fetch(userFetch) {
            for object in result {
                managedContext.delete(object as! PhotoCoreData)
            }
        }
    }
    
    func getData() -> [Photo] {
        var favoriteList: [Photo] = []
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoCoreData")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        let managedContext = appDelegate.persistentContainer.viewContext
        userFetch.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(userFetch)
            for data in result as! [PhotoCoreData] {
                guard let posterData = data.value(forKey: "data") as? Data,
                    let poster = UIImage(data: posterData) else { return []}
                favoriteList.append(Photo(binaryPhoto: poster))
            }
        } catch {
            print("Failed")
        }
        return favoriteList
    }
    
    
}

