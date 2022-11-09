//
//  HastagVC.swift
//  Langux
//
//  Created by Burak Altunoluk on 06/11/2022.
//

import UIKit
import AudioToolbox

class HastagVC: UIViewController {
    
    
    var deleteHastag = false
    
    @IBOutlet var trashButtonOutlet: UIButton!
    
    @IBOutlet var addCategory: UIButton!
    var categoryNeedFromAddNewVC = 0
    
    var categoryHastag = [String]()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCategory.layer.cornerRadius = 10
        addCategory.setTitle("", for: .normal)
        trashButtonOutlet.setTitle("", for: .normal)
    }
  

    
    
    @IBAction func deleteHastagButtonPressed(_ sender: UIButton) {
       
        self.deleteHastag.toggle()
       
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.object(forKey: "hastag") is [String] {
            
            categoryHastag = UserDefaults.standard.object(forKey: "hastag") as! [String]
            self.collectionView.reloadData()
        }
       
    }
    func addNewProduct(){
      
     var newHastag = ""
      let menu = UIAlertController(title: "New Hastag", message: "", preferredStyle: .alert)
      
      menu.addTextField { nameTextField in
          nameTextField.placeholder = "name"
      }
      
      
      let saveButton = UIAlertAction(title: "Save", style: .default) { data in
          let firstTextField = menu.textFields![0] as UITextField
    
          newHastag = firstTextField.text ?? ""
          print(firstTextField.text ?? "")
          
          if newHastag != "" {
              self.categoryHastag.append("#\(newHastag)")
              
              UserDefaults.standard.set(self.categoryHastag, forKey: "hastag")
              
              if UserDefaults.standard.object(forKey: "hastag") is [String] {
                  
                self.categoryHastag = UserDefaults.standard.object(forKey: "hastag") as! [String]
                  self.collectionView.reloadData()
              }
          }
     
      }
     
      let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
     
      menu.addAction(saveButton)
      menu.addAction(cancelButton)
      present(menu, animated: true)
       
  }
    
    @IBAction func addCategory(_ sender: UIButton) {
        
       addNewProduct()
        
        
       
        
        
  
        
    }
    
}

extension HastagVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryHastag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HastagCell", for: indexPath) as! HastagCollectionCell
        if deleteHastag == true {
        Cell.layer.borderColor = UIColor.red.cgColor
        Cell.layer.borderWidth = 4
        Cell.trashIcon.isHidden = false
        } else {
            Cell.layer.borderColor = UIColor.clear.cgColor
            Cell.layer.borderWidth = 0
            Cell.trashIcon.isHidden = true
        }
        
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
    
        
        if deleteHastag == true {
            
            if indexPath.row > 0 {
            self.categoryHastag.remove(at: indexPath.row)
            UserDefaults.standard.set(self.categoryHastag, forKey: "hastag")
            } else {
                AudioServicesPlayAlertSound(1521)
            }
            
            self.collectionView.reloadData()
        } else {
        
        
        if self.categoryNeedFromAddNewVC == 1 {
           
            sendCatagoryData = self.categoryHastag[indexPath.row]
            
        
            
        } else {
           
            performSegue(withIdentifier: "toMain", sender: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
           
        }
    }
    }
   
}
