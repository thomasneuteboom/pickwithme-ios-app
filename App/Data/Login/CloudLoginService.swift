//
//  CloudLoginService.swift
//  PickWithMe
//
//  Created by Thomas Neuteboom on 23/03/2020.
//  Copyright © 2020 The App Capital. All rights reserved.
//

import RxSwift

class CloudLoginService: LoginService {
    
    /// Login with e-mail and password.
    ///
    /// - Parameters:
    ///   - email: The e-mail to login.
    ///   - password: The password to login.
    /// - Returns: An observable object containing a boolean that determines if the
    /// user was logged in succesfully, otherwise an emitted error.
    func login(email: String, password: String) -> Single<Bool>
    {
        let isCorrectCombination =
            email == "thomasneuteboom@theappcapital.com" &&
            password == "secret"
        
        // Return a one second delayed observable that 'just' emits
        // a boolean that tells us whether the combination was correct or not.
        return Single.just(isCorrectCombination)
            .delay(.seconds(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
}
