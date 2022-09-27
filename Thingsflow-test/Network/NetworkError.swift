//
//  NetworkError.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import Foundation

enum NetworkError: Error {
    case invalidJSON
    case invalidURL
    case notExistData
    case unknown
    
    var message: String? {
        switch self {
        case .invalidJSON:
            return "데이터를 불러오는데 실패하였습니다."
        case .invalidURL:
            return "유효하지 않은 URL 입니다."
        case .notExistData:
            return "데이터가 없습니다."
        case .unknown:
            return "알수없는 에러가 발생했습니다."
        }
    }
}
