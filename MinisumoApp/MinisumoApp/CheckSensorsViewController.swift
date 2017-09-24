import UIKit
import CoreBluetooth

class CheckSensorsViewController: UIViewController, BluetoothSerialDelegate {
  
  
  
  @IBOutlet weak var leftSensor: UILabel!
  @IBOutlet weak var upperLeftSensor: UILabel!
  @IBOutlet weak var rightSensor: UILabel!
  @IBOutlet weak var upperRightSensor: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    leftSensor.text = " "
    serial.delegate = self
    msg = "9"
    serial.sendMessageToDevice(msg)
 

  }
  //MARK:- BluetoothSerialDelegate
  
  func serialDidReceiveString(_ message: String) {
    let messageArray = Array(message.characters)
    print("\(message)")
    if messageArray.count == 4 {
      if messageArray[0] == "1" {
        leftSensor.text = "work"
      } else {
        leftSensor.text = " "
      }
      
      if messageArray[1] == "1" {
        upperLeftSensor.text = "work"
      } else {
        upperLeftSensor.text = " "
      }
      
      if messageArray[2] == "1" {
        upperRightSensor.text = "work"
      } else {
        upperRightSensor.text = " "
      }
      
      if messageArray[3] == "1" {
        rightSensor.text = "work"
      } else {
        rightSensor.text = " "
      }
      
      serial.sendMessageToDevice(msg)
    }
  }
  
  func serialDidChangeState() {
    if serial.centralManager.state != .poweredOn {
      leftSensor.text = "errooooro"
    }
  }
  
  func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
    leftSensor.text = "rozloczono"
  }
}
