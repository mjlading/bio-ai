using Statistics

const GENOME_LENGTH = 8

# Decodes a genome to the corresponding phenome
function decode(genome::Vector{Int})
    return foldl((acc, bit) -> acc * 2 + bit, genome, init=0)
end

function fitness(phenome::Int)
    return phenome^2
end

# Individuals are static
struct Individual
    genome::Vector{Int} # TODO can be optimized into Vector{Bool} or BitArray
    phenome::Int
    fitness::Int

    function Individual(genome::Vector{Int})
        length(genome) == GENOME_LENGTH || throw(ArgumentError("Genome must have length $GENOME_LENGTH but was $(length(genome))"))
        phenome = decode(genome)
        fitness_ = fitness(phenome)
        new(genome, phenome, fitness_)
    end
end

# Population is dynamic
mutable struct Population
    individuals::Vector{Individual}
end

function generate_random_individual()
    random_genome = [rand(0:1) for _ in 1:GENOME_LENGTH]
    return Individual(random_genome)
end

# Generates a random population using binary representation
function generate_random_population(n::Int)
    individuals = [generate_random_individual() for _ in 1:n]
    return Population(individuals)
end

# Roulette wheel selection
function select_parents_roulette(population::Population)
    total_fitness = sum(individual -> individual.fitness, population.individuals)
    selection_probas = [individual.fitness / total_fitness for individual in population.individuals]
    cumulative_probas = accumulate(+, selection_probas)

    # Select n parents from population of size n
    parents::Vector{Individual} = []
    for _ in 1:length(population.individuals)
        r = rand()
        selected_index = findfirst(x -> x > r, cumulative_probas)
        selected_individual::Individual = population.individuals[selected_index]
        push!(parents, selected_individual)
    end

    # println("average population fitness: ", mean(i -> i.fitness, population.individuals))
    # println("average parents fitness: ", mean(i -> i.fitness, parents))

    return parents
end

# Single point crossover that takes two parents and returns their offspring
function crossover_single_point(parent1::Individual, parent2::Individual)
    crossover_point = rand(2:GENOME_LENGTH-1)

    head1 = parent1.genome[1:crossover_point]
    head2 = parent2.genome[1:crossover_point]
    tail1 = parent1.genome[crossover_point+1:end]
    tail2 = parent2.genome[crossover_point+1:end]

    offspring1_genome = [head1; tail2]
    offspring2_genome = [head2; tail1]

    offspring1 = Individual(offspring1_genome)
    offspring2 = Individual(offspring2_genome)

    return [offspring1, offspring2]
end

# Single point crossover that takes list of parents and returns offspring
function crossover_single_point(parents::Vector{Individual})
    offspring::Vector{Individual} = []

    for i in 1:2:(length(parents)-1)
        append!(offspring, crossover_single_point(parents[i], parents[i+1]))
    end

    return offspring
end

# bit-flip mutation
function mutate(individual::Individual)
    bit_index = rand(1:GENOME_LENGTH)
    new_genome = individual.genome
    new_genome[bit_index] = (individual.genome[bit_index] == 1) ? 0 : 1
    return Individual(new_genome)
end

function mutate(individuals::Vector{Individual}, mutation_rate::Float64)
    post_mutation_individuals::Vector{Individual} = []

    for individual in individuals
        if rand() < mutation_rate
            push!(post_mutation_individuals, mutate(individual))
        else
            push!(post_mutation_individuals, individual)
        end
    end

    return post_mutation_individuals
end

# Generational replacement, parents are fully replaced by their offspring
function replace_generation!(population::Population, offspring::Vector{Individual})
    length(population.individuals) == length(offspring) || throw(ArgumentError("Offspring size must match population size"))
    population.individuals = offspring
end

function get_best_individual(population::Population)
    return population.individuals[findmax(i -> i.fitness, population.individuals)[2]]
end

# Start by generating a random initial population
population_size = 10
mutation_probability = 0.8
crossover_probability = 0.8 #TODO

println("Generating random population")
population = generate_random_population(population_size)
println.(population.individuals)

# Main evolution cycle
for generation in 1:10
    println("--- Generation $generation ---")

    parents = select_parents_roulette(population)
    offspring = crossover_single_point(parents)
    post_mutation_offspring = mutate(offspring, mutation_probability)

    println("average offspring fitness: ", mean(i -> i.fitness, post_mutation_offspring)) #TODO use sum for efficiency

    replace_generation!(population, post_mutation_offspring)
end

println.(population.individuals)

best_individual = get_best_individual(population)
@show best_individual

