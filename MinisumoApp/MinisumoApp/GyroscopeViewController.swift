import UIKit
import CoreBluetooth
import CoreMotion

class GyroscopeViewController: UIViewController, BluetoothSerialDelegate {

  @IBOutlet weak var stateButton: UIButton!
  @IBOutlet weak var powerLabel: UILabel!
  @IBOutlet weak var directionLabel: UILabel!
//  var isPresented = true
  var msg = Array(repeating: "0", count: 10)
  let ms = 1000
  var ifStart = true
  
  var motionManager = CMMotionManager()
  
  @IBAction func gyroscope() {
    if ifStart {
      stateButton.setTitle("STOP", for: .normal)
    	startAcc()
    } else {
      stateButton.setTitle("START", for: .normal)
    	stopAcc()
    }
    
    ifStart = !ifStart
  }
  
  func startAcc() {
    motionManager.deviceMotionUpdateInterval = 0.2
//    motionManager.accelerometerUpdateInterval = 0.2
    motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
      if let motion = data {
//        print("RPY x:\(motion.attitude.roll) y: \(motion.attitude.pitch) z: \(motion.attitude.yaw) ")
        
        var turn = Int(100 * motion.attitude.pitch)
        var power = Int(100 * motion.attitude.roll)
        
        if power > 99 {
          power = 99
        }
        
        if power < -99 {
          power = -99
        }
        
        power /= 5
        
        if turn > 99 {
          turn = 99
        }
        
        if turn < -99 {
          turn = -99
        }
        
        var leftDirection = "0"
        var rightDirection = "0"
        var leftPower = 0
        var rightPower = 0
        
        // motors direction
        if power > 0 {
          leftDirection = "2"
          rightDirection = "2"
        } else {
          power *= -1
          leftDirection = "1"
          rightDirection = "1"
//          turn *= -1
        }
        
        if turn > 0 {
        	leftPower = power
          rightPower = power - power * turn / 100
        } else {
          turn *= -1
          leftPower = power - power * turn / 100
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
        serial.sendMessageToDevice(self.msg.joined())
//        print(self.msg.joined())
      }
    }
  }
  
  func stopAcc() {
    motionManager.stopDeviceMotionUpdates()
    msg[3] = "0"
    msg[4] = "0"
    msg[5] = "0"
    msg[6] = "0"
    serial.sendMessageToDevice(msg.joined())
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    ifStart = true
		msg[0] = "6"
    stateButton.setTitle("START", for: .normal)
    serial.delegate = self
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
  
  //MARK:- Handling landscape
  override var shouldAutorotate: Bool {
    return false
  }
  
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscapeRight
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .landscapeRight
  }
}
