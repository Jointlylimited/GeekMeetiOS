//
//  ReportViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 24/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

struct CellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

protocol ReportProtocol: class {
}

class ReportViewController: UIViewController, ReportProtocol {
    //var interactor : ReportInteractorProtocol?
    var presenter : ReportPresentationProtocol?
    
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var tblReasonList: UITableView!
    @IBOutlet weak var btnReportTitle: GradientButton!
    @IBOutlet weak var tblViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var txtReportView: UITextView!
    
    var placeHolderText = "Write here..."
    var arrReportData : [CellData] = []
    
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
        let interactor = ReportInteractor()
        let presenter = ReportPresenter()
        
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
        self.registerTableViewCell()
    }
    
    func registerTableViewCell(){
        self.tblReasonList.register(UINib.init(nibName: Cells.CommonTblListCell, bundle: Bundle.main), forCellReuseIdentifier: Cells.CommonTblListCell)
        self.arrReportData = [CellData(opened: false, title: "- Select Reason -", sectionData: ["Reason 1" , "Reason 2", "Reason 3"])]
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    @IBAction func btnReportAction(_ sender: GradientButton) {
        self.dismissVC(completion: nil)
    }
}

extension ReportViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrReportData[0].sectionData.count == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrReportData[0].opened == true {
            return arrReportData[0].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.CommonTblListCell)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CommonTblListCell {
            cell.btnArrow.setImage(#imageLiteral(resourceName: "icn_down_arrow"), for: .normal)
            if indexPath.row == 0 {
                cell.lblTitle.text = arrReportData[0].title
                cell.lblDesc.text = ""
            } else {
                cell.lblTitle.text = arrReportData[0].sectionData[indexPath.row]
                cell.lblDesc.text = ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView =  UIView()
        headerView.backgroundColor = .white
        
        let headerTitle = UILabel()
        headerTitle.frame = CGRect(x: 20, y: headerView.frame.origin.y + 10, w: ScreenSize.width - 60, h: 30)
        headerTitle.text = "Select Reason"
        headerTitle.textColor = .black
        headerTitle.font = UIFont(name: "Poppins-SemiBold", size: 14)
        headerView.addSubview(headerTitle)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.CommonTblListCell)
        
        if self.arrReportData[0].opened {
            
            self.arrReportData[0].opened = false
            //arrReportList.objReason = indexPath.row != 0 ? arrReportList.objReasonList[indexPath.row - 1] : nil
            let sections = IndexSet.init(integer: 0)
            tableView.reloadSections(sections, with: .none)
            self.tblViewHeightConstant.constant = CGFloat(85)
        } else {
            
            self.arrReportData[0].opened = true
            let sections = IndexSet.init(integer: indexPath.row)
            tableView.reloadSections(sections, with: .none)
            self.tblViewHeightConstant.constant = CGFloat(60*self.arrReportData[0].sectionData.count)
        }
    }
}

extension ReportViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtReportView.text == placeHolderText {
            
            txtReportView.text = ""
            txtReportView.textColor = .black
        } else {
            txtReportView.textColor = .lightGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtReportView.text == "" {
            
            txtReportView.text = placeHolderText
            txtReportView.textColor = .lightGray
        } else {
            txtReportView.textColor = .black
        }
    }
}
