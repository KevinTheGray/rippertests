//
//  SquareImageCell.swift
//  rippertest
//
//  Created by Kevin Gray on 7/8/16.
//  Copyright © 2016 posse. All rights reserved.
//

import KitCore
import UIKit
import KitUI
import Ripper

class SquareImageCell : UICollectionViewCell {
  
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  func initialize() {
    self.contentView.backgroundColor = UIColor.clearColor()
    self.contentView.addSubview(imageView)
    configureConstraints()
  }
  
  
  // MARK: - Layout
  func configureConstraints() {
    
    self.contentView.snp_makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    self.imageView.snp_makeConstraints { (make) in
      make.top.equalToSuperview().inset(15.0)
      make.left.equalToSuperview()
      make.right.equalToSuperview().inset(floor(15.0))
      make.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Lazy initialization
  lazy var imageView: UIImageView = {
    var view = UIImageView()
    view.backgroundColor = UIColor(hex: 0xCCCCCC)
    return view
  }()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.imageView.image = nil
  }
  
  
  // MARK: - Util
  static func reuseIdentifier() -> String {
    return "squareImageCell"
  }
}