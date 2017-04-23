//
//  SpreadSheet.swift
//  SpreadSheet
//
//  Created by Kazuya Shida on 2017/04/23.
//  Copyright © 2017 mani3. All rights reserved.
//

import UIKit

class SpreadSheet: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var horizontalView: UIScrollView!
    @IBOutlet weak var verticalView: UIScrollView!
    @IBOutlet weak var sheetView: UIScrollView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        Bundle.main.loadNibNamed(String(describing: SpreadSheet.self), owner: self, options: nil)
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sheet = LineView(frame: CGRect(x: 0, y: 0, width: sheetView.frame.width * 3, height: sheetView.frame.height * 3))
        sheet.lineColor = UIColor.orange
        sheetView.addSubview(sheet)
        sheetView.contentSize = sheet.frame.size
        
        let v = LineView(frame: CGRect(x: 0, y: 0, width: verticalView.frame.width, height: sheetView.frame.height * 3))
        v.lineColor = UIColor.magenta
        verticalView.addSubview(v)
        verticalView.contentSize = v.frame.size
        
        let h = LineView(frame: CGRect(x: 0, y: 0, width: sheetView.frame.width * 3, height: horizontalView.frame.height))
        h.lineColor = UIColor.cyan
        horizontalView.addSubview(h)
        horizontalView.contentSize = h.frame.size
    }
}

extension SpreadSheet: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(horizontalView) {
            if !sheetView.isDragging && !sheetView.isDecelerating {
                sheetView.setContentOffset(
                    CGPoint(x: horizontalView.contentOffset.x, y: sheetView.contentOffset.y),
                    animated: false
                )
            }
        } else if scrollView.isEqual(verticalView) {
            if !sheetView.isDragging && !sheetView.isDecelerating {
                sheetView.setContentOffset(
                    CGPoint(x: sheetView.contentOffset.x, y: verticalView.contentOffset.y),
                    animated: false
                )
            }
        } else {
            if !horizontalView.isDragging && !horizontalView.isDecelerating {
                horizontalView.setContentOffset(
                    CGPoint(x: sheetView.contentOffset.x, y: horizontalView.contentOffset.y),
                    animated: false
                )
            }
            if !verticalView.isDragging && !verticalView.isDecelerating {
                verticalView.setContentOffset(
                    CGPoint(x: verticalView.contentOffset.x, y: sheetView.contentOffset.y),
                    animated: false
                )
            }
        }
    }
}

class LineView: UIView {
    
    var lineColor: UIColor = UIColor.magenta
    
    override func draw(_ rect: CGRect) {
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return }
        let interval: CGFloat = 100
        
        let countX: Int = Int(round(rect.width / interval))
        for i in 0..<countX {
            context.setLineDash(phase: 0, lengths: [5, 2])
            let x: CGFloat =  CGFloat(i) * interval
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: rect.height))
            context.setStrokeColor(lineColor.cgColor)
            context.strokePath()
        }
        
        let countY: Int = Int(round(rect.height / interval))
        for i in 0..<countY {
            context.setLineDash(phase: 0, lengths: [5, 2])
            let y: CGFloat =  CGFloat(i) * interval
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
            context.setStrokeColor(lineColor.cgColor)
            context.strokePath()
        }
    }
}

