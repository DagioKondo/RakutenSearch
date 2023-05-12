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
    
    private var products = [Product]() {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        setIndicator()
        bindUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setSearchBar()
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
        self.navigationItem.titleView = searchBar
        if let navigationController = self.navigationController {
            searchBar.frame = navigationController.navigationBar.bounds
            searchBar.delegate = self
        }
    }
    
    private func setIndicator() {
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
//            indicator.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor),
//            indicator.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
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
//                $0
//                ? print("お気に入り追加しました。")
//                : print("お気に入り追加済みです。");
                let alert = UIAlertController(title: "お気に入りに追加しました。", message: "", preferredStyle: .alert)
                self?.present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                })
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
        viewModel.productsPublisher
            .receive(on: DispatchQueue.main)
            .sink { products in
                self.products = products
            }
            .store(in: &subscriptions)
    }
}

extension NetShoppingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetShoppingCell", for: indexPath) as! NetShoppingTableViewCell
        cell.render(viewModel: viewModel, indexPath: indexPath, product: self.products[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath)
    }
}

extension NetShoppingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            // ここで次のページを読み込む処理を実行する
            
        }
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
        Task { await viewModel.onSearchButtonClicked(query: searchBar.text) }
    }
}
