//
//  AddView.swift
//  NotasStoryboard
//
//  Created by Luis Angel Torres G on 23/11/22.
//

import UIKit

class AddView: UIViewController {


    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var boton: UIButton!
    @IBOutlet weak var fecha: UIDatePicker!
    @IBOutlet weak var nota: UITextView!

    var notas: Notas?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = notas != nil ? "Editar nota" : "Crear nota"
        titulo.text = notas?.titulo
        nota.text = notas?.nota
        fecha.date = notas?.fecha ?? Date()
        if notas == nil {
            validarText()
        } else {
            validarText2()
        }

        // Do any additional setup after loading the view.
    }


    @IBAction func guardar(_ sender: UIButton) {
        if notas != nil {
            Modelo.shared.editData(titulo: titulo.text ?? "", nota: nota.text, fecha: fecha.date, notas: notas!)
            navigationController?.popViewController(animated: true)
        } else {
            Modelo.shared.saveData(titulo: titulo.text ?? "", nota: nota.text, fecha: fecha.date)
            navigationController?.popViewController(animated: true)
        }
    }

    func validarText() {
        boton.isEnabled = false
        boton.backgroundColor = .systemGray2
        titulo.addTarget(self, action: #selector(validarTextField), for: .editingChanged)
    }
    func validarText2() {
        titulo.addTarget(self, action: #selector(validarTextField), for: .editingChanged)
    }
    
    @objc func validarTextField(sender: UITextField) {
        guard let titulo2 = titulo.text, !titulo2.isEmpty else {
            boton.isEnabled = false
            boton.backgroundColor = .systemGray2
            return
        }
        boton.isEnabled = true
        boton.backgroundColor = .systemTeal
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
