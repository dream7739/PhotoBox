//
//  ChartView.swift
//  Polaroid
//
//  Created by 홍정민 on 7/28/24.
//

import SwiftUI
import Charts


struct ChartView: View {
    var data: [HistoricalValue] = []
    
    var body: some View {
        let curColor = Color(UIColor.theme_blue)
        let curGradient = LinearGradient(
            gradient: Gradient (
                colors: [
                    curColor.opacity(0.7),
                    curColor.opacity(0.5),
                    curColor.opacity(0.3)
                ]
            ),
            startPoint: .top, endPoint: .bottom)
        
        if #available(iOS 16.0, *) {
            Chart {
                ForEach(data) { shape in
                    LineMark(
                        x: .value("", shape.date),
                        y: .value("", shape.value)
                    )
                    .foregroundStyle(curColor)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("", shape.date),
                        y: .value("", shape.value)
                    )
                    .foregroundStyle(curGradient)
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    ChartView()
}
