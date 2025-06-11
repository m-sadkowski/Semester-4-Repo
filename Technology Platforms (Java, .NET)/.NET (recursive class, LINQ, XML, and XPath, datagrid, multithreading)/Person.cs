using System;
using System.ComponentModel;
using System.Xml.Serialization;

namespace WpfApp
{
    [XmlRoot("Person")]
    public class Person : INotifyPropertyChanged
    {
        [XmlIgnore]
        private int _id;
        public int Id { get => _id;
            set { 
                if(_id != value)
                {
                    _id = value;
                    OnPropertyChanged(nameof(Id));
                }
            } }
        private string _name;
        public string Name
        {
            get => _name;
            set
            {
                if (_name != value)
                {
                    _name = value;
                    OnPropertyChanged(nameof(Name));
                }
            }
        }
        private string _surname;
        public string Surname
        {
            get => _surname;
            set
            {
                if (_surname != value)
                {
                    _surname = value;
                    OnPropertyChanged(nameof(Surname));
                }
            }
        }
        public int Age { get; set; }
        [XmlArray("Children")]
        [XmlArrayItem("Child")]
        public AdvancedObservableCollection<Child> Children { get; set; }
        public PersonDetails Details { get; set; }

        public Person(int id, string name, string surname, int age)
        {
            Id = id;
            Name = name;
            Surname = surname;
            Age = age;
            Children = new AdvancedObservableCollection<Child>();
            Details = CreateDetailsFromAge(age);
        }

        public Person(string name, string surname, int age) : this(0, name, surname, age) {}

        public Person()
        {
            Children = new AdvancedObservableCollection<Child>();
            Details = CreateDetailsFromAge(Age);
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string propertyName) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));

        private PersonDetails CreateDetailsFromAge(int age)
        {
            var random = new Random();
            int priority = random.Next(1, 11);
            int healthScore = random.Next(1, 11);

            PersonCategory category = age switch
            {
                < 15 => PersonCategory.Dziecko,
                < 20 => PersonCategory.Nastolatek,
                < 60 => PersonCategory.Dorosly,
                < 75 => PersonCategory.Senior,
                _ => PersonCategory.Sedziwy
            };

            return new PersonDetails(priority, healthScore, category);
        }

        public void AddChild(Child dziecko)
        {
            if (!Children.Contains(dziecko))
                Children.Add(dziecko);
        }

        public void RemoveChild(Child dziecko)
        {
            Children.Remove(dziecko);
        }

        public string getName()
        { 
                return $"{Name} {Surname}"; 
        }

        public override string ToString()
        {
            string childrenString = Children.Count > 0
                ? string.Join(Environment.NewLine, Children)
                : "  ↳ brak";

            return $"{Name} {Surname} (ID {Id}), {Age} lat{Environment.NewLine}" + $"kategoria: {Details.Category}, stan zdrowia: {Details.HealthScore}, priorytet: {Details.Priority}{Environment.NewLine}" + $"dzieci:{Environment.NewLine}{childrenString}";
        }
    }
}
