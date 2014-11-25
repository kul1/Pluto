//
//  SecondViewController.swift
//  Pluto
//
//  Created by Kul on 11/23/2557 BE.
//  Copyright (c) 2557 Kul.com. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    var photoFullURL: String!
    var photoThumbURL: String!
    
    
    @IBOutlet weak var txtName: UITextField! = UITextField()
    
    @IBOutlet weak var txtDesc: UITextField! = UITextField()
    
    
    @IBOutlet weak var myImage: UIImageView! = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "chooseImage:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        myImage.addGestureRecognizer(tapGestureRecognizer)
        myImage.userInteractionEnabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        textField.resignFirstResponder();
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBAction func add_Button(sender: AnyObject) {
        println("Add Button Clicked")
        
        ////////
//                // Prepare to access TaskData through TaskManager
//                let appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//                let moc:NSManagedObjectContext = appDel.managedObjectContext!
//                let ent = NSEntityDescription.entityForName("TaskData", inManagedObjectContext: moc)
//                var newTaskData = TaskData(entity: ent!, insertIntoManagedObjectContext: moc)
        ////////
        
        //////////
        ////////// Prepare to access TaskData through SwiftCoreDataHelper
        let moc:NSManagedObjectContext = SwiftCoreDataHelper.managedObjectContext()
        var newTaskData:TaskData = SwiftCoreDataHelper.insertManagedObject(NSStringFromClass(TaskData), managedObjectConect: moc) as TaskData
        
        //////////
        
        let myImagedata:NSData = UIImagePNGRepresentation(myImage.image)
        
        
        newTaskData.identifier = "\(NSDate())"
        newTaskData.taskName = txtName.text
        newTaskData.taskDesc = txtDesc.text
        newTaskData.taskImage = myImagedata
        
        // Save URL Image to CoreData
        // Save the reference to photo (i.e. URL) to CoreData
        if(self.photoFullURL == nil){
            let URL = NSURL(fileURLWithPath: noPhotoPNG)?.absoluteString!
            newTaskData.photoFullURL = URL!
            newTaskData.photoThumbURL = URL!
        }else{
            newTaskData.photoFullURL = self.photoFullURL
            newTaskData.photoThumbURL = self.photoThumbURL
        }
        
        
        // Save to CoreData
//                moc.save(nil)
        
        SwiftCoreDataHelper.saveManagedObjectContext(moc)
        
        
        // Print Save Image
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDir: NSString = paths.objectAtIndex(0) as NSString
        println("Save image at \(paths)")
        
        //        SwiftCoreDataHelper.saveManagedObjectContext(moc)
        
        // Clear Text Field
        
        txtName.text = ""
        txtDesc.text = ""
        
        // Clear Image ??
        myImage.image   = UIImage(named: "Image.jpg")
        
 //       self.navigationController?.popViewControllerAnimated(true)
        
    }

    
    
    @IBAction func chooseCamera(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            //load the camera interface
            var picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        }else{
            //no camera available
            var alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: {(alertAction)in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func chooseImage(recognizer: UITapGestureRecognizer){
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true , completion: nil)
    }
    
    func scaleImageWith(image:UIImage, newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // My Methods
    
    // Scale the photos
    func scaledImageWithImage(image: UIImage, size: CGSize) -> UIImage{
        let scale: CGFloat = max(size.width/image.size.width, size.height/image.size.height)
        let width: CGFloat = image.size.width * scale
        let height: CGFloat  = image.size.height * scale
        let imageRect: CGRect = CGRectMake((size.width-width)/2.0, (size.height - height)/2.0, width, height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.drawInRect(imageRect)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary!) {
        
        let pickedImage:UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        // smapp picture
        let smallPicture = scaleImageWith(pickedImage, newSize: CGSizeMake(300, 300))
        
        var sizeOfImageView:CGRect = myImage.frame
        sizeOfImageView.size = smallPicture.size
        myImage.frame = sizeOfImageView
        
        myImage.image = smallPicture
        picker.dismissViewControllerAnimated(true , completion: nil)
        
        
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), {
            // Scale the original image down before saving it (Good Practice)
            
            // Get the screen size for the target device
            let screenSize: CGSize = UIScreen.mainScreen().bounds.size
            var newImage: UIImage = self.scaledImageWithImage(image, size: CGSize(width: screenSize.width, height: screenSize.height))
            //            let newImage: UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.myImage.image = newImage
                picker.dismissViewControllerAnimated(true, completion: nil)
            })
            // Get path to the Documents Dir.
            let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentsDir: NSString = paths.objectAtIndex(0) as NSString
            
            // Get current date and time for unique name
            var dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd-HH-mm-ss"
            let now:NSDate = NSDate(timeIntervalSinceNow: 0)
            let theDate: NSString = dateFormat.stringFromDate(now)
            
            // Set URL for the full screen image
            self.photoFullURL = NSString(format: "/%@.png", theDate)
            
            // Save the full screen image via pngData
            let pathFull: NSString = documentsDir.stringByAppendingString(self.photoFullURL)
            let pngFullData: NSData = UIImagePNGRepresentation(newImage)
            pngFullData.writeToFile(pathFull, atomically: true)
            
            //  Create the thumbnail from the original image
            let thumbnailImage: UIImage = self.scaledImageWithImage(newImage, size: CGSize(width: 100, height: 100))
            self.photoThumbURL = NSString(format: "/%@_THUMB.png", theDate)
            
            // Save the thumbnail image
            let pathThumb: NSString = documentsDir.stringByAppendingString(self.photoThumbURL)
            let pngThumbData: NSData = UIImagePNGRepresentation(thumbnailImage)
            pngThumbData.writeToFile(pathThumb, atomically: true)
        })
        
        
        
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true , completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
}
