//
//  ViewController.swift
//  TabViewLayout
//
//  Created by Windy on 22/06/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {

    private var navBar: TabViewNavigationBar!
    var tabViewPager: TabViewPager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TabView"
        
        navBar = TabViewNavigationBar()
        navBar.root = self
        tabViewPager = TabViewPager()
        tabViewPager.navBar = navBar
        
        let cell1 = Cell()
        cell1.backgroundColor = .red
        let cell2 = Cell()
        cell2.backgroundColor = .red
        let cell3 = Cell()
        cell3.backgroundColor = .red
        tabViewPager.views = [cell1, cell2, cell3]
        
        view.addSubview(navBar)
        view.addSubview(tabViewPager)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        tabViewPager.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),
            
            tabViewPager.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            tabViewPager.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabViewPager.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabViewPager.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

class TabViewNavigationBar: UIView {
    
    var root: ViewController?
    var horizontalSlider: UIView!
    var sliderLeadingAnchor: NSLayoutConstraint!
    
    private var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NavbarCell.self, forCellWithReuseIdentifier: NavbarCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        
        horizontalSlider = UIView()
        horizontalSlider.translatesAutoresizingMaskIntoConstraints = false
        horizontalSlider.backgroundColor = .blue
        
        addSubview(collectionView)
        addSubview(horizontalSlider)
        
        sliderLeadingAnchor = horizontalSlider.leadingAnchor.constraint(equalTo: leadingAnchor)
        sliderLeadingAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            horizontalSlider.heightAnchor.constraint(equalToConstant: 2),
            horizontalSlider.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.333),
            horizontalSlider.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TabViewNavigationBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavbarCell.reuseIdentifier, for: indexPath) as! NavbarCell
        cell.label.text = "Tab \(indexPath.row)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let x = frame.width / 3 * CGFloat(indexPath.row)
        sliderLeadingAnchor.constant = x
        
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
        
        root?.tabViewPager.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
}

class NavbarCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "NavbarCell"
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
         
        label = UILabel()
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TabViewPager: UICollectionView {
    
    var navBar: TabViewNavigationBar!
    var views: [Cell]!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        backgroundColor = .systemBackground
        showsHorizontalScrollIndicator = false
        delegate = self
        dataSource = self
        isPagingEnabled = true
        register(Cell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TabViewPager: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        if indexPath.row == 0 {
            cell.viewController.view.backgroundColor = .red
        } else if indexPath.row == 1 {
            cell.viewController.view.backgroundColor = .yellow
        } else if indexPath.row == 2 {
            cell.viewController.view.backgroundColor = .green
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let x = scrollView.contentOffset.x / frame.width
        navBar.sliderLeadingAnchor.constant = x * frame.width / 3
        
        UIView.animate(withDuration: 0.1) {
            self.navBar.layoutIfNeeded()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return frame.size
    }
    
}

class Cell: UICollectionViewCell {
    
    var viewController: UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewController = UIViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(viewController.view)
        
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
