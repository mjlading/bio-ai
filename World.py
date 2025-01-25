import numpy as np
import matplotlib.pyplot as plt
import random
import math

random.seed(42)

X_MIN, Y_MIN = 0, 0
X_MAX, Y_MAX = 100, 100

class World:
    cities: list[tuple[int, int]] # each city has 2D (x, y) coordinates
    distances: dict[tuple[int, int], float] # maps each city pair to the distance between them
    population: list[list[int]] # population is stored as list of genomes

    def __init__(self, n_cities):
        self.cities = [(random.randint(X_MIN, X_MAX), random.randint(X_MIN, X_MAX)) for _ in range(n_cities)]
        self.distances = {}
        for index1, city1 in enumerate(self.cities):
            for index2, city2 in enumerate(self.cities):
                if index1 == index2: continue
                euclidean_distance = math.sqrt((city2[1] - city1[1])** 2 + (city2[0] - city1[0])** 2)
                self.distances[(index1, index2)] = euclidean_distance

    def plot(self):
        plt.scatter([t[0] for t in self.cities], [t[1] for t in self.cities])
        [plt.text(x, y, str(i), fontsize=14, ha='right', va='bottom') for i, (x, y) in enumerate(self.cities)]
        plt.title('City locations', fontsize=16)
        plt.show()

    def fitness(self, genome: list[int]) -> float:
        distance_traveled = 0
        for a, b in zip(genome, genome[1:] + [genome[0]]):
            distance_traveled += self.distances[(a, b)]
        return 1 / distance_traveled

    def generate_random_population(self, n):
        self.population = [np.random.permutation(len(self.cities)).tolist() for _ in range(n)]
