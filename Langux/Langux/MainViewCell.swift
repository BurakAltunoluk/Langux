//
//  MainViewCell.swift
//  Langux
//
//  Created by Burak Altunoluk on 01/11/2022.
//

import UIKit
import AVFoundation

class MainViewCell: UITableViewCell {

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
        textToSpeech(choosedRow: labelView.text!)
        print(playButtonOOutlet.tag)
       
    }
    
    @IBAction func TranslationresultsquestionButtonPressed(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    private func textToSpeech(choosedRow: String) {
        let string = choosedRow
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }

}
