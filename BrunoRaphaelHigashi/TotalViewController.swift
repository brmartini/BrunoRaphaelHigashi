//
//  TotalViewController.swift
//  BrunoRaphaelHigashi
//
//  Created by Bruno  Juliano Fernandes Martini on 23/04/17.
//  Copyright © 2017 Bruno  Juliano Fernandes Martini. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {

    @IBOutlet weak var lblIofbrl: UILabel!
    
    @IBOutlet weak var lblTotalbrl: UILabel!
    
    @IBOutlet weak var lblTotalus: UILabel!
    
    var fetchedResultController: NSFetchedResultsController<Product>!
    
    var dataSource: [Product]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProductsTotals()
        //lblIofbrl.text = "\(dataSource.count)"
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadProductsTotals()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadProductsTotals()
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadProductsTotals(){
        
        var totalUS: Double = 0
        var totalBRL: Double = 0
        var totalIOF: Double = 0
        var currency: Double = 0
        var iofTax: Double = 0
        var stateTax: Double = 0
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            
            try fetchedResultController.performFetch()
            
        }catch{
            print(error.localizedDescription)
        }
        
        dataSource = fetchedResultController.fetchedObjects!
        
        if dataSource.count != 0 {
            
            if let dolar = UserDefaults.standard.string(forKey: SettingsType.dolar.rawValue){
                currency = Double(dolar)!
            }
            
            if let iof = UserDefaults.standard.string(forKey: SettingsType.iof.rawValue){
                iofTax = Double(iof)!
            }
            
            
            for data in dataSource {
                
                stateTax = (data.statesTaxes?.tax)!
                totalUS += (data.usPrice)
                //lblTotalus.text = "\(totalUS)"
                lblTotalus.text = String(format: "%0.2f", totalUS)
                if data.iof == true {
                    totalBRL += ((data.usPrice * (1 + stateTax/100)) * currency) * (1 + (iofTax/100))
                    totalIOF += ((data.usPrice) * currency) * (iofTax/100)
                }else{
                    totalBRL += ((data.usPrice * (1 + stateTax/100)) * currency)
                    
                }
                //lblTotalbrl.text = "\(totalBRL)"
                lblTotalbrl.text = String(format: "%0.2f", totalBRL)
                
                //lblIofbrl.text = "\(totalIOF)"
                lblIofbrl.text = String(format: "%0.2f", totalIOF)
            }
            
        } else {
            
            lblIofbrl.text = "0.00"
            lblTotalbrl.text = "0.00"
            lblTotalus.text = "0.00"
        }
        
    }

}
