//
//  ViewController.swift
//  GCDSampleBruteForce
//
//  Created by Sultan on 17.08.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private var password = ""
    private let queue = DispatchQueue.global(qos: .background)
    private var workItem: DispatchWorkItem?
    private var continueTask = true

    // MARK: - UI

    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityView.color = .white
        return activityView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.clearsOnInsertion = true
        textField.setLeftIcon(UIImage(systemName: "lock.square")!)
        textField.setRightPadding(10.0)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 20
        return textField
    }()

    private lazy var generatePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(generatePassword), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.42, green: 0.45, blue: 0.81, alpha: 1.00)
        button.clipsToBounds = true
        button.layer.cornerRadius = 18
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        return button
    }()

    private lazy var bruteForceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("BruteForce", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(brutePassword), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.42, green: 0.45, blue: 0.81, alpha: 1.00)
        button.clipsToBounds = true
        button.layer.cornerRadius = 18
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        return button
    }()

    private lazy var bruteControlButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stop brute", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(stopBrute), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.42, green: 0.45, blue: 0.81, alpha: 1.00)
        button.clipsToBounds = true
        button.layer.cornerRadius = 18
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        button.isHidden = true
        return button
    }()

    private lazy var bruteLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .green
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupHierarchy()
    }

    // MARK: - Setup

    func setupViews(){
        view.backgroundColor = .black
        view.addSubview(label)
        view.addSubview(passwordTextField)
        view.addSubview(generatePasswordButton)
        view.addSubview(bruteForceButton)
        view.addSubview(activityView)
        view.addSubview(bruteLabel)
        view.addSubview(bruteControlButton)
    }

    func setupHierarchy(){
        label.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(180)
            make.centerX.equalToSuperview()
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(40)
        }
        activityView.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField.snp.top).offset(10)
            make.leading.equalTo(passwordTextField.snp.trailing).offset(10)
        }
        generatePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(35)
        }
        bruteForceButton.snp.makeConstraints { make in
            make.top.equalTo(generatePasswordButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
        bruteLabel.snp.makeConstraints { make in
            make.top.equalTo(bruteForceButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        bruteControlButton.snp.makeConstraints { make in
            make.top.equalTo(bruteLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(35)
        }
    }

    //MARK: - Action

    @objc func generatePassword() {
        password = ""
        passwordTextField.text = ""
        passwordTextField.isSecureTextEntry = true
        var passwordLength = 4
        let chars: [Character] = String().digitsAndLetters.map { Character(extendedGraphemeClusterLiteral: $0) }
        repeat {
            password.append(chars[Int.random(in: 0..<chars.count)])
            passwordLength -= 1
        } while passwordLength > 0
        passwordTextField.insertText(password)
    }

    @objc func brutePassword() {
        continueTask = true
        let passwordToBrute = passwordTextField.text ?? ""
        activityView.startAnimating()
        bruteControlButton.isHidden = false
        label.text = ""
        workItem = DispatchWorkItem {
            self.bruteForce(passwordToUnlock: passwordToBrute)
            if self.continueTask {
                DispatchQueue.main.sync {
                    self.label.text = passwordToBrute
                    self.passwordTextField.isSecureTextEntry = false
                    self.activityView.stopAnimating()
                    self.bruteControlButton.isHidden = true
                }
            }
        }
        queue.async(execute: workItem!)
    }

    @objc func stopBrute() {
        continueTask = false
        workItem?.cancel()
        label.text = "Password not cracked: \(passwordTextField.text ?? password)"
        activityView.stopAnimating()
        bruteControlButton.isHidden = true
    }

    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().digitsAndLetters.map { String($0) }
        var password: String = ""
        while continueTask && password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            DispatchQueue.main.sync {
                self.bruteLabel.text = password
            }
        }
    }

}
