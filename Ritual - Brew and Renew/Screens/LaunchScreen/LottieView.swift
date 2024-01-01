//
//  LottieView.swift
//  Ritual
//
//  Created by Tyler Rhodes on 10/5/23.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode
    var animationSpeed: CGFloat

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFit // Maintain aspect ratio
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            animationView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        animationView.play()
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

