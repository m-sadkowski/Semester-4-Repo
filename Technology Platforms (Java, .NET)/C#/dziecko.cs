using System;
using System.Windows;

namespace WpfApp
{
    public partial class AddChildWindow : Window
    {
        public Child CreatedChild { get; private set; }

        private readonly int _parentAge;

        public AddChildWindow(int parentAge)
        {
            InitializeComponent();
            _parentAge = parentAge;
        }

        private void OK_Click(object sender, RoutedEventArgs e)
        {
            string imie = tbImie.Text.Trim();
            if (!int.TryParse(tbWiek.Text, out int wiek) || wiek < 0 || wiek > 20)
            {
                MessageBox.Show("Wiek musi być liczbą nieujemną.", "Błąd", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(imie))
            {
                MessageBox.Show("Imię nie może być puste.", "Błąd", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (_parentAge - wiek < 20)
            {
                MessageBox.Show($"Dziecko musi być co najmniej 20 lat młodsze od rodzica. Maksymalny wiek dziecka to {_parentAge - 20}.", "Błąd", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            CreatedChild = new Child(imie, wiek);
            DialogResult = true;
        }

        private void Generate_Click(object sender, RoutedEventArgs e)
        {
            if (_parentAge < 21)
            {
                tbImie.Text = "Ten rodzic jest za młody na dzieci";
                tbWiek.Text = "";
                return;
            }

            var child = PersonGenerator.GenerateRandomChild();
            int maxChildAge = _parentAge - 20;
            child.Wiek = Math.Min(child.Wiek, maxChildAge);

            tbImie.Text = child.Imie;
            tbWiek.Text = child.Wiek.ToString();
        }
    }
}
