//
//  ViewController.swift
//  Searchers
//
//  Created by 近藤大伍 on 2023/01/31.
//

import UIKit
import Combine

final class NetShoppingViewController: UIViewController {
    enum Section: Int, Hashable, CaseIterable {
        case coupon
        case list
        var description: String {
            switch self {
            case .coupon: return "coupon"
            case .list: return "list"
            }
        }
    }
    
    struct NetShoppingItem: Hashable {
        let coupon: CouponCell?
        let product: NetShoppingCell?
        
        init(coupon: CouponCell? = nil, product: NetShoppingCell? = nil) {
            self.coupon = coupon
            self.product = product
        }
    }
    
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
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, NetShoppingItem>!
    private let viewModel: NetShoppingViewModelable = NetShoppingViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private var isLoading = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshot()
        configureIndicator()
        bindUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSearchBar()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(NetShoppingCell.self, forCellWithReuseIdentifier: NetShoppingCell.reuseIdentifier)
        collectionView.register(CouponCell.self, forCellWithReuseIdentifier: CouponCell.reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, NetShoppingItem>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: NetShoppingItem) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .coupon:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CouponCell.reuseIdentifier, for: indexPath) as? CouponCell
                cell?.render(viewModel: self.viewModel, coupon: self.viewModel.coupons[indexPath.row])
                return cell
            case .list:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NetShoppingCell.reuseIdentifier, for: indexPath) as? NetShoppingCell
                cell?.render(viewModel: self.viewModel, indexPath: indexPath, product: self.viewModel.products[indexPath.row])
                return cell
            }
        }
    }
    
    private func applyInitialSnapshot() {
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, NetShoppingItem>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func applyProductSnapshot() {
        var productSnapshot = NSDiffableDataSourceSectionSnapshot<NetShoppingItem>()
        let netShoppingList = Array(0..<viewModel.products.count).map { _ in NetShoppingItem(product: NetShoppingCell()) }
        productSnapshot.append(netShoppingList)
        dataSource.apply(productSnapshot, to: .list, animatingDifferences: false)
        print("あああ" + "\(viewModel.products.count)")
    }
    
    private func applyCouponSnapshot() {
        var couponSnapshot = NSDiffableDataSourceSectionSnapshot<NetShoppingItem>()
        let couponList = Array(0..<viewModel.coupons.count).map { _ in NetShoppingItem(coupon: CouponCell()) }
        couponSnapshot.append(couponList)
        dataSource.apply(couponSnapshot, to: .coupon, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            if sectionKind == .coupon {
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: size)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalWidth(0.3))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                // outline
            } else if sectionKind == .list {
                section = NSCollectionLayoutSection.list(using: .init(appearance: .sidebar), layoutEnvironment: layoutEnvironment)
            } else {
                fatalError("Unknown section!")
            }
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func configureSearchBar() {
        self.navigationItem.titleView = searchBar
        if let navigationController = self.navigationController {
            searchBar.frame = navigationController.navigationBar.bounds
            searchBar.delegate = self
        }
    }
    
    private func configureIndicator() {
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: self.collectionView.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: self.collectionView.trailingAnchor),
            indicator.topAnchor.constraint(equalTo: self.collectionView.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: self.collectionView.bottomAnchor)
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
                let alert = UIAlertController(title: "お気に入りに追加しました。", message: "", preferredStyle: .alert)
                self?.present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                })
            }
            .store(in: &subscriptions)
        viewModel.productsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.applyProductSnapshot()
            }
            .store(in: &subscriptions)
        viewModel.couponsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.applyCouponSnapshot()
            }
            .store(in: &subscriptions)
    }
}

extension NetShoppingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath)
    }
}

extension NetShoppingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height &&
            contentHeight != 0 &&
            !isLoading {
            isLoading = true
            Task {
                await viewModel.didScrollToBottom()
                isLoading = false
            }
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
        Task { await viewModel.onSearchButtonClicked(keyword: searchBar.text) }
    }
}
