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
        
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addQuadCurve(to: CGPoint(x: 100, y: 0), controlPoint: CGPoint(x: 50, y: 200))
        path.addLine(to: CGPoint(x: 99, y: 0))
        path.addQuadCurve(to: CGPoint(x: 1, y: 0), controlPoint: CGPoint(x: 50, y: 198))
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
        slider.thumbTintColor = .link
        startAnimation()
        volume = 0
    }
    
    @IBAction func touchDownButton(){
        slider.thumbTintColor = .clear
    }
    
    func startAnimation(){
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: animationView.frame.origin.x-100, y: animationView.frame.origin.y))
        path.addQuadCurve(to: CGPoint(x: animationView.frame.origin.x+(volume*5), y: animationView.frame.origin.y), controlPoint: CGPoint(x: animationView.frame.origin.x, y: animationView.frame.origin.y-300))
        
        let animation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 1
        animation.calculationMode = CAAnimationCalculationMode.cubic
        
        animationView.layer.add(animation, forKey: "position")
    }
}

