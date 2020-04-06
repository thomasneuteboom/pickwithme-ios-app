//
//  LoginViewController.swift
//  PickWithMe
//
//  Created by Thomas Neuteboom on 23/03/2020.
//  Copyright © 2020 The App Capital. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa

class LoginViewController: UIViewController {
    
    /// Thread safe bag that disposes added disposables.
    private let disposeBag = DisposeBag()
    
    /// The view model of this view controller.
    var viewModel: LoginViewModel!
    
    /// The title label on top of the image at the top of the screen.
    private lazy var titleLabel: UILabel =
    {
        let titleLabel = UILabel()
        titleLabel.text = "Login"
        titleLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        return titleLabel
    }()
    
    /// The subtitle label under the title label.
    private lazy var subtitleLabel: UILabel =
    {
        let subtitleLabel = UILabel()
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
        let attributedString = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedString.length)
        )
        subtitleLabel.attributedText = attributedString
        
        return subtitleLabel
    }()
    
    /// The image view on top above the bottom container view.
    private lazy var topImageView: UIImageView =
    {
        let topImageView = UIImageView()
        topImageView.image = UIImage(named: "login_splash_image")
        topImageView.backgroundColor = UIColor.black
        return topImageView
    }()
    
    /// The white rounded corner container view containing the email
    /// and password textfield as well as the login button.
    private lazy var bottomContainerView: UIView =
    {
        let bottomContainerView = UIView()
        bottomContainerView.backgroundColor = .white
        bottomContainerView.layer.cornerRadius = 16.0
        bottomContainerView.layer.masksToBounds = true
        // Only apply corner radius top-left, top-right.
        bottomContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return bottomContainerView
    }()
    
    /// The e-mail text field where the user can fill in its e-mail to login.
    private lazy var emailTextField: TextField =
    {
        let emailTextField = TextField()
        emailTextField.autocapitalizationType = .none
        emailTextField.layer.cornerRadius = 16.0
        emailTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.textContentType = .emailAddress
        emailTextField.layer.masksToBounds = true
        emailTextField.font = .systemFont(ofSize: 16.0, weight: .regular)
        emailTextField.placeholder = "Fill in your e-mail"
        return emailTextField
    }()
    
    /// The password text field where the user can fill in its password to login.
    private lazy var passwordTextField: TextField =
    {
        let passwordTextField = TextField()
        passwordTextField.layer.cornerRadius = 16.0
        passwordTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.masksToBounds = true
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = .systemFont(ofSize: 16.0, weight: .regular)
        passwordTextField.placeholder = "Fill in your password"
        return passwordTextField
    }()
    
    /// The login button, when tapped it will perform the action to login.
    private lazy var loginButton: UIButton =
    {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.cornerRadius = 16.0
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .medium)
        loginButton.backgroundColor = .black
        loginButton.tintColor = .white
        return loginButton
    }()
    
    /// The indicator that will be shown when logging in the user.
    private lazy var activityIndicator: UIActivityIndicatorView =
    {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    // MARK: - Lifecycle
    
    /// View did load is called after instantiation and outlet-setting.
    ///
    /// This is a good place to put a lot of setup code.
    ///
    /// Important: The geometry of the view (it's bounds) is not set yet, so do not
    /// initia lize things that are geometry-dependent here. Also, the navigation
    /// controller is not yet set here.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.boot()
    }
 
    // MARK: - Boot
    
    /// The default boot method for the controller. This method will be called when
    /// the controller did completed loading its view. Adding views to subviews,
    /// setting variables and such will be done here.
    private func boot()
    {
        self.view.addSubview(self.topImageView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.subtitleLabel)
        self.view.addSubview(self.bottomContainerView)
        
        self.bottomContainerView.addSubview(self.emailTextField)
        self.bottomContainerView.addSubview(self.passwordTextField)
        self.bottomContainerView.addSubview(self.loginButton)
        
        self.loginButton.addSubview(self.activityIndicator)
        
        self.setupViewLayoutConstraints()
        self.setupViewBindings()
    }
    
    /// Setup all the view's layout constraints here.
    private func setupViewLayoutConstraints()
    {
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40.0)
            make.leading.equalTo(self.view).offset(30.0)
            make.trailing.lessThanOrEqualTo(self.view).offset(-30.0)
        }
        
        self.subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10.0)
            make.leading.equalTo(self.view).offset(30.0)
            make.trailing.lessThanOrEqualTo(self.view).offset(-30.0)
        }
        
        self.topImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0.45)
        }
        
        self.bottomContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topImageView.snp.bottom).offset(-20)
            make.leading.trailing.bottom.equalTo(self.view)
        }
        
        self.emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomContainerView).offset(20)
            make.width.equalTo(self.bottomContainerView).offset(-30)
            make.centerX.equalTo(self.bottomContainerView)
            make.height.equalTo(50.0)
        }
        
        self.passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.emailTextField.snp.bottom).offset(15.0)
            make.width.equalTo(self.bottomContainerView).offset(-30)
            make.centerX.equalTo(self.bottomContainerView)
            make.height.equalTo(50.0)
        }
        
        self.loginButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.bottomContainerView)
            make.bottom.equalTo(self.bottomContainerView.safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(self.bottomContainerView).offset(-30)
            make.height.equalTo(50.0)
        }
        
        self.activityIndicator.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.loginButton)
            make.trailing.equalTo(self.loginButton).offset(-20)
        }
    }
    
    /// Setup all the view's bindings here.
    private func setupViewBindings()
    {
        // Variable bindings.
        self.emailTextField.rx.text.orEmpty
            .observeOn(MainScheduler.instance)
            .bind(to: self.viewModel.email)
            .disposed(by: self.disposeBag)
        
        self.passwordTextField.rx.text.orEmpty
            .observeOn(MainScheduler.instance)
            .bind(to: self.viewModel.password)
            .disposed(by: self.disposeBag)
        
        self.viewModel.canLogin
            .observeOn(MainScheduler.instance)
            .bind(to: self.loginButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        self.viewModel.isLoading.map { !$0 }
            .observeOn(MainScheduler.instance)
            .bind(to: self.activityIndicator.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        // Actions (from view to view-model).
        self.loginButton.rx.tap
            .observeOn(MainScheduler.instance)
            .bind {
            self.viewModel.onLogin()
        }.disposed(by: self.disposeBag)
        
        // Events (from view-model to view).
        self.viewModel.onSuccessfullyLoggedIn
            .observeOn(MainScheduler.instance)
            .bind { _ in
                print("<LoginViewController> - Successfully logged in.")
            }.disposed(by: self.disposeBag)
        
        self.viewModel.onError
            .observeOn(MainScheduler.instance)
            .bind { errorMessage in
                print("<LoginViewController> - An error occurred: '\(errorMessage)'")
            }.disposed(by: self.disposeBag)
    }

}
