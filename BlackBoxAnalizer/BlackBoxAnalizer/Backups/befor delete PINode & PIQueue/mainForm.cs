using System;
using System.IO;
using System.Windows.Forms;

namespace BlackBoxAnalizer
{
    public partial class mainForm : Form
    {
        string str;
        string fileName = @"C:\Documents and Settings\nima\Desktop\PAL\Scanned files\new.txt";
        Analizer analizer;
        public mainForm()
        {
            InitializeComponent();
            FileNameLbl.Text = fileName;

            resultLbl.Text = str = getResult();
            //resultLbl.Text = str = test();
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

            getResult();
            resultLbl.Text = str;
        }

        string getResult()
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
                    return "";
                }
            }

            return analizer.GetResult();
        }

        private void SaveBtn_Click(object sender, EventArgs e)
        {
            Stream stream;

            saveFileDialog1.FileName = fileName.TrimEnd(".txt".ToCharArray()) + " result.txt";
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
    }
}
