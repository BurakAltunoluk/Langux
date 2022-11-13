//
//  ViewController.swift
//  Langux
//
//  Created by Burak Altunoluk on 01/11/2022.
//

import UIKit
import AVFoundation
import CoreData
import MediaPlayer

final class MainVC: UIViewController, AVAudioPlayerDelegate {
    
    var choosedHastag = ""
    
    var testString = ""

    private var player: AVPlayer?
    private var playBackService = PlaybackService()
    private var dataService = DataService()
    private var audioPlayer: AVAudioPlayer!
    private var recordingSession = AVAudioSession.sharedInstance()
    
    private var wordSound = [Data]()
    private var wordList = [String]()
    private var hastagWord = [String]()
    private var meaningWord = [String]()
    
    private var sentenceSound = [Data]()
    private var sentenceList = [String]()
    private var hastagSentence = [String]()
    private var meaningSentence = [String]()
    
    private var filterArray = [String]()
    private var filterSound = [Data]()
    private var filterMeaning = [String]()
    private var filterHastag = [String]()

    @IBOutlet var searchButtonOutlet: UIButton!
    @IBOutlet var folderButtonOutled: UIButton!
    @IBOutlet var AddNewButtonOutlet: UIButton!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var segmentController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        do {
            try recordingSession.setCategory(.playback , mode: .default)
            try recordingSession.setActive(true)
            
        } catch {
        }
    }
    
    func prepareAccordingHastag() {
        
        var count = -1
        
        self.filterArray = []
        self.filterMeaning = []
        self.filterSound = []
        self.filterHastag = []
        
        for i in self.hastagWord {
            count += 1
            
            if segmentController.selectedSegmentIndex == 0 {
                
            if self.choosedHastag == "#all" {
                filterArray.append(wordList[count])
                filterSound.append(wordSound[count])
                filterMeaning.append(meaningWord[count])
                filterHastag.append(hastagWord[count])
                self.tableView.reloadData()
                
            } else if i == self.choosedHastag {
                
                filterArray.append(wordList[count])
                filterSound.append(wordSound[count])
                filterMeaning.append(meaningWord[count])
                filterHastag.append(hastagWord[count])
                self.tableView.reloadData()
                
            }
                
            } else if segmentController.selectedSegmentIndex == 1 {
              
                if self.choosedHastag == "#all" {
                    filterArray.append(sentenceList[count])
                    filterSound.append(sentenceSound[count])
                    filterMeaning.append(meaningSentence[count])
                    filterHastag.append(hastagSentence[count])
                
                    
                } else if i == self.choosedHastag {
                    
                    filterArray.append(sentenceList[count])
                    filterSound.append(sentenceSound[count])
                    filterMeaning.append(meaningSentence[count])
                    filterHastag.append(hastagSentence[count])
                    
                    
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    private func getWordData() {
        
        self.filterSound = []
        self.filterHastag = []
        self.filterMeaning = []
        self.filterArray = []
      
        dataService.getWordData { wordList in
            self.wordList = wordList
        } wordsSoundList: { wordSoundList in
            self.wordSound = wordSoundList
        } hastagWordList: { hastagWordList in
            self.hastagWord = hastagWordList
        } meaningWordList: { meaningWordList in
            self.meaningWord = meaningWordList
        }
        prepareAccordingHastag()
        
    }
    
    private func getSentenceData() {
        
        self.filterArray = []
        self.filterSound = []
        self.filterHastag = []
        self.filterMeaning = []
        
       
//        self.tableView.tag = 2
        
        dataService.getSentenceData { sentenceList in
            self.sentenceList = sentenceList
        } sentencesSoundList: { sentenceSound in
            self.sentenceSound = sentenceSound
        } sentencesHastagList: { sentenceHastag in
            self.hastagSentence = sentenceHastag
        } sentencesMeaningList: { sentenceMeaning in
            self.meaningSentence = sentenceMeaning
            
        }
        
     prepareAccordingHastag()
        
    }

    @IBAction private func myFolderButtonPressed(_ sender: UIButton) {
       dismiss(animated: true)
    }
    
    @IBAction private func addNewButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toAddNew", sender: nil)
    }
    
    
    @IBAction func segmentControllerChanged(_ sender: UISegmentedControl) {
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            
            self.filterArray = []
            
            self.tableView.reloadData()
          
            getWordData()
            
        case 1 :
            
            self.filterArray = []
            
            self.tableView.reloadData()
          
            getSentenceData()
            
           
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
        
        let adana = testString.replacingOccurrences(of: " ", with: "%20")
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
       print(filterHastag)
        return self.filterHastag.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainViewCell
        
        cell.playButtonOOutlet.tag = indexPath.row
        
        
        cell.labelView.text = self.filterArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if segmentController.selectedSegmentIndex == 0 && self.filterSound[indexPath.row] != Data() {
            
            playBackService.startPlayback(dataver: filterSound[indexPath.row], isRepeat: false)
            
        } else if segmentController.selectedSegmentIndex == 1 && self.sentenceSound[indexPath.row].count != 0 {
            
            playBackService.startPlayback(dataver: sentenceSound[indexPath.row], isRepeat: false)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if segmentController.selectedSegmentIndex == 0 {
                
                dataService.deleteStringData(filterArray: self.filterArray, entityName: .Words, object: .words, rowNumber: indexPath.row)
                
                dataService.deleteSoundData(dataArray: self.filterSound, entityName: .Words, object: .wordsSound, rowNumber: indexPath.row)
                
                dataService.deleteStringData(filterArray: self.filterMeaning, entityName: .Words, object: .meaningWord, rowNumber: indexPath.row)
                
                dataService.deleteStringData(filterArray: self.filterHastag, entityName: .Words, object: .hastagWord, rowNumber: indexPath.row)
                
                self.filterSound.remove(at: indexPath.row)
                self.filterHastag.remove(at: indexPath.row)
                self.filterMeaning.remove(at: indexPath.row)
                self.filterArray.remove(at: indexPath.row)
                self.tableView.reloadData()
                
            } else {
                
                dataService.deleteStringData(filterArray: self.filterArray, entityName: .Sentences, object: .sentences, rowNumber: indexPath.row)
                
                dataService.deleteSoundData(dataArray: self.filterSound, entityName: .Sentences, object: .sentencesSound, rowNumber: indexPath.row)
                
                dataService.deleteStringData(filterArray: self.filterMeaning, entityName: .Sentences, object: .meaningSentence, rowNumber: indexPath.row)
                
                dataService.deleteStringData(filterArray: self.filterHastag, entityName: .Sentences, object: .hastagSentence, rowNumber: indexPath.row)
                
                
                self.tableView.reloadData()
            }
        }
        
    }
    
}
