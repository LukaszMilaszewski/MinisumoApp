import UIKit
import CoreBluetooth

class JoystickViewController: UIViewController, BluetoothSerialDelegate {
  
  @IBOutlet weak var leftMagnitude: UILabel!
  @IBOutlet weak var leftTheta: UILabel!
  
  var msg = Array(repeating: "0", count: 10)
  let ms = 1000
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    serial.delegate = self
    msg[0] = "5"
    let rect = view.frame
    let size = CGSize(width: 150.0, height: 150.0)
    let joystick1Frame = CGRect(origin: CGPoint(x: rect.width/2 - size.width/2,
                                                y: rect.height/2),
                                size: size)
    let joystick1 = JoyStickView(frame: joystick1Frame)
    joystick1.monitor = { angle, displacement in
      // some logic here
      let power = Int(100 * displacement) / 5
      let direction = Int(angle)

      self.leftTheta.text = "\(direction)"
      self.leftMagnitude.text = "\(power) %"

      var leftDirection = "0"
      var rightDirection = "0"
      var leftPower = 0
      var rightPower = 0
      
      if direction == 0 {
        leftDirection = "2"
        rightDirection = "2"
        leftPower = power
        rightPower = power
      }
      
      if direction > 0 && direction < 90 {
        leftDirection = "2"
        rightDirection = "2"
        leftPower = power
        rightPower = 20 - direction * power / 90
      }
      
      if direction == 90 {
        leftDirection = "1"
        rightDirection = "2"
        leftPower = power
        rightPower = 0
      }
      
      if direction > 90 && direction < 180 {
        leftDirection = "1"
        rightDirection = "1"
        leftPower = power
        rightPower = (direction - 90) * power / 90
      }
      
      if direction == 180 {
        leftDirection = "1"
        rightDirection = "1"
        leftPower = power
        rightPower = power
      }
      
      if direction > 180 && direction < 270 {
        leftDirection = "1"
        rightDirection = "1"
        leftPower = 20 - (direction - 180) * power / 90
        rightPower = power
      }
      
      if direction == 270 {
        leftDirection = "2"
        rightDirection = "1"
        leftPower = 0
        rightPower = power
      }
      
      if direction > 270 && direction < 360 {
        leftDirection = "2"
        rightDirection = "2"
        leftPower = (direction - 270) * power / 90
        rightPower = power
      }
      
      self.msg[1] = rightDirection
      self.msg[2] = leftDirection
      
      if rightPower < 10 {
        self.msg[3] = "0"
        self.msg[4] = String(rightPower)
      } else {
        self.msg[3] = String(rightPower / 10)
        self.msg[4] = String(rightPower % 10)
      }
      
      if leftPower < 10 {
        self.msg[5] = "0"
        self.msg[6] = String(leftPower)
      } else {
        self.msg[5] = String(leftPower / 10)
        self.msg[6] = String(leftPower % 10)
      }
      
      print(self.msg.joined())
      usleep(useconds_t(20 * self.ms))
//      print(self.msg.joined())
      serial.sendMessageToDevice(self.msg.joined())
    }
    
    view.addSubview(joystick1)
    
    joystick1.movable = false
    joystick1.alpha = 1.0
    joystick1.baseAlpha = 0.5 // let the background bleed thru the base
    joystick1.handleTintColor = UIColor.blue // Colorize the handle

//    serial.sendMessageToDevice(msg.joined())
    
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


