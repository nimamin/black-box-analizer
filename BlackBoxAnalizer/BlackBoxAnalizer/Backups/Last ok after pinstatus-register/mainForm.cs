using System;
using System.IO;
using System.Windows.Forms;

namespace BlackBoxAnalizer
{
    public partial class mainForm : Form
    {
        string resultString;
        string detailString;
        string fileName = @"C:\Documents and Settings\Nima\Desktop\PAL\Scanned Files\bcc.txt";
        Analizer analizer;

        public delegate void CalDelegate();

        public mainForm()
        {
            InitializeComponent();
            FileNameLbl.Text = fileName;
            PIQueue.progressBar = progressBar;
            test();
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
                analizeBtn.Visible = true;
            }
            else
            {
                FileNameLbl.Text = fileName = "";
                analizeBtn.Visible = false;
            }

            SaveBtn.Visible = false;
            resultTextBox.Text = resultString = "";
            resultTextBox.Visible = false;
            moreDeatalsCeckBox.Visible = false;
            moreDeatalsCeckBox.Checked = false;
            pinNumberTextBox.Visible = false;
        }
        
        private void SaveBtn_Click(object sender, EventArgs e)
        {
            Stream stream;
            int i = 0;
            string sugestedFileName = fileName.TrimEnd(".txt".ToCharArray()) + " result.txt";

            while (File.Exists(sugestedFileName)) sugestedFileName = fileName.TrimEnd(".txt".ToCharArray()) + " result" + i++ + ".txt";

            saveFileDialog1.FileName = sugestedFileName;
            saveFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*";
            saveFileDialog1.RestoreDirectory = true;

            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                if ((stream = saveFileDialog1.OpenFile()) != null)
                {
                    StreamWriter streamWriter = new StreamWriter(stream);
                    streamWriter.Write(resultString);
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
                return;
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

            if (ShowProgressBar) PIQueue.Calculate = new CalDelegate(PIQueue.startDelegate);


            analizer.Analize();

            if (ShowProgressBar)
            {
                PIQueue.Calculate += PIQueue.endDelegate;
                PIQueue.Calculate();
            }

            resultString = analizer.GetResult();
            detailString = analizer.GetMoreDetails(int.Parse(pinNumberTextBox.Text));

            if (resultString != "")
            {
                resultTextBox.Visible = true;
                resultTextBox.Text = resultString;
                if (moreDeatalsCeckBox.Checked) resultTextBox.Text += detailString;
                SaveBtn.Visible = true;
                moreDeatalsCeckBox.Visible = true;
            }
        }

        #region Test
        void test1()
        {
            bool[] tt = new bool[4];
            tt[1] = tt[2] = tt[3] = true;
            PIQueue p = new PIQueue(tt, false);
            p.Normalize();
            p.Minimize();
            resultTextBox.Visible = true;
            resultTextBox.Text = p.GetAlphabetString();
        }
        void test2()
        {
            resultTextBox.Text = "\r\nDone";
        }
        string test0()
        {
            int[] a = { 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0 };
            bool[] b = new bool[a.Length];
            for (int i = 0; i < a.Length; i++) b[i] = (a[i] > 0);
            BoolStream B = new BoolStream(b);
            return B.ToString();
        }
        void test()
        {
            
        }
        #endregion

        public static bool ShowProgressBar;
        private void ShowProgressBarCheckBox_CheckedChanged(object sender, EventArgs e)
        {
            ShowProgressBar = progressBar.Visible = ShowProgressBarCheckBox.Checked;
        }

        private void moreDeatalsCeckBox_CheckedChanged(object sender, EventArgs e)
        {
            if (pinNumberTextBox.Visible = moreDeatalsCeckBox.Checked)
            {
                detailString = analizer.GetMoreDetails(int.Parse(pinNumberTextBox.Text));
                resultTextBox.Text = resultString + detailString;
            }
        }

        private void pinNumberTextBox_TextChanged(object sender, EventArgs e)
        {
            detailString = analizer.GetMoreDetails(int.Parse(pinNumberTextBox.Text));
            resultTextBox.Text = resultString + detailString;
        }
    }
}
