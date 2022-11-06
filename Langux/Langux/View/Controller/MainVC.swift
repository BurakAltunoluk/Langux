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
    var player: AVPlayer?
    var textString = "i am ok. How are you my mate"
    private var playBackService = PlaybackService()
    private var dataService = DataService()
    private var audioPlayer: AVAudioPlayer!
    
    private var wordSound = [Data]()
    private var sentenceSound = [Data]()
    private var filterArray = [String]()
    private var category = [String]()
    
    @IBOutlet var searchButtonOutlet: UIButton!
    @IBOutlet var folderButtonOutled: UIButton!
    @IBOutlet var AddNewButtonOutlet: UIButton!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var segmentController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWordData()
        self.prepareUI ()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        if segmentController.selectedSegmentIndex == 0 {
            getWordData()
            self.tableView.reloadData()
        } else { getSentenceData()
            self.tableView.reloadData()
        }
    }
    
    private func getWordData() {
        self.tableView.tag = 3
        dataService.getWordData { words in
            self.filterArray = words
            self.tableView.reloadData()
        } wordsSoundList: { wordssound in
            self.wordSound = wordssound
            self.tableView.reloadData()
        }
    }
    
    private func getSentenceData() {
        self.tableView.tag = 2
        dataService.getSentenceData { sentences in
            self.filterArray = sentences
            self.tableView.reloadData()
        } sentencesSoundList: { sentencesSound in
            self.sentenceSound = sentencesSound
            self.tableView.reloadData()
        }
    }

    @IBAction private func myFolderButtonPressed(_ sender: UIButton) {
        
        playBackService.speechToTextGoogle(language: "tr", someText: "aman allahIm")
        
    }
    
    @IBAction private func addNewButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toAddNew", sender: nil)
    }
    
    
    @IBAction func segmentControllerChanged(_ sender: UISegmentedControl) {
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            self.filterArray = []
            getWordData()
            self.tableView.reloadData()
        case 1 :
            self.filterArray = []
            getSentenceData()
            self.tableView.reloadData()
        default:
            break
        }
    }
    private func prepareUI () {
        self.tableView.layer.cornerRadius = 10
        self.AddNewButtonOutlet.setTitle("", for: .normal)
        self.folderButtonOutled.layer.cornerRadius = 10
        self.AddNewButtonOutlet.layer.cornerRadius = 10
        self.searchButtonOutlet.layer.cornerRadius = 10
        self.folderButtonOutled.setTitle("", for: .normal)
        self.searchButtonOutlet.setTitle("", for: .normal)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddNew" {
            let destinationVC = segue.destination as! AddNewVC
            destinationVC.segmentControllerPosition = self.segmentController.selectedSegmentIndex
        }
    }
    
    func playSound() {
        
        let adana = textString.replacingOccurrences(of: " ", with: "%20")
        print(adana)
        let url = "https://translate.google.com/translate_tts?ie=UTF-8&q=\(adana)&tl=en&total=1&idx=0&textlen=15&tk=350535.255567&client=webapp&prev=input"
        
        guard let url1 = URL.init(string: url)
                        else {
                            return
                    }
        
                    let playerItem = AVPlayerItem.init(url: url1)
                    player = AVPlayer.init(playerItem: playerItem)
                player?.play()
       
     

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
        
        if segmentController.selectedSegmentIndex == 0 && self.wordSound[indexPath.row] != Data() {
            
            playBackService.startPlayback(dataver: wordSound[indexPath.row], isRepeat: false)
            
        } else if segmentController.selectedSegmentIndex == 1 && self.sentenceSound[indexPath.row].count != 0 {
            
            playBackService.startPlayback(dataver: sentenceSound[indexPath.row], isRepeat: false)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if segmentController.selectedSegmentIndex == 0 {
                dataService.deleteStringData(filterArray: self.filterArray, entityName: .Words, object: .words, rowNumber: indexPath.row)
                dataService.deleteSoundData(dataArray: self.wordSound, entityName: .Words, object: .wordsSound, rowNumber: indexPath.row)
                
                self.filterArray = []
                dataService.getWordData { words in
                    self.filterArray = words
                } wordsSoundList: { sound in
                    self.wordSound = sound
                }
                
                self.tableView.reloadData()
                
            } else {
                
                dataService.deleteStringData(filterArray: self.filterArray, entityName: .Sentences, object: .sentences, rowNumber: indexPath.row)
                
                dataService.deleteSoundData(dataArray: self.sentenceSound, entityName: .Sentences, object: .sentencesSound, rowNumber: indexPath.row)
                
                self.filterArray = []
                
                dataService.getSentenceData { sentenceList in
                    self.filterArray = sentenceList
                } sentencesSoundList: { sentenceSound in
                    self.sentenceSound = sentenceSound
                }
                
                self.tableView.reloadData()
            }
        }
        
    }
    
}
