//
//  BannerTableCell.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import UIKit
import Kingfisher

class BannerTableCell: UITableViewCell {
    private let bannerImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(bannerImageView)
        bannerImageView.do {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.height.equalTo(44)
            }
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func setContent(_ issue: IssueData) {
        guard let url = URL(string: issue.image) else { return }
        bannerImageView.kf.setImage(with: url)
    }
}
