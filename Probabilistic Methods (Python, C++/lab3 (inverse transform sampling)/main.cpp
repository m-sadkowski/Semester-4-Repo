#include <iostream>
#include <random>
#include <vector>
#define N 100000

using namespace std;

extern "C" double transformUtoY(double);

/*
1.
Wygenerowac rzeczywiste <50,150> 10 podprzedzialow
2.  P(1)=0,05
    P(2)=0,15
    P(3)=0,25
    P(4)=0,55
*/

double mapU(double y)
{
    // dyskretny wybór wartości na podstawie skumulowanych prawdopodobieństw.
    if (y <= 0.05) return 1; // P(Y=1) = 0.05
    if (y <= 0.2) return 2; // P(Y=2) = 0.15 (suma 0.05+0.15)
    if (y <= 0.45) return 3; // P(Y=3) = 0.25 (suma 0.2+0.25)
    return 4; // P(Y=4) = 0.55 (reszta)
}

int main()
{
    // Losowane jest N liczby z przedziału [0, 1] za pomocą generatora mt19937.
    random_device rand_dev;
    mt19937 generator(rand_dev());
    uniform_real_distribution<double> dist(0.0, 1.0);

    vector<double> numbersA;
    vector<int> numbersB;
    numbersA.reserve(N);
    numbersB.reserve(N);
    vector<int> distributionA(10, 0); // 10 przedziałów [50-150)
    vector<int> distributionB(4, 0);  // 4 kategorie

    for (int i = 0; i < N; i++) {
        numbersA.push_back(transformUtoY(dist(generator))); // 3.1 Y = F⁻¹(U) - odwracanie dystrybuanty dla rozkładu ciągłego F(y) = (y-50) / 100 dla y ∈ [50, 150]
        numbersB.push_back(mapU(dist(generator))); // 3.3 wybiera najmniejsze k takie, że U ≤ ∑P(Y=i) dla i ≤ k - odwracania dystrybuanty dla rozkładu dyskretnego
    }

    for (double number : numbersA) {
        int i = (number - 50) / 10; // Oblicz indeks przedziału
        distributionA[i]++;
    }

    for (int number : numbersB) {
        distributionB[number - 1]++;
    }

    cout << "A: " << endl;
    for (int i = 0; i < 10; i++) {
        cout << 50 + 10 * i << " - " << 50 + 10 * (i + 1) << ": " << distributionA[i] << endl;
    }

    cout << endl << "B: " << endl;
    for (int i = 0; i < 4; i++) {
        cout << i + 1 << ": " << distributionB[i] << endl;
    }
}

