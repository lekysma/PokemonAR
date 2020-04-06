//
//  ViewController.swift
//  PokemonAR
//
//  Created by Jean martin Kyssama on 04/04/2020.
//  Copyright © 2020 Jean martin Kyssama. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        
        //ajouter de la luminosite a l'application
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        // On cree une image que notre application va reconnaitre comme enregistrée
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon cards", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            // nombre d'images qui seront simultanement analysees = au nombre d'images dans assets.xcassets
            configuration.maximumNumberOfTrackedImages = 1
            //test
            print("we managed to find our image and turn it into a reference")
        }
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    //MARK: - Fonctionalité permettant de reconnaitre l'image enregistrée et de la transformer en plan pour affichage 3D
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // on cree une figure 3d, celle que nous allons afficher
        let node = SCNNode()
        // si notre application detecte une image
        if let imageAnchor = anchor as? ARImageAnchor {
            //test
            print(imageAnchor.referenceImage.name)
            // on cree un plan sur lequel afficher la figure 3d, de meme dimension que notre image détectée
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                // on lui donne des caracteristiques : couleur blanche et transparent
                //plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            let planeMaterial = SCNMaterial()
            planeMaterial.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            plane.materials = [planeMaterial]
            
            
            // on cree une figure 3d juste au dessus du plan pour montrer que l'image a bien ete reconnue
            let planeNode = SCNNode(geometry: plane)
            // on donne la bonne orientation a cette figure
            planeNode.eulerAngles.x = -Float.pi / 2
            
            // on attache cet objet a notre figure originelle
            node.addChildNode(planeNode)
            
            //MARK: - Ici on affiche notre modele 3d de pokemon. on va gerer l'affichage de 2 cartes
            if imageAnchor.referenceImage.name == "Ajani" {
                //optional au cas ou il y a pas ce document
                if let pokeScene = SCNScene(named: "art.scnassets/eevee.scn") {
                    // dans ce cas et uniquement si possible (optional)
                    if let pokeNode = pokeScene.rootNode.childNodes.first {
                        // on ajuste l'orientation de la figure en premier
                        pokeNode.eulerAngles.x = Float.pi / 2
                        // on l'ajoute au plane node
                        planeNode.addChildNode(pokeNode)
                    }
                }
                
            }
            else if imageAnchor.referenceImage.name == "Hydre" {
                // on refait la meme chose
                if let secondPokeScene = SCNScene(named: "art.scnassets/oddish.scn") {
                    //
                    if let secondPokeNode = secondPokeScene.rootNode.childNodes.first {
                        //
                        secondPokeNode.eulerAngles.x = Float.pi / 2
                        //
                        planeNode.addChildNode(secondPokeNode)
                    }
                }
            }
        }
        
        return node
    }
    

}
