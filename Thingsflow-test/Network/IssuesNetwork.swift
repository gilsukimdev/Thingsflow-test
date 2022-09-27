//
//  IssuesNetwork.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import Foundation
import RxSwift
import RxCocoa

protocol IssuesNetworkProtocol {
    func fetchData() -> Observable<Result<[Issues], NetworkError>>
}

final class IssuesNetwork: IssuesNetworkProtocol {
    private let session: URLSession
    private let issuesApi = IssuesApi()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData() -> Observable<Result<[Issues], NetworkError>> {
        guard let url = issuesApi.makeGetIussuesComponets().url else {
            return .just(.failure(.invalidURL))
        }
                
        return session.rx.data(request: URLRequest(url: url))
            .map { data in
                do {
                    let issuesData = try JSONDecoder().decode([Issues].self, from: data)
                    return .success(issuesData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
    }
}
