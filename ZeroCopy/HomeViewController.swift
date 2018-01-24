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
    var transitionManager: TransitionManager!
    
    var oldContentOffset = CGPoint.zero
    let topConstraintRange = (CGFloat(-130)..<CGFloat(70))
    
    override func viewDidLoad() {
        setup()
        setupTableView()
        setupHeaderView()
        setupNavigationController()
        setupConstraints()
    }
    
    // MARK: Setup
    
    private func setup(){
        transitionManager = TransitionManager()
    }
    
    private func setupHeaderView(){
        homeHeaderView = HomeHeaderView()
        homeHeaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(homeHeaderView)
    }
    
    private func setupTableView(){
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupNavigationController(){
        navigationController?.navigationBar.topItem?.title = "Zero"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor  : UIColor.white]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = UIColor(red: 248/255, green: 110/255, blue: 92/255, alpha: 1.0)
        let leftButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsPressed))
        let rightButton = UIBarButtonItem(title: "Science", style: .plain, target: self, action: #selector(sciencePressed))
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setupConstraints() {
        let constraints:[NSLayoutConstraint] = [
            homeHeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64.0),
            homeHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: homeHeaderView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //applyGradient()
    }
    
    private func applyGradient() {
        let gradient = CAGradientLayer()
        
        gradient.frame = homeHeaderView.bounds
        
        let darkOrange = UIColor(red: 248/255, green: 110/255, blue: 92/255, alpha: 1.0)
        let lightOrange = UIColor(red: 207/255, green: 103/255, blue: 113/255, alpha: 1.0)
        
        gradient.colors = [lightOrange.cgColor, darkOrange.cgColor]
        
        homeHeaderView.layer.insertSublayer(gradient, at: 0)
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

// MARK: TableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 0
//        }
        return 30
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let label = UILabel(frame: CGRect(x: 30.0, y: 10.0, width: 100.0, height: 20.0))
            label.text = String(indexPath.row)
            let cell = UITableViewCell()
            cell.addSubview(label)
            return cell
    }
}


// MARK: TableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta =  scrollView.contentOffset.y - oldContentOffset.y
        let constraint = homeHeaderView.constraints[4]
        
        // Compress the top view
        if delta > 0 && constraint.constant > topConstraintRange.lowerBound && scrollView.contentOffset.y > 0 {
            constraint.constant -= delta
            scrollView.contentOffset.y -= delta
        }
        
        // Expand the top view
        if delta < 0 && constraint.constant < topConstraintRange.upperBound && scrollView.contentOffset.y < 0{
            constraint.constant -= delta
            scrollView.contentOffset.y -= delta
        }
        oldContentOffset = scrollView.contentOffset
    }
    
}
