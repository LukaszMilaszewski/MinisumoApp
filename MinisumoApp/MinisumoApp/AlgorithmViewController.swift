import UIKit
import CoreBluetooth

class AlgorithmViewController: UIViewController, UIScrollViewDelegate, BluetoothSerialDelegate {
  
  var algorithms = [Algorithm]()
  
  var msg = Array(repeating: "0", count: 10)
  let ms = 1000
  
  var competitionStatesArray: [String] = []
  var speedsArray: [String] = []

  
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    msg[0] = "1"
    let numberOfAlgorithms = 4
    
    competitionStatesArray = Array(repeating: "0", count: numberOfAlgorithms)
    speedsArray = Array(repeating: "0", count: numberOfAlgorithms * 2)
    
  	pageControl.numberOfPages = numberOfAlgorithms
    pageControl.currentPage = 0
  	
    let alg1 = Algorithm()
    alg1.description = "algorithm 1"
    alg1.videoName = "alg1"
    algorithms.append(alg1)
    
    let alg2 = Algorithm()
    alg2.description = "algorithm 2"
    alg2.videoName = "alg2"
    algorithms.append(alg2)
    
    let alg3 = Algorithm()
    alg3.description = "algorithm 3"
    alg3.videoName = "alg3"
    algorithms.append(alg3)
    
    let alg4 = Algorithm()
    alg4.description = "algorithm 4"
    alg4.videoName = "alg4"
    algorithms.append(alg4)
    
    scrollView.isPagingEnabled = true
    scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(algorithms.count), height: 450)
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.delegate = self
  	loadAlgorithms()
    hideKeyboard()
  }
  
  func hideKeyboard() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let page = scrollView.contentOffset.x / scrollView.frame.size.width
    pageControl.currentPage = Int(page)
  }
  
  @IBAction func pageChanged(_ sender: UIPageControl) {
    UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
    	self.scrollView.contentOffset = CGPoint(x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0)
    }, completion: nil)
  }
  
  func buttonClick(sender: UIButton) {
    if sender.title(for: .normal) == "START" {
      msg[0] = "1"
      sender.setTitle("STOP", for: .normal)
    } else {
      msg[0] = "0"
      sender.setTitle("START", for: .normal)
    }
    
    print("------------------------------")
    print("competitions: \(competitionStatesArray.joined())")
    print("speeds: \(speedsArray.joined())")
    
    let whichAlgorithm = sender.tag
    msg[1] = String(describing: whichAlgorithm)
    msg[2] = competitionStatesArray[whichAlgorithm]
    msg[3] = speedsArray[2 * whichAlgorithm]
    msg[4] = speedsArray[2 * whichAlgorithm + 1]
    
    print("MESSAGE: \(msg.joined())")
    serial.sendMessageToDevice(msg.joined())
  }
  
  func competitionSwitched(sender: UISwitch) {
    competitionStatesArray[sender.tag] = String(describing: NSNumber(value: sender.isOn))
  }
  
  func speedFieldText(sender: UITextField) {
    let index = 2 * sender.tag
    var value = Int(sender.text!)
    if value! > 99 { value = 99 }
    speedsArray[index] = String(describing: value! / 10)
    speedsArray[index+1] = String(describing: value! % 10)
  }
  
  func loadAlgorithms() {
    for (index, algorithm) in algorithms.enumerated() {
      if let algorithmView = Bundle.main.loadNibNamed("AlgorithmView", owner: self, options: nil)?.first as? AlgorithmView {
        algorithmView.descriptionLabel.text = algorithm.description
        let video = UIImage.gifImageWithName(algorithm.videoName)
        let imageView = UIImageView(image: video)
        imageView.frame = CGRect(x: 16, y: 20, width: 288, height: 128)
        algorithmView.addSubview(imageView)
        algorithmView.stateButton.tag = index
        algorithmView.stateButton.addTarget(self, action: #selector(AlgorithmViewController.buttonClick(sender:)), for: .touchUpInside)
        algorithmView.competitionSwitch.tag = index
        algorithmView.competitionSwitch.addTarget(self, action: #selector(AlgorithmViewController.competitionSwitched(sender:)), for: .touchUpInside)
        algorithmView.speedField.tag = index
        algorithmView.speedField.addTarget(self, action: #selector(AlgorithmViewController.speedFieldText(sender:)), for: .editingDidEnd)
       
        scrollView.addSubview(algorithmView)
        algorithmView.frame.size.width = self.view.bounds.size.width
        algorithmView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
      }
    }
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
