//
//  DataManager.swift
//  Contacts
//
//  Created by eOne Bilch Enko on 19.06.18.
//  Copyright © 2018 eOne Bilch Enko. All rights reserved.
//

import CoreData
import UIKit


class DataManager {
    
    let contactModelEntityName = "ContactUser"
    static let coreDataStackManager = CoreDataStackManager()
    
    func editContact(contact: ContactUser, name: String? = nil, lastName: String? = nil, phoneNumber: String? = nil, relationshipType: Int? = nil, photo: UIImage? = nil, emailAddress: String? = nil)   {
        if let newName = name {
            contact.name = newName
        }
        if let newLastName = lastName {
            contact.lastName = newLastName
        }
        if let newPhoneNumber = phoneNumber {
            contact.phoneNumber = newPhoneNumber
        }
        if let newEmailAddress = emailAddress {
            contact.emailAddress = newEmailAddress
        }
        if let newRelationshipType = relationshipType {
            contact.relationshipType = Int16(newRelationshipType)
        }
        if let newPhoto = photo {
            contact.photo = UIImagePNGRepresentation(newPhoto) as NSData?
        }
        
        DataManager.coreDataStackManager.saveMoc()
    }
    
    // TODO: - deleting by object ID
    func delete(objectID: NSManagedObjectID) {
        
        let context = DataManager.coreDataStackManager.persistentContainer.viewContext
        let objectID = context.object(with: objectID)
        //        let fetchRequest: NSFetchRequest<ContactUser> = ContactUser.fetchRequest()
        //        fetchRequest.predicate = NSPredicate.init(format: "lastName = %@", objectID)
        //        var results: [ContactUser] = []
        //        do {
        //            results = try DataManager.coreDataStackManager.persistentContainer.viewContext.fetch(fetchRequest)
        //        }
        //        catch {
        //            print("error")
        //        }
        //        guard let cotact = results.last else {
        //            return
        //        }
        context.delete(objectID)
        DataManager.coreDataStackManager.saveMoc()
        
    }
    
    func save(name: String, lastName: String, phoneNumber: String, relationshipType: Int, photo: UIImage?, emailAddress: String) -> ContactUser? {
        let contactUser = NSEntityDescription.insertNewObject(forEntityName: contactModelEntityName, into: DataManager.coreDataStackManager.persistentContainer.viewContext) as! ContactUser
        contactUser.name = name
        contactUser.lastName = lastName
        contactUser.phoneNumber = phoneNumber
        contactUser.relationshipType = Int16(relationshipType)
        if let _photo = photo {
            contactUser.photo = UIImagePNGRepresentation(_photo) as NSData?
        } else {
            contactUser.photo = nil
        }
        
        contactUser.emailAddress = emailAddress
        
        
        
        
        DataManager.coreDataStackManager.saveMoc()
        return contactUser
    }
    
    
    func search(bySeatchText text: String) -> [ContactUser] {
        let request = NSFetchRequest<ContactUser>(entityName: contactModelEntityName)
        // Sorting
        
        //        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        //        request.sortDescriptors = [sortDescriptor]
        
        //filtering
        
        let filterPredicate = NSPredicate(format: "name contains[c] %@ OR lastName contains[c] %@ OR phoneNumber contains[c] %@", text, text, text)
        //       let filterPredicate = NSPredicate(format: "name = %@ OR lastName = %@", name)
        request.predicate = filterPredicate
        
        var results: [ContactUser] = []
        do {
            results = try DataManager.coreDataStackManager.persistentContainer.viewContext.fetch(request)
        }
        catch {
            print("error")
        }
        return results
    }
    
    func loadData() -> [ContactUser] {
        let request = NSFetchRequest<ContactUser>(entityName: contactModelEntityName)
        // Sorting
        
        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        //filtering
        
        //        let filterPredicate = NSPredicate(format: "lastName = %@", "sdfasfd")
        //        request.predicate = filterPredicate
        
        var results: [ContactUser] = []
        do {
            results = try DataManager.coreDataStackManager.persistentContainer.viewContext.fetch(request)
        }
        catch {
            print("error")
        }
        return results
    }
    
    
    
    //    func deleteData(contact: ContactUser) -> Bool {
    //        let contactToDelate = NSEntityDescription.
    //
    //    }
    
    func initProductMidelFetchResultController() -> NSFetchedResultsController<ContactUser> {
        let request = NSFetchRequest<ContactUser>(entityName: contactModelEntityName)
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataManager.coreDataStackManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
        
    }
    
}

