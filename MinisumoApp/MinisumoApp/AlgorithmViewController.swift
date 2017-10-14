import UIKit
import CoreBluetooth

class AlgorithmViewController: UIViewController, UIScrollViewDelegate {
  
  var algorithms = [Algorithm]()
  
  let numberOfAlgorithms = 4
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var label: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
  
  func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y != 0 {
      scrollView.contentOffset.y = 0
    }
  }
  
  func buttonClick(sender: UIButton) {
    print(sender.tag)
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
//        algorithmView.backgroundColor = UIColor(colorLiteralRed: (50 * Float(index))/255, green: 2/255, blue: 100/255, alpha: 1)
        
        scrollView.addSubview(algorithmView)
        algorithmView.frame.size.width = self.view.bounds.size.width
        algorithmView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
      }
    }
  }
}
