//
//  ProductSelectPage.swift
//  Splitpay
//
//  Created by Cliff Chan on 2/7/2023.
//

import SwiftUI

struct ProductSelectPage: View {
    @Binding var user: User
    @StateObject private var cart = Cart()
    
    let products: [Product]
    
    var body: some View {
        VStack {
            List(products) { product in
                HStack {
                    Text(product.name)
                    Text(formatPrice(product.price))
                    
                    Spacer()
                    
                    Stepper(value: quantity(for: product), in: 0...Int.max) {
                        Text("Qty: \(quantity(for: product).wrappedValue)")
                    }
                }
            }
            
            Button("下單") {
                placeOrder()
            }
        }
    }
    
    private func quantity(for product: Product) -> Binding<Int> {
        let quantity = Binding<Int>(
            get: {
                guard let cartItem = cart.items.first(where: { $0.product.id == product.id }) else {
                    return 0
                }
                return cartItem.quantity
            },
            set: { newValue in
                if let index = cart.items.firstIndex(where: { $0.product.id == product.id }) {
                    cart.items[index].quantity = newValue
                } else {
                    cart.items.append(CartItem(id: UUID(), product: product, quantity: newValue))
                }
            }
        )
        return quantity
    }

    private func formatPrice(_ price: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(decimal: price)) ?? ""
    }
    
    private func placeOrder() {
        let selectedProducts = cart.items.filter { $0.quantity > 0 }.map { $0.product }
        let order = Order(id: UUID(), products: selectedProducts, totalPrice: calculateTotalPrice())
        user.orders.append(order)
        
        printOrderDetails()
        
        // Clear cart and selected products
        cart.items.removeAll()
        user.selectedProducts.removeAll()
    }
    
    private func calculateTotalPrice() -> Decimal {
        let total = cart.items.reduce(0) { $0 + Decimal($1.quantity) * $1.product.price }
        return total
    }
    
    private func printOrderDetails() {
        print("User: \(user.name)")
        print("Total Orders: \(user.orders.count)")
        
        for order in user.orders {
            print("Order ID: \(order.id)")
            print("Total Price: $\(String(format: "%.2f", order.totalPrice as NSNumber))")
            
            print("Products:")
            for product in order.products {
                print("- \(product.name) - $\(String(format: "%.2f", product.price as NSNumber))")
            }
            
            print("---")
        }
        
        print("=====")
    }
}

struct ContentView: View {
    @State private var users: [User] = [
        User(id: UUID(), name: "John", selectedProducts: [], orders: []),
        User(id: UUID(), name: "Alice", selectedProducts: [], orders: []),
        User(id: UUID(), name: "Bob", selectedProducts: [], orders: [])
    ]

    
    @State private var selectedUserID: UUID = UUID()
       
    var selectedUser: User {
       users.first(where: { $0.id == selectedUserID }) ?? users[0]
    }

    var body: some View {
       VStack {
           ScrollView(.horizontal) {
               LazyHStack(spacing: 10) {
                   ForEach(users) { user in
                       Button(action: {
                           selectedUserID = user.id
                       }) {
                           Text(user.name)
                               .foregroundColor(user.id == selectedUserID ? .blue : .black)
                       }
                   }
               }
               .padding(.leading, 10)
           }
           .frame(height: 100)
           Button("新增用戶") {
               let newUser = User(id: UUID(), name: "新用戶", selectedProducts: [], orders: [])
               users.append(newUser)
               selectedUserID = newUser.id
           }
           
           ProductSelectPage(user: Binding(get: {
               selectedUser
           }, set: { newValue in
               if let index = users.firstIndex(where: { $0.id == selectedUserID }) {
                   users[index] = newValue
               }
           }), products: productData)
       }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
