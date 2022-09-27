//
//  IssuesService.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import Foundation
import RxSwift

protocol IssuesServiceProtocol {
    func getIssueList() -> Observable<Result<[Issues], NetworkError>>
    func getIssuesModel(_ result: Result<[Issues], NetworkError>) -> [IssuesTableCell.Data]?
    func getIssuesError(_ result: Result<[Issues], NetworkError>) -> String?
}

struct IssuesService: IssuesServiceProtocol {
    private let issuesNetwork: IssuesNetworkProtocol
    
    init(issuesNetwork: IssuesNetworkProtocol = IssuesNetwork()) {
        self.issuesNetwork = issuesNetwork
    }
    
    func getIssueList() -> Observable<Result<[Issues], NetworkError>> {
        return issuesNetwork.fetchData()
    }
    
    func getIssuesModel(_ result: Result<[Issues], NetworkError>) -> [IssuesTableCell.Data]? {
        guard case .success(let issues) = result else {
            return nil
        }
        return issues.map { (number: $0.number ?? 0,
                             title: $0.title ?? "") }
    }
    
    func getIssuesError(_ result: Result<[Issues], NetworkError>) -> String? {
        guard case .failure(let error) = result else {
            return nil
        }
        return error.message
    }
}
