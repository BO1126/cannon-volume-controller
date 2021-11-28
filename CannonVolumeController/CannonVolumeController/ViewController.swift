//
//  ViewController.swift
//  CannonVolumeController
//
//  Created by 이정우 on 2021/11/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var volumeButton : UIButton!
    @IBOutlet weak var slider : UISlider!
    @IBOutlet weak var animationView : UIView!
    
    var timer : Timer?
    var volume : Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let press = UILongPressGestureRecognizer()
        press.addTarget(self, action: #selector(self.pressed(_:)))
        volumeButton.addGestureRecognizer(press)
        
        
        animationView.clipsToBounds = true
        animationView.layer.masksToBounds = true
        animationView.layer.cornerRadius = 13
    }
    
    @objc func pressed(_ gesture : UILongPressGestureRecognizer?){
            guard let ges = gesture else { return }
            
            switch ges.state{
            case .began:
                timer?.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 0.008, target: self, selector: #selector(hold), userInfo: nil, repeats: true)
            case .ended, .cancelled:
                holdEnd()
                timer?.invalidate()
            default:
                break
            }
        }
    
    @objc func hold(){
        if volume < 100 {
            volume+=1
            print(volume)
            volumeButton.transform = CGAffineTransform(rotationAngle: -CGFloat(volume/100)).translatedBy(x: 0, y: 0);
        }
    }
    
    func holdEnd(){
        print("bang!")
        slider.value = Float(volume)
        animationView.frame = CGRect(x: 264, y: 192, width: animationView.frame.width, height: animationView.frame.height)
        startAnimation()
        volume = 0
    }
    
    func startAnimation(){
        
        animationView.layer.backgroundColor = UIColor.link.cgColor
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: animationView.frame.origin.x-50, y: animationView.frame.origin.y-50))
        path.addQuadCurve(to: CGPoint(x: animationView.frame.origin.x+(volume*5), y: animationView.frame.origin.y), controlPoint: CGPoint(x: animationView.frame.origin.x+CGFloat(volume*2), y: animationView.frame.origin.y-CGFloat(300 - (volume-100)*2)))
        
        let animation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 0.6
        animationView.layer.add(animation, forKey: "position")
        animationView.frame = CGRect(x: animationView.frame.origin.x+(volume*5), y: animationView.frame.origin.y, width: animationView.frame.width, height: animationView.frame.height)
        
    }
}

