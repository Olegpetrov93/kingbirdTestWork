//
//  DataSource.swift
//  kingbirdTestWork
//
//  Created by Oleg on 7/8/21.
//

import Foundation
import CoreData

protocol CategoriesDelegate: AnyObject {
    func update(snapshots: [PhotoCD])
}

final class DataSource {
    
    private let context = AppDelegate().persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<PhotoCD>(entityName: "PhotoCD")
    
    weak var delegate: CategoriesDelegate?
    
    func importDataFromCoreData() {
        do {
            let categoryCount = try context.count(for: fetchRequest)
            if categoryCount == 0 {
                print("Data from CoreData is nill")
            }
            setUpCategories(request: fetchRequest)
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
        }
    }
    
    func setUpData(snapshots: [Photo]) {
        cleanData()
        
        for photo in snapshots {
            guard let entityCategory = NSEntityDescription.entity(forEntityName: "PhotoCD",
                                                                  in: context) else { return }
            
            let entityObject = PhotoCD(entity: entityCategory,
                                       insertInto: context)
            entityObject.id = photo.id
            entityObject.author = photo.author
            
            guard let photoURL = photo.downloadUrl else { return }
            NetworkService.fetchImageWithResize(imageUrl: photoURL) { (data) in
                guard let data = data else { return }
                entityObject.photo = data
                self.setUpCategories(request: self.fetchRequest)
            }
        }
        do {
            try context.save()
            setUpCategories(request: fetchRequest)
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func deletePhoto(photo: PhotoCD) {
        context.delete(photo)
        do {
            try context.save()
            let results = try context.fetch(fetchRequest)
            delegate?.update(snapshots: results)
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    private func cleanData() {
        do {
            let result = try? context.fetch(fetchRequest)
            guard let objects = result else { return }
            for object in objects {
                context.delete(object)
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Unresolved error \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    private func setUpCategories(request: NSFetchRequest<PhotoCD>) {
        do {
            let results = try context.fetch(request)
            delegate?.update(snapshots: results)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
