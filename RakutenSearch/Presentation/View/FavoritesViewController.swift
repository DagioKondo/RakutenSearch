//
//  FavoritesViewController.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/04/09.
//

import UIKit
import Combine

final class FavoritesViewController: UIViewController {
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.reuseIdentifier)
        view.estimatedRowHeight = 100
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private var favoriteProducts = [FavProduct]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let viewModel: FavoritesViewModelable = FavoritesViewModel()
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
    
    override func viewWillAppear(_ animated: Bool) {
        Task { await viewModel.willAppear() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBar()
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
    
    private func setNavigationBar() {
        self.navigationItem.title = "お気に入り"
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
//        viewModel.addToFavoritePublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] in
//                $0
//                ? print("お気に入り追加しました。")
//                : print("お気に入り追加済みです。");
//                let alert = UIAlertController(title: "お気に入りに追加しました。", message: "", preferredStyle: .alert)
//                self?.present(alert, animated: true, completion: {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                        alert.dismiss(animated: true, completion: nil)
//                    }
//                })
//                self?.tableView.reloadData()
//            }
//            .store(in: &subscriptions)
        viewModel.favoriteProductsPublisher
            .receive(on: DispatchQueue.main)
            .sink { favProducts in
                self.favoriteProducts = favProducts
            }
            .store(in: &subscriptions)
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.reuseIdentifier, for: indexPath) as! FavoritesCell
        cell.render(viewModel: viewModel, indexPath: indexPath, product: favoriteProducts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Task { await viewModel.deleteProduct(indexPath) }
        }
    }
}
