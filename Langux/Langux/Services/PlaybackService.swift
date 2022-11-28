//
//  PlaybackService.swift
//  Langux
//
//  Created by Burak Altunoluk on 04/11/2022.
//

import Foundation
import AVFoundation

class PlaybackService {
    var isPlaying = false
    var statu = ""
    var choosedLg = UserDefaults.standard.string(forKey: "speechLg") ?? "en"
    var player: AVPlayer?
    
    var audioPlayer = AVAudioPlayer()
    
    func textToSpeech(choosedRow: String) {
        
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
        let string = choosedRow
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    // MARK: - Playback
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func startPlayback(dataver: Data, isRepeat: Bool){
     
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        } else {
                do {
                    if isRepeat == true {
                        
  let audioFileName = getDocumentsDirectory().appendingPathComponent("recording.m4a")
                
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileName)
                        
                    } else {
                        
                    audioPlayer = try AVAudioPlayer(data: dataver)
                    
                        
                    }
                    
                audioPlayer.play()
                audioPlayer.volume = 10.0
                   
                } catch {}
        }
            
}

  func finishPlayback() {

    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
     isPlaying = false
    
    }
    
   func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
  
        finishPlayback()
    }
    
    
 
    
     func speechToTextGoogle(language:String, someText: String) {
       
         var textToRead = someText.replacingOccurrences(of: " ", with: "%20")
         textToRead = textToRead.replacingOccurrences(of: "’", with: "%27")
       
         textToRead = textToRead.replacingOccurrences(of: "ê", with: "%C3%AA")
         textToRead = textToRead.replacingOccurrences(of: "á", with: "%C3%A1")
         textToRead = textToRead.replacingOccurrences(of: "é", with: "%C3%A9")
         textToRead = textToRead.replacingOccurrences(of: "ñ", with: "%C3%B1")
         textToRead = textToRead.replacingOccurrences(of: "ó", with: "%C3%B3")
         textToRead = textToRead.replacingOccurrences(of: "í", with: "%C3%AD")
         textToRead = textToRead.replacingOccurrences(of: "ú", with: "%C3%BA")
         
         
        let url = "https://translate.google.com/translate_tts?ie=UTF-8&q=\(textToRead)&tl=\(language)&total=1&idx=0&textlen=15&tk=350535.255567&client=webapp&prev=input"
        
         print(url)
        guard let url1 = URL.init(string: url)
                        else {
                            return
                    }
        
                    let playerItem = AVPlayerItem.init(url: url1)
                    player = AVPlayer.init(playerItem: playerItem)
           NotificationCenter.default.addObserver(self, selector:  #selector(playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    
        

        if isPlaying == false {

            player?.play()
            isPlaying = true
            print("yurutuluyor")

        } else {


            player?.pause()
            isPlaying = false
            print("durdu")
        }
        
 
   
       
    }
    
    

}
    




