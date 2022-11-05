//
//  MainViewCell.swift
//  Langux
//
//  Created by Burak Altunoluk on 01/11/2022.
//

import UIKit
import AVFoundation

class MainViewCell: UITableViewCell {
    var playBackService = PlaybackService()
   
    var player: AVPlayer?

    @IBOutlet var playButtonOOutlet: UIButton!
    @IBOutlet var questionButtonOutlet: UIButton!
    @IBOutlet var labelView: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.questionButtonOutlet.setTitle("", for: .normal)
        self.questionButtonOutlet.layer.cornerRadius = 10
        self.playButtonOOutlet.setTitle("", for: .normal)
        self.playButtonOOutlet.layer.cornerRadius = 10
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        playBackService.textToSpeech(choosedRow: labelView.text!)
        print(playButtonOOutlet.tag)
       
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let adana = labelView.text!.replacingOccurrences(of: " ", with: "%20")
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
 
        
        
    }
    
}
