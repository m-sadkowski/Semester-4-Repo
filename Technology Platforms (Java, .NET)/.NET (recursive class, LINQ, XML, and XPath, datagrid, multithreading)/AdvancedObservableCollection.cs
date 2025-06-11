using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.Linq;
using System.Reflection;
using System.Windows;

namespace WpfApp
{
    public class AdvancedObservableCollection<T> : ObservableCollection<T>
    {
        public void SortBy(string propertyName)
        {
            var prop = typeof(T).GetProperty(propertyName,
                BindingFlags.Public | BindingFlags.Instance);
            if (prop == null)
                throw new ArgumentException($"Wartość '{propertyName}' nie znaleziona");

            if (!typeof(IComparable).IsAssignableFrom(prop.PropertyType))
                throw new InvalidOperationException(
                    $"Wartość '{propertyName}' nie implementuje IComparable");

            var sorted = this.OrderBy(item => (IComparable)prop.GetValue(item)).ToList();

            for (int i = 0; i < sorted.Count; i++)
            {
                int oldIndex = IndexOf(sorted[i]);
                if (oldIndex != i)
                    Move(oldIndex, i);
            }
        }

        public T FindBy(string propertyName, object value)
        {
            var prop = typeof(T).GetProperty(propertyName,
                BindingFlags.Public | BindingFlags.Instance);
            if (prop == null)
                throw new ArgumentException($"Wartość '{propertyName}' nie znaleziona");

            Type propType = prop.PropertyType;
            if (propType != typeof(string) && propType != typeof(Int32))
                throw new InvalidOperationException(
                    $"Szukanie '{propertyName}' wymaga typu string lub Int32");

            return this.FirstOrDefault(item => {
                var val = prop.GetValue(item);
                return val != null && val.ToString().Contains(value.ToString());
            });
        }

        public IEnumerable<T> FindAllBy(string propertyPath, object value)
        {
            string[] parts = propertyPath.Split('.');

            foreach (var item in this)
            {
                object currentObj = item;
                bool isMatch = true;

                foreach (var part in parts)
                {
                    var prop = currentObj?.GetType().GetProperty(part);
                    if (prop == null)
                    {
                        isMatch = false;
                        break;
                    }
                    currentObj = prop.GetValue(currentObj);
                }

                if (isMatch && currentObj != null && currentObj.ToString().Contains(value.ToString(), StringComparison.OrdinalIgnoreCase))
                {
                    yield return item;
                }
            }
        }

        public void AddRange(IEnumerable<T> items)
        {
            foreach (var item in items)
            {
                this.Items.Add(item);
            }
            this.OnCollectionChanged(new NotifyCollectionChangedEventArgs(NotifyCollectionChangedAction.Reset));

            if (Application.Current.MainWindow is MainWindow mainWindow)
            {
                mainWindow.RefreshTreeView();
            }
        }
    }

}
