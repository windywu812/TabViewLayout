//
//  CustomViewPager.swift
//  TabViewLayout
//
//  Created by Windy on 24/06/21.
//

import UIKit

class TabViewController: UIViewController, UICollectionViewDelegate {

    /// Call this function to add viewcontroller to the viewpager
    func addViewControllers(viewControllers: [UIViewController]) {
        tabViewPager.viewControllers = viewControllers
        
        viewControllers.forEach { [weak self] vc in
            self?.addChild(vc)
            self?.navBar.labels.append(vc.title ?? "Not set")
        }
        
    }
    
    /// Adding styles to the navigation bar
    /// - Parameters:
    ///   - height: Set the Indicator's height , DEFAULT is `3`
    ///   - color: Set the horizontal Indicator's color, DEFAULT is `.clear`
    ///   - backgroundColor: Set the horizontal Indicator's backgroundColor, DEFAULT is `.clear`
    ///   - activeColor: Set the horizontal activeColor, DEFAULT is `.label`
    ///   - inActiveColor: Set the horizontal inActiveColor, DEFAULT is `.secondaryLabel`
    func addStylesToNavigationBar(
        height: CGFloat = 3,
        color: UIColor = .clear,
        backgroundColor: UIColor = .systemBackground,
        activeColor: UIColor = .label,
        inActiveColor: UIColor = .secondaryLabel
    ) {
        navBar.indicatorColor = color
        navBar.navBarBackgroundColor = backgroundColor
        navBar.activeColor = activeColor
        navBar.inActiveColor = inActiveColor
        
        if height == 0 {
            navBar.showHorizontalIndicator = false
        } else {
            navBar.indicatorHeight = height
        }
    }
    
    private var navBar: CustomNavigationBar!
    private var tabViewPager: CustomViewPager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar = CustomNavigationBar()
        
        tabViewPager = CustomViewPager()
        tabViewPager.navBar = navBar
                
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


fileprivate let notificationName = "com.changescrollviewoffset"

fileprivate class CustomNavigationBar: UIView {
    
    // MARK: Customize Navigation Bar Properties
    var labels: [String] = [] {
        didSet {
            collectionView.reloadData()
            widthIndicatorAnchor.constant = bounds.width / CGFloat(labels.count)
            layoutIfNeeded()
        }
    }
    var showHorizontalIndicator = true {
        didSet {
            if !showHorizontalIndicator {
                horizontalSlider.removeFromSuperview()
            }
        }
    }
    var indicatorHeight: CGFloat = 2 {
        didSet {
            heightIndicatorAnchor.constant = indicatorHeight
            layoutIfNeeded()
        }
    }
    var indicatorColor: UIColor = .blue {
        didSet {
            horizontalSlider.backgroundColor = indicatorColor
        }
    }
    var navBarBackgroundColor: UIColor = .systemBackground {
        didSet {
            collectionView.backgroundColor = navBarBackgroundColor
        }
    }
    var activeTab: Int = 0 {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.collectionView.reloadData()
            }
        }
    }
    
    var activeColor: UIColor = .label
    var inActiveColor: UIColor = .secondaryLabel
    
    var heightIndicatorAnchor: NSLayoutConstraint!
    var widthIndicatorAnchor: NSLayoutConstraint!
    var sliderLeadingAnchor: NSLayoutConstraint!
    
    // MARK: Private Implementation
    private var horizontalSlider: UIView!
    private var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    private func setupView() {
                
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
        horizontalSlider.backgroundColor = indicatorColor
    }
    
    private func setupConstraint() {
        
        addSubview(collectionView)
        addSubview(horizontalSlider)
        
        sliderLeadingAnchor = horizontalSlider.leadingAnchor.constraint(equalTo: leadingAnchor)
        sliderLeadingAnchor.isActive = true
        
        heightIndicatorAnchor =             horizontalSlider.heightAnchor.constraint(equalToConstant: indicatorHeight)
        heightIndicatorAnchor.isActive = true
        
        widthIndicatorAnchor = horizontalSlider.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CGFloat(labels.count))
        widthIndicatorAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            
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

extension CustomNavigationBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavbarCell.reuseIdentifier, for: indexPath) as! NavbarCell
        cell.label.text = labels[indexPath.row]
        cell.label.textColor = (activeTab == indexPath.row) ? activeColor : inActiveColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info: [String: IndexPath] = ["indexPath": indexPath]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: notificationName),
            object: nil,
            userInfo: info)
        activeTab = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(labels.count), height: frame.height)
    }
    
}

fileprivate class NavbarCell: UICollectionViewCell {
    
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

fileprivate class CustomViewPager: UICollectionView {
    
    var navBar: CustomNavigationBar!
    var viewControllers: [UIViewController]!
    
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
        register(ViewPagerCell.self, forCellWithReuseIdentifier: "Cell")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification(notification:)),
            name: Notification.Name(rawValue: notificationName),
            object: nil)
    }
    
    @objc private func handleNotification(notification: NSNotification) {
        let indexPath: IndexPath = (notification.userInfo?["indexPath"]) as! IndexPath
        scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomViewPager: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ViewPagerCell
        cell.configureCell(viewController: viewControllers[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let x = scrollView.contentOffset.x / frame.width
        navBar.sliderLeadingAnchor.constant = x * frame.width / CGFloat(viewControllers.count)
        
        if abs(CGFloat(Int(x)) - x) <= 0.5 {
            navBar.activeTab = Int(x)
        } else {
            if navBar.activeTab > Int(x) {
                return
            } else {
                navBar.activeTab = Int(ceil(x))
            }
        }
        
        UIView.animate(withDuration: 0.1) {
            self.navBar.layoutIfNeeded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return frame.size
    }
    
}

fileprivate class ViewPagerCell: UICollectionViewCell {
    
    var viewController: UIViewController?
    
    func configureCell(viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(viewController.view)
        
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewController = nil
    }
    
}
