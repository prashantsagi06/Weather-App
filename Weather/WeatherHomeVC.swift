//
//  WeatherHomeVC.swift
//  Weather
//
//  Created by Prashant on 2/22/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class WeatherHomeVC: UIViewController {
    
    fileprivate struct Constants {
        static let kLastUserSearch = "kLastUserSearch"
        static let initialCity = "cupertino"
        static let kRowHeight: CGFloat = 50.0
        static let cellReuseID = "reuse"
    }
    
    var dataSource: [WeatherList] = [WeatherList]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    func setUP() -> Void {
        tableView.estimatedRowHeight = Constants.kRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let savedCity = UserDefaults.standard.value(forKey: Constants.kLastUserSearch) as? String {
            apiCall(savedCity)
            //  Added to demo the functionality for saving last searched city.
            print("Fetch data for previous saved city: \(savedCity)")
        } else {
            // hardCoded for initial data
            apiCall(Constants.initialCity)
        }
    }
    
    func apiCall(_ city: String ) -> Void {
        activityIndicator.startAnimating()
        DataManager().getDataFor(city) { [unowned self](success, response, error) in
            self.activityIndicator.stopAnimating()
            self.dataSource.removeAll()
            if success {
                if let responseData = (response as? WeatherData)?.list {
                    self.dataSource = responseData
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - SearchBar Delegate Methods -

extension WeatherHomeVC: UISearchBarDelegate {
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = nil
        return true
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            searchBar.resignFirstResponder()
            UserDefaults.standard.set(searchBarText, forKey: Constants.kLastUserSearch)
            apiCall(searchBarText)
        }
    }
}

// MARK: - UITableView DataSource Methods -

extension WeatherHomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data: WeatherList = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseID, for: indexPath) as! WeatherCell
        cell.data = data
        return cell
    }
}

