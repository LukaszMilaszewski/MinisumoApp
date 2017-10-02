import UIKit
import CoreBluetooth

class CleaningTiresViewController: UIViewController, BluetoothSerialDelegate {
  
  var msg = Array(repeating: "0", count: 10)
  
  @IBOutlet weak var switchOutlet: UISwitch!
  @IBAction func changedState(_ sender: UISwitch) {
    if sender.isOn {
      msg[0] = "3"
      serial.sendMessageToDevice(msg.joined())
    } else {
      msg[0] = "0"
      serial.sendMessageToDevice(msg.joined())
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    msg[0] = "0"
    serial.sendMessageToDevice(msg.joined())
    print("view disappeard")
    switchOutlet.setOn(false, animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    switchOutlet.setOn(false, animated: true)
    serial.delegate = self
    print("view loaded")
  }
  
  
  //MARK:- BluetoothSerialDelegate
  
  func serialDidReceiveString(_ message: String) {
    //    print("received message: \(message)")
    //        print("sendind message: \(msg.joined())")
    //        serial.sendMessageToDevice(msg.joined())
  }
  
  func serialDidChangeState() {
    if serial.centralManager.state != .poweredOn {
    }
  }
  
  func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
  }
}

