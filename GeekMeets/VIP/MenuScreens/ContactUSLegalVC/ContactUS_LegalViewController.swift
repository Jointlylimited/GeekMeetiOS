//
//  ContactUS_LegalViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 23/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import MessageUI

struct ContactUSModel {
    var title : String?
    var image : UIImage?
    var text : String?
    
    init(title: String, image: UIImage, text : String) {
        self.title = title
        self.image = image
        self.text = text
    }
}

protocol ContactUS_LegalProtocol: class {
    func getContactUsResponse(response : ContactUsResponse)
}

class ContactUS_LegalViewController: UIViewController, ContactUS_LegalProtocol {
    //var interactor : ContactUS_LegalInteractorProtocol?
    var presenter : ContactUS_LegalPresentationProtocol?
    
    // MARK: Object lifecycle
    
    @IBOutlet weak var tblContactList: UITableView!
    @IBOutlet weak var tblLegalList: UITableView!
    @IBOutlet weak var lblViewTitle: UILabel!
    @IBOutlet weak var viewLogo: UIView!
    
    var LegalTitleArray = ["Terms & Conditions", "Privacy Policy", "About Us", "Licenses"]
    var objContactData : [ContactUSModel] = []
    
    var isForLegal : Bool = false
    
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
        let interactor = ContactUS_LegalInteractor()
        let presenter = ContactUS_LegalPresenter()
        
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
        
        if isForLegal {
            self.lblViewTitle.text = "Legal"
            self.registerTableViewCell()
            self.tblContactList.alpha = 0.0
            self.tblLegalList.alpha = 1.0
            self.viewLogo.alpha = 0.0
        } else {
            self.lblViewTitle.text = "Contact Us"
//            self.setContactUsData()
            self.tblContactList.alpha = 1.0
            self.tblLegalList.alpha = 0.0
            self.viewLogo.alpha = 1.0
            self.presenter?.callContactUsAPI()
        }
    }
    
    func registerTableViewCell(){
        self.tblLegalList.register(UINib.init(nibName: Cells.CommonTblListCell, bundle: Bundle.main), forCellReuseIdentifier: Cells.CommonTblListCell)
    }
    
    func setContactUsData(){
        self.objContactData = [ContactUSModel(title: "Email", image: #imageLiteral(resourceName: "icn_email"), text: "john@gmail.com"), ContactUSModel(title: "Phone Number", image: #imageLiteral(resourceName: "icn_call"), text: "+1 123 455 852")]
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.popVC()
    }
    
    
    func configureMailComposer() -> MFMailComposeViewController{
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([self.objContactData[0].text!])
        mail.setSubject("Feedback")
        mail.setMessageBody("<p>Please give us your feedback.</p> <p>&nbsp;</p>  <p>&nbsp;</p> <p><br />Thank You!<br />Jointly Team<br /></p>", isHTML: true)
        return mail
    }
        
    func launchMailAppOnDevice() {
        
        let recipients = "mailto:?cc=&subject="
        let body = "&body="
        var email = "\(recipients)\(body)"
        email = (email as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue) ?? ""
        if let url = URL(string: email) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    func getContactUsResponse(response : ContactUsResponse){
        if response.responseCode == 200 {
            self.objContactData = [ContactUSModel(title: "Email", image: #imageLiteral(resourceName: "icn_email"), text: response.responseData?.vEmail ?? "john@gmail.com"), ContactUSModel(title: "Phone Number", image: #imageLiteral(resourceName: "icn_call"), text: response.responseData?.vPhone ?? "+1 123 455 852")]
            self.tblContactList.reloadData()
        }
    }
}

//MARK: UITableView Delegate & Datasource Methods
extension ContactUS_LegalViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isForLegal {
            return self.objContactData.count != 0 ? 2 : 0
        } else {
            return self.LegalTitleArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isForLegal {
            let cell : ContactUSCell = self.tblContactList.dequeueReusableCell(withIdentifier: "ContactUSCell", for: indexPath) as! ContactUSCell
            return cell
        } else {
            let cell = self.tblLegalList.dequeueReusableCell(withIdentifier: Cells.CommonTblListCell)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isForLegal {
            if let cell = cell as? ContactUSCell {
                
                let data = self.objContactData[indexPath.row]
                cell.btnTitle.setImage(data.image, for: .normal)
                cell.btnTitle.setTitle(data.title, for: .normal)
                cell.lblText.text = data.text
                cell.selectionStyle = .none
            }
        } else {
            if let cell = cell as? CommonTblListCell {
                cell.lblTitle.text = self.LegalTitleArray[indexPath.row]
                cell.selectionStyle = .none
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isForLegal {
            return UITableView.automaticDimension
        } else {
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if tableView == self.tblContactList {
            if indexPath.row == 0 {
                let mailComposeViewController = configureMailComposer()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.launchMailAppOnDevice()
                }
            } else {
                let phoneNumber = self.objContactData[indexPath.row].text
                if let url = NSURL(string: "tel://\(phoneNumber!)"), UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                } else {
                    AppSingleton.sharedInstance().showAlert("Unable to open in simulator", okTitle: "OK")
                }
            }
        } else {
            let commonVC = GeekMeets_StoryBoard.Menu.instantiateViewController(withIdentifier: GeekMeets_ViewController.CommonPagesScreen) as! CommonPagesViewController
            if index == 0 {
                commonVC.objCommonData = CommonModelData.Terms
                commonVC.slug = CommonModelData.Terms.slugTitle
            } else if index == 1 {
                commonVC.objCommonData = CommonModelData.Privacy
                commonVC.slug = CommonModelData.Privacy.slugTitle
            } else if index == 2 {
                commonVC.objCommonData = CommonModelData.About
                commonVC.slug = CommonModelData.About.slugTitle
            } else {
                commonVC.objCommonData = CommonModelData.Licenses
                commonVC.slug = CommonModelData.Licenses.slugTitle
            }
            self.pushVC(commonVC)
        }
    }
}

extension ContactUS_LegalViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
               print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
               print("Saved")
        case MFMailComposeResult.sent.rawValue:
               print("Sent")
        case MFMailComposeResult.failed.rawValue:
               print("Error: \(error?.localizedDescription)")
           default:
               break
           }
        controller.dismiss(animated: true, completion: nil)
    }
}
