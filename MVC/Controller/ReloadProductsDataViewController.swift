//
//  ReloadProductsDataViewController.swift
//  Homework4.4
//
//  Created by Zhansuluu Kydyrova on 15/1/23.
//

import UIKit

class ReloadProductsDataViewController: UIViewController {

    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var categoryTextField: UITextField!
    @IBOutlet private weak var brandTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func reloadProductButton(_ sender: UIButton) {
            guard Int(idTextField.text!) != nil,
                  Int(priceTextField.text!) != nil,
                  !titleTextField.text!.isEmpty,
                  !descriptionTextField.text!.isEmpty,
                  !categoryTextField.text!.isEmpty,
                  !brandTextField.text!.isEmpty else {
                showAlert()
                return
            }
            
            let productModel = ProductModel(
                id: 0,
                title: titleTextField.text!,
                description: descriptionTextField.text!,
                price: Int(priceTextField.text!)!,
                discountPercentage: 0.0,
                rating: 0.0, brand:  brandTextField.text!,
                category: categoryTextField.text!,
                images: [""]
            )
            
            putProductsData(model: productModel)
    }
    

    
    private func putProductsData(model:ProductModel) {
        guard let id = Int(idTextField.text!) else { return showAlert() }
        Task{
            do {
                let data =  try await NetworkLayer.shared.putProductsData(id: id)
                succesfulReloadingDataAlert()
            } catch {
                print("SOMETHING WRONG WITH PUT REQUEST")
                showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "???? ?????? ???????????? ?????????????????? ??????????", message: "?????????????????????????? ?????? ????????????", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func succesfulReloadingDataAlert() {
        let alert = UIAlertController(title: "???????????? ?????????????????? ??????????????", message: "?????????????? ???? ????????????????????????????!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
