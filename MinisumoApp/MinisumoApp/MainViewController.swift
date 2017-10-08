import UIKit

class MainViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Disconnect", style: .plain, target: self, action: #selector(disconnectDevice))
  }
  
  @IBAction func showGyroscope() {
    
  }
  
  func disconnectDevice() {
    serial.disconnect()
    performSegue(withIdentifier: "DisconnectMain", sender: nil)
  }
}
