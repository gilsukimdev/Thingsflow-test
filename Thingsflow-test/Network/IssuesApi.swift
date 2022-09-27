//
//  IssuesApi.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import Foundation

struct IssuesApi {
//https://api.github.com/repos/apple/swift/issues
    private let scheme = "https"
    private let host = "api.github.com"
    private let path = "/repos/apple/swift/issues"
    
    func makeGetIussuesComponets() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        return components
    }
}
