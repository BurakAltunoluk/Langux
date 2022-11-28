//
//  DataService.swift
//  Langux
//
//  Created by Burak Altunoluk on 04/11/2022.
//

import Foundation
import CoreData
import UIKit

var sendCatagoryData = ""

var editID = UUID()
var editSentenceOrWord = ""
var editMeaning = ""
var editHastag = ""
var editData = Data()


struct DataService {
    
    enum entityNames: String {
        case Sentences
        case Words
    }
   
    enum forKey: String {
        
        case words
        case meaningWord
        case wordsSound
        case hastagWord
        
        case sentences
        case hastagSentence
        case meaningSentence
        case sentencesSound
    }
    
    func getWordData(wordID: @escaping([UUID]) ->(),wordsList: @escaping([String]) ->(), wordsSoundList: @escaping([Data]) ->(), hastagWordList: @escaping([String]) ->(), meaningWordList: @escaping([String]) ->()) {
        
         var wordArray = [String]()
         var wordsSound = [Data]()
         var hastagWordArray = [String]()
         var meaningWordArray = [String]()
         var wordId = [UUID]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
         fetchRequest.returnsObjectsAsFaults = false
         
         do {
             let results = try context.fetch(fetchRequest)
             if results.count > 0 {
                 for result in results as! [NSManagedObject] {
                     
                     
                     if let id = result.value(forKey: "id")  {
                         
                         wordId.append(id as! UUID)
                         wordID(wordId)
                         
             }
                     
                     
                     if let name = result.value(forKey: "word")  {
                         
                         wordArray.append(name as! String)
                         wordsList(wordArray)
             }
                     if let wordSound = result.value(forKey: "voice")  {
                         wordsSound.append(wordSound as! Data)
                         wordsSoundList(wordsSound)
                     }
                    
                     if let wordMeaning = result.value(forKey: "meaning")  {
                         meaningWordArray.append(wordMeaning as! String)
                         
                         meaningWordList(meaningWordArray)
                     }
                     
                     if let hastagWord = result.value(forKey: "hastag")  {
                         hastagWordArray.append(hastagWord as! String)
                         hastagWordList(hastagWordArray)
                     }
                     
                     
                 }
             }
         } catch {
             print("error")
         }
     }
     
    func getSentenceData(sentencesID: @escaping([UUID]) ->(), sentencesList: @escaping([String]) ->(), sentencesSoundList: @escaping([Data]) ->(), sentencesHastagList: @escaping([String]) ->(), sentencesMeaningList: @escaping([String]) ->()) {
        
        var sentenceId = [UUID]()
        var sentenceArray = [String]()
        var sentenceHastagArray = [String]()
        var sentenceMeaningArray = [String]()
        var sentencesSound = [Data]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sentences")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let id = result.value(forKey: "id")  {
                        sentenceId.append(id as! UUID)
                        sentencesID(sentenceId)
            }
                    
                    if let name = result.value(forKey: "word")  {
                        sentenceArray.append(name as! String)
                        sentencesList(sentenceArray)
            }
                    
                    if let wordMeaning = result.value(forKey: "voice")  {
                       sentencesSound.append(wordMeaning as! Data)
                      sentencesSoundList(sentencesSound)
                        
            }
                    if let sentenceHastag = result.value(forKey: "hastag")  {
                        sentenceHastagArray.append(sentenceHastag as! String)
                        sentencesHastagList(sentenceHastagArray)
            }
                    
                    if let sentenceMeaning = result.value(forKey: "meaning")  {
                        sentenceMeaningArray.append(sentenceMeaning as! String)
                        sentencesMeaningList(sentenceMeaningArray)
            }
                    
                    
                }
            }
        } catch {
            print("error")
        }
    }

    func setData(id: UUID, hastag: String, voiceData:Data, meaning:String, wordSentence: String, EntityName: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: EntityName, into: context)
        
        newRecord.setValue(id, forKey: "id")
        newRecord.setValue(wordSentence, forKey: "word")
        newRecord.setValue(meaning, forKey: "meaning")
        newRecord.setValue(voiceData, forKey: "voice")
        newRecord.setValue(hastag, forKey: "hastag")
        
        do{
            try context.save()
        } catch {
            print("error SetData")
        }
    }
    
    
    
    
    func deleteData(choosedID: UUID, entityName: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", choosedID.uuidString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
        let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {

                for result in results as! [NSManagedObject] {

                    if let id = result.value(forKey: "id") as? UUID {
                       
                   if id == choosedID {
                            
                            context.delete(result)

                            do {
                                try context.save()

                            } catch {
                                print("error")
                            }
//
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
