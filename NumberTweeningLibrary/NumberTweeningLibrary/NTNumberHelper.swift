//
//  NTConsts.swift
//  NumberTweeningLibrary
//
//  Created by Michał Szyszka on 10.10.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
class NTNumberHelper {
    
    //MARK: Fields
    
    let maxVal = 208.0
    let minVal = -8.0
    
    var minWidth = Float(Int.max)
    var maxWidth = Float(Int.min)
    
    var minHeight = Float(Int.max)
    var maxHeight = Float(Int.min)
    
    var points: [[(Float, Float)]] = [
        [(44.5, 100), (100, 18), (156, 100), (100, 180), (44.5, 100)], // 0
        [(77, 20.5), (104.5, 20.5), (104.5, 181), (104.5, 181), (104.5, 181)], //1
        [(56, 60), (144.5, 61), (108, 122), (57, 177), (147, 177)], //2
        [(63.25, 54), (99.5, 18), (99.5, 96), (100, 180), (56.5, 143)], // 3
        [(155, 146), (43, 146), (129, 25), (129, 146), (129, 179)], //4
        [(146, 20), (91, 20), (72, 78), (145, 129), (45, 154)], // 5
        [(110, 20), (110, 20), (46, 126), (153, 126), (53.5, 100)], // 6
        [(47, 21), (158, 21), (120.67, 73.34), (83.34, 126.67), (46, 181)],  // 7
        [(101, 96), (101, 19), (101, 96), (101, 179), (101, 96)], // 8
        [(146.5, 100), (47, 74), (154, 74), (90, 180), (90, 180)] // 9
    ];
    
    var controlPoints1: [[(Float, Float)]] = [
        [(44.5, 60), (133, 18), (156, 140), (67, 180)], // 0
        [(77, 20.5), (104.5, 20.5), (104.5, 181), (104.5, 181)], // 1
        [(59, 2), (144.5, 78), (94, 138), (57, 177)], // 2
        [(63, 27), (156, 18), (158, 96), (54, 180)], // 3
        [(155, 146), (43, 146), (129, 25), (129, 146)], // 4
        [(91, 20), (72, 78), (97, 66), (140, 183)], // 5
        [(110, 20), (71, 79), (52, 208), (146, 66)], // 6
        [(47, 21), (158, 21), (120.67, 73.34), (83.34, 126.67)], // 7
        [(44, 95), (154, 19), (44, 96), (154, 179)], // 8
        [(124, 136), (42, 8), (152, 108), (90, 180)] // 9
    ];
    
    var controlPoints2: [[(Float, Float)]] = [
        [(67, 18), (156, 60), (133, 180), (44.5, 140)], // 0
        [(104.5, 20.5), (104.5, 181), (104.5, 181), (104.5, 181)], // 1
        [(143, 4), (130, 98), (74, 155), (147, 177)], // 2
        [(86, 18), (146, 96), (150, 180), (56, 150)], // 3
        [(43, 146), (129, 25), (129, 146), (129, 179)], // 4
        [(91, 20), (72, 78), (145, 85), (68, 198)], // 5
        [(110, 20), (48, 92), (158, 192), (76, 64)], // 6
        [(158, 21), (120.67, 73.34), (83.34, 126.67), (46, 181)], // 7
        [(44, 19), (154, 96), (36, 179), (154, 96)], // 8
        [(54, 134), (148, -8), (129, 121), (90, 180)] // 9
    ];
    
    //MARK: Inits
    
    init(frame: CGRect) {
        let smallerFrameDimension = frame.width < frame.height ? frame.width : frame.height
        normalizeNumberPoints(frameWidth: Float(smallerFrameDimension))
        
        let horizontalShift = ((Float(frame.width) - (maxWidth - minWidth)) / 2.0) - minWidth
        let verticalShift = (Float(frame.height) - (maxHeight + minHeight)) / 2.0
        
        centerDigits(&points, horizontalShift: horizontalShift, verticalShift: verticalShift)
        centerDigits(&controlPoints1, horizontalShift: horizontalShift, verticalShift: verticalShift)
        centerDigits(&controlPoints2, horizontalShift: horizontalShift, verticalShift: verticalShift)
    }
    
    //MARK: Functions
    
    func getPointsForFrame(frame: Int) -> [(Float, Float)]{
        return points[frame]
    }
    
    func getControlPoints1ForFrame(frame: Int) -> [(Float, Float)]{
        return controlPoints1[frame]
    }
    
    func getControlPoints2ForFrame(frame: Int) -> [(Float, Float)]{
        return controlPoints2[frame]
    }
    
    //MARK: Private
    
    private func normalizeNumberPoints(frameWidth: Float){
        normalizeArray(&points, frameWidth)
        normalizeArray(&controlPoints1, frameWidth)
        normalizeArray(&controlPoints2, frameWidth)
    }
    
    private func normalizeArray(_ arrayToNormalize: inout [[(Float, Float)]], _ frameWidth: Float){
        let valueRange = Float(maxVal - minVal)
        for i in 0..<arrayToNormalize.count{
            for j in 0..<arrayToNormalize[i].count{
                var pointRow = arrayToNormalize[i]
                var pointTuples = pointRow[j]
                
                pointTuples.0 /= valueRange
                pointTuples.1 /= valueRange
                
                pointTuples.0 *= frameWidth
                pointTuples.1 *= frameWidth
                
                maxWidth = max(maxWidth, pointTuples.0)
                minWidth = min(minWidth, pointTuples.0)
                
                maxHeight = max(maxHeight, pointTuples.1)
                minHeight = min(minHeight, pointTuples.1)
                
                arrayToNormalize[i][j] = pointTuples
            }
        }
    }
    
    private func centerDigits(_ arrayToNormalize: inout [[(Float, Float)]], horizontalShift: Float, verticalShift: Float){
        for i in 0..<arrayToNormalize.count{
            for j in 0..<arrayToNormalize[i].count{
                var pointRow = arrayToNormalize[i]
                var pointTuples = pointRow[j]
                
                pointTuples.0 += horizontalShift
                pointTuples.1 += verticalShift
                
                arrayToNormalize[i][j] = pointTuples
            }
        }
    }
}
