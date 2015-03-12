using System;
using System.IO;
using System.Windows.Forms;

namespace BlackBoxAnalizer
{
    public partial class mainForm : Form
    {
        string str;
        string fileName = @"C:\Documents and Settings\nima\Desktop\PAL\Scanned files\n1.txt";
        Analizer analizer;
        public mainForm()
        {
            InitializeComponent();
            FileNameLbl.Text = fileName;
        }

        string test3()
        {
            PrimeImplicant p1 = new PrimeImplicant(1, 2);
            PrimeImplicant p2 = new PrimeImplicant(2);
            PrimeImplicant p3 = new PrimeImplicant(3);
            return p1.ToString() + "+" + p2.ToString() + "+" + p3.ToString();
        }
        string test2()
        {
            //int[] a = { 2, 4, 6, 8, 9, 10, 12, 13, 15 };
            int[] a = { 4, 5, 6, 8, 11, 13, 15 };
            return QueenMcClaussy.GetString(a, 4);
        }
        string test()
        {
            int[] a = { 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0 };
            bool[] b = new bool[a.Length];
            for (int i = 0; i < a.Length; i++) b[i] = (a[i] > 0);
            BoolStream B = new BoolStream(b);
            return B.ToString();
        }

        private void ImportFileBtn_Click(object sender, EventArgs e)
        {
            openFileDialog1.FileName = fileName;
            openFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*";
            openFileDialog1.RestoreDirectory = true;

            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                fileName = openFileDialog1.FileName;
                FileNameLbl.Text = fileName;
                SaveBtn.Visible = false;
            }

            resultLbl.Text = str;
        }
        
        private void SaveBtn_Click(object sender, EventArgs e)
        {
            Stream stream;
            int i = 0;
            string sugestedFileName = fileName.TrimEnd(".txt".ToCharArray()) + " result.txt";
            while (File.Exists(sugestedFileName)) sugestedFileName = fileName.TrimEnd(".txt".ToCharArray()) + " result" + i + ".txt";
            saveFileDialog1.FileName = sugestedFileName;
            saveFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*";
            saveFileDialog1.RestoreDirectory = true;

            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                if ((stream = saveFileDialog1.OpenFile()) != null)
                {
                    StreamWriter streamWriter = new StreamWriter(stream);
                    streamWriter.Write(str);
                    streamWriter.Close();
                    stream.Close();
                }
            }
        }

        private void CloseBtn_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void analizeBtn_Click(object sender, EventArgs e)
        {
            if (!File.Exists(fileName))
            {
                MessageBox.Show(fileName + " does not exist.");
            }

            using (StreamReader sr = File.OpenText(fileName))
            {
                string s;
                analizer = new Analizer();
                s = analizer.Parse(sr);
                if (s != null)
                {
                    MessageBox.Show(s);
                    return;
                }
            }

            resultLbl.Text = str = analizer.GetResult();
            if (str != "") SaveBtn.Visible = true;
        }
    }
}
