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
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.isHidden = true
        indicator.style = .large
        indicator.color = UIColor.systemMint
        indicator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let viewModel: NetShoppingViewModelable = NetShoppingViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setSearchBar()
        setIndicator()
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
    
    private func setIndicator() {
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
            indicator.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor),
            indicator.topAnchor.constraint(equalTo: self.tableView.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor)
        ])
    }
    
    private func bindUI() {
        viewModel.showWebViewPublisher
            .sink { [weak self] in
                let webViewController = WebViewController($0)
                self?.present(webViewController, animated: true, completion: nil)
            }
            .store(in: &subscriptions)
        viewModel.onSearchButtonClickedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.view.bringSubviewToFront(self!.indicator)
                $0
                ? self?.indicator.startAnimating()
                : self?.indicator.stopAnimating()
                self?.indicator.isHidden = !$0
            }
            .store(in: &subscriptions)
        viewModel.addToFavoritePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                $0
                ? print("お気に入り追加しました。")
                : print("お気に入り追加済みです。");
                let alert = UIAlertController(title: "お気に入りに追加しました。", message: "", preferredStyle: .alert)
                self?.present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                })
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    @objc func onFavoriteButtonClicked(_ sender: UIButton) {
//        let cell = sender.superview?.superview?.superview?.superview?.superview as! UITableViewCell
//        let indexPath = tableView.indexPath(for: cell)
        print(sender.tag)
        let indexPath = IndexPath(row: sender.tag, section: 0)
        Task { await viewModel.addToFavorites(indexPath) }
    }
}

extension NetShoppingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetShoppingCell", for: indexPath) as! NetShoppingTableViewCell
        cell.favoriteButton.addTarget(self, action: #selector(onFavoriteButtonClicked(_:)), for: .touchUpInside)
        cell.favoriteButton.tag = indexPath.row
        cell.render(product: viewModel.products[indexPath.row])
//        cell.render(viewModel: viewModel, indexPath: indexPath)
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
        Task { await viewModel.handleSearchButtonClicked(query: searchBar.text) }
    }
}
