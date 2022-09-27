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
        let viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        let cellData: Driver<[IssuesTableCell.Data]>
        let errorMsg: Signal<String>
    }
    
    func transform(input: Input) -> Output {
        let cellData = PublishRelay<[IssuesTableCell.Data]>()
        let errorMsg = PublishSubject<String>()
        
        let result = input.viewWillAppear
            .map { _ in () }
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
            errorMsg: errorMsg.asSignal(onErrorSignalWith: .empty())
        )
    }
}
