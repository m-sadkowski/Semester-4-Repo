using System;

namespace WpfApp
{
    public class SharedResults
    {
        private double sum = 0;
        private double sumSquares = 0;
        private int count = 0;
        private readonly object lockObj = new object();
        private readonly int totalCount;

        public event Action<double> ProgressChanged;

        public SharedResults()
        {
            this.totalCount = totalCount;
        }

        public SharedResults(int totalCount)
        {
            this.totalCount = totalCount;
        }

        public void AddPartialResult(double sum, double sumSquares, int count)
        {
            lock (lockObj)
            {
                this.sum += sum;
                this.sumSquares += sumSquares;
                this.count += count;

                if (this.count % 1000 == 0)
                {
                    double progress = ((double)this.count / totalCount) * 50;
                    ProgressChanged?.Invoke(progress);
                }
            }
        }

        public double GetMean()
        {
            lock (lockObj)
            {
                return sum / count;
            }
        }

        public double GetVariance()
        {
            lock (lockObj)
            {
                return (sumSquares - (sum * sum) / count) / count;
            }
        }

        public void PrintStatistics()
        {
            lock (lockObj)
            {
                Console.WriteLine("\nStatystyki pośrednie:");
                Console.WriteLine("Łączna suma:        " + sum);
                Console.WriteLine("Suma kwadratów:     " + sumSquares);
                Console.WriteLine("Liczba elementów:   " + count);
                Console.WriteLine("Średnia:            " + GetMean());
                Console.WriteLine("Wariancja:          " + GetVariance());
                Console.WriteLine("Odchylenie std:     " + Math.Sqrt(GetVariance()));
            }
        }
    }
}
