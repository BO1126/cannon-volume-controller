//
//  GravityViewController.swift
//  CannonVolumeController
//
//  Created by 이정우 on 2021/12/01.
//

import UIKit
import CoreMotion

class GravityViewController: UIViewController {
    
    @IBOutlet weak var slider : UIVolumeSlider!
    @IBOutlet weak var volumeLabel : UILabel!
    
    var motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.updatePositionForSystemVolume()
        motionManager.deviceMotionUpdateInterval = 0.1
        
        motionManager.startDeviceMotionUpdates(
                    to: OperationQueue.current!,
                    withHandler: {(
                        deviceMotion: CMDeviceMotion!,
                        error: Error!
                    ) -> Void in
                        self.slider.value = Float(deviceMotion.gravity.y)
                        self.volumeLabel.text = "Volume : \(self.slider.value)"
                    }
                )
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            slider.activate()
        }

    override func viewWillDisappear(_ animated: Bool) {
        slider.deactivate()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func dismissView(){
        dismiss(animated: true)
    }
    
}
