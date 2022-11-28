//
//  MenuVC.swift
//  Langux
//
//  Created by Burak Altunoluk on 20/11/2022.
//

import UIKit

class MenuVC: UIViewController {

    private var shareLink = ""
    @IBOutlet var segmentController: UISegmentedControl!
    private var playbackservice = PlaybackService()
    override func viewDidLoad() {
    super.viewDidLoad()
        
        getShareLink()
        
        
        let choosedLg = UserDefaults.standard.string(forKey: "speechLg") ?? "en"
        switch choosedLg {
        case "en": segmentController.selectedSegmentIndex = 0
        case "es": segmentController.selectedSegmentIndex = 1
        case "fr": segmentController.selectedSegmentIndex = 2
        case "pt": segmentController.selectedSegmentIndex = 3
        default:
            segmentController.selectedSegmentIndex = 0
        }
        
    }
    @IBAction func shareAppButtonPressed(_ sender: Any) {
      
      share(sender: view)
    }
    
    @IBAction func segmentControllerChanged(_ sender: UISegmentedControl) {
        let choosedindex = segmentController.selectedSegmentIndex

        let languages = ["en","es","fr","pt"]
        let lng = ["English","España","France","Portugal"]
        playbackservice.speechToTextGoogle(language: languages[choosedindex], someText: lng[choosedindex])
        
        UserDefaults.standard.set(languages[choosedindex], forKey: "speechLg")
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        
        dismiss(animated: true)
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func getShareLink()  {
        
    
        
        let url = URL(string: "https://raw.githubusercontent.com/BurakAltunoluk/APIs-Sample/main/Langux.json")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data {
                
            
            let links = try? JSONDecoder().decode([Model].self, from: data)
        
                self.shareLink = links![0].shareLink
        }
        
        }.resume()
    
    }
    
    func share(sender:UIView){
           
           
            UIGraphicsBeginImageContext(view.frame.size)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIImage(named: "share")   //UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            let textToShare = "Check out Langux App"

        if let myWebsite = URL(string: self.shareLink) {
                
                let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                //Excluded Activities
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                //

                activityVC.popoverPresentationController?.sourceView = sender
                self.present(activityVC, animated: true, completion: nil)
            }    }

}
