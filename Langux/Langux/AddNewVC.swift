//
//  addNewVC.swift
//  Langux
//
//  Created by Burak Altunoluk on 01/11/2022.
//

import UIKit
import AVFoundation
import CoreData

final class AddNewVC: UIViewController {
    
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
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record!
        }

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
            finishPlayback()
        }
    }
    

    
    
    @IBAction private func deleteVoiceButtonPressed(_ sender: UIButton) {
     
    }
    
    @IBAction private func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }

    
    @IBAction private func submintButtonPressed(_ sender: UIButton) {
        
        if typeSegmentController.selectedSegmentIndex == 0 {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Words", into: context)
            
            newRecord.setValue(self.wordInputTextFiled.text!, forKey: "words")
            
            
let datam = try? Data(contentsOf: getDocumentsDirectory().appendingPathComponent("recording.m4a"))
       
            if datam != nil {
            newRecord.setValue(datam, forKey: "wordsSound")
            
            do{
                try context.save()
            } catch {
            }
            } else { newRecord.setValue(nil, forKey: "wordsSound")}
        } else if typeSegmentController.selectedSegmentIndex == 1 {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Sentences", into: context)
            
            newRecord.setValue(self.wordInputTextFiled.text!, forKey: "sentence")
            
            
let datam = try? Data(contentsOf: getDocumentsDirectory().appendingPathComponent("recording.m4a"))
       
            if datam != nil {
            newRecord.setValue(datam, forKey: "sentencesSound")
            
            do{
                try context.save()
            } catch {
            }
            } else { newRecord.setValue(nil, forKey: "wordsSound")}
        }
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
       let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
          //  audioPlayer = try AVAudioPlayer(data: dataVer)
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

extension AddNewVC: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
}

extension AddNewVC: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        finishPlayback()
    }
    
}
