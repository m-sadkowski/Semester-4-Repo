using System.Windows;

namespace WpfApp
{
    public partial class AddPersonWindow : Window
    {
        public Person CreatedPerson { get; private set; }

        public AddPersonWindow()
        {
            InitializeComponent();
        }

        private void OK_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(tbName.Text) || string.IsNullOrWhiteSpace(tbSurname.Text) || !int.TryParse(tbAge.Text, out int age))
            {
                MessageBox.Show("Wprowadź poprawne dane!", "Błąd", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            CreatedPerson = new Person(tbName.Text, tbSurname.Text, age);
            CreatedPerson.Id = PersonGenerator.GetNextId();
            DialogResult = true;
            Close();
        }

        private void Cancel_Click(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }

        private void Generate_Click(object sender, RoutedEventArgs e)
        {
            var person = PersonGenerator.GenerateRandomPerson();
            PersonGenerator.ReduceId();
            tbName.Text = person.Name;
            tbSurname.Text = person.Surname;
            tbAge.Text = person.Age.ToString();
        }
    }
}
