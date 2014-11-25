//
//  ImageViewController.swift
//  Pluto
//
//  Created by Kul on 11/23/2557 BE.
//  Copyright (c) 2557 Kul.com. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var photoFullURL: String! = NSString()
    
    @IBOutlet weak var fullImage: UIImageView! = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Get photo from path URL and display it
        //        let noPhotoURL =  NSURL(fileURLWithPath: noPhotoPNG).absoluteString!
        let noPhotoURL = NSURL(fileURLWithPath: noPhotoPNG)?.absoluteString!
        //        let myFullPhoto:NSString = self.photoFullURL
        println("photoFullURL at ImageView before if no photo = \(self.photoFullURL)")
        // If no photo record or photo not noPhoto
          if (self.photoFullURL != noPhotoURL) {

            
            let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentsDir: NSString = paths.objectAtIndex(0) as NSString
            
            let path: NSString = documentsDir.stringByAppendingString(photoFullURL)
            self.fullImage.image = UIImage(contentsOfFile: path)
            println("FullVC after display = \(self.photoFullURL)")
            
        }else{
            self.fullImage.image = UIImage(named: noPhotoPNG)
            println(self.photoFullURL)
            
        }
        
    }
    

}
