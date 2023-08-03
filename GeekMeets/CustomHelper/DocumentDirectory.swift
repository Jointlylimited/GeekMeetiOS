import UIKit

class DocumentDirectory: NSObject
{
    static var instance: DocumentDirectory!
    // SHARED INSTANCE
    class func shared() -> DocumentDirectory {
        self.instance = (self.instance ?? DocumentDirectory())
        return self.instance
    }
    
    //MARK:-
    func createFolder() -> String
    {
//        let documentsPath1 = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
//        let logsPath = documentsPath1.appendingPathComponent("\(currentCustomerUser.vFirstName ?? "")_\(currentCustomerUser.iUserId ?? 0)")
//        do {
//            try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)
//        } catch let error as NSError {
//            NSLog("Unable to create directory \(error.debugDescription)")
//        }
//        return logsPath?.path ?? ""
      return "abc"
    }
    
    func getAllFiles(strFolderName : String) -> [String]
    {
        let dirs = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true) as [String]
        var fileList = [""]
        if dirs.count > 0 {
            do {
                fileList = try FileManager.default.contentsOfDirectory(atPath: self.createFolder())
                return fileList
            } catch _ {
                return fileList
            }
        } else {
            return fileList
        }
    }
    
    func clearSpecificFolder() {
        do {
            let filePaths = try FileManager.default.contentsOfDirectory(atPath: self.createFolder())
            for filePath in filePaths
            {
                try FileManager.default.removeItem(atPath: filePath)
                
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func clearDocumentDirectory()
    {
        let fileManager = FileManager.default
        let tempFolderPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths
            {
                try fileManager.removeItem(atPath: tempFolderPath + "/" + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func writeImageToDocumentsDirectory(image : UIImage, imageName : String)
    {
        if image.size.height <= 0
        {
            return
        }
        let fileURL = "\(self.createFolder())/\(imageName)"
        let url = URL(fileURLWithPath: fileURL)
        if let data = image.jpegData(compressionQuality: 0.5),
            !FileManager.default.fileExists(atPath: url.path) {
            do {
                try data.write(to: url)
            } catch {
            }
        }        //print(fileURL)
    }
    
    func writeSingleImage(image : UIImage, imagename : String, completionHandler: @escaping (_ isSuccess : Bool, _ name : String) -> ())
    {
        let fileURL = "\(self.createFolder())/\(imagename)"
        let url = URL(fileURLWithPath: fileURL)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if FileManager.default.fileExists(atPath: url.path)
        {
            try! FileManager.default.removeItem(at: url)
        }
        if let data = image.jpegData(compressionQuality: 0.5)
        {
            do {
                try data.write(to: url)
                completionHandler(true, imagename)
            } catch {
                completionHandler(false, "")
            }
        }
    }
    
    
    func getFolderPath(strFolderName : String) -> String {
        var documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        documentDirectory = documentDirectory + strFolderName
        return documentDirectory
    }
    
    func getFileURL(name : String) -> String
    {
        return "\(self.createFolder())/\(name)"
    }
}
