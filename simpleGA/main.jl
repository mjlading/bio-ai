include("simple_ga.jl")

using Plots

# Start by generating a random initial population
population_size = 20
mutation_rate = 0.05
crossover_rate = 0.8 #TODO
n_generations = 100

println("Generating random population")
population = generate_random_population(population_size)
println.(population.individuals)

# Main evolution cycle
for generation in 1:n_generations
    println("\nGeneration $generation")

    parents = select_parents_roulette(population)
    offspring = crossover_single_point(parents)
    post_mutation_offspring = mutate(offspring, mutation_rate)

    println("average offspring fitness: ", mean(i -> i.fitness, post_mutation_offspring))

    replace_generation!(population, post_mutation_offspring)
end

println.(population.individuals)

best_individual = get_best_individual(population)
@show best_individual
