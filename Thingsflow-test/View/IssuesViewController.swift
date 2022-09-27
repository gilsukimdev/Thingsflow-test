//
//  IssuesViewController.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxAppState

final class IssuesViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let viewModel: IssuesViewModel
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
        
    init(_ viewModel: IssuesViewModel = IssuesViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
}

extension IssuesViewController {
    private func bind() {
        
        let input = IssuesViewModel.Input(
            viewWillAppear: rx.viewWillAppear.take(1).asObservable(),
            searchText: searchController.searchBar.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.cellData
            .drive(tableView.rx.items) { tv, row, data in
                let indexPath = IndexPath(row: row, section: 0)
                
                let cell = tv.dequeueReusableCell(withIdentifier: String(describing: IssuesTableCell.self), for: indexPath) as! IssuesTableCell
                cell.setContent(data)
                cell.accessoryType = .disclosureIndicator
                return cell
            }
            .disposed(by: disposeBag)
        
        output.query
            .withUnretained(self)
            .emit(onNext: { owner, query in
                self.title = query
            })
            .disposed(by: disposeBag)
        
        output.errorMsg
            .withUnretained(self)
            .emit(onNext: { owner, message in
                self.alert(title: "에러", message: message)
            })
            .disposed(by: disposeBag)
    }
}

extension IssuesViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
        view.addSubview(tableView)
        tableView.do {
            $0.register(IssuesTableCell.self, forCellReuseIdentifier: String(describing: IssuesTableCell.self))
            $0.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
}
