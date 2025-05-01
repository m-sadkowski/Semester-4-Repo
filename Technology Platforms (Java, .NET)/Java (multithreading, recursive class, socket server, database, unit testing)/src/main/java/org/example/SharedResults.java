package org.example;

import java.io.Serializable;

public class SharedResults implements Serializable {
    private double sum = 0;
    private double sumSquares = 0;
    private int count = 0;

    public synchronized void addPartialResult(double sum, double sumSquares, int count) {
        this.sum += sum;
        this.sumSquares += sumSquares;
        this.count += count;
    }

    public synchronized double getMean() {
        return sum / count;
    }

    public synchronized double getVariance() {
        return (sumSquares - (sum * sum) / count) / count;
    }

    public synchronized void printStatistics() {
        System.out.println("\nStatystyki pośrednie:");
        System.out.println("Łączna suma:        " + sum);
        System.out.println("Suma kwadratów:     " + sumSquares);
        System.out.println("Liczba elementów:   " + count);
        System.out.println("Średnia:            " + getMean());
        System.out.println("Wariancja:          " + getVariance());
        System.out.println("Odchylenie std:     " + Math.sqrt(getVariance()));
        System.out.println("\n");
    }
}