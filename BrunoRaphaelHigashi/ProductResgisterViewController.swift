//
//  ProductResgisterViewController.swift
//  BrunoRaphaelHigashi
//
//  Created by Bruno  Juliano Fernandes Martini on 18/04/17.
//  Copyright © 2017 Bruno  Juliano Fernandes Martini. All rights reserved.
//
import Foundation
import UIKit
import CoreData



class ProductResgisterViewController: UIViewController {
    
    
    
    @IBOutlet weak var tfProdName: UITextField!
    @IBOutlet weak var ivProdPicture: UIImageView!
    @IBOutlet weak var tfStateProd: UITextField!
    @IBOutlet weak var tfProdPrice: UITextField!
    @IBOutlet weak var swProdCard: UISwitch!
    @IBOutlet weak var btnAddUpdate: UIButton!
    
    var fetchedResultController: NSFetchedResultsController<States>!    
    var states: States!
    //
    var dataSource: [States]!
    var product: Product!
    var smallImage: UIImage!
    var pickerView: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if product != nil {
            tfProdName.text = product.name
            tfProdPrice.text = "\(product.usPrice)"
            if let image = product.picture as? UIImage {
                ivProdPicture.image = image
            }
            
            // add
            if let statesTaxes = product.statesTaxes{
                tfStateProd.text =  statesTaxes.name
            }
            
            swProdCard.isOn = product.iof
            //
            
            
            btnAddUpdate.setTitle("Atualizar" , for: .normal)
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        
        tfStateProd.inputView = pickerView
        tfStateProd.inputAccessoryView = toolbar
        
        loadStateTax()
        
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    

    
    func cancel() {
        tfStateProd.resignFirstResponder()
    }
    
    func done() {
        
        if dataSource.count != 0{
            tfStateProd.text = dataSource[pickerView.selectedRow(inComponent: 0)].name
        }
        
        cancel()
    }
    
    
    
    
    func loadStateTax(){
        
        let fetchRequest: NSFetchRequest<States> = States.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            
            try fetchedResultController.performFetch()
            
        }catch{
            print(error.localizedDescription)
        }
        
        dataSource = fetchedResultController.fetchedObjects!
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     
     */
    
    
    
    @IBAction func addState(_ sender: UIButton) {
    }
    
    @IBAction func addProduct(_ sender: UIButton) {
        
        if ((tfProdName.text?.isEmpty)! || (tfProdPrice.text?.isEmpty)! || (tfStateProd.text?.isEmpty)!){
            
            let alert = UIAlertController(title: "Preenchimento incompleto", message: "Preencha todos os campos antes de cadastrar o produto", preferredStyle: UIAlertControllerStyle.alert)
            
            let btnAlert = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alert.addAction(btnAlert)
            
            present(alert, animated: true, completion: nil)
            
            
        }else {
            
            
            
            if product == nil { product = Product(context: context)    }
            product.name = tfProdName.text!
            
           
            product.usPrice = Double(tfProdPrice.text!)!
           
            
                
            
            if smallImage != nil {
                product.picture = smallImage
            }
            
            
            
            if dataSource.count != 0 {
                product.statesTaxes = (dataSource[pickerView.selectedRow(inComponent: 0)])
            }
            
            product.iof = swProdCard.isOn
            
            
            do{
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            
            _ = navigationController?.popViewController(animated: true)
            
        }
        
        
        
    }
    
    func validateFields(){
        
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func changePhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar Foto", message: "De onde você quer escolher a foto", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
    }
    
}
extension ProductResgisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //
    //    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //Como reduzir uma imagem
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        ivProdPicture.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
}


extension ProductResgisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataSource[row].name
    }
    
}


extension ProductResgisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let count = fetchedResultController.fetchedObjects?.count{
            return count
        }
        
        return 0
    }
}

