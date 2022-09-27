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
    var query: String
        
    init(_ viewModel: IssuesViewModel = IssuesViewModel(), query: String? = nil) {
        self.viewModel = viewModel
        self.query = query ?? "apple/swift"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindUI()
        bindViewModel()
    }
}

extension IssuesViewController {
    
    private func bindUI() {
        
        Observable.just(query)
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                owner.searchController.searchBar.text = text
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(IssueData.self)
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                if let linkURL = URL(string: data.link) {
                    UIApplication.shared.open(linkURL)
                } else {
                    let deatilView = DetailViewController()
                    owner.navigationController?.pushViewController(deatilView, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = IssuesViewModel.Input(
            searchText: searchController.searchBar.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.cellData
            .drive(tableView.rx.items) { tv, row, data in
                let indexPath = IndexPath(row: row, section: 0)
                
                if !data.image.isEmpty {
                    let cell = tv.dequeueReusableCell(withIdentifier: String(describing: BannerTableCell.self), for: indexPath) as! BannerTableCell
                    cell.setContent(data)
                    return cell
                }
                
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
            $0.estimatedRowHeight = 44
            $0.register(IssuesTableCell.self, forCellReuseIdentifier: String(describing: IssuesTableCell.self))
            $0.register(BannerTableCell.self, forCellReuseIdentifier: String(describing: BannerTableCell.self))
            $0.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
}
