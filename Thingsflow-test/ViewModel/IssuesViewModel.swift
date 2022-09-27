//
//  IssuesViewModel.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import Foundation
import RxSwift
import RxCocoa

struct IssuesViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    private let service: IssuesServiceProtocol
    
    init(service: IssuesServiceProtocol = IssuesService()) {
        self.service = service
    }
    
    struct Input {
        let searchText: Observable<String>
    }
    
    struct Output {
        let cellData: Driver<[IssueData]>
        let query: Signal<String>
        let errorMsg: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let cellData = PublishRelay<[IssueData]>()
        let errorMsg = PublishSubject<String>()
        let query = PublishRelay<String>()
        
        input.searchText
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .bind(to: query)
            .disposed(by: disposeBag)
        
        let result = query
            .flatMapLatest(service.getIssueList)
            .share()
        
        result
            .compactMap(service.getIssuesModel)
            .bind(to: cellData)
            .disposed(by: disposeBag)
        
        result
            .compactMap(service.getIssuesError)
            .bind(to: errorMsg)
            .disposed(by: disposeBag)
        
        return Output(
            cellData: cellData.asDriver(onErrorDriveWith: .empty()),
            query: query.asSignal(onErrorSignalWith: .empty()),
            errorMsg: errorMsg.asSignal(onErrorSignalWith: .empty())
        )
    }
}
