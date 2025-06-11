using System.Xml.Serialization;

namespace WpfApp
{
    [XmlType("Child")]
    public class Child
    {
        public string Name { get; set; }

        public int Age { get; set; }

        public Child(string imie, int wiek)
        {
            Name = imie;
            Age = wiek;
        }

        public Child() {}

        public override string ToString()
        {
            return $"  ↳ {Name}, {Age} lat";
        }
    }
}
