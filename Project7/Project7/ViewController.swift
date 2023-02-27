
import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterByString))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(restorePetitions))
        title = "Petitions"
        navigationController?.navigationBar.prefersLargeTitles = true
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
            }else{
                print("could not fetch")
            }
        }
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        print(json.index(before: 1))
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }else{
            print("could not parse")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    @objc func showCredits(){
        let ac = UIAlertController(title: "Credits", message: "Data Source: We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterByString(){
        let ac = UIAlertController(title: "Word to match", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Search", style: .default){ [weak self, weak ac] action in
            guard let stringToMatch = ac?.textFields?[0].text else {return}
            self?.submit(stringToMatch)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ text: String){
        filteredPetitions = petitions.filter { petition in
            return petition.title.contains(text) || petition.body.contains(text)
        }
        tableView.reloadData()
    }
    
    @objc func restorePetitions(){
        filteredPetitions = petitions
        tableView.reloadData()
    }
    


}

