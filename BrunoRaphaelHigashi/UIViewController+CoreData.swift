	//
//  UIViewController+CoreData.swift
//  BrunoRaphaelHigashi
//
//  Created by Bruno  Juliano Fernandes Martini on 19/04/17.
//  Copyright © 2017 Bruno  Juliano Fernandes Martini. All rights reserved.
//

import Foundation
import UIKit
import CoreData
    
    


    extension UIViewController{
        
        var appDelegate: AppDelegate {
            
            return UIApplication.shared.delegate as! AppDelegate
        }
        
        var context: NSManagedObjectContext {
            
            return appDelegate.persistentContainer.viewContext
        }
    }
    
    
   
    
    
