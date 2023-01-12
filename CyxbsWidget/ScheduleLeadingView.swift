//
//  ScheduleLeadingView.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2022/12/31.
//  Copyright © 2022 Redrock. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ScheduleLeadingView: View {
    var month: String
    var range: Range<Int>
    var height: CGFloat
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        GeometryReader { entry in
            VStack(spacing: 0) {
                TypeText(month)
                    .frame(height: height)
                ForEach(range, id:\.self) { index in
                    TypeText("\(index)")
                        .frame(height: (entry.size.height - height) / CGFloat(range.upperBound - range.lowerBound))
                }
            }
        }
    }
}

extension ScheduleLeadingView {
    func TypeText(_ str: String) -> some View{
        var color: Color {
            switch scheme {
            case .light:
                return Color(red: 0.082, green: 0.192, blue: 0.357, opacity: 1)
            case .dark:
                return Color(red: 0.941, green: 0.941, blue: 0.949, opacity: 1)
            @unknown default:
                return .clear
            }
        }
        
        return Text(str)
            .font(.system(size: 12))
            .foregroundColor(color)
    }
}



struct ScheduleLeadingView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleLeadingView(month: "12月", range: 1..<9, height: 46)
            .frame(width: 29)
            .padding()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}