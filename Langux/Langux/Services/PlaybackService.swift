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
        
        if player == nil {
            do {

                if isRepeat == true {
                    let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
                    audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
                } else {
       audioPlayer = try AVAudioPlayer(data: dataver)
                }
                
                audioPlayer.play()
                
                audioPlayer.volume = 100.0
               
            } catch {
           
        }
        } else {
            
        }
        
        
    
}

    mutating func finishPlayback() {
        audioPlayer = nil
    }
    
    mutating func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        finishPlayback()
    }
    
    
    var player: AVPlayer?
    mutating func speechToTextGoogle(language:String, someText: String) {
       
        let textToRead = someText.replacingOccurrences(of: " ", with: "%20")
       
        let url = "https://translate.google.com/translate_tts?ie=UTF-8&q=\(textToRead)&tl=\(language)&total=1&idx=0&textlen=15&tk=350535.255567&client=webapp&prev=input"
        
        guard let url1 = URL.init(string: url)
                        else {
                            return
                    }
        
                    let playerItem = AVPlayerItem.init(url: url1)
                    player = AVPlayer.init(playerItem: playerItem)
                player?.play()
        
        
 
   
       
    }
    
    

}
    
    


