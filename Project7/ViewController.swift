//
//  ViewController.swift
//  Project7
//
//  Created by Hua Son Tung on 11/12/2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Navigation bar
        self.navigationItem.title = "Petitions"
        
        let creditButton = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(showCredit))
        navigationItem.rightBarButtonItem = creditButton
        
        let searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(findPetition))
        navigationItem.leftBarButtonItem = searchButton
        
        //Fetch data
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                //We're ok to parse
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed. Please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    @objc func showCredit() {
        let ac = UIAlertController(title: "The data comes from \"We The People API of the Whitehouse\"", message: nil, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(confirmButton)
        present(ac, animated: true, completion: nil)
    }
    
    @objc func findPetition() {
        let ac = UIAlertController(title: "Find petition", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        
        let submitButton = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let filteredString = ac?.textFields?[0].text else { return }
            self?.filteredPetitions = [Petition]()
            
            for petition in self!.petitions {
                if petition.title.contains(filteredString) {
                    self!.filteredPetitions.append(petition)
                }
            }
            
            print("FilteredPetitions.count = \(self!.filteredPetitions.count)")
            
            if self!.filteredPetitions.count == 0 {
                self?.filteredPetitions = self!.petitions
                
                let noInfoAC = UIAlertController(title: "Not found", message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                noInfoAC.addAction(okButton)
                self?.present(noInfoAC, animated: true, completion: nil)
            }
            
            self?.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(submitButton)
        ac.addAction(cancelButton)
        present(ac, animated: true, completion: nil)
    }

    //MARK: -Tableview Datasource
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

