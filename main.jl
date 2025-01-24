
const GENOME_LENGTH = 5

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
    return individuals
end

n = 100 # Population size
println("Generating random population")
population = generate_random_population(n)
println(population)