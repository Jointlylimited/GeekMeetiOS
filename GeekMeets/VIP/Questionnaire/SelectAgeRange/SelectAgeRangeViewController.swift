//
//  SelectAgeRangeViewController.swift
//  GeekMeets
//
//  Created by SOTSYS216 on 23/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectAgeRangeProtocol: class {
    func displaySomething()
    func displayQuesionsData(Data : [NSDictionary])
   
}

struct QuestionaryModel {
    var arrQuestionnaire:[NSDictionary]!
    var objQuestionnaire:QuestionnaireModel!
}

class SelectAgeRangeViewController: UIViewController, SelectAgeRangeProtocol {
  
  
    //var interactor : SelectAgeRangeInteractorProtocol?
    var presenter : SelectAgeRangePresentationProtocol?

    @IBOutlet weak var lblQuestionIndex: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var clnSelectAge: UICollectionView!
  
    var objQuestionModel = QuestionaryModel()
    
    var intAgeSelected:Int = 0
    var index : Int = 0
    var selectedCells = [Int]()
    
    var isFromSignUp : Bool = true
    
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
        let interactor = SelectAgeRangeInteractor()
        let presenter = SelectAgeRangePresenter()
        
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
        doSomething()
    }
    
    func doSomething() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true
        self.presenter?.callQuestionnaireRequest()
    }
  override func viewWillAppear(_ animated: Bool) {
     self.navigationController?.isNavigationBarHidden = true
  }
    func displaySomething() {
        //nameTextField.text = viewModel.name
    }
    func displayQuesionsData(Data: [NSDictionary]) {
        print(Data)
        self.objQuestionModel.arrQuestionnaire = Data
        if isFromSignUp {
            self.objQuestionModel.objQuestionnaire = QuestionnaireModel(dictionary: Data[self.index])!
            self.index = self.index + 1
            self.lblQuestionIndex.text = "\(self.index)/\(self.objQuestionModel.arrQuestionnaire.count)"
            self.lblTitle.text = "\(self.objQuestionModel.objQuestionnaire.title!)"
        } else {
            setQuestionData(index: self.index)
        }
        if self.objQuestionModel.objQuestionnaire.field_code == 100{
            self.lblDescription.isHidden = true
        }else{
            self.lblDescription.isHidden = false
            self.lblDescription.text = "\(self.objQuestionModel.objQuestionnaire.description!)"
        }
     
    }
  
    func setQuestionData(index : Int){
        self.objQuestionModel.objQuestionnaire = QuestionnaireModel(dictionary: self.objQuestionModel.arrQuestionnaire[self.index - 1])!
        self.lblQuestionIndex.text = "\(self.index)/\(self.objQuestionModel.arrQuestionnaire.count)"
        self.lblTitle.text = "\(self.objQuestionModel.objQuestionnaire.title!)"
        if self.objQuestionModel.objQuestionnaire.field_code == 100{
            self.lblDescription.isHidden = true
        }else{
            self.lblDescription.isHidden = false
            self.lblDescription.text = "\(self.objQuestionModel.objQuestionnaire.description!)"
        }
        self.selectedCells = []
        self.clnSelectAge.reloadData()
    }
    
    
  //MARK: IBAction Method
    @IBAction func actionContinues(_ sender: Any) {
        if isFromSignUp {
            if self.index < self.objQuestionModel.arrQuestionnaire.count {
                self.index = index + 1
                self.setQuestionData(index: self.index)
            } else {
                self.presenter?.actionContinue()
            }
        } else {
            self.popVC()
        }
     }
    
    @IBAction func actionSkip(_ sender: Any) {
        if isFromSignUp {
            if self.index < self.objQuestionModel.arrQuestionnaire.count {
                self.index = index + 1
                self.setQuestionData(index: self.index)
            } else {
                self.presenter?.actionContinue()
            }
        } else {
            self.popVC()
        }
    }
}

//MARK:UICollectionview

extension SelectAgeRangeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,SelectAgeDelegate
{
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objQuestionModel.objQuestionnaire.response_set!.response_option?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : SelectAgeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectAgeCell", for: indexPath) as! SelectAgeCell
        cell.delegate = self
          return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? SelectAgeCell {
            cell.indexPath = indexPath
            let name = self.objQuestionModel.objQuestionnaire.response_set?.response_option?[indexPath.row].name!
            cell.lblTitle.text = name
            
            if self.selectedCells.contains(indexPath.row) {
                cell.btnSelectAge.layer.borderColor = #colorLiteral(red: 0.7098039216, green: 0.3254901961, blue: 0.8941176471, alpha: 1)
                cell.btnSelectAge.setTitleColor(#colorLiteral(red: 0.7098039216, green: 0.3254901961, blue: 0.8941176471, alpha: 1), for: .normal)
                cell.lblTitle.textColor = #colorLiteral(red: 0.7098039216, green: 0.3254901961, blue: 0.8941176471, alpha: 1)
            } else {
                cell.btnSelectAge.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                cell.btnSelectAge.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5), for: .normal)
                cell.lblTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            }
            
            cell.clickOnCell = {
                if self.objQuestionModel.objQuestionnaire.field_code == 100 {
                    if self.selectedCells.count != 0 {
                        let index = self.selectedCells.firstIndex { (index) -> Bool in
                            return index == indexPath.row
                        }
                        if self.selectedCells.contains(indexPath.row) {
                            self.selectedCells.remove(at: index!)
                        } else {
                            self.selectedCells.removeAll()
                            if self.selectedCells.count == 0 {
                                self.selectedCells.append(indexPath.row)
                            }
                        }
                    } else {
                        if self.selectedCells.count == 0 {
                            self.selectedCells.append(indexPath.row)
                        }
                    }
                } else {
                    if self.selectedCells.contains(indexPath.row) {
                        let index = self.selectedCells.firstIndex { (index) -> Bool in
                            return index == indexPath.row
                        }
                        self.selectedCells.remove(at: index!)
                    } else {
                        self.selectedCells.append(indexPath.row)
                    }
                }
                self.clnSelectAge.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let yourWidth = collectionView.bounds.width/3.0
      let yourHeight = CGFloat(50)
      return CGSize(width: yourWidth, height: yourHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      
        return 0
      
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
   
    func actionSelectAge(at index:IndexPath){
      intAgeSelected = index.row
      clnSelectAge.reloadData()
    }
}
