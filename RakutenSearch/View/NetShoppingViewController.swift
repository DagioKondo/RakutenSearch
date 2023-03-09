//
//  ViewController.swift
//  Searchers
//
//  Created by 近藤大伍 on 2023/01/31.
//

import UIKit
import Combine

final class NetShoppingViewController: UIViewController {
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(NetShoppingTableViewCell.self, forCellReuseIdentifier: "NetShoppingCell")
        view.estimatedRowHeight = 100
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "商品を検索"
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.layer.shadowColor = UIColor.gray.cgColor
        searchBar.searchTextField.layer.shadowOpacity = 0.3
        searchBar.searchTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchBar.searchTextField.layer.masksToBounds = false
        return searchBar
    }()
    
    private let viewModel: NetShoppingViewModelable = NetShoppingViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setSearchBar()
        bindUI()
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setSearchBar() {
        navigationItem.titleView = searchBar
        if let navigationBarFrame = self.navigationController?.navigationBar.bounds {
            searchBar.frame = navigationBarFrame
            searchBar.delegate = self
        }
    }
    
    private func bindUI() {
        viewModel.showWebViewPublisher
            .sink { [weak self] in
                let webViewController = WebViewController($0)
                self?.present(webViewController, animated: true, completion: nil)
            }
            .store(in: &subscriptions)
    }
}

extension NetShoppingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetShoppingCell", for: indexPath) as! NetShoppingTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleDidSelectRowAt(indexPath)
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
