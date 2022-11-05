//
//  DataService.swift
//  Langux
//
//  Created by Burak Altunoluk on 04/11/2022.
//

import Foundation
import CoreData
import UIKit

struct DataService {
    
    enum entityNames: String {
        case Sentences
        case Words
    }
   
    enum forKey: String {
        case sentences
        case words
        case wordsSound
        case sentencesSound
    }
    
    func getWordData(wordsList: @escaping([String]) ->(), wordsSoundList: @escaping([Data]) ->()) {
         var wordArray = [String]()
         var wordsSound = [Data]()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
         fetchRequest.returnsObjectsAsFaults = false
         
         do {
             let results = try context.fetch(fetchRequest)
             if results.count > 0 {
                 for result in results as! [NSManagedObject] {
                     
                     if let name = result.value(forKey: "words")  {
                         
                         wordArray.append(name as! String)
                         wordsList(wordArray)
             }
                     if let wordMeaning = result.value(forKey: "wordsSound")  {
                         wordsSound.append(wordMeaning as! Data)
                         wordsSoundList(wordsSound)
                     }
                 }
             }
         } catch {
             print("error")
         }
     }
     
    
   
    func getSentenceData(sentencesList: @escaping([String]) ->(), sentencesSoundList: @escaping([Data]) ->()) {
        
        var sentenceArray = [String]()
        var sentencesSound = [Data]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sentences")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let name = result.value(forKey: "sentences")  {
                        sentenceArray.append(name as! String)
                        sentencesList(sentenceArray)
            }
                    if let wordMeaning = result.value(forKey: "sentencesSound")  {
                       sentencesSound.append(wordMeaning as! Data)
                      sentencesSoundList(sentencesSound)
                        
                    }
                }
            }
        } catch {
            print("error")
        }
    }

    func setData(forKey: forKey, Value: Any, EntityName: entityNames) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: EntityName.rawValue, into: context)
        
        newRecord.setValue(Value, forKey: forKey.rawValue)
        
        do{
            try context.save()
        } catch {
        }
       
    }
    
    func deleteSoundData(dataArray: [Data], entityName: entityNames, object: forKey, rowNumber: Int) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        
        let wordVoice = dataArray[rowNumber]
        fetchRequest.predicate = NSPredicate(format: "\(object) = %@", wordVoice as CVarArg)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
        let results = try context.fetch(fetchRequest)
            if results.count > 0 {

                for result in results as! [NSManagedObject] {

                    if let id = result.value(forKey: object.rawValue) as? Data {

                        if id == dataArray[rowNumber] {
                            context.delete(result)

                            do {
                                try context.save()

                            } catch {
                                print("error")
                            }

                            break
                        }
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    
    func deleteStringData(filterArray: [String], entityName: entityNames, object: forKey, rowNumber: Int ) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        
        let wordVoice = filterArray[rowNumber]
        fetchRequest.predicate = NSPredicate(format: "\(object) = %@", wordVoice as String)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
        let results = try context.fetch(fetchRequest)
            if results.count > 0 {

                for result in results as! [NSManagedObject] {

                    if let id = result.value(forKey: object.rawValue) as? String {

                        if id == filterArray[rowNumber] {
                            context.delete(result)

                            do {
                                try context.save()

                            } catch {
                                print("error")
                            }

                            break
                        }
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    
}
