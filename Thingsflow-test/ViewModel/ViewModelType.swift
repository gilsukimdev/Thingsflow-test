//
//  ViewModelType.swift
//  Thingsflow-test
//
//  Created by 김길수 on 2022/09/27.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
        
    var disposeBag: DisposeBag { get set }
    func transform(input: Input) -> Output
}
