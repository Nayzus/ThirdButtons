//
//  ViewController.swift
//  RectangleGradient
//
//  Created by Pavel Parshutkin on 02.07.2023.
//

import UIKit

class ViewController: UIViewController {

    lazy var buttonStack: UIStackView = configureButtonStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(buttonStack)
        self.setupConstraints()
    }

    
    private func setupConstraints() {
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            buttonStack.leftAnchor.constraint(equalTo: view.leftAnchor),
            buttonStack.rightAnchor.constraint(equalTo: view.rightAnchor),
            buttonStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
 
        ]
        NSLayoutConstraint.activate(constraints)
    }
    

    private func configureButtonStack() -> UIStackView {
        
        let stack = UIStackView()
        
        let firstButton = PrimaryButton()
        firstButton.configuration?.title = "First Button"
        stack.addArrangedSubview(firstButton)
        
        let secondaryButton = PrimaryButton()
        secondaryButton.configuration?.title = "Secondary Medium Button"
        stack.addArrangedSubview(secondaryButton)
        
        let thirdButon = PrimaryButton()
        thirdButon.configuration?.title = "Third"
        thirdButon.addTarget(self, action: #selector(openModal), for: .touchUpInside)

        stack.addArrangedSubview(thirdButon)
        
        
        stack.spacing = 8
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        
        return stack
    }
    
    @objc func openModal() {
        let sheetViewController = UIViewController()
        sheetViewController.view.backgroundColor = .white
        
        present(sheetViewController, animated: true)
    }
}


class PrimaryButton: UIButton {
    
    var dimmedForegroundColor: UIColor = .systemGray3
    var dimmedBackgroundColor: UIColor = .systemGray2
    
    var defaultForegroundColor: UIColor = .white
    var defaultBackgroundColor: UIColor = .systemBlue
    
    init() {
        super.init(frame: .zero)
        self.configuration = self.setupDefaultConfiguration()
        self.updateConfiguration()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func updateConfiguration() {
        super.updateConfiguration()
        
        var configuration: UIButton.Configuration = self.configuration ?? setupDefaultConfiguration()
 
        
        let foregroundColor: UIColor = .white
        let backgroundColor: UIColor = .systemBlue
        
        configuration.baseBackgroundColor = backgroundColor
        configuration.baseForegroundColor = foregroundColor
        
        configuration.titleTextAttributesTransformer  = getDefaultTitleTextAttributesTransformer()
        configuration.imageColorTransformer = getDefaultImageColorTransformer()
        configuration.background.backgroundColorTransformer = getDefaultBackgroundColorTransformer()
        
        self.configuration = configuration
    }
    
    private func getDefaultBackgroundColorTransformer() -> UIConfigurationColorTransformer {
        UIConfigurationColorTransformer { [weak self] color in
            
            guard let self = self else { return color }
            
            if self.tintAdjustmentMode == .dimmed {
                return self.dimmedBackgroundColor
            }
            else {
                return self.defaultBackgroundColor
            }
        }
    }
    
    private func getDefaultImageColorTransformer() -> UIConfigurationColorTransformer {
        UIConfigurationColorTransformer({ [weak self] color in
            
            guard let self = self else { return color }
            
            if self.tintAdjustmentMode == .dimmed {
                return self.dimmedForegroundColor
            }
            else {
                return self.defaultForegroundColor
            }
        })
    }
    
    private func getDefaultTitleTextAttributesTransformer() -> UIConfigurationTextAttributesTransformer {
        UIConfigurationTextAttributesTransformer({ [weak self] attr in
            guard let self = self else { return attr }
            
            var attribute = attr
            
            if self.tintAdjustmentMode == .dimmed {
                attribute.foregroundColor = self.dimmedForegroundColor
            }
            else {
                attribute.foregroundColor = self.defaultForegroundColor
            }
            
            return attribute
      
        })
    }
    
    private func setupDefaultConfiguration() -> UIButton.Configuration {
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 14)
        
        
        var configuration: UIButton.Configuration = UIButton.Configuration.filled()
        
        let icon = UIImage(systemName: "arrow.right.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .regular))
        
        configuration.attributedTitle = AttributedString("Ascending Order", attributes: container)
        configuration.image = icon
        configuration.imagePadding = 8
        configuration.imagePlacement = .trailing
        configuration.contentInsets = .init(top: 10, leading: 14, bottom: 10, trailing: 14)
        configuration.background.cornerRadius = 6
        
        
        return configuration
        
    }
    
    
    
    override public var isHighlighted: Bool {
        
        didSet {
            UIView.animate(withDuration: self.isHighlighted ? 0 : 0.25, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: { [weak self] in
                if let self = self {
                    self.transform = CGAffineTransform.identity.scaledBy(x: self.isHighlighted ? 0.95 : 1, y: self.isHighlighted ? 0.95 : 1)
            
                }
            })
        }
    }
}
