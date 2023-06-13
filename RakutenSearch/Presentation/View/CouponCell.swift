//
//  CouponCell.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/05/15.
//

import UIKit

class CouponCell: UICollectionViewCell {
    static let reuseIdentifier = "number-cell-reuse-identifier"
    
    private let productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 元の価格
    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 割引価格
    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 割引額
    private let discountAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.font = UIFont(name: "Helvetica", size: 24.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let couponLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.text = "OFF クーポン"
        label.font = UIFont(name: "Helvetica", size: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expirationDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.text = "5月22日 15:00まで"
        label.font = UIFont(name: "Helvetica", size: 14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 全体のstackView
    private let containerHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.alignment = .center
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
    
    // クーポン詳細エリア
    private let detailAreaVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    // 割引価格エリア
    private let discountAreaHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(containerHorizontalStackView)
        containerHorizontalStackView.addArrangedSubview(productImageVerticalStackView)
        containerHorizontalStackView.addArrangedSubview(SpacerView(type: .width(4)))
        containerHorizontalStackView.addArrangedSubview(detailAreaVerticalStackView)
        
        //        productImageVerticalStackView.addArrangedSubview(SpacerView(type: .height(4)))
        productImageVerticalStackView.addArrangedSubview(productImageView)
        //        productImageVerticalStackView.addArrangedSubview(SpacerView(type: .height(4)))
        
        detailAreaVerticalStackView.addArrangedSubview(discountAmountLabel)
        detailAreaVerticalStackView.addArrangedSubview(SpacerView(type: .height(2)))
        detailAreaVerticalStackView.addArrangedSubview(couponLabel)
        detailAreaVerticalStackView.addArrangedSubview(SpacerView(type: .height(4)))
        detailAreaVerticalStackView.addArrangedSubview(discountAreaHorizontalStackView)
        detailAreaVerticalStackView.addArrangedSubview(SpacerView(type: .height(4)))
        detailAreaVerticalStackView.addArrangedSubview(expirationDateLabel)
        
        discountAreaHorizontalStackView.addArrangedSubview(originalPriceLabel)
        discountAreaHorizontalStackView.addArrangedSubview(SpacerView(type: .width(4)))
        discountAreaHorizontalStackView.addArrangedSubview(discountedPriceLabel)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowRadius = 8
        contentView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            containerHorizontalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            containerHorizontalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            containerHorizontalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            containerHorizontalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            productImageView.widthAnchor.constraint(equalToConstant: 84),
            productImageView.heightAnchor.constraint(equalToConstant: 84),
        ])
    }
    
    private func formatAmountWithCurrency(amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 0
        let formattedString = formatter.string(from: NSNumber(value: amount)) ?? "--円"
        let text = formattedString + "円"
        return text
    }
    
    func render(viewModel: NetShoppingViewModelable, coupon: Coupon) {
        guard let price = Int(coupon.price),
              let discountAmount = Int(coupon.discountAmount)
        else { return }
        originalPriceLabel.text = formatAmountWithCurrency(amount: price)
        discountAmountLabel.text = formatAmountWithCurrency(amount: discountAmount)
        discountedPriceLabel.text = formatAmountWithCurrency(amount: price - discountAmount)
        productImageView.image = UIImage.getImageByUrl(url: coupon.imageUrl)
        expirationDateLabel.text = coupon.expirationDate + "まで"
        
        // discountAmountLabelの最後の文字を小さくする
        let attributedText = NSMutableAttributedString(string: discountAmountLabel.text ?? "")
        let lastCharacterRange = NSRange(location: (discountAmountLabel.text?.count ?? 1) - 1, length: 1) // 最後の文字の範囲
        let smallFontSize: CGFloat = 16.0 // 小さいフォントサイズ
        let smallFont = UIFont.systemFont(ofSize: smallFontSize) // 小さいフォント
        attributedText.addAttribute(.font, value: smallFont, range: lastCharacterRange)
        discountAmountLabel.attributedText = attributedText
        
        // 打ち消し線を引く
        let attributedString = NSAttributedString(string: originalPriceLabel.text ?? "", attributes: [
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.strikethroughColor: UIColor.gray
        ])
        originalPriceLabel.attributedText = attributedString
    }
}
