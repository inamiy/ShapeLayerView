//
//  ViewController.swift
//  ShapeLayerView
//
//  Created by Yasuhiro Inami on 2017-11-12.
//  Copyright © 2017 Yasuhiro Inami. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var shapeLayerView: ShapeLayerView!
    @IBOutlet weak var shapeMaskedView: ShapeMaskedView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.shapeLayerView.path = UIBezierPath(rect: self.shapeLayerView.bounds)
        self.shapeLayerView.layer.fillColor = UIColor.white.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self._showAlert {
                UIView.animate(withDuration: 2, animations: {
                    self._updateShapePath()
                })
            }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        coordinator.animate(alongsideTransition: { _ in
            self._updateShapePath()
        })

        super.viewWillTransition(to: size, with: coordinator)
    }

    private func _updateShapePath()
    {
        let path = UIBezierPath(ovalIn: self.shapeLayerView.bounds.insetBy(dx: 30, dy: 30))
        self.shapeLayerView.path = path
        self.shapeMaskedView.maskPath = path
    }

    private func _showAlert(completion: @escaping () -> ())
    {
        let alert = UIAlertController(title: "Change orientation", message: "to see smooth CAShapeLayer animation", preferredStyle: .alert)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismiss(animated: true, completion: completion)
            }
        }
    }
}
