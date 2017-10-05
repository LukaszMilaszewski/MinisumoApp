//
//  ViewController.swift
//  JoystickTestApp
//
//  Created by Bradley Howes on 8/24/17.
//  Copyright © 2017 Bradl Howes. All rights reserved.
//

import UIKit
import CoreBluetooth

class JoystickViewController: UIViewController {
  
  @IBOutlet weak var leftMagnitude: UILabel!
  @IBOutlet weak var leftTheta: UILabel!
  
  var msg = Array(repeating: "0", count: 10)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    let rect = view.frame
    let size = CGSize(width: 80.0, height: 80.0)
    let joystick1Frame = CGRect(origin: CGPoint(x: 40.0,
                                                y: (rect.height - size.height - 40.0)),
                                size: size)
    let joystick1 = JoyStickView(frame: joystick1Frame)
    joystick1.monitor = { angle, displacement in
      // some logic here
      self.leftTheta.text = "\(angle)"
      self.leftMagnitude.text = "\(displacement)"
    }
    
    view.addSubview(joystick1)
    
    joystick1.movable = false
    joystick1.alpha = 1.0
    joystick1.baseAlpha = 0.5 // let the background bleed thru the base
    joystick1.handleTintColor = UIColor.green // Colorize the handle
    msg[0] = "5"
    serial.sendMessageToDevice(msg.joined())
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    print("view disappeard")
    msg[0] = "0"
    serial.sendMessageToDevice(msg.joined())
  }
  
  //MARK:- BluetoothSerialDelegate
  
  func serialDidReceiveString(_ message: String) {
  	print("received message: \(message)")
  }
  
  func serialDidChangeState() {
    if serial.centralManager.state != .poweredOn {
    }
  }
  
  func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
  }
}


