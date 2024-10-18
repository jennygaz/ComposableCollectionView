//
//  BentoCell.swift
//  Bento
//
//  Created by Jenny Gallegos Cardenas on 16/10/24.
//

import SwiftUI

struct BentoCell: View {
    let items: [String]

    var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .center, spacing: 12) {
                    Image(items[0])
                        .resizable()
                        .scaledToFit()
                        .background(Color.red.opacity(0.2))
//                        .frame(
//                            width: proxy.frame(in: .local).width * 2 / 3,
//                            height: proxy.frame(in: .local).height * 1 / 2,
//                            alignment: .center)
                    HStack(alignment: .center, spacing: 12) {
                        Image(items[2])
                            .resizable()
                            .scaledToFit()
//                            .frame(width: proxy.frame(in: .local).width * 1 / 3,
//                                   height: proxy.frame(in: .local).height * 1 / 2,
//                                   alignment: .center)
                        Image(items[3])
                            .resizable()
                            .scaledToFit()
//                            .frame(width: proxy.frame(in: .local).width * 1 / 3,
//                                   height: proxy.frame(in: .local).height * 1 / 2,
//                                   alignment: .center)
                    }
                    .background(Color.orange.opacity(0.2))
                }
                .background(Color.green.opacity(0.2))
                Image(items[1])
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.frame(in: .global).width * 1 / 3,
                           alignment: .center)
                    .background(Color.blue.opacity(0.2))
            }
//            .frame(width: proxy.frame(in: .global).width, height: proxy.frame(in: .global).height * 1 / 3, alignment: .center)
            .background(Color.brown.opacity(0.1))
        }
    }
}

@available(iOS 17, *)
#Preview {
    @Previewable @State var items: [String] = [
        "stock_image_01",
        "stock_image_02",
        "stock_image_03",
        "stock_image_04"
    ]
    BentoCell(items: items)
}
