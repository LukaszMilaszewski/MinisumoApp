import UIKit
import CoreBluetooth
import QuartzCore

final class InitialViewController: UIViewController, UITextFieldDelegate, BluetoothSerialDelegate {
  
  //MARK: IBOutlets
  
  @IBOutlet weak var navItem: UINavigationItem!
  @IBOutlet weak var instructionLabel: UILabel!
  @IBOutlet weak var searchButton: UIButton!
  
  //MARK: Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // init serial
    serial = BluetoothSerial(delegate: self)
    
    // UI
    reloadView()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  func reloadView() {
    // in case we're the visible view again
    serial.delegate = self
    
    if serial.isReady {
      navItem.title = serial.connectedPeripheral!.name
      searchButton.setTitle("Disconnect", for: .normal)
      searchButton.tintColor = UIColor.red
      searchButton.isEnabled = true
    } else if serial.centralManager.state == .poweredOn {
      navItem.title = "Bluetooth Serial"
      searchButton.setTitle("Connect", for: .normal)
      searchButton.tintColor = view.tintColor
      searchButton.isEnabled = true
    } else {
      navItem.title = "Bluetooth Serial"
      searchButton.setTitle("Connect", for: .normal)
      searchButton.tintColor = view.tintColor
      searchButton.isEnabled = false
    }
  }
  
  //MARK: BluetoothSerialDelegate
  
  
  func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
    reloadView()
  }
  
  func serialDidChangeState() {
    reloadView()
  }
  
  //MARK: IBActions
  
  @IBAction func SearchDevice(_ sender: AnyObject) {
    if serial.connectedPeripheral == nil {
      performSegue(withIdentifier: "ShowScanner", sender: self)
    } else {
      serial.disconnect()
      reloadView()
    }
  }
}
