//
//  LoginService.swift
//  PickWithMe
//
//  Created by Thomas Neuteboom on 23/03/2020.
//  Copyright © 2020 The App Capital. All rights reserved.
//

import RxSwift

protocol LoginService {
    
    /// Login with e-mail and password.
    ///
    /// - Parameters:
    ///   - email: The e-mail to login.
    ///   - password: The password to login.
    /// - Returns: An observable object containing a boolean that determines if the
    /// user was logged in succesfully, otherwise an emitted error.
    func login(email: String, password: String) -> Single<Bool>

}
