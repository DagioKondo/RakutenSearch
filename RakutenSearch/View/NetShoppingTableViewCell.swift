//
//  NetShoppingTableViewCell.swift
//  Searchers
//
//  Created by 近藤大伍 on 2023/02/13.
//

import UIKit

class NetShoppingTableViewCell: UITableViewCell {
    private lazy var productImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "applelogo")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "テストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテスト"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
//        button.backgroundColor = .red
        button.tintColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 23.0)
        label.text = "￥100,000"
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var valuationImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star.fill")
        view.contentMode = .scaleAspectFit
//        view.backgroundColor = .black
        view.tintColor = .systemYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var valuationLabel: UILabel = {
        let label = UILabel()
        label.text = "3.8"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let containerHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.alignment = .top
        view.axis = .horizontal
        return view
    }()

    private let detailAreaVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    private let valuationHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private let priceHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        self.contentView.addSubview(containerHorizontalStackView)

        containerHorizontalStackView.addArrangedSubview(productImageView)
        containerHorizontalStackView.addArrangedSubview(SpacerView(type: .width(6))) // imageと商品詳細エリアの距離
        containerHorizontalStackView.addArrangedSubview(detailAreaVerticalStackView)
        containerHorizontalStackView.addArrangedSubview(SpacerView(type: .width(6))) // 全体のstackViewの左端と商品詳細エリアの左端の距離

        detailAreaVerticalStackView.addArrangedSubview(SpacerView(type: .height(16))) // titleLabelとtopの距離
        detailAreaVerticalStackView.addArrangedSubview(titleLabel)
        detailAreaVerticalStackView.addArrangedSubview(SpacerView(type: .height(16))) // titleLabelと評価の距離
        detailAreaVerticalStackView.addArrangedSubview(valuationHorizontalStackView)
        detailAreaVerticalStackView.addArrangedSubview(SpacerView(type: .height(6))) // 評価と値段の距離
        detailAreaVerticalStackView.addArrangedSubview(priceHorizontalStackView)

        valuationHorizontalStackView.addArrangedSubview(valuationImageView)
        valuationHorizontalStackView.addArrangedSubview(valuationLabel)
        valuationHorizontalStackView.addArrangedSubview(SpacerView(type: .noConstraint))

        priceHorizontalStackView.addArrangedSubview(priceLabel)
        priceHorizontalStackView.addArrangedSubview(favoriteButton)

        NSLayoutConstraint.activate([
            containerHorizontalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            containerHorizontalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            containerHorizontalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            containerHorizontalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            productImageView.widthAnchor.constraint(equalToConstant: 150),
            productImageView.heightAnchor.constraint(equalToConstant: 150),
            valuationImageView.widthAnchor.constraint(equalToConstant: 20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
