import UIKit
import CoreBluetooth

class CheckSensorsViewController: UIViewController, BluetoothSerialDelegate {
  
  let ms = 1000
  var msg = Array(repeating: "0", count: 10)
  
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
    msg[0] = "4"
    serial.sendMessageToDevice(msg.joined())
    print("transmit: \(msg.joined())")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    print("view disappeard")
    usleep(useconds_t(20 * ms))
    msg[0] = "0"
    serial.sendMessageToDevice(msg.joined())
  }
  
  //MARK:- BluetoothSerialDelegate
  
  func serialDidReceiveString(_ message: String) {
    let messageArray = Array(message.characters)
    print("received: \(message)")
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
      
      usleep(useconds_t(20 * ms))
      serial.sendMessageToDevice(msg.joined())
      print("sent: \(msg.joined())")
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
