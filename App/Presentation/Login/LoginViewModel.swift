//
//  LoginViewModel.swift
//  PickWithMe
//
//  Created by Thomas Neuteboom on 23/03/2020.
//  Copyright © 2020 The App Capital. All rights reserved.
//

import RxRelay
import RxSwift
import Foundation
class LoginViewModel {
    
    // MARK: - Model
    
    /// The service (model) we use to login a user with e-mail and password.
    private let loginService: LoginService
    
    // MARK: - State
    
    /// Determines whether is currently loading, default false.
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    /// The current filled in e-mail to login, default "".
    let email = BehaviorRelay<String>(value: "")
    
    /// The current filled in password to login, default "".
    let password = BehaviorRelay<String>(value: "")
    
    /// Determines whether we can login. We will validate if both
    /// e-mail and password are filled. We can use this to disable/enable
    /// a login button for example.
    ///
    /// Note that this is the domain logic I was talking about earlier.
    lazy var canLogin: Observable<Bool> =
    {
        // `combineLatest` combines all sources and emits any time there's a new value from any of them.
        return Observable.combineLatest(
            self.isLoading.asObservable(),
            self.isEmailFilled,
            self.isPasswordFilled
        ).map { isLoading, isEmailFilled, isPasswordFilled in
            return !isLoading &&
                isEmailFilled &&
                isPasswordFilled
        }
    }()
    
    /// Determines whether the e-mail is filled, at least 5 characters (domain logic).
    private lazy var isEmailFilled: Observable<Bool> =
    {
        return self.email.asObservable().map { email in
            return email.trimmingCharacters(in: .whitespacesAndNewlines).count >= 5
        }
    }()
    
    /// Determines whether the password is filled, at least 3 characters (domain logic).
    private lazy var isPasswordFilled: Observable<Bool> =
    {
        return self.password.asObservable().map { password in
            return password.count >= 3
        }
    }()
    
    // MARK: - Events
    
    /// Called whenever a login attempt was successful.
    let onSuccessfullyLoggedIn = PublishRelay<Void>()
    
    /// Called whenever an error occurred, providing an error message.
    let onError = PublishRelay<String>()
    
    // MARK: - Misc
    
    /// Thread safe bag that disposes added disposables.
    private let disposeBag = DisposeBag()
    
    // MARK: - Boot
    
    /// Initialize the `LoginViewModel`.
    ///
    /// - Parameter loginService: The login service that is used to
    /// login a user with e-mail and password.
    init(loginService: LoginService)
    {
        self.loginService = loginService
    }

    // MARK: - Actions
    
    /// Called whenever the user executed login actions,
    /// tapping on a login button for example.
    ///
    /// - Parameters:
    ///   - email: The e-mail to login.
    ///   - password: The password to login.
    func onLogin()
    {
        // 1. Start loading.
        self.isLoading.accept(true)
        
        // 2. Execute login.
        self.loginService.login(email: self.email.value, password: self.password.value)
            .subscribe(onSuccess: { isSuccessfullyLoggedIn in
                // 3. Successfully logged in; stop loading.
                self.isLoading.accept(false)
                
                if isSuccessfullyLoggedIn {
                    self.onSuccessfullyLoggedIn.accept(Void())
                } else {
                    self.onError.accept("Login failed, check if the correct combination was used and try again")
                }
            }
        ).disposed(by: self.disposeBag)
    }
    
}
