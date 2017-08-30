//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Parth Tamane on 28/08/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    
    var stores = [Store]()
    
    var types = [ItemType]()
    
    var imagePicker: UIImagePickerController!
    
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeSegment.removeAllSegments()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain , target: nil , action: nil)
        
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        getStores()
        
        getTypes()
        
        if stores.count == 0 && types.count == 0 {
            
            let store1 = Store(context: context)
            store1.name = "Best Buy"
    
            let store2 = Store(context: context)
            store2.name = "Wallmart"
    
            let store3 = Store(context: context)
            store3.name = "Tesla Dealership"
    
            let store4 = Store(context: context)
            store4.name = "Ebay"
    
            let store5 = Store(context: context)
            store5.name = "Amazon"
    
            let store6 = Store(context: context)
            store6.name = "Target"
    
            ad.saveContext()
    
            let type1 = ItemType(context: context)
            type1.type = "Toys"
    
            let type2 = ItemType(context: context)
            type2.type = "Sports"
            
            let type3 = ItemType(context: context)
            type3.type = "Electronics"
            
            let type4 = ItemType(context: context)
            type4.type = "Automoble"
            
            let type5 = ItemType(context: context)
            type5.type = "Others"
            
            ad.saveContext()
            
            getStores()
            
            getTypes()
            
        }
        
        var i = 0
        repeat {
            typeSegment.insertSegment(withTitle: "\(types[i].type!)", at: i, animated: true)
            i += 1
        } while ( i < types.count)
        typeSegment.selectedSegmentIndex = 0
        typeSegment.apportionsSegmentWidthsByContent = true
        typeSegment.tintColor = UIColor.darkGray
        
        if itemToEdit != nil {
            
            loadItemData()
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let store = stores[row]
        return store.name
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //Update when selected
    }
    
    
    func getStores() {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
            
        } catch {
            
            //Handle error
        }
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbImage.image
        
        if itemToEdit == nil {
            
            item = Item(context: context)
        } else {
            
            print("Here")
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            
            item.title = title
        }
        
        if let price = priceField.text {
            
            item.price = ( price as NSString ).doubleValue
        }
        
        if let details = detailsField.text {
            
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = types[typeSegment.selectedSegmentIndex]
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        navigationController?.popViewController(animated: true )
    }
    
    func loadItemData()  {
        
        if let item = itemToEdit {
            
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImage.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0 , animated: true)
                        break
                    }
                    
                    index += 1
                    
                } while ( index < stores.count)
            }
            
            if let type = item.toItemType {
                
                var index = 0
                repeat {
                    
                    if types[index].type == type.type {
                        
                        print("FOUND INDEX IS: \(index)")
                        break
                    }
                    
                    index += 1
                } while ( index < types.count)
                
                   typeSegment.selectedSegmentIndex = index
            }
        }
        
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            thumbImage.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func getTypes() {
        
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do{
            
            self.types = try context.fetch(fetchRequest)
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
        }
        
    }

    @IBAction func tapToDismiss(_ sender: Any) {
        
        view.endEditing(true)
    }
}
