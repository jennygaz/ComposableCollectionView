//
//  BentoCollectionView.swift
//  Bento
//
//  Created by Jenny Gallegos Cardenas on 16/10/24.
//

import SwiftUI
import UIKit

struct BentoCollectionView: UIViewControllerRepresentable {
    var elements: Binding<[String]>

    func makeUIViewController(context: Context) -> BentoCollectionViewController {
        let vc = BentoCollectionViewController(
            elements: elements.wrappedValue,
            delegate: context.coordinator)
        return vc
    }

    func updateUIViewController(_ uiViewController: BentoCollectionViewController, context: Context) {
//        print("Updating... current list is \(elements.wrappedValue)")
        uiViewController.updateItems(diffingWith: elements.wrappedValue)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: BentoCollectionViewDelegate {
        var parent: BentoCollectionView

        init(parent: BentoCollectionView) {
            self.parent = parent
        }

        func updateItems(diffingWith newItems: [String]) {
            
        }
    }
}

@available(iOS 17, *)
#Preview {
    @Previewable @State var items: [String] = [
        "stock_image_01",
        "stock_image_02",
        "stock_image_03",
        "stock_image_04",
        "stock_image_05",
        "stock_image_06",
        "stock_image_07",
        "stock_image_08",
        "stock_image_09",
        "stock_image_10"
    ]
    BentoCollectionView(elements: $items)
        .task {
            try? await Task.sleep(for: .seconds(5))
            withAnimation{
                items.removeAll { $0 == "stock_image_06" }
                items.append(contentsOf: [
                    "stock_image_11",
                    "stock_image_12",
                    "stock_image_01"
                ])
            }
        }
}
