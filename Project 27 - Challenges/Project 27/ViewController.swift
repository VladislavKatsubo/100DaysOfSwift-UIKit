//
//  ViewController.swift
//  Project 27
//
//  Created by Vlad Katsubo on 6/16/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 8 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawTwins()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImageAndText()
        case 6:
            drawSmile()
        case 7:
            drawStar()
        case 8:
            drawRectangle()
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 25, dy: 25)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }

    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 25, dy: 25)
            
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let leftEye = CGRect(x: 150, y: 128, width: 50, height: 100)
            ctx.cgContext.setFillColor(UIColor.systemOrange.cgColor)
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.drawPath(using: .fill)
            
            let rightEye = CGRect(x: 311, y: 128, width: 50, height: 100)
            ctx.cgContext.setFillColor(UIColor.systemOrange.cgColor)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.drawPath(using: .fill)
            
            ctx.cgContext.move(to: CGPoint(x: 150, y: 324))
            ctx.cgContext.addQuadCurve(to: CGPoint(x: 361, y: 324), control: CGPoint(x: 255, y: 400))
            ctx.cgContext.addLine(to: CGPoint(x: 361, y: 324))
            ctx.cgContext.drawPath(using: .fill)
//            ctx.cgContext.addCurve(to: CGPoint(x: 361, y: 324), control1: CGPoint(x: 255, y: 364), control2: CGPoint(x: 255, y: 364))
            
            
            
            
            
            
        }
        
        imageView.image = image
    }
    
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col).isMultiple(of: 2) {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
            
            
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 4
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: amount)
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.cyan.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
        
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 200
            
            for i in 0 ..< 200 {
                ctx.cgContext.rotate(by: .pi / 6)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    print(i, length)
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawImageAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle,
                .foregroundColor : UIColor.white.cgColor
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
            
        }
        
        imageView.image = image
    }
    
    func drawSmile() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 25, dy: 25)
            
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let leftEye = CGRect(x: 150, y: 128, width: 50, height: 100)
            ctx.cgContext.setFillColor(UIColor.systemOrange.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let rightEye = CGRect(x: 311, y: 128, width: 50, height: 100)
            ctx.cgContext.setFillColor(UIColor.systemOrange.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.move(to: CGPoint(x: 150, y: 324))
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.addQuadCurve(to: CGPoint(x: 361, y: 324), control: CGPoint(x: 255, y: 400))
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.move(to: CGPoint(x: 150, y: 324))
            ctx.cgContext.addLine(to: CGPoint(x: 361, y: 324))
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = image
    }
    
//    func drawStar() {
//        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
//
//        let image = renderer.image { ctx in
//        ctx.cgContext.translateBy(x: 256, y: 256)
//
//            for _ in 1...6 {
//                ctx.cgContext.rotate(by: .pi / 5)
//                ctx.cgContext.move(to: CGPoint(x: 0, y: 0))
//                ctx.cgContext.addLine(to: CGPoint(x: 100, y: 0))
//            }
//
//        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
//        ctx.cgContext.strokePath()
//        }
//
//        imageView.image = image
//    }
    
    func drawStar() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            var first = true

            for _ in 1...5 {
                if first {
                    ctx.cgContext.move(to: CGPoint(x: -30, y: -40))
                    ctx.cgContext.addLine(to: CGPoint(x: 0, y: -100))
                    ctx.cgContext.move(to: CGPoint(x: 30, y: -40))
                    ctx.cgContext.addLine(to: CGPoint(x: 0, y: -100))
                    first = false
                } else {
                    ctx.cgContext.rotate(by: .pi / 2.5)
                    ctx.cgContext.move(to: CGPoint(x: -30, y: -40))
                    ctx.cgContext.addLine(to: CGPoint(x: 0, y: -100))
                    ctx.cgContext.move(to: CGPoint(x: 30, y: -40))
                    ctx.cgContext.addLine(to: CGPoint(x: 0, y: -100))
                }
            }
            
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.setFillColor(UIColor.systemOrange.cgColor)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        
        imageView.image = image
    }
    
    func drawTwins() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            
            let topLine = 128
            let bottomLine = 384
            
            let middle = 256
            let letterWidth = 122
            let offset = 38
            
            // T letter - hat
            ctx.cgContext.move(to: CGPoint(x: 0, y: topLine))
            ctx.cgContext.addLine(to: CGPoint(x: letterWidth, y: topLine))
            // T letter - stick
            ctx.cgContext.move(to: CGPoint(x: letterWidth / 2, y: topLine))
            ctx.cgContext.addLine(to: CGPoint(x: letterWidth / 2 , y: bottomLine))
            
            // W letter
            //1
            let sectionWidth = letterWidth / 4
            ctx.cgContext.move(to: CGPoint(x: offset + letterWidth, y: topLine))
            ctx.cgContext.addLine(to: CGPoint(x: offset + letterWidth + sectionWidth, y: bottomLine))
            //2
            ctx.cgContext.move(to: CGPoint(x: offset + letterWidth + sectionWidth, y: bottomLine))
            ctx.cgContext.addLine(to: CGPoint(x: offset + letterWidth + sectionWidth * 2, y: middle))
            //3
            ctx.cgContext.move(to: CGPoint(x: offset + letterWidth + sectionWidth * 2, y: middle))
            ctx.cgContext.addLine(to: CGPoint(x: offset + letterWidth + sectionWidth * 3, y: bottomLine))
            //4
            ctx.cgContext.move(to: CGPoint(x: offset + letterWidth + sectionWidth * 3, y: bottomLine))
            ctx.cgContext.addLine(to: CGPoint(x: offset + letterWidth + sectionWidth * 4, y: topLine))
            let secondLetterLastPoint = offset + letterWidth + sectionWidth * 4
            
            //I letter
            //hat
            ctx.cgContext.move(to: CGPoint(x: offset + secondLetterLastPoint, y: topLine))
            ctx.cgContext.addLine(to: CGPoint(x: offset + secondLetterLastPoint + sectionWidth, y: topLine))
            //stick
            ctx.cgContext.move(to: CGPoint(x: offset + secondLetterLastPoint + sectionWidth / 2, y: topLine))
            ctx.cgContext.addLine(to: CGPoint(x: offset + secondLetterLastPoint + sectionWidth / 2, y: bottomLine))
            //bottom
            ctx.cgContext.move(to: CGPoint(x: offset + secondLetterLastPoint, y: bottomLine))
            ctx.cgContext.addLine(to: CGPoint(x: offset + secondLetterLastPoint + sectionWidth, y: bottomLine))
            let thirdX = offset + secondLetterLastPoint + sectionWidth
            
            //N letter
            //1 straight
            ctx.cgContext.move(to: CGPoint(x: thirdX + offset, y: topLine))
            ctx.cgContext.addLine(to: CGPoint(x: thirdX + offset, y: bottomLine))
            //2 slash
            ctx.cgContext.move(to: CGPoint(x: thirdX + offset, y: topLine))
            ctx.cgContext.addLine(to: CGPoint(x: thirdX + offset + letterWidth, y: bottomLine))
            //3 straight
            ctx.cgContext.move(to: CGPoint(x: thirdX + offset + letterWidth, y: bottomLine))
            ctx.cgContext.addLine(to: CGPoint(x: thirdX + offset + letterWidth, y: topLine))
            
            
            
            ctx.cgContext.setLineWidth(2)
            ctx.cgContext.setStrokeColor(UIColor.brown.cgColor)
            ctx.cgContext.drawPath(using: .stroke)
        }
        
        imageView.image = image
    }
    
    
}

