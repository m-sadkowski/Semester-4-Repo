#include <iostream>
#include <random>
#include <vector>
#define N 100000

using namespace std;

double transformUtoY(double u) {
    return 100 * u + 50;
}

double mapU(double y) {
    if (y <= 0.2) return 1;
    if (y <= 0.6) return 2;
    if (y <= 0.9) return 3;
    return 4;
}

double density(double x) {
    return (x - 50) / 5000;
}

int main()
{
    random_device rand_dev;
    mt19937 generator(rand_dev());
    double fmax = 0.02;
    uniform_real_distribution<double> dist(0.0, 1.0);
    uniform_real_distribution<double> dist1(0.0, fmax);
    uniform_real_distribution<double> distDensity(50.0, 150.0);

    vector<double> numbersA;
    vector<int> numbersB;
    vector<double> selected;
    vector<int> distElimination(10, 0);
    int tries = 0;
    vector<int> distA(10, 0);
    vector<int> distB(4, 0);

    for (int i = 0; i < N; i++) {
        numbersA.push_back(transformUtoY(dist(generator)));
        numbersB.push_back(mapU(dist(generator)));
    }

    for (double number : numbersA) {
        int i = (number - 50) / 10;
        distA[i]++;
    }

    for (int number : numbersB) {
        distB[number - 1]++;
    }

    while (selected.size() < N) {
        double x = distDensity(generator); 
        double u = dist1(generator);
        double fx = density(x);
        tries++;
        if (u + 0.0001 <= fx) { 
            selected.push_back(x);
        }
    }

    for (double number : selected) {
        int index = (number - 50) / 10;
        distElimination[index]++;
    }

    cout << "A: " << endl;
    for (int i = 0; i < 10; i++) {
        cout << 50 + 10 * i << " - " << 50 + 10 * (i + 1) << ": " << distA[i] << endl;
    }

    cout << endl << "B: " << endl;
    for (int i = 0; i < 4; i++) {
        cout << i + 1 << ": " << distB[i] << endl;
    }

    cout << endl << "eliminacja: " << endl;
    for (int i = 0; i < 10; i++) {
        cout << 50 + 10 * i << " - " << 50 + 10 * (i + 1) << ": " << distElimination[i] << endl;
    }

    cout << endl << "Proby: " << tries << endl;
}