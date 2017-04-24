//
//  ProductsTableTableViewController.swift
//  BrunoRaphaelHigashi
//
//  Created by Bruno  Juliano Fernandes Martini on 20/04/17.
//  Copyright © 2017 Bruno  Juliano Fernandes Martini. All rights reserved.
//

import UIKit
import CoreData

class ProductsTableTableViewController: UITableViewController {
    
    
    
    var fetchedResultController: NSFetchedResultsController<Product>!
    
    var label:UILabel!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
        label.text = "Sua lista está vazia"
        label.textAlignment = .center
        
        loadProducts()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadProducts(){
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController.fetchedObjects?.count {
            tableView.backgroundView = (count == 0) ? label : nil
            return count
        } else {
            tableView.backgroundView = label
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prodcell", for: indexPath) as! ProductTableViewCell

        // Configure the cell...

        let product = fetchedResultController.object(at: indexPath)
        
        
        cell.lblProductName.text = product.name
        cell.lblProductPrice.text = "U$" + "\(product.usPrice)"
        if let prodpic = product.picture as? UIImage{
            cell.ivProdPic.image = prodpic
        }
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let product = fetchedResultController.object(at: indexPath)
            context.delete(product)
            do{
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "updProd"{
            
            if let vc = segue.destination as? ProductResgisterViewController{
                
                vc.product =  fetchedResultController.object(at: tableView.indexPathForSelectedRow!)
                
            }
            
            
        }
        
        
    }
    
    
    
    
    

}



extension ProductsTableTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        
        tableView.reloadData()
    }
}
