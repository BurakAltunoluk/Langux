//
//  HastagVC.swift
//  Langux
//
//  Created by Burak Altunoluk on 06/11/2022.
//

import UIKit
import AudioToolbox

final class HastagVC: UIViewController {
    
    // MARK: Properties
    var categoryNeedFromAddNewVC = 0
    private var deleteHastag = false
    private var rowNumber = 0
    
    @IBOutlet var menuOutlet: UIButton!
    @IBOutlet private var trashButtonOutlet: UIButton!
    @IBOutlet private var addCategory: UIButton!
    private var categoryHastag = [String]()
    @IBOutlet private var collectionView: UICollectionView!
    
    
// MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        menuOutlet.layer.cornerRadius = 10
        addCategory.layer.cornerRadius = 10
        trashButtonOutlet.layer.cornerRadius = 10
        menuOutlet.setTitle("", for: .normal)
        addCategory.setTitle("", for: .normal)
        trashButtonOutlet.setTitle("", for: .normal)
        
        if UserDefaults.standard.object(forKey: "hastag") == nil {
                self.categoryHastag.append("#all")
                UserDefaults.standard.set(self.categoryHastag, forKey: "hastag")
            }
         }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.layer.cornerRadius = 10
        getHastagData()
       
    }

// MARK: Buttons
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toMenu", sender: nil)
    }
    @IBAction func deleteHastagButtonPressed(_ sender: UIButton) {
        self.addCategory.isEnabled.toggle()
        self.menuOutlet.isEnabled.toggle()
        if addCategory.isEnabled == true {
            trashButtonOutlet.layer.borderWidth = 0
        } else {
            trashButtonOutlet.layer.borderColor = UIColor.red.cgColor
            trashButtonOutlet.layer.borderWidth = 4
        }
       
       
        self.deleteHastag.toggle()
        self.collectionView.reloadData()
    }
    
    @IBAction func addCategory(_ sender: UIButton) {
       addNewProduct()
    }
    
    
    
// MARK: Functions
    func getHastagData() {
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
      
      
        let saveButton = UIAlertAction(title: "Add", style: .cancel) { data in
          let firstTextField = menu.textFields![0] as UITextField
    
          newHastag = firstTextField.text ?? ""
          
          if newHastag != "" {
              self.categoryHastag.append("#\(newHastag)")
              
              UserDefaults.standard.set(self.categoryHastag, forKey: "hastag")
              
              if UserDefaults.standard.object(forKey: "hastag") is [String] {
                  
                self.categoryHastag = UserDefaults.standard.object(forKey: "hastag") as! [String]
                  self.collectionView.reloadData()
              }
          }
     
      }
     
        let cancelButton = UIAlertAction(title: "Cancel", style: .default)
      menu.addAction(saveButton)
      menu.addAction(cancelButton)
      present(menu, animated: true)
       
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMain" {
            
            let MainVC = segue.destination as! MainVC
            MainVC.choosedHastag = categoryHastag[rowNumber]
            
        }
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}

extension HastagVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryHastag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HastagCell", for: indexPath) as! HastagCollectionCell
        if deleteHastag == true{
        
        if indexPath.row != 0 {
              
        Cell.layer.borderColor = UIColor.red.cgColor
        Cell.layer.borderWidth = 4
        Cell.trashIcon.isHidden = false
           
            }
            
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
        return CGSize(width: screenWitdh / 2 - 16, height: screenWitdh / 2 - 16)
    }
}


extension HastagVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  
        
        
        if deleteHastag == true {
            
            if indexPath.row > 0 {
            self.categoryHastag.remove(at: indexPath.row)
            UserDefaults.standard.set(self.categoryHastag, forKey: "hastag")
            self.menuOutlet.isEnabled.toggle()
            deleteHastag = false
            self.collectionView.reloadData()
                
            } else {
            
                AudioServicesPlayAlertSound(1521)
                deleteHastag = false
                self.collectionView.reloadData()
              
            }
            
            self.collectionView.reloadData()
            self.addCategory.isEnabled.toggle()
            trashButtonOutlet.layer.borderWidth = 0
        } else {
        
        
        if self.categoryNeedFromAddNewVC == 1 {
           
            sendCatagoryData = self.categoryHastag[indexPath.row]
            dismiss(animated: true)
        
            
        } else {
            self.rowNumber = indexPath.row
            performSegue(withIdentifier: "toMain", sender: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
           
        }
     }
  }
   
}
