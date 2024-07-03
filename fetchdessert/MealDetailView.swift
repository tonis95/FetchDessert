//
//  MealDetailView.swift
//  fetchdessert
//
//  Created by Antonio Saenz on 7/2/24.
//

import SwiftUI

struct MealDetailView: View {
    
    let mealID: String
    @StateObject private var viewModel = DetailViewModel()
    
    var body: some View {
        VStack {
            if let recipes = viewModel.recipes {
            ScrollView {
                    VStack {
                        Text(recipes.strMeal)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.largeTitle)
                            .padding([.top, .leading, .trailing], 20)
                        
                        AsyncImage(url: URL(string: recipes.strMealThumb)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 300)
                                .clipShape(RoundedRectangle(cornerSize: /*@START_MENU_TOKEN@*/CGSize(width: 20, height: 10)/*@END_MENU_TOKEN@*/))
                        } placeholder: {
                            Circle()
                                .fill(.gray)
                                .frame(width: 300, height: 300)
                        }
                        
                        Text("Instructions")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.title3)
                            .padding()
                        Text(recipes.strInstructions)
                            .padding([.bottom, .trailing, .leading], 30)
                        
                        Text("Recipe")
                            .fontWeight(.bold)
                            .font(.title3)
                        ForEach(1...20, id: \.self) { index in
                            if let ingredient = recipes.value(forKey: "strIngredient\(index)") as? String,
                               !ingredient.isEmpty,
                               let measure = recipes.value(forKey: "strMeasure\(index)") as? String,
                               !ingredient.isEmpty {
                                HStack {
                                    Text("\(ingredient):")
                                        .fontWeight(.semibold)
                                    Text("\(measure)")
                                }
                                .frame(width: 300, height: 20, alignment: .leading)
                                //Text("\(ingredient): \(measure)")
                            }
                        }
                    }
                } //end of scroll view
            }
        }
        .task 
        {
            await viewModel.loadRecipe(mealID: mealID)
        }
    }
}

extension Recipe {
    func value(forKey key: String) -> Any? {
        return Mirror(reflecting: self).children.first { $0.label == key }?.value
    }
}

#Preview {
    MealDetailView(mealID: "53049")
}
