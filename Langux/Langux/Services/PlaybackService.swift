//
//  PlaybackService.swift
//  Langux
//
//  Created by Burak Altunoluk on 04/11/2022.
//

import Foundation
import AVFoundation

struct PlaybackService {
    
    var statu = ""
    
    var audioPlayer: AVAudioPlayer!
    
    func textToSpeech(choosedRow: String) {
        let string = choosedRow
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    
    // MARK: - Playback
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    mutating func startPlayback(dataver: Data, isRepeat: Bool) {
        
        do {

            if isRepeat == true {
                let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
                audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            } else {
   audioPlayer = try AVAudioPlayer(data: dataver)
            }
           
            audioPlayer.play()
            
            audioPlayer.volume = 30.0
        
        } catch {
    }
}

    mutating func finishPlayback() {
        audioPlayer = nil
   
       
    }
    
    mutating func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        finishPlayback()
    }
    

     }
    
    

