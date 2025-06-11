using System;

namespace WpfApp
{
    public enum PersonCategory
    {
        Dziecko,
        Nastolatek,
        Dorosly,
        Senior,
        Sedziwy
    }

    public class PersonDetails : IComparable<PersonDetails>
    {
        public int Priority { get; set; }
        public int HealthScore { get; set; }
        public PersonCategory Category { get; set; }

        public PersonDetails() { }

        public PersonDetails(int priority, int healthScore, PersonCategory category)
        {
            Priority = priority;
            HealthScore = healthScore;
            Category = category;
        }

        public int CompareTo(PersonDetails? other)
        {
            if (other == null) return 1;

            int priorityCompare = Priority.CompareTo(other.Priority);
            if(priorityCompare != 0) return priorityCompare;

            int healthCompare = HealthScore.CompareTo(other.HealthScore);
            if(healthCompare != 0) return healthCompare;

            return Category.CompareTo(other.Category);
        }
    }
}