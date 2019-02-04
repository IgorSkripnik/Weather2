//
//  ViewController.swift
//  WeatyerApp
//
//  Created by Igor Skripnik on 18.12.2018.
//  Copyright © 2018 garik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
    }
}


extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let urlString = "https://api.apixu.com/v1/current.json?key=e56c9c4bb2044c81a63165638181812&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))"
        
        let url = URL(string: urlString)
        
        var locationName: String?
        var temperature: Double?
        var errorHasOccured: Bool = false
        
        
        let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                if let _ = json["error"] {
                    errorHasOccured = true
                }
                
                if let location = json["location"] {
                    locationName = location["name"] as? String
                }
                
                if let current = json["current"] {
                    temperature = current["temp_c"] as? Double
                }
                
                DispatchQueue.main.async {
                    if errorHasOccured {
                        
                        self?.cityLabel.text = "error has occured"
                        self?.tempLabel.isHidden = true
                        
                    } else {
                        
                        self?.cityLabel.text = locationName
                        self?.tempLabel.text = "\(temperature!)"
                        self?.tempLabel.isHidden = false
                    }
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
    
}

