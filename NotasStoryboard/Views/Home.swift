//
//  Home.swift
//  NotasStoryboard
//
//  Created by Luis Angel Torres G on 23/11/22.
//

import UIKit
import CoreData


class Home: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {



    @IBOutlet weak var tabla: UITableView!
    var notas = [Notas]()
    var fetchResultController: NSFetchedResultsController<Notas>!


    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        mostrarNotas()

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let nota = notas[indexPath.row]
        cell.textLabel?.text = nota.titulo
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        cell.detailTextLabel?.text = dateFormatter.string(from: nota.fecha ?? Date())
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Eliminar"){ (_, _, _) in
            
            let contexto = Modelo.shared.contexto()
            let borrar = self.fetchResultController.object(at: indexPath)
            contexto.delete(borrar)
            
            do {
                try contexto.save()
            }catch let error as NSError {
                print("No eliminó", error.localizedDescription)
            }
            
        }
        delete.image = UIImage(systemName: "trash")
        let editar = UIContextualAction(style: .destructive, title: "Editar"){ (_, _, _) in
            print("Editar")
            
        }
        editar.backgroundColor = .systemBlue
        editar.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [delete, editar])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "enviar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviar" {
            if let id = tabla.indexPathForSelectedRow{
                let fila = notas[id.row]
                let destino = segue.destination as! AddView
                destino.notas = fila
            }
        }
    }

    //Todo: NSFetchedResult
    func mostrarNotas() {
        let contexto = Modelo.shared.contexto()
        let fetchRequest: NSFetchRequest<Notas> = Notas.fetchRequest()
        let order = NSSortDescriptor(key: "titulo", ascending: true)//Ordenar alfabeticamente
        fetchRequest.sortDescriptors = [order]
        fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: contexto,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchResultController.delegate = self

        do {
            try fetchResultController.performFetch()
            notas = fetchResultController.fetchedObjects!

        } catch let error as NSError {
            print("no mostró nada", error.localizedDescription)
        }

    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tabla.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tabla.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath:
                    IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tabla.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tabla.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.tabla.reloadRows(at: [newIndexPath!], with: .fade)
        default:
            self.tabla.reloadData()
        }
        
        self.notas = controller.fetchedObjects as! [Notas]
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
