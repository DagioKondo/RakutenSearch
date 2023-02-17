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

    private let stackView1: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.alignment = .fill
        view.axis = .horizontal
//        view.spacing = 10.0
//        view.backgroundColor = .blue
        return view
    }() // large
    
    private let stackView2: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.alignment = .fill
        view.axis = .vertical
//        view.spacing = 10.0
//        view.backgroundColor = .yellow
        return view
    }() // medium
    
    private let stackView3: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.alignment = .fill
        view.axis = .horizontal
//        view.spacing = 10.0
//        view.backgroundColor = .brown
        return view
    }() // small1
    
    private let stackView4: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.alignment = .fill
//        view.spacing = 10.0
//        view.backgroundColor = .cyan
        return view
    }() // small2
    
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
        self.contentView.addSubview(stackView1)
        stackView4.addArrangedSubview(priceLabel)
        stackView4.addArrangedSubview(favoriteButton)
        stackView3.addArrangedSubview(valuationImageView)
        stackView3.addArrangedSubview(valuationLabel)
        stackView2.addArrangedSubview(titleLabel)
        stackView2.addArrangedSubview(stackView3)
        stackView2.addArrangedSubview(stackView4)
        stackView1.addArrangedSubview(productImageView)
        stackView1.addArrangedSubview(stackView2)
        NSLayoutConstraint.activate([
            stackView1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            stackView1.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            stackView1.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            stackView1.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            productImageView.widthAnchor.constraint(equalToConstant: 150),
            productImageView.heightAnchor.constraint(equalToConstant: 150),
            stackView2.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 5),
            stackView2.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalTo: stackView1.heightAnchor, multiplier: 0.5),
            stackView3.heightAnchor.constraint(equalTo: stackView1.heightAnchor, multiplier: 0.2),
            valuationLabel.widthAnchor.constraint(equalToConstant: 30),
            valuationImageView.widthAnchor.constraint(equalToConstant: 20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
