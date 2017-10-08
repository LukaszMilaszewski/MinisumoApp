import UIKit
import CoreBluetooth

class GyroscopeViewController: UIViewController, BluetoothSerialDelegate {

  @IBOutlet weak var stateButton: UIButton!
  @IBOutlet weak var powerLabel: UILabel!
  @IBOutlet weak var directionLabel: UILabel!
//  var isPresented = true
  var msg = Array(repeating: "0", count: 10)
  let ms = 1000
  var ifStart = true
  
  @IBAction func gyroscope() {
    if ifStart {
      stateButton.setTitle("STOP", for: .normal)
    } else {
      stateButton.setTitle("START", for: .normal)
    }
    
    ifStart = !ifStart
  }
  
  override var shouldAutorotate: Bool {
    return false
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscapeRight
  }
  
  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .landscapeRight
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    ifStart = true

    stateButton.setTitle("START", for: .normal)
    
    serial.delegate = self
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
//    if (self.isMovingFromParentViewController) {
//      UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
//    }
    print("view disappeard")
    msg[0] = "0"
//    serial.sendMessageToDevice(msg.joined())
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
