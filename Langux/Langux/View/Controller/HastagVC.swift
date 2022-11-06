//
//  HastagVC.swift
//  Langux
//
//  Created by Burak Altunoluk on 06/11/2022.
//

import UIKit

class HastagVC: UIViewController {
    
    @IBOutlet var addCategory: UIButton!
    var categoryNeedFromAddNewVC = 0
    
    var categoryHastag = [String]()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCategory.layer.cornerRadius = 10
        addCategory.setTitle("", for: .normal)
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.object(forKey: "hastag") is [String] {
            
            categoryHastag = UserDefaults.standard.object(forKey: "hastag") as! [String]
            self.collectionView.reloadData()
        }
        
    }
    
    
    @IBAction func addCategory(_ sender: UIButton) {
        
        categoryHastag.append("#all")
        UserDefaults.standard.set(self.categoryHastag, forKey: "hastag")
        if UserDefaults.standard.object(forKey: "hastag") is [String] {
            
            categoryHastag = UserDefaults.standard.object(forKey: "hastag") as! [String]
            self.collectionView.reloadData()
        }
        
    }
    
}

extension HastagVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryHastag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HastagCell", for: indexPath) as! HastagCollectionCell
        Cell.hastagLabel.text = self.categoryHastag[indexPath.row]
        Cell.layer.cornerRadius = 20
        return Cell
    }


   
}

extension HastagVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWitdh = UIScreen.main.bounds.width
        return CGSize(width: screenWitdh / 2 - 15, height: screenWitdh / 2 - 15)
    }
}


extension HastagVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if self.categoryNeedFromAddNewVC == 1 {
           
            sendCatagoryData = self.categoryHastag[indexPath.row]
           
            dismiss(animated: true)
        } else {
           
            performSegue(withIdentifier: "toMain", sender: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
           
        }
    }
    
   
}
