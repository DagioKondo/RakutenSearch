//
//  FavoritesTableViewCell.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/04/14.
//

import UIKit
import Combine

final class FavoritesCell: UITableViewCell {
    static let reuseIdentifier = "FavoritesCell"
    private let productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private let favoriteButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.imageView?.contentMode = .scaleAspectFit
//        button.setImage(UIImage(systemName: "heart"), for: .normal)
//        button.tintColor = .red
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 23.0)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valuationImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star.fill")
        view.contentMode = .scaleAspectFit
        view.tintColor = .systemYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let valuationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 全体のstackView
    private let containerHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.alignment = .top
        view.axis = .horizontal
        return view
    }()
    
    private let productImageVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    // 商品詳細エリア
    private let detailAreaVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    // 評価を表示するエリア
    private let valuationHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    // 金額とお気に入りボタンを表示するエリア
    private let priceHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private var viewModel: FavoritesViewModelable?
    private var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        favoriteButton.addTarget(self, action: #selector(onFavoriteButtonClicked(_:)), for: .touchUpInside)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        self.contentView.addSubview(containerHorizontalStackView)

        containerHorizontalStackView.addArrangedSubview(productImageVerticalStackView)
        containerHorizontalStackView.addArrangedSubview(SpacerView(type: .width(6))) // imageと商品詳細エリアの距離
        containerHorizontalStackView.addArrangedSubview(detailAreaVerticalStackView)
        containerHorizontalStackView.addArrangedSubview(SpacerView(type: .width(6))) // 全体のstackViewの左端と商品詳細エリアの左端の距離
        
        productImageVerticalStackView.addArrangedSubview(SpacerView(type: .height(8)))
        productImageVerticalStackView.addArrangedSubview(productImageView)

        detailAreaVerticalStackView.addArrangedSubview(SpacerView(type: .height(8))) // titleLabelとtopの距離
        detailAreaVerticalStackView.addArrangedSubview(titleLabel)
        detailAreaVerticalStackView.addArrangedSubview(SpacerView(type: .height(16))) // titleLabelと評価の距離
        detailAreaVerticalStackView.addArrangedSubview(valuationHorizontalStackView)
        detailAreaVerticalStackView.addArrangedSubview(SpacerView(type: .height(6))) // 評価と値段の距離
        detailAreaVerticalStackView.addArrangedSubview(priceHorizontalStackView)

        valuationHorizontalStackView.addArrangedSubview(valuationImageView)
        valuationHorizontalStackView.addArrangedSubview(valuationLabel)
        valuationHorizontalStackView.addArrangedSubview(SpacerView(type: .noConstraint))

        priceHorizontalStackView.addArrangedSubview(priceLabel)
//        priceHorizontalStackView.addArrangedSubview(favoriteButton)

        NSLayoutConstraint.activate([
            containerHorizontalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4),
            containerHorizontalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4),
            containerHorizontalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            containerHorizontalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            productImageView.widthAnchor.constraint(equalToConstant: 140),
            productImageView.heightAnchor.constraint(equalToConstant: 140),
            valuationImageView.widthAnchor.constraint(equalToConstant: 20),
//            favoriteButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
//
//    func render(product: Product) {
//        let itemName = product.item.name
//        let itemPrice = product.item.price
//        let imageUrl = product.item.imageUrls[0]
//        let itemReviewAverage = product.item.reviewAverage
//        titleLabel.text = itemName
//        priceLabel.text = "￥" + String(itemPrice)
//        productImageView.image = UIImage.getImageByUrl(url: imageUrl)
//        valuationLabel.text = String(itemReviewAverage)
//        favoriteButton.setImage(UIImage(systemName: product.item.favProductImage), for: .normal)
//    }
    
    func render(viewModel: FavoritesViewModelable, indexPath: IndexPath, product: FavProduct) {
        self.viewModel = viewModel
        self.indexPath = indexPath
        let product = product
        let itemPrice = product.price
        let itemReviewAverage = product.reviewAverage
        guard let itemName = product.name,
              let imageUrl = product.imageUrl
        else { return }
        titleLabel.text = itemName
        priceLabel.text = "￥" + String(itemPrice)
        productImageView.image = UIImage.getImageByUrl(url: imageUrl)
        valuationLabel.text = String(itemReviewAverage)
//        favoriteButton.tag = indexPath.row
//        favoriteButton.setImage(UIImage(systemName: product.favProductImage), for: .normal)
    }
    
//    @objc func onFavoriteButtonClicked(_ sender: UIButton) {
//        //        let cell = sender.superview?.superview?.superview?.superview?.superview as! UITableViewCell
//        //        let indexPath = tableView.indexPath(for: cell)
//        print(sender.tag)
//        let indexPath = IndexPath(row: sender.tag, section: indexPath!.section)
//        Task { await self.viewModel?.onFavoriteButtonClicked(indexPath) }
//    }
}

