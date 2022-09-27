//
//  IssuesService.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import Foundation
import RxSwift

protocol IssuesServiceProtocol {
    func getIssuesModel(_ result: Result<[Issues], NetworkError>) -> [Issues]?
    func getIssuesError(_ result: Result<[Issues], NetworkError>) -> String?
}

struct ISssuesService: IssuesServiceProtocol {
    private let issuesNetwork: IssuesNetworkProtocol
    
    init(issuesNetwork: IssuesNetworkProtocol = IssuesNetwork()) {
        self.issuesNetwork = issuesNetwork
    }
    
    func getIssueList() -> Observable<Result<[Issues], NetworkError>> {
        return issuesNetwork.fetchData()
    }
    
    func getIssuesModel(_ result: Result<[Issues], NetworkError>) -> [Issues]? {
        guard case .success(let issues) = result else {
            return nil
        }
        return issues
    }
    
    func getIssuesError(_ result: Result<[Issues], NetworkError>) -> String? {
        guard case .failure(let error) = result else {
            return nil
        }
        return error.message
    }
}
