//
//  ContentView.swift
//  fetchdessert
//
//  Created by Antonio Saenz on 6/27/24.
//

import SwiftUI

struct Response: Codable {
    var meals: [Meal]
}


struct Meal: Codable, Hashable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
}

struct ContentView: View {
    
    // Empty array to store meals in
    @State private var meals = [Meal]()
    
    var body: some View {
        NavigationStack {
            List(meals, id: \.idMeal) { meal in
                VStack {
                    NavigationLink(destination: MealDetailView(mealID: meal.idMeal)) {
                        HStack {
                            AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                Circle()
                                    .fill(.gray)
                                    .frame(width: 50, height: 50)
                            }
                            Text(meal.strMeal)
                        }
                    }
                }
            }
            .task {
                await loadData()
            }
            .navigationTitle("Desserts")
        }
    }
    
    // Bring meal data in from api
    func loadData() async {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data)
            {
                meals = decodedResponse.meals
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
