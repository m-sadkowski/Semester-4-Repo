import numpy as np

def initialize_centroids_forgy(data, k):
    # TODO implement random initialization
    return data[np.random.choice(data.shape[0], k, replace=False)]

def initialize_centroids_kmeans_pp(data, k):
    # TODO implement kmeans++ initizalization
    centroids = np.empty((k, data.shape[1]))
    centroids[0] = data[np.random.choice(data.shape[0], 1, replace=False)]
    for i in range(1, k):
        distances = np.empty(data.shape[0])
        for j in range(data.shape[0]):
            distances[j] = np.min(np.sqrt(np.sum((data[j] - centroids[:i]) ** 2)))
        centroids[i] = data[distances.argmax()]
    return centroids

def assign_to_cluster(data, centroids):
    # TODO find the closest cluster for each data point
    assignments = []
    for point in data:
        distances = np.linalg.norm(point - centroids, axis=1)
        assignments.append(np.argmin(distances))
    return np.array(assignments)

def update_centroids(data, assignments):
    # TODO find new centroids based on the assignments
    centroids = np.empty((len(np.unique(assignments)), data.shape[1]))
    for i in range(len(np.unique(assignments))):
        centroids[i] = np.mean(data[assignments == i], axis=0)
    return centroids

def mean_intra_distance(data, assignments, centroids):
    return np.sqrt(np.sum((data - centroids[assignments, :])**2))

def k_means(data, num_centroids, kmeansplusplus= False):
    # centroids initizalization
    if kmeansplusplus:
        centroids = initialize_centroids_kmeans_pp(data, num_centroids)
    else:
        centroids = initialize_centroids_forgy(data, num_centroids)


    assignments  = assign_to_cluster(data, centroids)
    for i in range(100): # max number of iteration = 100
        print(f"Intra distance after {i} iterations: {mean_intra_distance(data, assignments, centroids)}")
        centroids = update_centroids(data, assignments)
        new_assignments = assign_to_cluster(data, centroids)
        if np.all(new_assignments == assignments): # stop if nothing changed
            break
        else:
            assignments = new_assignments

    return new_assignments, centroids, mean_intra_distance(data, new_assignments, centroids)

