//
//  ProductListView.swift
//  Splitpay
//
//  Created by Cliff Chan on 2/7/2023.
//

import SwiftUI
//
//struct ProductListView: View {
//    @Binding var products: [Product]
//    @Binding var selectedProducts: [Product]
//    
//    var body: some View {
//        List(products) { product in
//            HStack {
//                Text(product.name)
//                Spacer()
//                Text("$\(String(format: "%.2f", product.price as NSNumber))")
//                
//                Stepper(value: selectedQuantity(for: product), in: 0...Int.max) {
//                    Text("\(selectedQuantity(for: product).wrappedValue)")
//                }
//            }
//        }
//    }
//    
//    private func selectedQuantity(for product: Product) -> Binding<Int> {
//        let index = selectedProducts.firstIndex { $0.id == product.id }
//        return Binding<Int>(
//            get: {
//                guard let index = index else { return 0 }
//                return selectedProducts[index].quantity
//            },
//            set: { newValue in
//                guard let index = index else { return }
//                selectedProducts[index].quantity = newValue
//            }
//        )
//    }
//}
