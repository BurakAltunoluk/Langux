//
//  ViewController.swift
//  Langux
//
//  Created by Burak Altunoluk on 01/11/2022.
//

import UIKit
import AVFoundation
import CoreData

final class MainVC: UIViewController, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer!
    private var wordArray = [String]()
    private var wordSound = [Data]()
    
    private var sentenceArray = [String]()
    private var sentenceSoundArray = [Data]()
    
    @IBOutlet var searchButtonOutlet: UIButton!
    @IBOutlet var folderButtonOutled: UIButton!
    @IBOutlet var AddNewButtonOutlet: UIButton!
    @IBOutlet private var segmentController: UISegmentedControl!
    @IBOutlet private var tableView: UITableView!
    
    private var filterArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareWordData()
        self.tableView.layer.cornerRadius = 10
        self.AddNewButtonOutlet.setTitle("", for: .normal)
        self.folderButtonOutled.layer.cornerRadius = 10
        self.AddNewButtonOutlet.layer.cornerRadius = 10
        self.searchButtonOutlet.layer.cornerRadius = 10
        self.folderButtonOutled.setTitle("", for: .normal)
        self.searchButtonOutlet.setTitle("", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if segmentController.selectedSegmentIndex == 0 {
            prepareWordData()
        } else { prepareSentenceData() }
    }
    
    @IBAction private func myFolderButtonPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "toAddNew", sender: nil)
        
    }
    
    @IBAction private func addNewButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toAddNew", sender: nil)
    }
    
    
    @IBAction func segmentControllerChanged(_ sender: UISegmentedControl) {
        self.sentenceArray = [String]()
        self.wordArray = [String]()
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            self.prepareWordData()
            self.filterArray = self.wordArray
            self.tableView.reloadData()
        case 1 :
            self.prepareSentenceData()
            self.filterArray = self.sentenceArray
            self.tableView.reloadData()
        default:
            break
        }
    }
    
    private func textToSpeech(choosedRow: String) {
        let string = choosedRow
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    private func prepareSentenceData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sentences")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let name = result.value(forKey: "sentences")  {
                        self.sentenceArray.append(name as! String)
                        self.filterArray = sentenceArray
            }
                    if let wordMeaning = result.value(forKey: "sentencesSound")  {
                        self.sentenceSoundArray.append(wordMeaning as! Data)
                        
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    
    private func prepareWordData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let name = result.value(forKey: "words")  {
                        self.wordArray.append(name as! String)
                        self.filterArray = wordArray
            }
                    if let wordMeaning = result.value(forKey: "wordsSound")  {
                        self.wordSound.append(wordMeaning as! Data)
                        
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    

    
    
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainViewCell
        cell.playButtonOOutlet.tag = indexPath.row
            
        
        cell.labelView.text = self.filterArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if segmentController.selectedSegmentIndex == 0 && self.wordSound[indexPath.row].count == 0{
            
            textToSpeech(choosedRow: self.filterArray[indexPath.row])
            print("konus")
        }
        
        
        
        
        
    }
    
    
}


extension MainVC {
    
    // MARK: - Playback
    
    func startPlayback(dataver: Data) {
//       let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
   audioPlayer = try AVAudioPlayer(data: dataver)
            audioPlayer.delegate = self
            audioPlayer.play()
            audioPlayer.volume = 2.0
          //  playButton.setTitle("Stop Playback", for: .normal)
        } catch {
          //  playButton.isHidden = true
            // unable to play recording!
        }
    }
    
    
    
    
    func finishPlayback() {
        audioPlayer = nil
       // playButton.setTitle("Play Your Recording", for: .normal)
    }


   
}


extension MainVC {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        finishPlayback()
    }
    
}

    
    

