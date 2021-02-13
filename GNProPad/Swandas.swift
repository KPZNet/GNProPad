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

    func RandomColor() -> UIColor {
        
        let rBlue = Double.random(in: 0...255)
        let rGreen = Double.random(in: 0...255)
        let rRed = Double.random(in: 0...255)
        let kolor = UIColor(red: CGFloat((rRed/255.0)), green: CGFloat((rGreen/255.0)), blue: CGFloat((rBlue/255.0)), alpha: 1.0)
        return kolor
    }
    
    func GetGNXYDataSetFromFile(fileName : String, fileExt:String) ->XYGNDataSet
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

