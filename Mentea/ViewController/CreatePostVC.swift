//
//  CreatePostVC.swift
//  Mentea
//
//  Created by Rv on 12/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import MobileCoreServices



class CreatePostVC: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var txtPostText: UITextView!
    @IBOutlet weak var btnAttachment: UIButton!
    @IBOutlet weak var viewDocument: UIView!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocument: UILabel!
    @IBOutlet weak var imgPostImage: UIImageView!
    
     var images = [String]()
    
    
    var ref: DatabaseReference!
    var messageList = [MessageModel]()
    
    var senderId = ""
    var receiverId = ""
    var message = ""
    var attachFile = ""
    var attachFileUrl = ""
    var date = ""
    var userID = ""
    var receiver_Id = ""
    var which = ""
    var userType = ""
    
    var imagePath = ""
    var attachFileName = ""
    var receiverName = ""
    
    var userName : String?
    var userImageUrl : String?
    var userLocation : String?
    var userTypeFrom = ""
    
    
    var imagePickerController = UIImagePickerController()
    
   
    var userImg : UIImage?
    var placeholderLabel : UILabel!
    
    typealias CompletionBlock = (_ isAdd: Bool) -> Void
    var onCompletion:CompletionBlock?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.title = "Create Post"
        //self.userImageUrl = image
        if let url = URL(string: self.userImageUrl ?? "") {
                               self.userImage.sd_setImage(with: url, completed: nil)
                           }
        //userImage.image = userImg
        lblUserName.text = userName 
        
        txtPostText.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "What you want to share?"
        placeholderLabel.font = UIFont.systemFont(ofSize: (txtPostText.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtPostText.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtPostText.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtPostText.text.isEmpty
    }
    
    
    @IBAction func handleBtnAttachment(_ sender: Any) {
        self.showActionAlert(onVC: self, onTakePhoto:
                   self.takeNewPhotoFromCamera , onChooseFromGallery: self.choosePhotoFromExistingImages)
    }
    
    @IBAction func actionPost(_ sender: Any) {
        if ((txtPostText.text?.trimmingCharacters(in: .whitespaces).count ?? 0) > 0 || (self.attachFileUrl.trimmingCharacters(in: .whitespaces).count ?? 0) > 0){
            addPost(text: txtPostText.text ?? "")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func addPost(text: String) {
        guard let key = self.ref.child("blogs").childByAutoId().key else { return }
        let date = Date().string(format: "yyyy-MM-dd HH:mm:ss")
        
        let params = ["blogId" : key,
                      "blogText":text,"bloggerId":Helper.getPREF("userId") ?? "","bloggerImage":userImageUrl ?? "",
                      "bloggerName": userName ?? "","createdDate":date,"currentCity":self.userLocation ?? "","commentCount":"0","likesCount":"0",
                      "attachFileName":self.attachFileName ?? "", "attachFileUrl":self.attachFileUrl ?? ""]
        
        self.ref.child("blogs").child(key).setValue(params) { (Error, DatabaseReference) in
            if Error == nil{
            }else{
                print(Error.debugDescription)
            }
            if let isCompletion = self.onCompletion {
                isCompletion(true)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension CreatePostVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate {
    
    func showActionAlert(onVC viewController: UIViewController, onTakePhoto:@escaping ()->(), onChooseFromGallery:@escaping ()->()) {
        DispatchQueue.main.async {
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            
            let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
                print("Take Photo")
                self.which = "image"
                onTakePhoto()
            }
            actionSheetControllerIOS8.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: "Choose from library", style: .default) { action -> Void in
                print("Choose from library")
                self.which = "image"
                onChooseFromGallery()
            }
            actionSheetControllerIOS8.addAction(deleteActionButton)
            
            let makeVideoActionButton: UIAlertAction = UIAlertAction(title: "Make Video", style: .default) { action -> Void in
                print("Take Photo")
                self.which = "video"
                self.takeNewVideoFromCamera()
            }
            actionSheetControllerIOS8.addAction(makeVideoActionButton)
            
            let chooseVideoActionButton: UIAlertAction = UIAlertAction(title: "Choose Video", style: .default) { action -> Void in
                print("Choose from library")
                self.which = "video"
                self.chooseVideoFromExistingVideos()
            }
            actionSheetControllerIOS8.addAction(chooseVideoActionButton)
            
            let fileActionButton: UIAlertAction = UIAlertAction(title: "Choose File", style: .default) { action -> Void in
                print("Choose file")
                
                self.clickFunction()
            }
            actionSheetControllerIOS8.addAction(fileActionButton)
            
            if let popoverPresentationController = actionSheetControllerIOS8.popoverPresentationController {
                popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                
                var rect = viewController.view.frame;
                
                rect.origin.x = viewController.view.frame.size.width / 20;
                rect.origin.y = viewController.view.frame.size.height / 20;
                
                popoverPresentationController.sourceView = viewController.view
                popoverPresentationController.sourceRect = rect
            }
            
            actionSheetControllerIOS8.view.tintColor = UIColor.black
            viewController.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
    }
    
    
    func takeNewVideoFromCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.mediaTypes = [kUTTypeMovie as String]
        self.present(picker, animated: true, completion: nil)
    }
    
    func chooseVideoFromExistingVideos() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        picker.mediaTypes = ["public.movie"]
        
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    func takeNewPhotoFromCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.camera
        //picker.mediaTypes = ["",""]
        self.present(picker, animated: true, completion: nil)
    }
    
    func choosePhotoFromExistingImages() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func clickFunction(){
        
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.text", "public.data","public.pdf", "public.doc","com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document",kUTTypePDF as String], in: .import)
        
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
        
        
        if (self.which == "image" ){
            
            guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return  }
            DispatchQueue.main.async {
                let date = Date().timeIntervalSince1970
                
                self.imgPostImage.isHidden = false
                self.viewDocument.isHidden = true
                self.txtPostText.isHidden = true
                self.imgPostImage.image = editedImage
                
                self.createUploadFir(for: editedImage)
            }
            
        } else if(self.which == "video"){
            
            if let meadiaUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                print(meadiaUrl)
                meadiaUrl.videoFileSizeInMB()
                
                let videoData : Data!
                do {
                    try videoData = Data(contentsOf: meadiaUrl as URL)
                    var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    let documentsDirectory = paths[0]
                    let tempPath = documentsDirectory.appendingFormat("/vid1.mp4")
                    let url = URL(fileURLWithPath: tempPath)
                    do {
                        try _ = videoData.write(to: url, options: [])
                    }
                    //uploadVideoToAPI(tempPath)
                    
                    //self.sendFileVideo(url)
                    DispatchQueue.main.async {
                        print(meadiaUrl)
                        self.imgPostImage.isHidden = true
                        self.viewDocument.isHidden = false
                        self.txtPostText.isHidden = true
                        self.imgDocument.image = UIImage.init(named: "video")
                        url.videoFileSizeInMB()
                        //self.sendFileVideo(url)
                        self.createUploadVideo(for: url)
                    }
                } catch {
                    //handle error
                    print(error)
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //document
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        self.downloadfile(URL: myURL as NSURL)
        
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func createUploadFir(for image: UIImage) {
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        Helper.showLoader(onVC: self, message: "")
        
        let imageRef = Storage.storage().reference().child("userImage/"+"user"+dateString+"user.jpg")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            Helper.hideLoader(onVC: self)
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
            self.imagePath = urlString
            self.attachFileUrl = downloadURL.absoluteString ?? ""
            self.attachFileName = dateString+"user.jpg"
            
            // self.sendImageFir(url: self.imagePath,fileName: "")
        }
    }
           
    func createUploadVideo(for videoURL: URL) {
        let date = Date().timeIntervalSince1970 //string(format: "yyyy-MM-dd HH:mm:ss")
        Helper.showLoader(onVC: self, message: "")
        let storageReference = Storage.storage().reference().child("videoMessages/"+"\(date)"+".mov")
        storageReference.putFile(from: videoURL, metadata: nil) { (metadata, error) in
            
            Helper.hideLoader(onVC: self)
            if error == nil {
                
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                storageReference.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    
                    print(downloadURL.absoluteString ?? "")
                    let videoUrlPath = downloadURL
                    print("Successful document upload")
                    self.attachFileUrl = downloadURL.absoluteString ?? ""
                    self.attachFileName = "\(date)"+".mov"
                    self.lblDocument.text = self.attachFileName
                    // self.sendImageFir(url: downloadURL.absoluteString ?? "" ,fileName: "\(date)"+".mov")
                    //self.sendImageFir(url: downloadURL.absoluteString ?? "",fileName: filename)
                    
                }
                
                //print(metadata?.path ?? "")
                //let videoUrlPath = metadata?.path
                //print("Successful video upload")
                //self.sendImageFir(url: videoUrlPath ?? "",fileName: "\(date)"+".mov")
            } else {
                print(error?.localizedDescription ?? "")
            }
            
        }
    }
           
           
    func sendImageFir(url : String,fileName : String)  {
        
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        attachFileName = fileName
        attachFileUrl = url
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        var messageId = ref.childByAutoId().key ?? ""
        let params : [String:Any] = ["senderId":userID,
                                     "receiverId" : receiver_Id,
                                     "messageId" : messageId,
                                     "attachFile" : url,
                                     "date": dateString,
                                     "fileName" : fileName]
        
        Helper.showLoader(onVC: self, message: "")
    }
    
    func downloadfile(URL: NSURL) {
           let sessionConfig = URLSessionConfiguration.default
           let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
           var request = URLRequest(url: URL as URL)
           request.httpMethod = "GET"
           let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
               if (error == nil) {
                   // Success
                   let statusCode = response?.mimeType
                   print("Success: \(String(describing: statusCode))")
                   DispatchQueue.main.async(execute: {
                       self.createUploadDoument(for: data!,filename: URL.lastPathComponent!)
                   })
                   
                   // This is your file-variable:
                   // data
               }
               else {
                   // Failure
                   print("Failure: %@", error!.localizedDescription)
               }
           })
           task.resume()
       }
       
    func createUploadDoument(for videoURL: Data,filename : String) {
        let date = Date().timeIntervalSince1970 //string(format: "yyyy-MM-dd HH:mm:ss")
        Helper.showLoader(onVC: self, message: "")
        let storageReference = Storage.storage().reference().child("docMessages/"+"\(filename)")
        storageReference.putData(videoURL, metadata: nil) { (metadata, error) in
            Helper.hideLoader(onVC: self)
            if error == nil {
                
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                storageReference.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    self.attachFileUrl = downloadURL.absoluteString ?? ""
                    self.attachFileName = filename
                    print(downloadURL.absoluteString ?? "")
                    print("Successful document upload")
                    
                    self.imgPostImage.isHidden = true
                    self.viewDocument.isHidden = false
                    self.txtPostText.isHidden = true
                    self.imgDocument.image = UIImage.init(named: "document")
                    self.lblDocument.text = self.attachFileName
                }
                
                
            }
            else
            {
                
                print(error?.localizedDescription ?? "")
            }
            
        }
        
    }
}

