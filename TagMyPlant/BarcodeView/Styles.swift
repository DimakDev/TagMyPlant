//
//  Styles.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 29.06.21.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .font(.callout)
            .foregroundColor(Color.primary)
            .background(Color.accentColor)
            .cornerRadius(40.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct PrimaryLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label(configuration)
            .padding(10)
            .font(.callout)
            .foregroundColor(Color.primary)
            .background(Color.accentColor)
            .cornerRadius(40.0)
    }
}
