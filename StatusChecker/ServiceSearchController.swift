//
//  ServiceSearchController.swift
//  StatusChecker
//
//  Created by Aurélien Haie on 24/04/2019.
//  Copyright © 2019 Aurélien Haie. All rights reserved.
//

import UIKit
import CoreData

class ServiceSearchController: UITableViewController {
    
    // MARK: - Properties
    
    var services = [ServiceData]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let cellId = "cellId"
    var bottomViewConstraint = NSLayoutConstraint()
    
    // MARK: - View elements
    
    lazy var addServiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add new service", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        button.layer.cornerRadius = 8
        button.backgroundColor = .appBlue
        button.addTarget(self, action: #selector(addNewButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        
        let headerLabel = UILabel()
        headerLabel.text = "New service"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        // setup view
        view.addSubview(headerLabel)
        view.addSubview(nameInput)
        view.addSubview(urlInput)
        view.addSubview(checkButton)
        
        headerLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        nameInput.anchor(top: headerLabel.bottomAnchor, left: headerLabel.leftAnchor, bottom: nil, right: headerLabel.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 44)
        urlInput.anchor(top: nameInput.bottomAnchor, left: nameInput.leftAnchor, bottom: nil, right: nameInput.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 44)
        checkButton.anchor(top: urlInput.bottomAnchor, left: urlInput.leftAnchor, bottom: view.bottomAnchor, right: urlInput.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 0, height: 44)
        
        return view
    }()
    
    lazy var nameInput: TextField = {
        let tf = TextField(withPlaceholder: "Name")
        tf.addTarget(self, action: #selector(isFormValid), for: .editingChanged)
        return tf
    }()
    
    lazy var urlInput: TextField = {
        let tf = TextField(withPlaceholder: "URL")
        tf.addTarget(self, action: #selector(isFormValid), for: .editingChanged)
        return tf
    }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appGreen
        button.setTitle("Check service", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(createNewService), for: .touchUpInside)
        button.alpha = 0.5
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchServices()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupView()
    }
    
    // MARK: - Custom funcs
    
    fileprivate func fetchServices() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = delegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Service")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var servicesArray = [ServiceData]()
            for data in result as! [Service] {
                let fetchedService = ServiceData(name: data.name!, url: data.url!, status: Int(data.status), lastTimeChecked: data.lastTimeChecked!)
                servicesArray.append(fetchedService)
            }
            services = servicesArray
        } catch {
            print("Failed")
        }
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            })
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.transform = .identity
        })
    }
    
    fileprivate func setupView() {
        setupNavBar()
        
        tableView.backgroundColor = .white
        tableView.register(ServiceCell.self, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Services"
    }
    
    @objc fileprivate func addNewButtonTapped() {
        guard let mainView = navigationController?.view else { return }
        
        if mainView.subviews.contains(bottomView) { // hide bottomView
            removeBottomView()
        } else { // show bottomView
            mainView.addSubview(bottomView)
            bottomView.anchor(top: nil, left: mainView.leftAnchor, bottom: mainView.bottomAnchor, right: mainView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 32, paddingRight: 16, width: 0, height: 232)
            
            addServiceButton.setTitle("Cancel", for: .normal)
            addServiceButton.backgroundColor = .appOrange
            
            bottomView.transform = CGAffineTransform(translationX: 0, y: 300)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.5, options: .curveEaseOut, animations: {
                self.bottomView.transform = .identity
            }, completion: nil)
        }
    }
    
    @objc fileprivate func isFormValid() {
        if nameInput.text != "", urlInput.text != "" { // Valid
            checkButtonTurned(on: true)
        } else { // Invalid
            checkButtonTurned(on: false)
        }
    }
    
    @objc fileprivate func createNewService() {
        guard let name = nameInput.text else { return }
        guard let url = urlInput.text else { return }
        
        checkStatus(forURL: url) { (responseStatus) in
            DispatchQueue.main.async {
                guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = delegate.persistentContainer.viewContext
                
                let newService = Service(context: context)
                newService.name = name
                newService.url = url
                newService.status = Int16(responseStatus)
                newService.lastTimeChecked = Tools.getTime()
                
                delegate.saveContext()
                
                self.removeBottomView()
                
                self.fetchServices()
            }
        }
    }
    
    func checkStatus(forURL url: String, completion: @escaping (Int) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(404)
                return
            }
            if let response = response as? HTTPURLResponse {
                completion(response.statusCode)
            }
        }.resume()
    }
    
    fileprivate func removeBottomView() {
        nameInput.text = nil
        urlInput.text = nil
        checkButtonTurned(on: false)
        addServiceButton.setTitle("Add new service", for: .normal)
        addServiceButton.backgroundColor = .appBlue
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 0
        }) { (_) in
            self.bottomView.removeFromSuperview()
            self.bottomView.alpha = 1
        }
    }
    
    fileprivate func checkButtonTurned(on: Bool) {
        if on {
            checkButton.alpha = 1
            checkButton.isEnabled = true
        } else {
            checkButton.alpha = 0.5
            checkButton.isEnabled = false
        }
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.addSubview(addServiceButton)
        addServiceButton.anchor(top: header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, width: 0, height: 0)
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ServiceCell
        cell.service = services[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        checkStatus(forURL: services[indexPath.row].url) { (responseStatus) in
            DispatchQueue.main.async {
                guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = delegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Service")
                request.returnsObjectsAsFaults = false
                do {
                    let result = try context.fetch(request)
                    var i = 0
                    for data in result as! [Service] {
                        if indexPath.row == i {
                            data.status = Int16(responseStatus)
                            data.lastTimeChecked = Tools.getTime()
                        }
                        i += 1
                    }
                    delegate.saveContext()
                    self.fetchServices()
                } catch {
                    print("Failed")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = delegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Service")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request) as! [Service]
                context.delete(result[indexPath.row])
                delegate.saveContext()
                fetchServices()
            } catch {
                print("Failed")
            }
        }
    }
    
}
