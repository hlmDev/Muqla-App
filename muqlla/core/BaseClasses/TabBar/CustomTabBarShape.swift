//
//  CustomTabBarShape.swift
//  muqlla
//
//  Created by Mohammad Alturbaq on 16/02/2025.
//

import Foundation


// MARK: - Tab Bar Cutout Shape
//struct CustomTabBarShape: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        let curveHeight: CGFloat = 50
//        let curveWidth: CGFloat = 100
//        let center = rect.width / 2
//
//        path.move(to: .zero)
//
//        path.addLine(
//            to: CGPoint(
//                x: (center - curveWidth / 2) - 50,
//                y: -10
//            )
//        )
//
//        path.addQuadCurve(
//            to: CGPoint(
//                x: (center - curveWidth / 2) + 15,
//                y: 0
//            ),
//            control: CGPoint(
//                x: (center - curveWidth / 2) + 5,
//                y: -20
//            )
//        )
//
//        path.addQuadCurve(
//            to: CGPoint(
//                x: (center + curveWidth / 2) - 50,
//                y: -10
//            ),
//            control: CGPoint(
//                x: center,
//                y: curveHeight
//            )
//        )
//        path.addQuadCurve(
//            to: CGPoint(
//                x: (center + curveWidth / 2) - 50,
//                y: 10
//            ),
//            control: CGPoint(
//                x: (center + curveWidth / 2) + 10,
//                y: 20
//            )
//        )
//        path.addLine(
//            to: CGPoint(
//                x: rect.width,
//                y: 0
//            )
//        )
//
//
//        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
//        path.addLine(to: CGPoint(x: 0, y: rect.height))
//        path.closeSubpath()
//        return path
//    }
//}
