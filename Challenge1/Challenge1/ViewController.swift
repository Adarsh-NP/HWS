import UIKit

class ViewController: UITableViewController {
    
    var flags = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Flags"
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.contains("3x"){
                flags.append(item)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flags", for: indexPath)
        cell.textLabel?.text = flags[indexPath.row].uppercased().components(separatedBy: "@")[0]
        cell.imageView?.image = UIImage(contentsOfFile: flags[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FlagImages") as? DetailViewController {
            vc.selectedImage = flags[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

