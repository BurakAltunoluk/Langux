//
//  DataService.swift
//  Langux
//
//  Created by Burak Altunoluk on 02/11/2022.
//

import Foundation
import CoreData
import AVFoundation

class RecordingService {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    
    func startup () {
        
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
    
    
    func loadRecordingUI() {
//        recordButton.isHidden = false
//        recordButton.setTitle("Tap to Record", for: .normal)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
}
