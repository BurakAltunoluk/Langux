//
//  DataService.swift
//  Langux
//
//  Created by Burak Altunoluk on 02/11/2022.
//

import Foundation
import CoreData
import AVFoundation

class RecordingService1 {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    func loadRecordingUI() {
//        recordButton.isHidden = false
//        recordButton.setTitle("Tap to Record", for: .normal)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func startRecording(delegate: AVAudioRecorderDelegate) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = delegate.self
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

}
