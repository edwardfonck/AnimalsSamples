//
//  HeaderView.swift
//  testing
//
//  Created by Familia Fonseca López on 09/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import Foundation
import UIKit

class HeaderView: UICollectionReusableView {
  static let reuseIdentifier = "header-reuse-identifier"

  let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
}

extension HeaderView {
  func configure() {
    backgroundColor = .clear

    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true

    let inset = CGFloat(10)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
      label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
      label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
    ])
    label.font = UIFont.preferredFont(forTextStyle: .title3)
    label.textColor = .white
  }
}
