//
//  Swandas.swift
//  GNProPad
//
//  Created by Kenneth Ceglia on 2/10/21.
//

import Foundation
import UIKit
import GameplayKit

class TSVReader {
    
    static var iColor:Int = 0
    
    var cColors:[String] = [
                            "#FF0000",
                            "#00FF00",
                            "#0000FF",
                            "#FFFF00",
                            "#00FFFF",
                            "#FF00FF",
                            "#808080",
                            "#FF8080",
                            "#80FF80",
                            "#8080FF",
                            "#008080",
                            "#800080",
                            "#808000",
                            "#FFFF80",
                            "#80FFFF",
                            "#FF80FF",
                            "#FF0080",
                            "#80FF00",
                            "#0080FF",
                            "#00FF80",
                            "#8000FF",
                            "#FF8000",
                            "#000080",
                            "#800000",
                            "#008000"]
    
    
    init() {
        TSVReader.iColor = Int.random(in: 0..<cColors.count)
    }

    func RandomColor2() -> UIColor {
        
        let rBlue = Double.random(in: 0...255)
        let rGreen = Double.random(in: 0...255)
        let rRed = Double.random(in: 0...255)
        let kolor = UIColor(red: CGFloat((rRed/255.0)), green: CGFloat((rGreen/255.0)), blue: CGFloat((rBlue/255.0)), alpha: 1.0)
        return kolor
    }
    func RandomColor() -> UIColor{

        let s = cColors[TSVReader.iColor]
        TSVReader.iColor = TSVReader.iColor + 1
        if TSVReader.iColor > cColors.count-1 {
            TSVReader.iColor = Int.random(in: 0..<cColors.count)
        }
        return UIColor(hexString: s, alpha: 0.75)
    }
    
    func GetDataSetFromBundleResource(fileName : String, fileExt:String) ->XYGNDataSet
    {
        let dataSetXY = XYGNDataSet()
        if let url = Bundle.main.url(forResource: fileName, withExtension: fileExt)
        {
           if let fileContents = try? String(contentsOf: url)
           {
                let data = FixupFile(file: fileContents)
                let csvRows = ParseDelimitedFile(data: data, delimiter: "\t")
                let labelRow = csvRows[0]
                
                for k in 5 ..< labelRow.count{
                    dataSetXY.labels.updateValue(RandomColor(), forKey: labelRow[k])
                }
                for i in 1 ..< csvRows.count
                {
                    let r = csvRows[i]
                    if r.count < labelRow.count {
                        break
                    }
                    let _id: String = r[0]
                    let _nameID :String = r[1]
                    let _x:Float = Float(r[2]) ?? 0.0
                    let _y:Float = Float(r[3]) ?? 0.0
                    let _subType:String = r[4]
                    
                    dataSetXY.subTypes.updateValue(RandomColor(), forKey: _subType)
                    
                    var labelDict = [String:Float]()
                    for j in 5 ..< labelRow.count
                    {
                        let r_j = r[j]
                        let r_j_label = labelRow[j]
                        let rjVal = Float( r_j ) ?? 0.0
                        labelDict.updateValue(rjVal, forKey: r_j_label)
                    }
                    let xyRow = XYGNData(X: _x, Y: _y, ID: _id, NameID: _nameID, SubType: _subType, Labels: labelDict)
                    dataSetXY.dataValues.append(xyRow)
                }
           }
        }
        return dataSetXY
    }

    func FixupFile(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }

    func ParseDelimitedFile(data: String, delimiter:String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: delimiter)
            result.append(columns)
        }
        return result
    }
    
}
extension UIFont {
    func sizeOfString (_ string: NSString) -> CGSize
    {
        return string.boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude),
                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                   attributes: [NSAttributedString.Key.font: self],
                                   context: nil).size
    }
}


extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
