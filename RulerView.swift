//
//  RulerView.swift
//
//  Created by Eshrar Rafsun on 20/4/26.
//


import UIKit

final class RulerView: UIView {
    
    // MARK: - Public API
    var minValue: Int = 0
    var maxValue: Int = 60
    var step: Int = 5
    
    var onValueChange: ((Int) -> Void)?
    
    private(set) var currentValue: Int = 0 {
        didSet {
            valueLabel.text = "\(currentValue)min"
            onValueChange?(currentValue)
            configureActive(isActive: true)
        }
    }
    
    // MARK: - UI
    private let collectionView: UICollectionView
    private let flowLayout = UICollectionViewFlowLayout()
    private let indicatorView = UIView()
    private let valueLabel = UILabel()
    
    // MARK: - Config
    private let itemSpacing: CGFloat = 12
    private let itemWidth: CGFloat = 2
    
    private var totalItems: Int {
        return (maxValue - minValue) / step + 1
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = itemSpacing
        flowLayout.itemSize = CGSize(width: itemWidth, height: 58)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = itemSpacing
        flowLayout.itemSize = CGSize(width: itemWidth, height: 58)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TickCell.self, forCellWithReuseIdentifier: "TickCell")
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        indicatorView.backgroundColor = hexStringToUIColor(hex: "#8D8D8D")
        indicatorView.layer.borderWidth = 2.5
        indicatorView.layer.cornerRadius = 1.5
        indicatorView.layer.borderColor = hexStringToUIColor(hex: "#8D8D8D").cgColor
        addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9),
            indicatorView.widthAnchor.constraint(equalToConstant: 3),
            indicatorView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        valueLabel.textColor = hexStringToUIColor(hex: "#8D8D8D")
        valueLabel.font = CustomFont.getFont(fontName: CustomFont.SFProText.Medium, size: 13)
        valueLabel.textAlignment = .center

        addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -38)
        ])
        
        valueLabel.text = "\(currentValue)min"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset = bounds.width / 2
        collectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    // MARK: - Public
    func setValue(_ value: Int, animated: Bool = true) {
        let index = (value - minValue) / step
        let offset = CGFloat(index) * (itemWidth + itemSpacing) - collectionView.contentInset.left
        
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.collectionView.contentOffset.x = offset
        }
    }
    
    func configureActive(isActive: Bool){
        if isActive {
            indicatorView.backgroundColor = .white
            valueLabel.textColor = .white
            indicatorView.layer.borderColor = UIColor.white.cgColor
        } else {
            indicatorView.backgroundColor = hexStringToUIColor(hex: "#8D8D8D")
            valueLabel.textColor = hexStringToUIColor(hex: "#8D8D8D")
            indicatorView.layer.borderColor = hexStringToUIColor(hex: "#8D8D8D").cgColor
        }
    }
}

// MARK: - UICollectionView
extension RulerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TickCell", for: indexPath) as! TickCell
        return cell
    }
}

// MARK: - Scroll + Snap
extension RulerView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + bounds.width / 2
        let index = Int(round(centerX / (itemWidth + itemSpacing)))
        let value = min(max(minValue + index * step, minValue), maxValue)
        
        if value != currentValue {
            currentValue = value
            Common.feedBack()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemFullWidth = itemWidth + itemSpacing
        let targetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let index = round(targetX / itemFullWidth)
        targetContentOffset.pointee.x = index * itemFullWidth - scrollView.contentInset.left
    }
}

// MARK: - Tick Cell
final class TickCell: UICollectionViewCell {
    
    private let line = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(line)
        
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            line.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            line.widthAnchor.constraint(equalToConstant: 2),
            line.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        line.layer.cornerRadius = 1
        line.backgroundColor = .hexStringToUIColor("#484848")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
