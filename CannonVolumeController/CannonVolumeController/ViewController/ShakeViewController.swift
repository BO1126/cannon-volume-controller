//
//  ShakeViewController.swift
//  CannonVolumeController
//
//  Created by 이정우 on 2021/12/08.
//

import UIKit

class ShakeViewController: UIViewController {

    @IBOutlet weak var volumeBar : UIProgressView!
    @IBOutlet weak var volumeLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { timer in
            self.volumeBar.progress -= 0.001
            self.volumeLabel.text = "Volume : \(Int(self.volumeBar.progress*100))"
        })
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            volumeBar.progress += 0.3
            self.volumeLabel.text = "Volume : \(Int(self.volumeBar.progress*100))"
            motionCancelled(.motionShake, with: nil)
        }
    }
    
    @IBAction func dismissView(){
        dismiss(animated: true, completion: nil)
    }

}
