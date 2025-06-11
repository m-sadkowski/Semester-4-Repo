using System.Windows;

namespace WpfApp
{
    public partial class ProgressWindow : Window
    {
        public ProgressWindow(string message)
        {
            InitializeComponent();
            MessageTextBlock.Text = message;
            ProgressBar.IsIndeterminate = false;
            ProgressBar.Minimum = 0;
            ProgressBar.Maximum = 100;
        }

        public void UpdateProgress(double value)
        {
            Dispatcher.Invoke(() =>
            {
                ProgressBar.Value = value;
                MessageTextBlock.Text = $"{value:F1}%";
            });
        }

        public void SetIndeterminate()
        {
            Dispatcher.Invoke(() =>
            {
                ProgressBar.IsIndeterminate = true;
            });
        }
    }
}