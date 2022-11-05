//
//  addNewVC.swift
//  Langux
//  Created by Burak Altunoluk on 01/11/2022.
//

import UIKit
import AVFoundation
import CoreData

final class AddNewVC: UIViewController, AVAudioRecorderDelegate {
    var player: AVPlayer?
    var segmentControllerPosition = 0 
    private var dataService = DataService()
    private var recordingService = RecordingService()
    private var playbackService = PlaybackService()
    
    var centenceVoices = [Data]()
    var meaning = [String]()
    var datamm = Data()
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet private var typeSegmentController: UISegmentedControl!
    @IBOutlet private var sharingSegmentController: UISegmentedControl!
    @IBOutlet private var wordInputTextFiled: UITextField!
    @IBOutlet private var meanningInputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewGesture))
        view.addGestureRecognizer(gesture)
        self.typeSegmentController.selectedSegmentIndex = segmentControllerPosition
        recordingService.startup()
       
    }
    
    @objc func viewGesture() {
        
        view.endEditing(true)
        
        
    }
    private func textToSpeech(textToSpeech: String) {
        let string = textToSpeech
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
        return paths[0]
    }
    
    func loadRecordingUI() {
//        recordButton.isHidden = false
//        recordButton.setTitle("Tap to Record", for: .normal)
    }

    @IBAction private func playButtonPressed(_ sender: UIButton) {
        if audioPlayer == nil {
            startPlayback()
        } else {
            playbackService.finishPlayback()
        }
    }

    @IBAction private func deleteVoiceButtonPressed(_ sender: UIButton) {
//        try? FileManager.default.removeItem(at: getDocumentsDirectory().appendingPathComponent("recording.m4a"))
        
        let adana = wordInputTextFiled.text!.replacingOccurrences(of: " ", with: "%20")
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
    
    @IBAction private func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

    
    @IBAction private func submitButtonPressed(_ sender: UIButton) {
        
        let datam = try? Data(contentsOf: getDocumentsDirectory().appendingPathComponent("recording.m4a"))
        
        if typeSegmentController.selectedSegmentIndex == 0 {
            
        dataService.setData(forKey: .words, Value: self.wordInputTextFiled.text!, EntityName: .Words)
            
            if datam != nil {
                dataService.setData(forKey: .wordsSound, Value: datam!, EntityName: .Words)
        
            } else { dataService.setData(forKey: .wordsSound, Value: Data(), EntityName: .Words)}
            
            
        } else if typeSegmentController.selectedSegmentIndex == 1 {
            
            dataService.setData(forKey: .sentences, Value: self.wordInputTextFiled.text!, EntityName: .Sentences)
            if datam != nil {
                dataService.setData(forKey: .sentencesSound, Value: datam!, EntityName: .Sentences)
                
            } else { dataService.setData(forKey: .sentencesSound, Value: Data(), EntityName: .Sentences)}
        }
        dismiss(animated: true)
    }
    
    
    // MARK: - Recording

    @IBAction private func recButtonPressed(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
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

}
