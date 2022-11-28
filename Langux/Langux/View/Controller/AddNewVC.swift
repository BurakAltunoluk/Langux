//
//  addNewVC.swift
//  Langux
//  Created by Burak Altunoluk on 01/11/2022.
//

import UIKit
import AVFoundation
import CoreData

final class AddNewVC: UIViewController, AVAudioRecorderDelegate {
    
    var newVoice = false
    var segmentControllerPosition = 0
    private var dataService = DataService()

    private var playbackService = PlaybackService()
    private var choosedLg = ""
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var audioPlayer: AVAudioPlayer!
    private var player: AVPlayer?
    @IBOutlet private var recButtonOutlet: UIButton!
    @IBOutlet private var playButtonOutlet: UIButton!
    @IBOutlet private var wordOrSentenceLabel: UILabel!
    
    var voiceData = Data()
    
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var typeSegmentController: UISegmentedControl!
    @IBOutlet private var sharingSegmentController: UISegmentedControl!
    @IBOutlet var meanningInputTextField: UITextView!
    @IBOutlet private var wordInputTextFiled: UITextView!
    
    // MARK: Life Cycile
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHiding()
        categoryLabel.layer.borderColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        categoryLabel.layer.borderWidth = 0.5
        self.categoryLabel.isUserInteractionEnabled = true
        let hastagGesture = UITapGestureRecognizer(target: self, action:#selector(hastagChoose))
        categoryLabel.addGestureRecognizer(hastagGesture)
        self.choosedLg = UserDefaults.standard.string(forKey: "speechLg") ?? "en"
       
        if editHastag != "" {
            checkEditData()
        }
        viewGestureSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        prepareStart()
    }
    
    // MARK: Buttons
    
    @objc func hastagChoose() {
        performSegue(withIdentifier: "toCategoryVC", sender: nil)
    }
    

    @IBAction private func segmentControllerChanged(_ sender: UISegmentedControl) {
        
        let categories = ["Word?","Sentence?"]
        wordOrSentenceLabel.text = categories[typeSegmentController.selectedSegmentIndex]
    }
    
    @IBAction private func playButtonPressed(_ sender: UIButton) {
     preparePlayback()
    
        
        if editHastag != "" {
            playbackService.startPlayback(dataver: voiceData, isRepeat: false)
        } else if audioPlayer == nil {
            startPlayback()
    } else {
        playbackService.finishPlayback()
    }
}
    
    @IBAction private func textToSpeechButtonPressed(_ sender: UIButton) {
    
        if wordInputTextFiled.text != "" {
        
    if Reachability.isConnectedToNetwork(){
        preparePlayback()
        playbackService.speechToTextGoogle(language: self.choosedLg, someText: self.wordInputTextFiled.text!)
    } else {
        playbackService.textToSpeech(choosedRow: self.wordInputTextFiled.text!)
    }
    
        }
        
    }
    
    @IBAction private func cancelButtonPressed(_ sender: UIButton) {
        editHastag = ""
        editMeaning = ""
        editSentenceOrWord = ""
        audioRecorder = nil
        recordingSession = nil
        dismiss(animated: true)
    }
    
    
    @IBAction private func submitButtonPressed(_ sender: UIButton) {
        
        if self.wordInputTextFiled.text != "" && self.meanningInputTextField.text != "" && self.playButtonOutlet.isEnabled == true {
            
        
        var datam = Data()
        
        if editSentenceOrWord == "" {
        
            datam = try! Data(contentsOf: getDocumentsDirectory().appendingPathComponent("recording.m4a"))
        
        let entityName1 =  typeSegmentController.selectedSegmentIndex == 0 ? "Words" : "Sentences"
        
            dataService.setData(id: UUID(), hastag: categoryLabel.text!, voiceData: datam, meaning: meanningInputTextField.text!, wordSentence: wordInputTextFiled.text!, EntityName: entityName1)
        
        } else {
            
        let entityName = ["Words","Sentences"]
            
        dataService.deleteData(choosedID: editID, entityName: entityName[segmentControllerPosition])
        
            if newVoice == true {
                datam = try! Data(contentsOf: getDocumentsDirectory().appendingPathComponent("recording.m4a"))
            } else {
                datam = editData
            }
          
            dataService.setData(id: UUID(), hastag: categoryLabel.text!, voiceData: datam, meaning: meanningInputTextField.text!, wordSentence: wordInputTextFiled.text!, EntityName: entityName[typeSegmentController.selectedSegmentIndex])
            editMeaning = ""
            editHastag = ""
            editSentenceOrWord = ""
            editID = UUID()
        }
            
        dismiss(animated: true)
            
        } else {
            
            submitAlert()
            
        }
        
        
        
        
    
    }
    
    @IBAction private func recButtonPressed(_ sender: UIButton) {
        newVoice = true
        editHastag = ""
        prepareRec()
        
        if self.recButtonOutlet.titleLabel!.text == "●" {
        self.recButtonOutlet.setTitle("Ⅱ", for: .normal)
        recButtonOutlet.layer.borderColor = UIColor.red.cgColor
        recButtonOutlet.layer.borderWidth = 2
       
        } else {
            self.recButtonOutlet.setTitle("●", for: .normal)
            self.playButtonOutlet.isEnabled = true
            recButtonOutlet.layer.borderWidth = 0
        }
       
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    

    // MARK: Functions
    
    private func submitAlert() {
        
        var message = ""
        
        if self.wordInputTextFiled.text == "" {
            message = "Enter a word or sentence!"
        } else if self.meanningInputTextField.text == "" {
            message = "Enter the meaning!"
        } else if self.playButtonOutlet.isEnabled == false {
            message = "Record your voice!"
        }
        
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    
    private func checkEditData() {
        
        if editMeaning != "" {
            self.playButtonOutlet.isEnabled = true
            self.wordInputTextFiled.text = editSentenceOrWord
            self.meanningInputTextField.text = editMeaning
            self.categoryLabel.text = editHastag
            self.voiceData = editData
            print(editData)
        }
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    private func textToSpeech(textToSpeech: String) {
        var language = "" //["en-GB","es-ES","pt-PT","fr-FR"]
     
        switch self.choosedLg {
        case "en":
            language = "en-GB"
        case "es":
            language = "es-ES"
        case "pt":
            language = "pt-PT"
        case "fr":
            language = "fr-FR"
        default:
            language = "en-GB"
        }
        
        
        let string = textToSpeech
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @objc private func viewGesture() {
        view.endEditing(true)
    }

     private func viewGestureSetup() {
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewGesture))
        view.addGestureRecognizer(gesture)
    }
    
     private func loadRecordingUI() {
//        recordButton.isHidden = false
//        recordButton.setTitle("Tap to Record", for: .normal)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCategoryVC" {
            let destinationVC = segue.destination as! HastagVC
            destinationVC.categoryNeedFromAddNewVC = 1
        }
        
    }
    
    // MARK: - Recording
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
           // recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        recordingSession = nil 
        if success {
//            recordButton.setTitle("Tap to Re-record", for: .normal)
//            playButton.setTitle("Play Your Recording", for: .normal)
//            playButton.isHidden = false
        } else {
            
//            recordButton.setTitle("Tap to Record", for: .normal)
//            playButton.isHidden = true
            // recording failed :(
        }
    }
    // MARK: - Playback
    
    func startPlayback() {
        
       playbackService.startPlayback(dataver: Data(), isRepeat: true)
       
}
    
    func prepareStart () {
        
            self.recButtonOutlet.setTitle("●", for: .normal)
            if sendCatagoryData != "0" {
            self.categoryLabel.text = sendCatagoryData
            sendCatagoryData = ""
            }
        
        self.typeSegmentController.selectedSegmentIndex = segmentControllerPosition
        if segmentControllerPosition == 1 {
        self.wordOrSentenceLabel.text = "Sentence?"
            
        }
        
   
    }
    
    func prepareRec () {
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission { [unowned self] allowed in
                
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                    }
                }
            }
        } catch {
        }
        
    }
 
    func preparePlayback() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playback, mode: .default)
            try recordingSession.setActive(false)
            
        } catch {
        }
    }

}

extension AddNewVC {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y = 0
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            view.frame.origin.y -= keyboardHeight - 120
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
