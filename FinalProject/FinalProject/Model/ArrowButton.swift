//
//  ArrowButton.swift
//  FinalProject
//
//  Created by Maria Andreea on 21.03.2022.
//

import UIKit


@IBDesignable
class ArrowButton: UIButton {

        @IBInspectable var fillColor : UIColor = UIColor.red
        @IBInspectable var lineWidth : CGFloat =  2.0

        enum Direction{
            case up , down
        }

       var direction : Direction = Direction.up{
            didSet {
                review()
            }
        }

        func review(){
            setNeedsDisplay()
        }

         func directionToRadians(_ direction: ArrowButton.Direction) -> CGFloat{
            switch direction {
            case .up:
                return ArrowButton.degreesToRadians(90)
            case .down:
                return ArrowButton.degreesToRadians(-90)
            }
        }


        static func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
            return degrees  * CGFloat(Double.pi) / 180
        }

        override func draw(_ rect: CGRect) {
            let origin = CGPoint(x:0, y:self.frame.height / 2)
            let path = UIBezierPath()
            path.lineJoinStyle = CGLineJoin.round
            path.move(to: CGPoint(x:origin.x + self.frame.width * (1/2), y: frame.height - 13))
            path.addLine(to: CGPoint(x: origin.x , y: origin.y))
            path.addLine(to: CGPoint(x: origin.x + self.frame.width * (1/2), y:13))
            path.addLine(to: CGPoint(x: origin.x , y: origin.y ))
            path.addLine(to: CGPoint(x: origin.x + self.frame.width * 12, y: 0))
            fillColor.setStroke()
            path.lineWidth = lineWidth
            path.stroke()
            self.backgroundColor = UIColor.clear
            self.transform = CGAffineTransform(rotationAngle: directionToRadians(self.direction))

            let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 2, width: 40, height: 8))
            rectanglePath.stroke()
            




        }


}
