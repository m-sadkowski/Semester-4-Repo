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
            string name = tbName.Text.Trim();
            if (!int.TryParse(tbAge.Text, out int age) || age < 0 || age > 20)
            {
                MessageBox.Show("Wiek musi być liczbą nieujemną.", "Błąd", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (string.IsNullOrWhiteSpace(name))
            {
                MessageBox.Show("Imię nie może być puste.", "Błąd", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (_parentAge - age < 20)
            {
                MessageBox.Show($"Dziecko musi być co najmniej 20 lat młodsze od rodzica. Maksymalny wiek dziecka to {_parentAge - 20}.", "Błąd", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            CreatedChild = new Child(name, age);
            DialogResult = true;
        }

        private void Generate_Click(object sender, RoutedEventArgs e)
        {
            if (_parentAge < 21)
            {
                tbName.Text = "Ten rodzic jest za młody na dzieci";
                tbAge.Text = "";
                return;
            }

            var child = PersonGenerator.GenerateRandomChild();
            int maxChildAge = _parentAge - 20;
            child.Age = Math.Min(child.Age, maxChildAge);

            tbName.Text = child.Name;
            tbAge.Text = child.Age.ToString();
        }
    }
}