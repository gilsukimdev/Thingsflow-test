//
//  IssuesService.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import Foundation
import RxSwift

protocol IssuesServiceProtocol {
    func getIssueList(_ query: String) -> Observable<Result<[Issues], NetworkError>>
    func getIssuesModel(_ result: Result<[Issues], NetworkError>) -> [IssueData]?
    func getIssuesError(_ result: Result<[Issues], NetworkError>) -> String?
}

struct IssuesService: IssuesServiceProtocol {
    
    private let issuesNetwork: IssuesNetworkProtocol
    
    init(issuesNetwork: IssuesNetworkProtocol = IssuesNetwork()) {
        self.issuesNetwork = issuesNetwork
    }
    
    func getIssueList(_ query: String) -> Observable<Result<[Issues], NetworkError>> {
        return issuesNetwork.fetchData(query)
    }
    
    func getIssuesModel(_ result: Result<[Issues], NetworkError>) -> [IssueData]? {
        guard case .success(let issues) = result else {
            return nil
        }

        return combineList(issues.map { IssueData(number: $0.number ?? 0,
                                                  title: $0.title ?? "",
                                                  image: "",
                                                  link: "") })
    }
    
    func getIssuesError(_ result: Result<[Issues], NetworkError>) -> String? {
        guard case .failure(let error) = result else {
            return nil
        }
        return error.message
    }
    
    func combineList(_ issues: [IssueData]) -> [IssueData] {
        // 베너를 넣는 조건이 5번째셀이라는 전제밖에 없어서
        // 무식하지만 직접 밀어넣었습니다.
        var combineIssues = issues
        let image = "https://s3.ap-northeast-2.amazonaws.com/hellobot-kr-test/image/main_logo.png"
        let link = "http://thingsflow.com/ko/home/"
        combineIssues.insert(IssueData(number: 0, title: "", image: image, link: link), at: 4)
        return combineIssues
    }
}
