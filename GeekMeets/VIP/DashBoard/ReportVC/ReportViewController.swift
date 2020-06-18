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

struct ReasonModel {
    var arrReasonList:[ReasonListFields]!
    var objReason:ReasonListFields!
    
    var isSelectedReason : Bool = false
    var selectedReason: String {
        guard objReason != nil else {
            return isSelectedReason ? objReason.vReason! : ""
        }
        return ""
    }
    
    var selectedReasonId: String {
        guard objReason != nil else {
            return isSelectedReason ? "\(objReason.iReasonId!)" : ""
        }
        return ""
    }
}

protocol ReportProtocol: class {
    func getReportListResponse(response : ReasonListData)
    func getPostReportResponse(response : CommonResponse)
}

class ReportViewController: UIViewController, ReportProtocol {
    //var interactor : ReportInteractorProtocol?
    var presenter : ReportPresentationProtocol?
    
    @IBOutlet weak var lblScreenTitle: UILabel!
    @IBOutlet weak var tblReasonList: UITableView!
    @IBOutlet weak var btnReportTitle: GradientButton!
    @IBOutlet weak var tblViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var txtReportView: UITextView!
    @IBOutlet weak var lblTextCount: UILabel!
    
    var reasonTitle = "- Select Reason -"
    var placeHolderText = "Write here..."
    var arrReportData : [CellData] = []
    var arrReport = ReasonModel()
    
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
        self.presenter?.callReportAPI()
        self.registerTableViewCell()
    }
    
    func registerTableViewCell(){
        self.tblReasonList.register(UINib.init(nibName: Cells.CommonTblListCell, bundle: Bundle.main), forCellReuseIdentifier: Cells.CommonTblListCell)
        self.arrReportData = [CellData(opened: false, title: reasonTitle, sectionData: ["Reason 1" , "Reason 2", "Reason 3"])]
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    @IBAction func btnReportAction(_ sender: GradientButton) {
        let params = RequestParameter.sharedInstance().sendReason(iReportedFor: "", iStoryId: "", tiReportType: "1", iReasonId: arrReport.objReason != nil ? "\(arrReport.objReason.iReasonId!)" : "", vReportText: txtReportView.text)
        
        if arrReport.objReason == nil {
            AppSingleton.sharedInstance().showAlert(kSelectReason, okTitle: "OK")
            return
        }
        if txtReportView.text == placeHolderText {
            AppSingleton.sharedInstance().showAlert(kReasonEmpty, okTitle: "OK")
            return
        }
        self.callSendReportAPI(params : params)
    }
}

//MARK: API Methods
extension ReportViewController {
    func getReportListResponse(response : ReasonListData) {
        if response.responseCode == 200 {
            self.arrReport.arrReasonList = response.responseData
        } else {
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
        self.tblReasonList.reloadData()
    }
    
    func callSendReportAPI(params : Dictionary<String, String>){
        self.presenter?.callSendReportAPI(params: params)
    }
    
    func getPostReportResponse(response : CommonResponse) {
        if response.responseCode == 200 {
            self.dismissVC(completion: nil)
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
}

//MARK: UITableview Delegate & Datasource Methods
extension ReportViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrReport.arrReasonList == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrReport.isSelectedReason == true {
            return arrReport.arrReasonList.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.CommonTblListCell) as! CommonTblListCell
        
        if indexPath.row == 0 {
            cell.lblTitle.text = arrReport.isSelectedReason ? reasonTitle : (arrReport.objReason != nil ? arrReport.objReason.vReason : reasonTitle)
            cell.btnArrow.isHidden = false
            if arrReport.isSelectedReason {
                cell.btnArrow.setImage(#imageLiteral(resourceName: "icn_up"), for: .normal)
            } else {
                 cell.btnArrow.setImage(#imageLiteral(resourceName: "icn_down"), for: .normal)
            }
            
        } else {
            let reasonData = arrReport.arrReasonList[indexPath.row - 1]
            cell.lblTitle.text = reasonData.vReason
            cell.lblTitle.font = indexPath.row == 0 ? UIFont(name: "Poppins-SemiBold", size: 14) : UIFont(name: "Poppins-Medium", size: 14)
            cell.btnArrow.isHidden = true
        }
        cell.selectionStyle = .none
        
        return cell
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
        if arrReport.isSelectedReason {
            
            arrReport.isSelectedReason = false
            arrReport.objReason = indexPath.row != 0 ? arrReport.arrReasonList[indexPath.row - 1] : nil
            let sections = IndexSet.init(integer: 0)
            tableView.reloadSections(sections, with: .none)
            self.tblViewHeightConstant.constant = CGFloat(85)
        } else {
            
            arrReport.isSelectedReason = true
            let sections = IndexSet.init(integer: indexPath.row)
            tableView.reloadSections(sections, with: .none)
            self.tblViewHeightConstant.constant = CGFloat(85 + (60*arrReport.arrReasonList.count - 1))
        }
    }
}

//MARK: UITextView Delegate Methods
extension ReportViewController : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if (textView.text?.count)! <= 300 {
            return true
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text?.count)! <= 300 {
            textView.isUserInteractionEnabled = true
            self.lblTextCount.text = "\((textView.text?.count)!)/\(300)"
            
        } else {
            textView.isUserInteractionEnabled = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtReportView.text == placeHolderText {
            txtReportView.text = ""
            txtReportView.textColor = .black
        } else {
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
