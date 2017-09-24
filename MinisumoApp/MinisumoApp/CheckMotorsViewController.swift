import UIKit
import CoreBluetooth

class CheckMotorsViewController: UIViewController, BluetoothSerialDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    serial.delegate = self
    msg = "8"
    serial.sendMessageToDevice(msg)
  }
  
  //MARK:- BluetoothSerialDelegate
  
  func serialDidReceiveString(_ message: String) {

    print("\(message)")
    serial.sendMessageToDevice(msg)
  }
  
  func serialDidChangeState() {
    if serial.centralManager.state != .poweredOn {
    }
  }
  
  func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
  }
}
