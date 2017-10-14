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
    algorithms.append(alg1)
    
    let alg2 = Algorithm()
    alg2.description = "algorithm 2"
    algorithms.append(alg2)
    
    let alg3 = Algorithm()
    alg3.description = "algorithm 3"
    algorithms.append(alg3)
    
    let alg4 = Algorithm()
    alg4.description = "algorithm 4"
    algorithms.append(alg4)
    
    scrollView.isPagingEnabled = true
    scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(algorithms.count), height: 300)
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.delegate = self
  	loadAlgorithms()
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
  
  func loadAlgorithms() {
    for (index, algorithm) in algorithms.enumerated() {
      if let algorithmView = Bundle.main.loadNibNamed("AlgorithmView", owner: self, options: nil)?.first as? AlgorithmView {
        algorithmView.descriptionLabel.text = algorithm.description
        algorithmView.backgroundColor = UIColor(colorLiteralRed: (50 * Float(index))/255, green: 2/255, blue: 100/255, alpha: 1)
        
        scrollView.addSubview(algorithmView)
        algorithmView.frame.size.width = self.view.bounds.size.width
        algorithmView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
      }
    }
  }
}
