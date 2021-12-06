//
//  ViewController.swift
//  CannonVolumeController
//
//  Created by 이정우 on 2021/11/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var volumeButton : UIButton!
    @IBOutlet weak var slider : UIVolumeSlider!
    @IBOutlet weak var animationView : UIView!
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet weak var volumeLabel : UILabel!
    
    var timer : Timer?
    var volume : Double = 0
    var bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let press = UILongPressGestureRecognizer()
        press.addTarget(self, action: #selector(self.pressed(_:)))
        volumeButton.addGestureRecognizer(press)
        
        animationView.clipsToBounds = true
        animationView.layer.masksToBounds = true
        animationView.layer.cornerRadius = 13
        
        let gradientImage = UIImage.gradientImage(with: progressView.frame,
                                                colors: [UIColor.green.cgColor, UIColor.red.cgColor],
                                                locations: nil)
        
        progressView.progressImage = gradientImage!
        
        slider.updatePositionForSystemVolume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           slider.activate()
       }

       override func viewWillDisappear(_ animated: Bool) {
           slider.deactivate()
           super.viewWillDisappear(animated)
       }
    
    @objc func pressed(_ gesture : UILongPressGestureRecognizer?){
            guard let ges = gesture else { return }
            
            switch ges.state{
            case .began:
                timer?.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(hold), userInfo: nil, repeats: true)
            case .ended, .cancelled:
                holdEnd()
                timer?.invalidate()
            default:
                break
            }
        }
    
    @objc func hold(){
        if volume == 100 {
            bool = false
        }
        else if volume == 0 {
            bool = true
        }
        if bool == true{
            if volume < 100 {
                volume+=1
                print(volume)
                volumeButton.transform = CGAffineTransform(rotationAngle: -CGFloat(volume/100)).translatedBy(x: 0, y: 0);
                progressView.progress = Float(volume/100)
            }
        }else{
            volume-=1
            print(volume)
            volumeButton.transform = CGAffineTransform(rotationAngle: -CGFloat(volume/100)).translatedBy(x: 0, y: 0);
            progressView.progress = Float(volume/100)
        }
    }
    
    func holdEnd(){
        print("bang!")
        slider.value = Float(volume)
        animationView.frame = CGRect(x: 264, y: 192, width: animationView.frame.width, height: animationView.frame.height)
        startAnimation()
        slider.setVolume()
        volume = 0
    }
    
    func startAnimation(){
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: animationView.frame.origin.x-50, y: animationView.frame.origin.y-50))
        path.addQuadCurve(to: CGPoint(x: animationView.frame.origin.x+(volume*5), y: animationView.frame.origin.y), controlPoint: CGPoint(x: animationView.frame.origin.x+CGFloat(volume*2.5), y: animationView.frame.origin.y-CGFloat(350 - (volume-100)*2)))
        
        let animation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 0.6
        animationView.layer.add(animation, forKey: "position")
        animationView.frame = CGRect(x: animationView.frame.origin.x+(volume*5), y: animationView.frame.origin.y, width: animationView.frame.width, height: animationView.frame.height)
    }
    
    @IBAction func dismissView(){
        dismiss(animated: true)
    }
}

fileprivate extension UIImage {
    static func gradientImage(with bounds: CGRect,
                            colors: [CGColor],
                            locations: [NSNumber]?) -> UIImage? {

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        // This makes it horizontal
        gradientLayer.startPoint = CGPoint(x: 0.0,
                                        y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,
                                        y: 0.5)

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}
