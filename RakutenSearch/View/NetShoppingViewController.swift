//
//  ViewController.swift
//  Searchers
//
//  Created by 近藤大伍 on 2023/01/31.
//

import UIKit

class NetShoppingViewController: UIViewController {
    private lazy var netShoppingTableView: UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.delegate = self
        view.dataSource = self
        view.register(NetShoppingTableViewCell.self, forCellReuseIdentifier: "NetShoppingCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let navigationBarFrame = self.navigationController?.navigationBar.bounds
        let searchBar = UISearchBar(frame: navigationBarFrame!)
        searchBar.delegate = self
        searchBar.placeholder = "商品を検索"
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.layer.shadowColor = UIColor.gray.cgColor
        searchBar.searchTextField.layer.shadowOpacity = 0.3
        searchBar.searchTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchBar.searchTextField.layer.masksToBounds = false
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        navigationItem.titleView?.frame = searchBar.frame
        view.addSubview(netShoppingTableView)
    }
}

extension NetShoppingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        netShoppingTableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetShoppingCell", for: indexPath) as! NetShoppingTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetShoppingCell", for: indexPath) as! NetShoppingTableViewCell
    }
}

extension NetShoppingViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {}
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}
