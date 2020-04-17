//
//  TabbarViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 17/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TabbarProtocol: class {
    
}

class TabbarViewController: UIViewController, TabbarProtocol {
    //var interactor : TabbarInteractorProtocol?
    var presenter : TabbarPresentationProtocol?
    
     @IBOutlet weak var cards: SwipeableCards!
    
    var cardsData = [Int]()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = TabbarInteractor()
        let presenter = TabbarPresenter()
        
        //View Controller will communicate with only presenter
        viewController.presenter = presenter
        //viewController.interactor = interactor
        
        //Presenter will communicate with Interector and Viewcontroller
        presenter.viewController = viewController
        presenter.interactor = interactor
        
        //Interactor will communucate with only presenter.
        interactor.presenter = presenter
    }
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCards()
    }
    
    func setCards() {
        makeCardsData()
        cards.dataSource = self
        cards.delegate = self
    }
    
    func makeCardsData() {
        for i in 0..<100 {
            cardsData.append(i)
        }
    }
}

extension TabbarViewController : SwipeableCardsDataSource, SwipeableCardsDelegate {
    // SwipeableCardsDataSource methods
    func numberOfTotalCards(in cards: SwipeableCards) -> Int {
        return cardsData.count
    }
    func view(for cards: SwipeableCards, index: Int, reusingView: CardView?) -> CardView {
        
        let view = CardView.initCoachingAlertView()
        view.frame = CGRect(x: 30, y: -50, w: ScreenSize.width - 60, h: ScreenSize.height - 200)
        
        view.clickOnClose = {
            print("Close Action clicked!")
        }
        
        view.clickOnFavourite = {
            print("Favourite Action clicked!")
            self.presenter?.gotoMatchVC()
        }
        
        view.clickOnView = {
            print("View Action clicked!")
        }
        
        return view
    }
    
    
    // SwipeableCardsDelegate methods
    func cards(_ cards: SwipeableCards, beforeSwipingItemAt index: Int) {
        print("Begin swiping card \(index)!")
    }
    func cards(_ cards: SwipeableCards, didLeftRemovedItemAt index: Int) {
        print("<--\(index)")
    }
    func cards(_ cards: SwipeableCards, didRightRemovedItemAt index: Int) {
        print("\(index)-->")
    }
    func cards(_ cards: SwipeableCards, didRemovedItemAt index: Int) {
        print("index of removed card:\(index)")
    }
}
