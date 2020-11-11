//
//  PopUpViewController.swift
//  try
//
//  Created by Sandeep Guliani on 6/30/20.
//

import UIKit

class PopUpViewController: UIViewController {

    
    var strings:[String] = []
    var bulletLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = .white
        
        //self.view = view
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Tapped))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        setupUI()
        setupConstraints()
        layoutTrait(traitCollection: UIScreen.main.traitCollection)

        // Do any additional setup after loading the view.
    }
    
    /*
    override func loadView() {
        let view = PopUpView()
        //view.backgroundColor = .white

        self.view = view
        
    }
    */
    
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
            instructionsLabel2Vertical.heightAnchor.constraint(equalToConstant: 70),
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
        if traitCollection.verticalSizeClass == .compact {
            instructionsLabelStackView.axis = .horizontal
            //instructionsLabel1.font = instructionsLabel1.font.withSize(14)
            //instructionsLabel2.font = instructionsLabel2.font.withSize(14)
            //instructionsLabel3.font = instructionsLabel3.font.withSize(14)
            //instructionsLabel4.font = instructionsLabel4.font.withSize(14)
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
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.deactivate(regularConstraints)
            dismiss(animated: false, completion: nil)
        }
    }
    //unowned var MainView: PopUpView { return self.view as! PopUpView }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
