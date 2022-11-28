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
    var isPlaying = false
    var player: AVPlayer?
    var choosedLg = ""
    @IBOutlet var editButtonOutlet: UIButton!
    @IBOutlet var playButtonOOutlet: UIButton!
    @IBOutlet var questionButtonOutlet: UIButton!
    @IBOutlet var labelView: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.editButtonOutlet.setTitle("", for: .normal)
        self.questionButtonOutlet.setTitle("", for: .normal)
        self.playButtonOOutlet.setTitle("", for: .normal)
        self.editButtonOutlet.layer.cornerRadius = 5
        self.questionButtonOutlet.layer.cornerRadius = 5
        self.playButtonOOutlet.layer.cornerRadius = 5
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork(){
            self.choosedLg = UserDefaults.standard.string(forKey: "speechLg") ?? "en"
            playBackService.speechToTextGoogle(language: choosedLg, someText: labelView.text!)
       
        } else {
            
            playBackService.textToSpeech(choosedRow: labelView.text!)
        }
       
    }


    @IBAction func editButtonPressed(_ sender: UIButton) {


    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    
}
