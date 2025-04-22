//
//  ViewController.swift
//  project7
//
//  Created by cxq on 2025/4/22.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filterPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString: String
        let button1 = UIBarButtonItem(title: "credit",style: .plain, target: self, action: #selector(credits))
        let button2 = UIBarButtonItem(title: "filter", style: .plain, target: self, action: #selector(dataFilter))
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 10
        navigationItem.rightBarButtonItems = [button1,spacer,button2]
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }

        showError()
    }
    
    @objc func dataFilter(){
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default){[weak self,weak ac]action in
            guard let searchMes = ac?.textFields?[0].text else{
                return
            }
            self?.confirm(searchMes)
        }
        ac.addAction(confirmAction)
        present(ac,animated: true)
    }
    
    @objc func credits(){
        let ac = UIAlertController(title: "Warn", message: "the data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPetitions.isEmpty ? petitions.count : filterPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let petition = filterPetitions.isEmpty ? petitions[indexPath.row] : filterPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func confirm(_ searchMes:String){
        filterPetitions = petitions.filter{petition in
            return petition.body.lowercased().contains(searchMes.lowercased()) || petition.title.lowercased().contains(searchMes.lowercased()) || petition.signatureCount.description.lowercased().contains(searchMes.lowercased())
        }
        tableView.reloadData()
    }
}

