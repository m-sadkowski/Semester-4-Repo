using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace WpfApp
{
    internal class PersonGenerator
    {
        private static int _nextId = 1;
        private static readonly string[] NAMES = { "Jan", "Anna", "Piotr", "Maria", "Krzysztof", "Agnieszka", "Czesław", "Miłosz",
            "Mirosław", "Wacław", "Zbigniew", "Mariusz", "Michał", "Dawid", "Antoni", "Robert", "Anastazja", "Barbara", "Katarzyna", "Maja", "Zuzanna", "Oliwia", "Julia" };
        private static readonly string[] SURNAMES = { "Kowal", "Nowak", "Maj", "Mazur", "Mucha", "Pazdan", "Milik", "Glik", "Krychowiak", "Muller", "Lato", "Lis", "Kruk", "Kowalik", "Bednarz" };
        private static readonly Random RANDOM = new Random();

        public static Person GenerateRandomPerson()
        {
            string name = NAMES[RANDOM.Next(NAMES.Length)];
            string surname = SURNAMES[RANDOM.Next(SURNAMES.Length)];
            int age = RANDOM.Next(1, 91);
            int id = _nextId++;

            Person person = new Person(id, name, surname, age);
            AdvancedObservableCollection<Child> children = new AdvancedObservableCollection<Child>();
            if (person.Details.Category != PersonCategory.Dziecko && person.Details.Category != PersonCategory.Nastolatek)
            {
                int iloscDzieci = RANDOM.Next(3);
                for (int i = 0; i < iloscDzieci; i++)
                {
                    string childName = NAMES[RANDOM.Next(NAMES.Length)];
                    int minChildAge = Math.Max(1, age - 50);
                    int maxChildAge = Math.Max(1, age - 20);
                    int childAge = RANDOM.Next(minChildAge, maxChildAge + 1);
                    children.Add(new Child(childName, childAge));
                }
            }

            person.Children = children;
            return person;
        }

        public static List<Person> GeneratePeopleList(int count)
        {
            List<Person> peopleList = new List<Person>(count);
            for (int i = 0; i < count; i++)
            {
                peopleList.Add(GenerateRandomPerson());
            }
            return peopleList;
        }

        public static Child GenerateRandomChild()
        {
            string name = NAMES[RANDOM.Next(NAMES.Length)];
            int age = RANDOM.Next(1, 18);
            return new Child(name, age);
        }

        public static int GetNextId()
        {
            return _nextId++;
        }

        public static void ReduceId()
        {
            _nextId--;
        }

        public static void ResetId()
        {
            _nextId = 1;
        }
    }
}
