//
//  HomeViewController.swift
//  ZeroCopy
//
//  Created by Mike Gopsill on 12/01/2018.
//  Copyright © 2018 Mike Gopsill. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var homeHeaderView: HomeHeaderView!
    var tableView: UITableView!
    var tableViewDataSource: TableViewDataSource!
    var transitionManager: TransitionManager!
    
    let constraintRangeForHeaderView = (CGFloat(-190)..<CGFloat(0))
    let constraintRangeForHeaderTransparency = (CGFloat(-175)..<CGFloat(-54))

    // MARK: Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitionManager = TransitionManager()
        tableViewDataSource = TableViewDataSource()
        setupNavigationController()
        setupTableView()
        setupHeaderView()
        setupConstraints()
    }
    
    // MARK: Setup
    
    private func setupNavigationController(){
        guard let navigationController = navigationController  else {
            fatalError("navigationController does not exist")
        }
        
        navigationController.navigationBar.topItem?.title = "Zero"
        navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor  : UIColor.white]
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationBar.barTintColor = UIColor(red: 248/255, green: 110/255, blue: 92/255, alpha: 0.1)
        
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true

        
        let leftButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsPressed))
        let rightButton = UIBarButtonItem(title: "Science", style: .plain, target: self, action: #selector(sciencePressed))
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupTableView(){
        tableView = UITableView()
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupHeaderView(){
        homeHeaderView = HomeHeaderView()
        view.addSubview(homeHeaderView)
    }
    
    private func setupConstraints() {
        let constraints:[NSLayoutConstraint] = [
            homeHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
            homeHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: homeHeaderView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        var i = 0
        for constraint in view.constraints {
            print("\(i)")
            print("\(constraint)")
            i += 1
        }
    }
    
    // MARK: Button Methods
    
    @objc func settingsPressed(){
        let transition = transitionManager.transitionUp()
        navigationController!.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(SettingViewController(), animated: false)
    }
    
    @objc func sciencePressed(){
        let transition = transitionManager.transitionUp()
        navigationController!.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(ScienceViewController(), animated: false)
    }
}


// MARK: TableViewDelegate Methods

extension HomeViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let constraint = view.constraints[0]
        var alpha: CGFloat = 1.0
        // TODO: Set transparency
        // Code to set transparency
        //         goalLabel.textColor = goalLabel.textColor.withAlphaComponent(0.3)
        //         tagline.textColor = goalLabel.textColor.withAlphaComponent(0.3)

        
        // TODO: Remove print statements
        // Compress the top view
        if constraint.constant > constraintRangeForHeaderView.lowerBound && scrollView.contentOffset.y > 0 {
            print("Constraint const = \(constraint.constant)")
            print("Scroll view content offset = \(scrollView.contentOffset.y)")
            if constraint.constant < constraintRangeForHeaderTransparency.upperBound {
                // Below maths for alpha number
                let result: CGFloat =  (constraint.constant + 175)*(1)/(-54+175)
                print("\(result)")
                homeHeaderView.goalLabel.textColor = homeHeaderView.goalLabel.textColor.withAlphaComponent(result)
            }
            constraint.constant -= scrollView.contentOffset.y
            scrollView.contentOffset.y -= scrollView.contentOffset.y
        }
        
        if constraint.constant > constraintRangeForHeaderView.upperBound {
            constraint.constant = constraintRangeForHeaderView.upperBound
        }
        
        // Expand the top view
        if constraint.constant < constraintRangeForHeaderView.upperBound && scrollView.contentOffset.y < 0{
            print("Constraint const = \(constraint.constant)")
            print("Scroll view content offset = \(scrollView.contentOffset.y)")
            constraint.constant -= scrollView.contentOffset.y
            scrollView.contentOffset.y -= scrollView.contentOffset.y
        }
        
        if constraint.constant < constraintRangeForHeaderView.lowerBound {
            constraint.constant = constraintRangeForHeaderView.lowerBound
        }

    }
}
