//
//  SpacerView.swift
//  RakutenSearch
//
//  Created by 山口誠士 on 2023/02/19.
//

import UIKit

enum SpacerViewConstraintType {
    case height(CGFloat)
    case width(CGFloat)
    case noConstraint
}

final class SpacerView: UIView {
    init(type: SpacerViewConstraintType) {
        super.init(frame: .zero)
        setConstraint(type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setConstraint(type: SpacerViewConstraintType) {
        translatesAutoresizingMaskIntoConstraints = false
        switch type {
        case .height(let height):
            NSLayoutConstraint.activate([
                heightAnchor.constraint(equalToConstant: height)
            ])
        case .width(let widht):
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: widht)
            ])
        case .noConstraint:
            break
        }
    }
}
