using Statistics

const GENOME_LENGTH = 8

# Individuals are static
struct Individual
    genome::Vector{Int} # TODO: can be optimized into Vector{Bool} or BitArray
    phenome::Int
    fitness::Int

    function Individual(genome::Vector{Int})
        length(genome) == GENOME_LENGTH || throw(ArgumentError("Genome must have length 5"))
        phenome = foldl((acc, bit) -> acc * 2 + bit, genome, init=0)
        fitness = phenome^2
        new(genome, phenome, fitness)
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
    individuals::Vector{Individual} = [generate_random_individual() for _ in 1:n]
    return Population(individuals)
end

# Roulette wheel selection
function select_parents(population::Population)
    total_fitness = sum(individual -> individual.fitness, population.individuals)
    @show total_fitness
    selection_probas = [individual.fitness / total_fitness for individual in population.individuals]
    println.(selection_probas)

    println("---")
    cumulative_probas = accumulate(+, selection_probas)
    println.(cumulative_probas)

    # Select n paretns from population of size n
    parents = []
    for _ in 1:length(population.individuals)
        r = rand()
        # @show r
        selected_index = findfirst(x -> x > r, cumulative_probas)
        # @show selected_index
        selected_individual = population.individuals[selected_index]
        # @show selected_individual
        push!(parents, selected_individual)
    end

    println("average population fitness: ", mean(i -> i.fitness, population.individuals))
    println("average parents fitness: ", mean(i -> i.fitness, parents))

    return parents
end

# Uses single-point crossover
function recombination(parents::Vector{Individual})

end

# Start by generating a random initial population
n = 10 # Population size
println("Generating random population")
population = generate_random_population(n)
println.(population.individuals)

# Main evolution cycle
for _ in 1:10
    continue
end

# Parent selection using roulette wheel
parents = select_parents(population)

# Crossover/recombination using single-point crossover
offspring = recombination(parents)

