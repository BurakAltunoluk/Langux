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
import Cici

final class MainVC: UIViewController, AVAudioPlayerDelegate {
    
    var choosedHastag = ""
    private var choosedLg = ""
    @IBOutlet var hastagLabelInfo: UILabel!
    private var player: AVPlayer?
    private var playBackService = PlaybackService()
    private var dataService = DataService()
    private var audioPlayer: AVAudioPlayer!
    private var recordingSession = AVAudioSession.sharedInstance()
    private var cici = Cici()
    
    
    // ---------------
    private var wordSound = [Data]()
    private var wordList = [String]()
    private var hastagWord = [String]()
    private var meaningWord = [String]()
    private var wordID = [UUID]()
    
    private var sentenceSound = [Data]()
    private var sentenceList = [String]()
    private var hastagSentence = [String]()
    private var meaningSentence = [String]()
    private var sentenceID = [UUID]()
    @IBOutlet var menuButton: UIButton!
    private var filterArray = [String]()
    private var filterSound = [Data]()
    private var filterMeaning = [String]()
    private var filterHastag = [String]()
    private var filterID = [UUID]()
    //----------------
    
    @IBOutlet private var segmentController: UISegmentedControl!
   
    @IBOutlet private var folderButtonOutled: UIButton!
    @IBOutlet private var AddNewButtonOutlet: UIButton!
    @IBOutlet private var tableView: UITableView!
   
// MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.choosedLg = UserDefaults.standard.string(forKey: "speechLg") ?? "en"
        self.prepareUI()
        cici.view = view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        self.prepareDataDependHastag()
        
        self.hastagLabelInfo.text = choosedHastag
        
        do {
            try recordingSession.setCategory(.playback , mode: .default)
            try recordingSession.setActive(true)
            
        } catch {
        }
    }
    
    
// MARK: Functions
    private func resetTableViewData() {
        self.filterArray = []
        self.filterMeaning = []
        self.filterSound = []
        self.filterHastag = []
        self.filterID = []
    }
    
    private func prepareDataDependHastag() {
        
        resetTableViewData()
        
        if segmentController.selectedSegmentIndex == 0 {
            
            self.wordSound = []
            self.wordList = []
            self.hastagWord = []
            self.meaningWord = []
            self.wordID = []
            
            self.getWordData()
            
            if choosedHastag == "#all" {
                self.filterID = self.wordID
                self.filterArray = self.wordList
                self.filterMeaning = self.meaningWord
                self.filterSound = self.wordSound
                self.filterHastag = self.hastagWord
                self.tableView.reloadData()
            } else {
             
                var rowNumber = -1
                
                for i in hastagWord {
                    
                    rowNumber += 1
                    
                    if i == self.choosedHastag {

                        self.filterID.append(wordID[rowNumber])
                        self.filterArray.append(wordList[rowNumber])
                        self.filterHastag.append(hastagWord[rowNumber])
                        self.filterMeaning.append(meaningWord[rowNumber])
                        self.filterSound.append(wordSound[rowNumber])
                    }
                }
                self.tableView.reloadData()
            }
            
            
        } else {
            
            sentenceSound = []
            sentenceList = []
            hastagSentence = []
            meaningSentence = []
            sentenceID = []
            self.getSentenceData()
     
            if choosedHastag == "#all" {
                self.filterID = self.sentenceID
                self.filterArray = self.sentenceList
                self.filterMeaning = self.meaningSentence
                self.filterSound = self.sentenceSound
                self.filterHastag = self.hastagSentence
                
            } else {
             
              
                var rowNumber = -1
                for i in hastagSentence {
                    rowNumber += 1
                    if i == self.choosedHastag {

                        
                        self.filterID.append(sentenceID[rowNumber])
                        self.filterArray.append(sentenceList[rowNumber])
                        self.filterMeaning.append(meaningSentence[rowNumber])
                        self.filterSound.append(sentenceSound[rowNumber])
                        self.filterHastag.append(hastagSentence[rowNumber])
                    }
                }
                
            }
            self.tableView.reloadData()
        }
    }
    
    private func getWordData() {
        
        resetTableViewData()
        
        dataService.getWordData { wordIDList in
            self.wordID = wordIDList
            print("\(wordIDList) wordId list yeni")
            
        } wordsList: { wordList in
            self.wordList = wordList
        } wordsSoundList: { voiceList in
            self.wordSound = voiceList
        } hastagWordList: { hastagList in
            self.hastagWord = hastagList
        } meaningWordList: { wordMeaning in
            self.meaningWord = wordMeaning
        }
    
    
    }
    
    private func getSentenceData() {
        
   resetTableViewData()
        
        dataService.getSentenceData { sentenceIDList in
            self.sentenceID = sentenceIDList
        } sentencesList: { sentenceList in
            self.sentenceList = sentenceList
        } sentencesSoundList: { voiceDataList in
            self.sentenceSound = voiceDataList
        } sentencesHastagList: { sentenceHastagList in
            self.hastagSentence = sentenceHastagList
        } sentencesMeaningList: { sentenceMeaningList in
            self.meaningSentence = sentenceMeaningList
        }
    }

// MARK: Buttons
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toMenu", sender: nil)
    }
    
    
    @IBAction private func myFolderButtonPressed(_ sender: UIButton) {
       dismiss(animated: true)
    }
    
    @IBAction private func addNewButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toAddNew", sender: nil)
        sendCatagoryData = choosedHastag
    }
    
    @IBAction func segmentControllerChanged(_ sender: UISegmentedControl) {
        prepareDataDependHastag()
    }
    
    private func prepareUI () {
        
        self.AddNewButtonOutlet.setTitle("", for: .normal)
        self.menuButton.setTitle("", for: .normal)
        self.folderButtonOutled.setTitle("", for: .normal)
        self.menuButton.setTitle("", for: .normal)
        self.folderButtonOutled.layer.cornerRadius = 10
        self.AddNewButtonOutlet.layer.cornerRadius = 10
        self.menuButton.layer.cornerRadius = 10
        self.tableView.layer.cornerRadius = 10
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddNew" {
            let destinationVC = segue.destination as! AddNewVC
            destinationVC.segmentControllerPosition = self.segmentController.selectedSegmentIndex
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

// MARK: Tableview

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainViewCell
        cell.editButtonOutlet.tag = indexPath.row
        cell.playButtonOOutlet.tag = indexPath.row
        cell.questionButtonOutlet.tag = indexPath.row
        cell.questionButtonOutlet.addTarget(self, action: #selector(cellButtonPressed), for: .touchUpInside)
        cell.editButtonOutlet.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        cell.labelView.text = self.filterArray[indexPath.row]
        
        return cell
    }
    @objc func editButtonPressed(sender: UIButton) {
        
        sendCatagoryData = filterHastag[sender.tag]
        editID = filterID[sender.tag]
        editSentenceOrWord = filterArray[sender.tag]
        editMeaning = filterMeaning[sender.tag]
        editData = filterSound[sender.tag]
        editHastag = filterHastag[sender.tag]
        performSegue(withIdentifier: "toAddNew", sender: nil)
        
    }
    
    @objc func cellButtonPressed(sender: UIButton) {
   
        cici.horizontalMargins = 20.0
        cici.backgroundColor = #colorLiteral(red: 0.2823528945, green: 0.2823528647, blue: 0.2823528945, alpha: 1)
        cici.mesaggeTextColor = #colorLiteral(red: 0.957662642, green: 0.7624127865, blue: 0.04283533245, alpha: 1)
        cici.buttonWidth = 150.0
        cici.buttonBackroundColor = #colorLiteral(red: 0.957662642, green: 0.7624127865, blue: 0.04283533245, alpha: 1)
        cici.heightExtra = -170.0
        cici.showAlert(messageText: self.filterMeaning[sender.tag], buttonTitle: "Ok")
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        playBackService.startPlayback(dataver: filterSound[indexPath.row], isRepeat: false)
        
//        if segmentController.selectedSegmentIndex == 0 && self.filterSound[indexPath.row] != Data() {
//
//            playBackService.startPlayback(dataver: filterSound[indexPath.row], isRepeat: false)
//
//        } else if segmentController.selectedSegmentIndex == 1 && self.sentenceSound[indexPath.row].count != 0 {
//
//            playBackService.startPlayback(dataver: filterSound[indexPath.row], isRepeat: false)
//        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let entityNamem =  segmentController.selectedSegmentIndex != 0 ? "Sentences" : "Words"
        
        
        if editingStyle == .delete {
            
            
        dataService.deleteData(choosedID: self.filterID[indexPath.row], entityName: entityNamem)
            
        self.prepareDataDependHastag()
            
        }
    }
}
