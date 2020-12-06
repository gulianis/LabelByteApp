//
//  PopUpViewController.swift
//  try
//
//  Created by Sachin Guliani on 6/30/20.
//

import UIKit

class PopUpViewController: UIViewController {

    weak var delegate: ImageViewController?
    
    var strings:[String] = []
    var bulletLabel: UILabel = UILabel()

    var currentInstructionsView = InstructionsView()
    var instructionsLabel1Vertical: UILabel { return currentInstructionsView.instructionsLabel1Vertical }
    var instructionsLabel1Horizontal: UILabel { return currentInstructionsView.instructionsLabel1Horizontal }
    var instructionsLabel2Vertical: UILabel { return currentInstructionsView.instructionsLabel2Vertical }
    var instructionsLabel2Horizontal: UILabel { return currentInstructionsView.instructionsLabel2Horizontal }
    var instructionsLabel3Vertical: UILabel { return currentInstructionsView.instructionsLabel3Vertical}
    var instructionsLabel3Horizontal: UILabel { return currentInstructionsView.instructionsLabel3Horizontal }
    var instructionsLabel4Vertical: UILabel { return currentInstructionsView.instructionsLabel4Vertical }
    var instructionsLabel4Horizontal: UILabel { return currentInstructionsView.instructionsLabel4Horizontal }
    var instructionsLabelStackView: UIStackView { return currentInstructionsView.instructionsLabelStackView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Tapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        
        setupUI()
        setupConstraints()
        layoutTrait(traitCollection: UIScreen.main.traitCollection)

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        super.traitCollectionDidChange(previousTraitCollection)

        layoutTrait(traitCollection: traitCollection)
    }
    
    func setupUI() {
        //view.addSubview(instructionsLabel)
        instructionsLabelStackView.addArrangedSubview(instructionsLabel1Vertical)
        instructionsLabelStackView.addArrangedSubview(instructionsLabel1Horizontal)
        instructionsLabelStackView.addArrangedSubview(instructionsLabel2Vertical)
        instructionsLabelStackView.addArrangedSubview(instructionsLabel2Horizontal)
        instructionsLabelStackView.addArrangedSubview(instructionsLabel3Vertical)
        instructionsLabelStackView.addArrangedSubview(instructionsLabel3Horizontal)
        instructionsLabelStackView.addArrangedSubview(instructionsLabel4Vertical)
        instructionsLabelStackView.addArrangedSubview(instructionsLabel4Horizontal)
        view.addSubview(instructionsLabelStackView)
    }
    
    var compactConstraints: [NSLayoutConstraint] = []
    var regularConstraints: [NSLayoutConstraint] = []

    func setupConstraints() {
        regularConstraints.append(contentsOf: [
            instructionsLabelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionsLabelStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            instructionsLabel1Vertical.widthAnchor.constraint(equalToConstant: 240),
            instructionsLabel1Vertical.heightAnchor.constraint(equalToConstant: 125),
            instructionsLabel2Vertical.widthAnchor.constraint(equalToConstant: 240),
            instructionsLabel2Vertical.heightAnchor.constraint(equalToConstant: 95),
            instructionsLabel3Vertical.widthAnchor.constraint(equalToConstant: 240),
            instructionsLabel3Vertical.heightAnchor.constraint(equalToConstant: 90),
            instructionsLabel4Vertical.widthAnchor.constraint(equalToConstant: 240),
            instructionsLabel4Vertical.heightAnchor.constraint(equalToConstant: 140)
        ])
        compactConstraints.append(contentsOf: [
            instructionsLabelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionsLabelStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            instructionsLabel1Horizontal.widthAnchor.constraint(equalToConstant: 160),
            instructionsLabel1Horizontal.heightAnchor.constraint(equalToConstant: 225),
            instructionsLabel2Horizontal.widthAnchor.constraint(equalToConstant: 140),
            instructionsLabel2Horizontal.heightAnchor.constraint(equalToConstant: 225),
            instructionsLabel3Horizontal.widthAnchor.constraint(equalToConstant: 150),
            instructionsLabel3Horizontal.heightAnchor.constraint(equalToConstant: 225),
            instructionsLabel4Horizontal.widthAnchor.constraint(equalToConstant: 180),
            instructionsLabel4Horizontal.heightAnchor.constraint(equalToConstant: 225)
        ])
    }
    
    func layoutTrait(traitCollection: UITraitCollection) {
        // Sets up Instructions differently horizontally for iphones
        // so it fits on screen
        if traitCollection.verticalSizeClass == .compact {
            instructionsLabelStackView.axis = .horizontal
            instructionsLabel1Vertical.isHidden = true
            instructionsLabel1Horizontal.isHidden = false
            instructionsLabel2Vertical.isHidden = true
            instructionsLabel2Horizontal.isHidden = false
            instructionsLabel3Vertical.isHidden = true
            instructionsLabel3Horizontal.isHidden = false
            instructionsLabel4Vertical.isHidden = true
            instructionsLabel4Horizontal.isHidden = false
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            instructionsLabelStackView.axis = .vertical
            instructionsLabel1Vertical.isHidden = false
            instructionsLabel1Horizontal.isHidden = true
            instructionsLabel2Vertical.isHidden = false
            instructionsLabel2Horizontal.isHidden = true
            instructionsLabel3Vertical.isHidden = false
            instructionsLabel3Horizontal.isHidden = true
            instructionsLabel4Vertical.isHidden = false
            instructionsLabel4Horizontal.isHidden = true
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
    @objc func Tapped(sender:UITapGestureRecognizer) {
        if sender.state == .ended {
            // Make sure constraints are destroyed as view is dismissed
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.deactivate(regularConstraints)
            dismiss(animated: false, completion: nil)
            delegate?.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

}
