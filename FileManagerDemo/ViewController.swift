//
//  ViewController.swift
//  FileManagerDemo
//
//  Created by Marco Alonso Rodriguez on 24/06/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var crearEditarButton: UIButton!
    @IBOutlet weak var contenidoArchivoText: UITextView!
    @IBOutlet weak var nombreArchivo: UITextField!
    
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crearDirectorio()
    }
    
    func crearDirectorio() {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let carpeta = url.appendingPathComponent("carpeta-archivos")
        
        do {
            try fileManager.createDirectory(at: carpeta, withIntermediateDirectories: true)
        } catch {
            print("Debug: error \(error.localizedDescription)")
        }
    }
    
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "OK", style: .default) { _ in
            //Do something
        }
        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    
    func reestablecerButon() {
        crearEditarButton.setTitle("Crear archivo", for: .normal)
        crearEditarButton.backgroundColor = .purple
    }

    
    @IBAction func crearArchivoButton(_ sender: UIButton) {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //abrir la carpeta donde vamos a guardar el archivo
        let carpetaURL = url.appendingPathComponent("carpeta-archivos")
        
        //Crear el archivo con su extension
        let pathArchivoURL = carpetaURL.appendingPathComponent("\(nombreArchivo.text ?? "nota").txt")
        
        //Informacion a guardar en el archivo
        if contenidoArchivoText.text != "" {
            let data = contenidoArchivoText.text.data(using: .utf8)
            
            ///utilizar el manager p guardar la data en el archivo del directorio
            fileManager.createFile(atPath: pathArchivoURL.path, contents: data, attributes: [FileAttributeKey.creationDate: Date.now])
            print("Archivo guardado: \(url.path)")
            
            //Despues de crearlo
            contenidoArchivoText.text = ""
            nombreArchivo.text = ""
            
            //Alerta
            mostrarAlerta(titulo: "Atencion", mensaje: "¡Archivo guardado!")
            
            reestablecerButon()
            
        }
        
        
       
    }
    
    @IBAction func abrirArchivoButton(_ sender: UIButton) {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let contenidoArchivo = url.appendingPathComponent("carpeta-archivos").appendingPathComponent("\(nombreArchivo.text ?? "nota").txt")
        
        ///mostrar el contenido el en textView
        do {
            try contenidoArchivoText.text = String(contentsOf: contenidoArchivo, encoding: .utf8)
            //cambiar el estilo del boton "crear archivo"
            crearEditarButton.setTitle("Editar", for: .normal)
            crearEditarButton.backgroundColor = .orange
            
        } catch {
            print("Debug: error \(error.localizedDescription)")
            mostrarAlerta(titulo: "Atención", mensaje: "El archivo que intentas abrir no existe, intenta con otro nombre.")
        }
    }
    
    @IBAction func eliminarArchivoButton(_ sender: UIButton) {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //abrir la carpeta donde tenemos el archivo a eliminar
        let carpetaURL = url.appendingPathComponent("carpeta-archivos")
        
        ///Archivo a eliminar
        let archivoEliminar = carpetaURL.appendingPathComponent("\(nombreArchivo.text ?? "").txt")
        
        //Validar si el archivo a eliminar si existe
        if fileManager.fileExists(atPath: archivoEliminar.path) {
            
            do {
                try fileManager.removeItem(at: archivoEliminar)
                mostrarAlerta(titulo: "Archivo", mensaje: "¡Borrado!")
                
                nombreArchivo.text = ""
                contenidoArchivoText.text = ""
                
                reestablecerButon()
                
            } catch {
                
                print("Debug: error \(error.localizedDescription)")
            }
            
        } else {
            mostrarAlerta(titulo: "Atencion", mensaje: "El archivo que intentas eliminar no existe!")
        }
    }
    
    
}

