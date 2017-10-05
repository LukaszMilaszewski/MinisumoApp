//
//  ViewController.swift
//  JoystickTestApp
//
//  Created by Bradley Howes on 8/24/17.
//  Copyright © 2017 Bradl Howes. All rights reserved.
//

import UIKit

class JoystickViewController: UIViewController {
  
  @IBOutlet weak var leftMagnitude: UILabel!
  @IBOutlet weak var leftTheta: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    // Create 'fixed' joystick
    //
    let rect = view.frame
    let size = CGSize(width: 80.0, height: 80.0)
    let joystick1Frame = CGRect(origin: CGPoint(x: 40.0,
                                                y: (rect.height - size.height - 40.0)),
                                size: size)
    let joystick1 = JoyStickView(frame: joystick1Frame)
    joystick1.monitor = { angle, displacement in
      self.leftTheta.text = "\(angle)"
      self.leftMagnitude.text = "\(displacement)"
    }
    
    view.addSubview(joystick1)
    
    joystick1.movable = false
    joystick1.alpha = 1.0
    joystick1.baseAlpha = 0.5 // let the background bleed thru the base
    joystick1.handleTintColor = UIColor.green // Colorize the handle
  }
}


