//
//  ViewController.swift
//  CustomSliderDemo
//
//  Created by Unikwork on 23/07/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scaleView: ScaleView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        scaleView.onMonthSelected = { month in print("Selected month: \(month)") }
    }
}

class ScaleView: UIView {
    private let numIntervals = 12 // 12 months, 11 intervals between them
    private let startEndSpacing: CGFloat = 20.0
    private let markerRadius: CGFloat = 5
    private let lineColor = UIColor.gray
    private let markerColor = UIColor.systemPink
    private var markerPosition: Int = Calendar.current.component(.month, from: Date()) - 1
    private let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var onMonthSelected: ((String) -> Void)?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let width = bounds.width
        let height = bounds.height
        let lineY = height / 2
        let interval = (width - 2 * startEndSpacing) / CGFloat(numIntervals - 1)
        
        // Draw horizontal line
        context.setStrokeColor(lineColor.cgColor)
        context.setLineWidth(2.0)
        context.move(to: CGPoint(x: 0, y: lineY))
        context.addLine(to: CGPoint(x: width, y: lineY))
        context.strokePath()
        
        // Draw vertical lines and month labels
        for i in 0..<numIntervals {
            let x = startEndSpacing + CGFloat(i) * interval
            context.move(to: CGPoint(x: x, y: lineY))
            context.addLine(to: CGPoint(x: x, y: lineY + 10))
            context.strokePath()
            
            // Draw month label
            let month = months[i]
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.gray
            ]
            let textSize = month.size(withAttributes: attributes)
            let textRect = CGRect(x: x - textSize.width / 2, y: lineY + 15, width: textSize.width, height: textSize.height)
            month.draw(in: textRect, withAttributes: attributes)
        }
        
        // Draw marker
        let markerX = startEndSpacing + CGFloat(markerPosition) * interval
        context.setFillColor(markerColor.cgColor)
        context.addArc(center: CGPoint(x: markerX, y: lineY), radius: markerRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        context.fillPath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }
    
    private func handleTouch(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let x = touch.location(in: self).x
        let interval = (bounds.width - 2 * startEndSpacing) / CGFloat(numIntervals - 1)
        let exactPosition = (x - startEndSpacing) / interval
        let selectedPosition = max(0, min(numIntervals - 1, Int(round(exactPosition))))
        if markerPosition != selectedPosition {
            markerPosition = selectedPosition
            setNeedsDisplay()
            onMonthSelected?(months[selectedPosition])
        }
    }
}
