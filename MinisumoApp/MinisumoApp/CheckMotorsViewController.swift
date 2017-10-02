import UIKit
import CoreBluetooth

class CheckMotorsViewController: UIViewController, BluetoothSerialDelegate {

  
  // direction: 1 - backward 2 - forward
  let ms = 1000
  var left_motor_direction = 1
  var left_motor_power = 0
  
  var right_motor_direction = 1
  var right_motor_power = 0

    @IBOutlet weak var leftMotorSlider: UISlider!
    @IBOutlet weak var rightMotorSlider: UISlider!
    
  var msg = Array(repeating: "0", count: 10)
  
    @IBAction func leftMotor(_ sender: UISlider) {
    	left_motor_power = Int(sender.value)
      
      if left_motor_power < 0 {
        left_motor_direction = 1
        left_motor_power *= -1
      } else {
      	left_motor_direction = 2
      }
      
      msg[1] = String(left_motor_direction)
      
      if left_motor_power < 10 {
        msg[3] = "0"
        msg[4] = String(left_motor_power)
      } else {
        msg[3] = String(left_motor_power / 10)
        msg[4] = String(left_motor_power % 10)
      }
      
      usleep(useconds_t(20 * ms))
      serial.sendMessageToDevice(msg.joined())
    }

  @IBAction func RightMotor(_ sender: UISlider) {
    right_motor_power = Int(sender.value)
    
    if right_motor_power < 0 {
      right_motor_direction = 1
      right_motor_power *= -1
    } else {
      right_motor_direction = 2
    }
    
    msg[2] = String(right_motor_direction)
    
    if right_motor_power < 10 {
      msg[5] = "0"
      msg[6] = String(right_motor_power)
    } else {
      msg[5] = String(right_motor_power / 10)
      msg[6] = String(right_motor_power % 10)
    }
    
    usleep(useconds_t(20 * ms))
    print(msg.joined())
    serial.sendMessageToDevice(msg.joined())
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
	override func viewWillDisappear(_ animated: Bool) {
  	super.viewWillDisappear(true)
    print("view disappeard")
    msg[0] = "0"
    serial.sendMessageToDevice(msg.joined())
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    serial.delegate = self
    print("view loaded")
    leftMotorSlider.value = 0
    rightMotorSlider.value = 0
    usleep(useconds_t(20 * ms))
    msg[0] = "2"
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
