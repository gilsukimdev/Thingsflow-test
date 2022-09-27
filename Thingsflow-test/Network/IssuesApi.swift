//
//  IssuesApi.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import Foundation

struct IssuesApi {
    private let scheme = "https"
    private let host = "api.github.com"
    private let path = "/repos/query/issues"
    
    func makeGetIussuesComponets(_ query: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path.replacingOccurrences(of: "query", with: query)
        return components
    }
}
