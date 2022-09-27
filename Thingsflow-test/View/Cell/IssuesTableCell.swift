//
//  IssuesTableCell.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import UIKit
import SnapKit
import Then

class IssuesTableCell: UITableViewCell {
    typealias Data = (number: Int, title: String)
    
    private let issuesLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(issuesLabel)
        issuesLabel.do {
            $0.font = .systemFont(ofSize: 16)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalTo(16)
                $0.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(44)
            }
        }
    }
    
    func setContent(_ issue: Data) {
        issuesLabel.text = "\(issue.number) - \(issue.title)"
    }
}
