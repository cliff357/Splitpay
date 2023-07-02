//
//  ProductSelectPage.swift
//  Splitpay
//
//  Created by Cliff Chan on 2/7/2023.
//

import SwiftUI

struct ProductSelectPage: View {
    @Binding var user: User
    @StateObject var cart: Cart
    
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
                printCartItemDetails(for: product)
                updateUserOrder()
            }
        )
        return quantity
    }
    
    private func updateUserOrder() {
        let selectedProducts = cart.items.filter { $0.quantity > 0 }.map { $0.product }
        let order = Order(id: UUID(), products: selectedProducts, totalPrice: calculateTotalPrice())
        user.orders.append(order)
    }
    
    private func printCartItemDetails(for product: Product) {
        if let cartItem = cart.items.first(where: { $0.product.id == product.id }) {
            print("點擊 stepper")
            print("Product: \(product.name)")
            print("Quantity: \(cartItem.quantity)")
            print("=====")
        }
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
        
        // Reset cart
        cart.reset()
    }
    
    private func calculateTotalPrice() -> Decimal {
        let total = cart.items.reduce(0) { $0 + Decimal($1.quantity) * $1.product.price }
        return total
    }
    
    
    
    private func printOrderDetails() {
        print("點撃下單")
        print("User: \(user.name)")
        print("Total Orders: \(user.orders.count)")
        
        for order in user.orders {
            print("Order ID: \(order.id)")
            print("Total Price: \(formatPrice(order.totalPrice))")
            
            print("Products:")
            for cartItem in cart.items {
                let product = cartItem.product
                let quantity = cartItem.quantity
                print("- \(product.name) - \(quantity) Qty - \(formatPrice(product.price))")
            }
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
    
    @StateObject private var cart = Cart()
    @State private var selectedUserIndex: Int = 0
    
    var selectedUser: User {
        users[selectedUserIndex]
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(users) { user in
                        Button(action: {
                            if let index = users.firstIndex(of: user) {
                                selectedUserIndex = index
                            }
                        }) {
                            Text(user.name)
                                .foregroundColor(user.id == selectedUser.id ? .blue : .black)
                        }
                    }
                }
                .padding(.leading, 10)
            }
            .frame(height: 100)
            
            Button("新增用戶") {
                let newUser = User(id: UUID(), name: "新用戶", selectedProducts: [], orders: [])
                users.append(newUser)
                selectedUserIndex = users.count - 1
            }
            
            ProductSelectPage(user: $users[selectedUserIndex], cart: cart, products: productData)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
