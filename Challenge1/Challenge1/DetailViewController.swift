import UIKit
import AVFoundation

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var currentImage = 0
    var totalImages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = selectedImage?.uppercased().components(separatedBy: "@")[0]
        // Do any additional setup after loading the view.
        
        if let imageToLoad = selectedImage {
            
            imageView.layer.borderColor = CGColor(gray: 0.2, alpha: 1)
            imageView.layer.borderWidth = 2
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
