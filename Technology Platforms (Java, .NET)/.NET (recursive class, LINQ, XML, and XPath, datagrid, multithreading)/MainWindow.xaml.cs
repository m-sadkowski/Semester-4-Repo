using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Xml.Linq;
using System.Xml.Serialization;
using Microsoft.Win32;

namespace WpfApp
{
    public partial class MainWindow : Window
    {
        public AdvancedObservableCollection<Person> People { get; } = new AdvancedObservableCollection<Person>();
        private IEnumerable<dynamic> projectionResults;
        private int generatorCount = 1000000;
        private int currentPage = 1;
        private const int pageSize = 100;
        private delegate double CalculateSDDelegate(int threads);

        public MainWindow()
        {
            InitializeComponent();
            PersonGenerator.ResetId();
            DataContext = this;
            People.CollectionChanged += People_CollectionChanged;
        }

        /*
         * *****************************************************************************************************
         * Obliczenia wielowątkowe
         * *****************************************************************************************************
         */

        // Odchylenie standardowe wykorzystując klasy Task i Task
        private void CalculateSDTask_Click(object sender, RoutedEventArgs e)
        {
            if (!People.Any())
            {
                MessageBox.Show("Brak danych do obliczeń", "Błąd", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            int threads = AskForThreads();

            var progressWindow = new ProgressWindow("Obliczanie odchylenia standardowego (Task)");
            progressWindow.Show();

            var progress = new Progress<double>(value =>
            {
                progressWindow.UpdateProgress(value);
            });

            Task.Run(() =>
            {
                try
                {
                    var parallelStopwatch = Stopwatch.StartNew();
                    double parallelSD = CalculateSDParallel(threads, progress);
                    parallelStopwatch.Stop();

                    var sequentialStopwatch = Stopwatch.StartNew();
                    double sequentialSD = CalculateSDSequential(progress);
                    sequentialStopwatch.Stop();

                    Thread.Sleep(10000);
                    Dispatcher.Invoke(() =>
                    {
                        progressWindow.Close();

                        string message = $"Wersja równoległa ({threads} wątków):\n" +
                                         $"Odchylenie standardowe: {parallelSD:F2}\n" +
                                         $"Czas obliczeń: {parallelStopwatch.ElapsedMilliseconds} ms\n\n" +
                                         $"Wersja sekwencyjna:\n" +
                                         $"Odchylenie standardowe: {sequentialSD:F2}\n" +
                                         $"Czas obliczeń: {sequentialStopwatch.ElapsedMilliseconds} ms";

                        MessageBox.Show(message, "Porównanie wyników", MessageBoxButton.OK, MessageBoxImage.Information);
                    });
                }
                catch (Exception ex)
                {
                    Dispatcher.Invoke(() =>
                    {
                        progressWindow.Close();
                        MessageBox.Show($"Błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
                    });
                }
            });
        }

        // Odchylenie standardowe wykorzystując delegaty do asynchronicznego wywołania metod
        /*
         * Wykorzystanie tasków do delegatów zamiast BeginInvoke
         * ponieważ BeginInvoke jest przestarzałe i nie działa w .NET >= 5
         */
        private void CalculateSDDelegate_Click(object sender, RoutedEventArgs e)
        {
            if (!People.Any())
            {
                MessageBox.Show("Brak danych do obliczeń", "Błąd", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            int threads = AskForThreads();
            var progressWindow = new ProgressWindow("Obliczanie odchylenia standardowego (Delegaty)");
            progressWindow.Show();

            var progress = new Progress<double>(value =>
            {
                progressWindow.UpdateProgress(value);
            });

            try
            {
                CalculateSDDelegate del = (t) => CalculateSDParallel(t, progress);

                var parallelStopwatch = Stopwatch.StartNew();
                Task<double> task = Task.Run(() => del(threads));
                task.Wait();
                double parallelSD = task.Result;
                parallelStopwatch.Stop();

                var sequentialStopwatch = Stopwatch.StartNew();
                double sequentialSD = CalculateSDSequential(progress);
                sequentialStopwatch.Stop();

                progressWindow.Close();

                string message = $"Wersja równoległa (Delegaty, {threads} wątków):\n" +
                                 $"Odchylenie standardowe: {parallelSD:F2}\n" +
                                 $"Czas obliczeń: {parallelStopwatch.ElapsedMilliseconds} ms\n\n" +
                                 $"Wersja sekwencyjna:\n" +
                                 $"Odchylenie standardowe: {sequentialSD:F2}\n" +
                                 $"Czas obliczeń: {sequentialStopwatch.ElapsedMilliseconds} ms";

                MessageBox.Show(message, "Porównanie wyników (Delegaty)", MessageBoxButton.OK, MessageBoxImage.Information);
            }
            catch (Exception ex)
            {
                progressWindow.Close();
                MessageBox.Show($"Błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        // Odchylenie standardowe wykorzystując metodę asynchroniczną async-await
        private async void CalculateSDAsync_Click(object sender, RoutedEventArgs e)
        {
            if (!People.Any())
            {
                MessageBox.Show("Brak danych do obliczeń", "Błąd", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            int threads = AskForThreads();
            var progressWindow = new ProgressWindow("Obliczanie (async-await)");
            progressWindow.Show();

            var progress = new Progress<double>(value => progressWindow.UpdateProgress(value));

            try
            {
                await Task.Delay(10000);
                // Faza równoległa (0-50%)
                var parallelStopwatch = Stopwatch.StartNew();
                double parallelSD = await Task.Run(() => CalculateSDParallel(threads, progress));
                parallelStopwatch.Stop();

                // Faza sekwencyjna (50-100%)
                var sequentialStopwatch = Stopwatch.StartNew();
                double sequentialSD = await Task.Run(() => CalculateSDSequential(progress));
                sequentialStopwatch.Stop();

                progressWindow.Close();

                string message = $"Wersja równoległa ({threads} wątków):\n" +
                                $"Odchylenie: {parallelSD:F2}\n" +
                                $"Czas: {parallelStopwatch.ElapsedMilliseconds} ms\n\n" +
                                $"Wersja sekwencyjna:\n" +
                                $"Odchylenie: {sequentialSD:F2}\n" +
                                $"Czas: {sequentialStopwatch.ElapsedMilliseconds} ms";

                MessageBox.Show(message, "Wyniki (async-await)", MessageBoxButton.OK, MessageBoxImage.Information);
            }
            catch (Exception ex)
            {
                progressWindow.Close();
                MessageBox.Show($"Błąd: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        // Odchylenie standardowe wykorzystując klasę BackgroundWorker
        private void CalculateSDWorker_Click(object sender, RoutedEventArgs e)
        {
            if (!People.Any())
            {
                MessageBox.Show("Brak danych do obliczeń", "Błąd", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            int threads = AskForThreads();
            var progressWindow = new ProgressWindow("Obliczanie (BackgroundWorker)");
            progressWindow.Show();

            var worker = new BackgroundWorker
            {
                WorkerReportsProgress = true,
                WorkerSupportsCancellation = true
            };

            worker.DoWork += (s, e) =>
            {
                var workerInstance = s as BackgroundWorker;
                var people = (List<Person>)e.Argument;
                int totalPeople = people.Count;
                int processed = 0;

                // Faza 1: Obliczenia równoległe (0-50%)
                var sharedResults = new SharedResults(totalPeople);
                sharedResults.ProgressChanged += (progress) =>
                {
                    workerInstance.ReportProgress((int)progress);
                };

                var parallelStopwatch = Stopwatch.StartNew();
                int chunkSize = (totalPeople + threads - 1) / threads;
                var tasks = new List<Task>();

                for (int i = 0; i < threads; i++)
                {
                    int start = i * chunkSize;
                    int end = Math.Min(start + chunkSize, totalPeople);
                    tasks.Add(Task.Run(() =>
                    {
                        for (int j = start; j < end; j++)
                        {
                            if (workerInstance.CancellationPending)
                            {
                                e.Cancel = true;
                                return;
                            }

                            int age = people[j].Age;
                            sharedResults.AddPartialResult(age, age * age, 1);
                        }
                    }));
                }

                Task.WaitAll(tasks.ToArray());
                parallelStopwatch.Stop();

                // Faza 2: Obliczenia sekwencyjne (50-100%)
                var sequentialStopwatch = Stopwatch.StartNew();
                double sum = 0;
                double sumSquares = 0;
                int count = people.Count;

                for (int i = 0; i < count; i++)
                {
                    if (workerInstance.CancellationPending)
                    {
                        e.Cancel = true;
                        return;
                    }

                    int age = people[i].Age;
                    sum += age;
                    sumSquares += age * age;

                    // Raportuj postęp (50-100%)
                    if (i % 1000 == 0)
                    {
                        double progress = 50 + ((double)i / count * 50);
                        workerInstance.ReportProgress((int)progress);
                    }
                }

                double variance = (sumSquares - (sum * sum) / count) / count;
                double sequentialSD = Math.Sqrt(variance);
                sequentialStopwatch.Stop();

                e.Result = new WorkerResult
                {
                    ParallelSD = Math.Sqrt(sharedResults.GetVariance()),
                    ParallelTime = parallelStopwatch.ElapsedMilliseconds,
                    SequentialSD = sequentialSD,
                    SequentialTime = sequentialStopwatch.ElapsedMilliseconds
                };
            };

            worker.ProgressChanged += (s, e) =>
            {
                progressWindow.UpdateProgress(e.ProgressPercentage);
            };

            worker.RunWorkerCompleted += (s, e) =>
            {
                progressWindow.Close();

                if (e.Cancelled)
                {
                    MessageBox.Show("Obliczenia przerwane!", "Informacja", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else if (e.Error != null)
                {
                    MessageBox.Show($"Błąd: {e.Error.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
                }
                else
                {
                    var result = (WorkerResult)e.Result;
                    string message = $"Równolegle ({threads} wątków):\n" +
                                     $"Odchylenie: {result.ParallelSD:F2}\n" +
                                     $"Czas: {result.ParallelTime} ms\n\n" +
                                     $"Sekwencyjnie:\n" +
                                     $"Odchylenie: {result.SequentialSD:F2}\n" +
                                     $"Czas: {result.SequentialTime} ms";

                    MessageBox.Show(message, "Wyniki", MessageBoxButton.OK, MessageBoxImage.Information);
                }
            };

            worker.RunWorkerAsync(People.ToList());
        }

        // Klasa pomocnicza do przechowywania wyników dla BackgroundWorker
        private class WorkerResult
        {
            public double ParallelSD { get; set; }
            public long ParallelTime { get; set; }
            public double SequentialSD { get; set; }
            public long SequentialTime { get; set; }
        }

        //  Odchylenie standardowe sekwencyjnie dla listy osób (potrzebne do BackgroundWorkera)
        private double CalculateSDSequential(List<Person> people)
        {
            double sum = 0;
            double sumSquares = 0;
            int count = people.Count;

            foreach (var person in people)
            {
                sum += person.Age;
                sumSquares += person.Age * person.Age;
            }

            double variance = (sumSquares - (sum * sum) / count) / count;
            return Math.Sqrt(variance);
        }

        // Odchylenie standardowe sekwencyjnie
        private double CalculateSDSequential(IProgress<double> progress)
        {
            double sum = 0;
            double sumSquares = 0;
            int count = People.Count;
            double number = 0;

            foreach (var person in People)
            {
                int age = person.Age;
                sum += age;
                sumSquares += age * age;
                number++;
                if(number%500==0)
                {
                    progress.Report(50 + ((double)number / count * 50));
                }

            }

            double mean = sum / count;
            double variance = (sumSquares / count) - (mean * mean);
            return Math.Sqrt(variance);
        }

        // Odchylenie standardowe współbieżnie
        private double CalculateSDParallel(int threads, IProgress<double> progress)
        {
            var sharedResults = new SharedResults();

            int totalPeople = People.Count;
            int chunkSize = (totalPeople + threads - 1) / threads;
            var tasks = new List<Task>();
            int processed = 0;

            for (int i = 0; i < threads; i++)
            {
                int start = i * chunkSize;
                int end = Math.Min(start + chunkSize, totalPeople);
                tasks.Add(Task.Run(() =>
                {
                    double localSum = 0;
                    double localSumSquares = 0;
                    int localCount = 0;

                    for (int j = start; j < end; j++)
                    {
                        int age = People[j].Age;
                        localSum += age;
                        localSumSquares += age * age;
                        localCount++;

                        int current = Interlocked.Increment(ref processed);
                        if (current % 100 == 0)
                        {
                            // Aktualizuj postęp (0-50%)
                            progress.Report((double)current / totalPeople * 50);
                        }
                    }

                    sharedResults.AddPartialResult(localSum, localSumSquares, localCount);
                }));
            }

            Task.WaitAll(tasks.ToArray());
            return Math.Sqrt(sharedResults.GetVariance());
        }

        // Pobieranie ilości wątków od użytkownika
        private int AskForThreads()
        {
            string input = Microsoft.VisualBasic.Interaction.InputBox(
                "Podaj liczbę wątków (1-16):",
                "Liczba wątków",
                "4");

            if (!int.TryParse(input, out int threads) || threads < 1 || threads > 16)
            {
                MessageBox.Show("Nieprawidłowa liczba wątków. Używam domyślnej wartości 4.");
                threads = 4;
            }
            return threads;
        }

        /*
         * *****************************************************************************************************
         * Operacja na liście osób
         * *****************************************************************************************************
         */

        // Sortowanie po imieniu
        private void SortName(object sender, RoutedEventArgs e)
        {
            People.SortBy("Name");
        }

        // Sortowanie po wieku
        private void SortAge(object sender, RoutedEventArgs e)
        {
            People.SortBy("Age");
        }

        // Szukanie Jana
        private void findByName(object sender, RoutedEventArgs e)
        {
            var found = People.FindBy("Name", "Jan");
            if (found != null)
            {
                MessageBox.Show($"Znaleziono osobę: {found}", "Wynik wyszukiwania", MessageBoxButton.OK, MessageBoxImage.Information);
            }
            else
            {
                MessageBox.Show("Nie znaleziono osoby o podanym imieniu.", "Wynik wyszukiwania", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }

        // Szukanie ID 2
        private void findById(object sender, RoutedEventArgs e)
        {
            var found = People.FindBy("Id", 2);
            if (found != null)
            {
                MessageBox.Show($"Znaleziono osobę: {found}", "Wynik wyszukiwania", MessageBoxButton.OK, MessageBoxImage.Information);
            }
            else
            {
                MessageBox.Show("Nie znaleziono osoby o podanym Id.", "Wynik wyszukiwania", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }

        /*
         * *****************************************************************************************************
         * Projekcja
         * *****************************************************************************************************
         */

        // Projekcja elementów kolekcji
        private void Projection_Click(object sender, RoutedEventArgs e)
        {
            projectionResults = People.Where(p => p.Id % 2 != 0).Select(p => new
            {
                SUM_OF = p.Details.Priority + p.Details.HealthScore,
                UPPERCASE = p.Details.Category.ToString().ToUpper()
            }).ToList();

            var lines = projectionResults.Select(item => $"SUM_OF = {item.SUM_OF}, UPPERCASE = {item.UPPERCASE}");

            var message = "Wyniki projekcji LINQ:" + Environment.NewLine + Environment.NewLine + string.Join(Environment.NewLine, lines);

            MessageBox.Show(message, "Projekcja LINQ", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        // Grupowanie elementów kolekcji
        private void Grouping_Click(object sender, RoutedEventArgs e)
        {
            if (projectionResults == null || !projectionResults.Any())
            {
                MessageBox.Show("Najpierw wykonaj projekcję.", "Błąd", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var groups = projectionResults.GroupBy(x => x.UPPERCASE);

            var lines = groups.Select(g =>
            {
                var avg = g.Average(x => x.SUM_OF);
                return $"Grupa: {g.Key}, Średnia SUM_OF = {avg:F2}";
            });

            var message = "Wynik grupowania LINQ:" + Environment.NewLine + Environment.NewLine + string.Join(Environment.NewLine, lines);

            MessageBox.Show(message, "Grupowanie LINQ", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        /*
         * *****************************************************************************************************
         * XML
         * *****************************************************************************************************
         */

        // Importowanie z pliku XML
        private void ImportFromXml_Click(object sender, RoutedEventArgs e)
        {
            var dlg = new OpenFileDialog
            {
                Filter = "Pliki XML (*.xml)|*.xml",
                DefaultExt = "xml"
            };
            if (dlg.ShowDialog() != true) return;

            List<Person> importedPeople;
            var serializer = new XmlSerializer(typeof(List<Person>));

            try
            {
                using (var stream = File.OpenRead(dlg.FileName))
                {
                    importedPeople = (List<Person>)serializer.Deserialize(stream);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Błąd wczytywania:\n{ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            People.Clear();
            tvPeople.Items.Clear();

            int id = 1;
            foreach (var p in importedPeople)
            {
                p.Id = (int)DateTimeOffset.UtcNow.ToUnixTimeSeconds() + id++;
                People.Add(p);
                RenderPersonWithChildrenInTreeView(p);
            }

            MessageBox.Show($"Zaimportowano {People.Count} osób", "Gotowe", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        // Eksportowanie do pliku XML
        private void ExportToXml_Click(object sender, RoutedEventArgs e)
        {
            if (!People.Any())
            {
                MessageBox.Show("Brak danych", "Błąd", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            var dlg = new SaveFileDialog
            {
                Filter = "Pliki XML (*.xml)|*.xml",
                DefaultExt = "xml"
            };
            if (dlg.ShowDialog() != true) return;

            var list = new List<Person>(People);
            var serializer = new XmlSerializer(typeof(List<Person>));
            using (var stream = File.Create(dlg.FileName))
            {
                serializer.Serialize(stream, list);
            }

            MessageBox.Show($"Wyeksportowano do {dlg.FileName}", "Gotowe", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        /*
         * *****************************************************************************************************
         * XPath
         * *****************************************************************************************************
         */

        // Wyrażenie XPath
        private void CallXPath_Click(object sender, RoutedEventArgs e)
        {
            var dlg = new OpenFileDialog
            {
                Filter = "Pliki XML (*.xml)|*.xml",
                Title = "Wybierz plik XML z danymi"
            };
            if (dlg.ShowDialog() != true) return;

            var elems = XPathHelper.CallXPath(dlg.FileName);
            var sb = new StringBuilder("Osoby z wyrażenia XPath:\n\n");
            foreach (var el in elems)
            {
                string name = (string)el.Element("Name");
                string surname = (string)el.Element("Surname");
                string age = (string)el.Element("Age");
                var details = el.Element("Details");
                string priority = (string)details.Element("Priority");
                string category = (string)details.Element("Category");
                string healthScore = (string)details.Element("HealthScore");

                sb.AppendLine($"{name} {surname}, {age} lat ({category}) - priorytet: {priority}, zdrowie: {healthScore}");
            }

            MessageBox.Show(sb.ToString(), "XPath", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        /*
         * *****************************************************************************************************
         * XHTML
         * *****************************************************************************************************
         */

        // Tworzenie dokumentu XHTML
        private void GenerateHtmlTable_Click(object sender, RoutedEventArgs e)
        {
            if (!People.Any())
            {
                MessageBox.Show("Brak danych", "Błąd", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            var saveDialog = new SaveFileDialog
            {
                Filter = "Pliki XHTML (*.xhtml)|*.xhtml",
                DefaultExt = "html",
                Title = "Zapisz XHTML"
            };

            if (saveDialog.ShowDialog() == true)
            {
                try
                {
                    var htmlDocument = GeneratePeopleHtmlTable(People);
                    htmlDocument.Save(saveDialog.FileName);
                    MessageBox.Show($"Wyeksportowano tabelę do {saveDialog.FileName}", "Sukces", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Błąd podczas eksportu: {ex.Message}", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        // Generowanie zawartości XHTML
        private XDocument GeneratePeopleHtmlTable(ObservableCollection<Person> people)
        {
            XNamespace xhtml = "http://www.w3.org/1999/xhtml";

            var html = new XDocument(
                new XDocumentType("html", "-//W3C//DTD XHTML 1.0 Strict//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd", null),
                new XElement(xhtml + "html",
                    new XAttribute("xmlns", "http://www.w3.org/1999/xhtml"),
                    new XElement(xhtml + "head",
                        new XElement(xhtml + "title", "Lista osób")
                    ),
                    new XElement(xhtml + "body",
                        new XElement(xhtml + "h1", "Lista osób"),
                        new XElement(xhtml + "table",
                            new XElement(xhtml + "thead",
                                new XElement(xhtml + "tr",
                                    new XElement(xhtml + "th", "ID"),
                                    new XElement(xhtml + "th", "Imię"),
                                    new XElement(xhtml + "th", "Nazwisko"),
                                    new XElement(xhtml + "th", "Wiek"),
                                    new XElement(xhtml + "th", "Priorytet"),
                                    new XElement(xhtml + "th", "Stan zdrowia"),
                                    new XElement(xhtml + "th", "Kategoria"),
                                    new XElement(xhtml + "th", "Liczba dzieci")
                                )
                            ),
                            new XElement(xhtml + "tbody",
                                from person in people
                                select new XElement(xhtml + "tr",
                                    new XElement(xhtml + "td", person.Id),
                                    new XElement(xhtml + "td", person.Name),
                                    new XElement(xhtml + "td", person.Surname),
                                    new XElement(xhtml + "td", person.Age),
                                    new XElement(xhtml + "td", person.Details.Priority),
                                    new XElement(xhtml + "td", person.Details.HealthScore),
                                    new XElement(xhtml + "td", person.Details.Category),
                                    new XElement(xhtml + "td", person.Children.Count)
                                )
                            )
                        )
                    )
                )
            );

            return html;
        }

        /*
         * *****************************************************************************************************
         * Podstawowe funkcje i przyciski
         * *****************************************************************************************************
         */

        // Czyszczenie listy osób
        private void ClearPeople_Click(object sender, RoutedEventArgs e)
        {
            People.Clear();
            tvPeople.Items.Clear();
            tbPersonData.Text = string.Empty;
            PersonGenerator.ResetId();
        }
        
        // Usuwanie elementów z listy
        private void DeletePerson_Click(object sender, RoutedEventArgs e)
        {
            if (sender is MenuItem menuItem &&
                menuItem.Parent is ContextMenu contextMenu &&
                contextMenu.PlacementTarget is TreeViewItem treeViewItem &&
                treeViewItem.Tag is Person person)
            {
                tvPeople.Items.Remove(treeViewItem);
                People.Remove(person);

                if (tbPersonData.Text.Contains(person.Name))
                {
                    tbPersonData.Text = string.Empty;
                }
            }
        }

        private void DeleteChild_Click(object sender, RoutedEventArgs e)
        {
            if (sender is MenuItem menuItem &&
                menuItem.Parent is ContextMenu contextMenu &&
                contextMenu.PlacementTarget is TreeViewItem childItem &&
                childItem.Tag is Child childToDelete)
            {
                foreach (TreeViewItem parentItem in tvPeople.Items)
                {
                    if (parentItem.Tag is Person parentPerson)
                    {
                        foreach (TreeViewItem item in parentItem.Items)
                        {
                            if (item == childItem)
                            {
                                parentPerson.Children.Remove(childToDelete);

                                parentItem.Items.Remove(childItem);
                                RefreshSelectedPersonData();
                                return;
                            }
                        }
                    }
                }
            }
        }

        // Dodawanie elementów do listy
        private void AddPerson_Click(object sender, RoutedEventArgs e)
        {
            var addWindow = new AddPersonWindow();
            if (addWindow.ShowDialog() == true)
            {
                var person = addWindow.CreatedPerson;

                People.Add(person);

            }
        }

        private void AddChild_Click(object sender, RoutedEventArgs e)
        {
            if (sender is MenuItem menuItem &&
                menuItem.Parent is ContextMenu contextMenu &&
                contextMenu.PlacementTarget is TreeViewItem treeViewItem &&
                treeViewItem.Tag is Person person)
            {
                var window = new AddChildWindow(person.Age);
                if (window.ShowDialog() == true && window.CreatedChild != null)
                {
                    person.Children.Add(window.CreatedChild);

                    TreeViewItem childItem = new TreeViewItem
                    {
                        Header = window.CreatedChild.Name,
                        Tag = window.CreatedChild,
                        ContextMenu = new ContextMenu()
                    };

                    MenuItem deleteChildMenuItem = new MenuItem { Header = "Usuń dziecko" };
                    deleteChildMenuItem.Click += DeleteChild_Click;
                    childItem.ContextMenu.Items.Add(deleteChildMenuItem);

                    treeViewItem.Items.Add(childItem);
                    treeViewItem.IsExpanded = true;

                    RefreshSelectedPersonData();
                }
            }
        }

        // Generowanie danych
        private void GenerateData_Click(object sender, RoutedEventArgs e)
        {
            var generated = PersonGenerator.GeneratePeopleList(generatorCount);
            People.AddRange(generated);

            string message = string.Join("\n\n", generated.Take(10)); // Wyświetl tylko pierwsze 10 osób
            MessageBox.Show($"{message}\n\n... i więcej ({generated.Count - 10}) osób.", "Wygenerowano dane", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        // Wersja aplikacji
        private void Version_Click(object sender, RoutedEventArgs e)
        {
            MessageBox.Show("Wersja 1.0", "Wersja aplikacji", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        // Wyjście z aplikacji
        private void Exit_Click(object sender, RoutedEventArgs e)
        {
            Application.Current.Shutdown();
        }

        // Przyciski do zmiany stron
        private void PreviousPage_Click(object sender, RoutedEventArgs e)
        {
            if (currentPage > 1)
            {
                currentPage--;
                RefreshTreeView();
            }
        }

        private void NextPage_Click(object sender, RoutedEventArgs e)
        {
            if ((currentPage * pageSize) < People.Count)
            {
                currentPage++;
                RefreshTreeView();
            }
        }

        // Wyszukiwanie w siatce
        private void SearchButton_Click(object sender, RoutedEventArgs e)
        {
            if (cbSearchProperty.SelectedItem is ComboBoxItem selectedItem)
            {
                string propertyPath = selectedItem.Tag.ToString();
                string searchValue = txtSearchValue.Text.Trim();

                var matches = People.FindAllBy(propertyPath, searchValue).ToList();

                if (matches.Any())
                {
                    var view = CollectionViewSource.GetDefaultView(PeopleDataGrid.ItemsSource);
                    view.Filter = item => matches.Contains(item);
                    view.Refresh();
                }
                else
                {
                    MessageBox.Show("Nie znaleziono pasujących rekordów.");
                }
            }
        }

        private void ClearSearch_Click(object sender, RoutedEventArgs e)
        {
            var view = CollectionViewSource.GetDefaultView(PeopleDataGrid.ItemsSource);
            view.Filter = null;
            view.Refresh();

            PeopleDataGrid.SelectedItems.Clear();
            txtSearchValue.Text = string.Empty;
        }

        /*
         * *****************************************************************************************************
         * Odświeżanie widoków
         * *****************************************************************************************************
         */

        // Zdarzenie zmiany zaznaczenia w DataGrid
        private void PeopleDataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (PeopleDataGrid.SelectedItem is Person p)
            {
                tbPersonData.Text =
                    $"Id: {p.Id}\nImię: {p.Name}\nNazwisko: {p.Surname}\nWiek: {p.Age}\n" +
                    $"Priorytet: {p.Details.Priority}\nZdrowie: {p.Details.HealthScore}\nKategoria: {p.Details.Category}";
            }
            else
            {
                tbPersonData.Text = "(brak zaznaczenia)";
            }
        }

        // Zdarzenie zmiany kolekcji osób
        private void People_CollectionChanged(object sender, NotifyCollectionChangedEventArgs e)
        {
            if (e.Action == NotifyCollectionChangedAction.Add)
            {
                tvPeople.Items.Clear();
                foreach (var person in People)
                {
                    if (person.Id <= 0)
                        person.Id = PersonGenerator.GetNextId();

                    person.PropertyChanged += Person_PropertyChanged;

                    RenderPersonWithChildrenInTreeView(person);
                }
            }
            else if (e.Action == NotifyCollectionChangedAction.Remove)
            {
                foreach (Person p in e.OldItems)
                {
                    p.PropertyChanged -= Person_PropertyChanged;

                    var itemToRemove = tvPeople.Items
                        .OfType<TreeViewItem>()
                        .FirstOrDefault(tvi => tvi.Tag == p);
                    if (itemToRemove != null)
                        tvPeople.Items.Remove(itemToRemove);
                }
            }
        }

        private void Person_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName == nameof(Person.Name) ||
                e.PropertyName == nameof(Person.Surname))
            {
                var p = (Person)sender;
                var tvi = tvPeople.Items
                    .OfType<TreeViewItem>()
                    .FirstOrDefault(i => i.Tag == p);
                if (tvi != null)
                {
                    tvi.Header = p.getName();
                }
            }
        }

        // Zdarzenie zakończenia edycji w DataGrid
        private void PeopleDataGrid_RowEditEnding(object sender, DataGridRowEditEndingEventArgs e)
        {
            if (e.EditAction == DataGridEditAction.Commit)
            {
                Dispatcher.BeginInvoke(new Action(() =>
                {
                    PeopleDataGrid.CommitEdit(DataGridEditingUnit.Row, true);
                }), System.Windows.Threading.DispatcherPriority.Background);
            }
        }

        private void RenderPersonWithChildrenInTreeView(Person person)
        {
            TreeViewItem new_person = new TreeViewItem
            {
                Header = person.getName(),
                Tag = person,
                ContextMenu = CreatePersonContextMenu(person)
            };

            foreach (var child in person.Children)
            {
                TreeViewItem childItem = new TreeViewItem
                {
                    Header = child.Name,
                    Tag = child,
                    ContextMenu = CreateChildContextMenu(child)
                };

                new_person.Items.Add(childItem);
            }

            tvPeople.Items.Add(new_person);
        }

        // Odświeżenie TreeView
        public void RefreshTreeView()
        {
            tvPeople.Items.Clear();

            var pageData = People.Skip((currentPage - 1) * pageSize).Take(pageSize);
            foreach (var person in pageData)
            {
                RenderPersonWithChildrenInTreeView(person);
            }
        }

        private void RefreshSelectedPersonData()
        {
            if (tvPeople.SelectedItem is TreeViewItem selectedItem && selectedItem.Tag is Person person)
            {
                tbPersonData.Text = $"Typ: Osoba\nId: {person.Id}\nImię: {person.Surname}\nNazwisko: {person.Name}\nWiek: {person.Age}\nPriorytet: {person.Details.Priority}\nZdrowie: {person.Details.HealthScore}\nGrupa: {person.Details.Category}\nDzieci: {string.Join(", ", person.Children.Select(d => d.Name))}";
            }
        }

        private void tvPeople_SelectedItemChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
        {
            if (e.NewValue is TreeViewItem selectedItem)
            {
                if (selectedItem.Tag is Person person)
                {
                    tbPersonData.Text = $"Typ: Osoba\nId: {person.Id}\nImię: {person.Surname}\nNazwisko: {person.Name}\nWiek: {person.Age}\nPriorytet: {person.Details.Priority}\nZdrowie: {person.Details.HealthScore}\nGrupa: {person.Details.Category}\nDzieci: {string.Join(", ", person.Children.Select(d => d.Name))}";
                }
                else if (selectedItem.Tag is Child child)
                {
                    tbPersonData.Text = $"Typ: Dziecko\nImię: {child.Name}\nWiek: {child.Age}\n";
                }
                else
                {
                    tbPersonData.Text = selectedItem.Header.ToString();
                }
            }
        }

        private void CbSearchProperty_GotFocus(object sender, RoutedEventArgs e)
        {
            cbSearchProperty.Items.Clear();

            foreach (var column in PeopleDataGrid.Columns.OfType<DataGridTextColumn>())
            {
                string header = column.Header.ToString();
                string bindingPath = (column.Binding as Binding)?.Path.Path;

                if (!string.IsNullOrEmpty(bindingPath))
                {
                    cbSearchProperty.Items.Add(new ComboBoxItem
                    {
                        Content = header,
                        Tag = bindingPath 
                    });
                }
            }
        }

        /*
         * *****************************************************************************************************
         * Menu kontekstowe
         * *****************************************************************************************************
         */

        private ContextMenu CreatePersonContextMenu(Person person)
        {
            var contextMenu = new ContextMenu();

            MenuItem deletePersonMenuItem = new MenuItem { Header = "Usuń osobę" };
            deletePersonMenuItem.Click += DeletePerson_Click;
            contextMenu.Items.Add(deletePersonMenuItem);

            MenuItem addChildMenuItem = new MenuItem { Header = "Dodaj dziecko" };
            addChildMenuItem.Click += AddChild_Click;
            contextMenu.Items.Add(addChildMenuItem);

            var projMenuItem = new MenuItem { Header = "Projekcja LINQ" };
            projMenuItem.Click += Projection_Click;
            contextMenu.Items.Add(projMenuItem);

            var groupMenuItem = new MenuItem { Header = "Grupowanie LINQ" };
            groupMenuItem.Click += Grouping_Click;
            contextMenu.Items.Add(groupMenuItem);

            var clearMenuItem = new MenuItem { Header = "Wyczyść listę osób" };
            clearMenuItem.Click += ClearPeople_Click;
            contextMenu.Items.Add(clearMenuItem);

            return contextMenu;
        }

        private ContextMenu CreateChildContextMenu(Child child)
        {
            var contextMenu = new ContextMenu();

            MenuItem deleteChildMenuItem = new MenuItem { Header = "Usuń dziecko" };
            deleteChildMenuItem.Click += DeleteChild_Click;
            contextMenu.Items.Add(deleteChildMenuItem);

            return contextMenu;
        }
    }
}