namespace BlackBoxAnalizer
{
    partial class mainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.ImportFileBtn = new System.Windows.Forms.Button();
            this.FileNameLbl = new System.Windows.Forms.Label();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
            this.CloseBtn = new System.Windows.Forms.Button();
            this.SaveBtn = new System.Windows.Forms.Button();
            this.resultLbl = new System.Windows.Forms.Label();
            this.analizeBtn = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // ImportFileBtn
            // 
            this.ImportFileBtn.Location = new System.Drawing.Point(12, 12);
            this.ImportFileBtn.Name = "ImportFileBtn";
            this.ImportFileBtn.Size = new System.Drawing.Size(75, 23);
            this.ImportFileBtn.TabIndex = 0;
            this.ImportFileBtn.Text = "ImportFile";
            this.ImportFileBtn.UseVisualStyleBackColor = true;
            this.ImportFileBtn.Click += new System.EventHandler(this.ImportFileBtn_Click);
            // 
            // FileNameLbl
            // 
            this.FileNameLbl.AutoSize = true;
            this.FileNameLbl.Location = new System.Drawing.Point(12, 38);
            this.FileNameLbl.Name = "FileNameLbl";
            this.FileNameLbl.Size = new System.Drawing.Size(0, 13);
            this.FileNameLbl.TabIndex = 1;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // CloseBtn
            // 
            this.CloseBtn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.CloseBtn.Cursor = System.Windows.Forms.Cursors.Default;
            this.CloseBtn.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.CloseBtn.Location = new System.Drawing.Point(425, 231);
            this.CloseBtn.Name = "CloseBtn";
            this.CloseBtn.Size = new System.Drawing.Size(75, 23);
            this.CloseBtn.TabIndex = 2;
            this.CloseBtn.Text = "Close";
            this.CloseBtn.UseVisualStyleBackColor = true;
            this.CloseBtn.Click += new System.EventHandler(this.CloseBtn_Click);
            // 
            // SaveBtn
            // 
            this.SaveBtn.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.SaveBtn.Location = new System.Drawing.Point(425, 12);
            this.SaveBtn.Name = "SaveBtn";
            this.SaveBtn.Size = new System.Drawing.Size(75, 23);
            this.SaveBtn.TabIndex = 3;
            this.SaveBtn.Text = "Save";
            this.SaveBtn.UseVisualStyleBackColor = true;
            this.SaveBtn.Visible = false;
            this.SaveBtn.Click += new System.EventHandler(this.SaveBtn_Click);
            // 
            // resultLbl
            // 
            this.resultLbl.AutoSize = true;
            this.resultLbl.Location = new System.Drawing.Point(12, 51);
            this.resultLbl.Name = "resultLbl";
            this.resultLbl.Size = new System.Drawing.Size(0, 13);
            this.resultLbl.TabIndex = 1;
            // 
            // analizeBtn
            // 
            this.analizeBtn.Location = new System.Drawing.Point(93, 12);
            this.analizeBtn.Name = "analizeBtn";
            this.analizeBtn.Size = new System.Drawing.Size(75, 23);
            this.analizeBtn.TabIndex = 4;
            this.analizeBtn.Text = "Analize";
            this.analizeBtn.UseVisualStyleBackColor = true;
            this.analizeBtn.Click += new System.EventHandler(this.analizeBtn_Click);
            // 
            // mainForm
            // 
            this.AcceptButton = this.ImportFileBtn;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.CloseBtn;
            this.ClientSize = new System.Drawing.Size(512, 266);
            this.Controls.Add(this.analizeBtn);
            this.Controls.Add(this.SaveBtn);
            this.Controls.Add(this.CloseBtn);
            this.Controls.Add(this.resultLbl);
            this.Controls.Add(this.FileNameLbl);
            this.Controls.Add(this.ImportFileBtn);
            this.Name = "mainForm";
            this.Text = "Black Box Analizer";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button ImportFileBtn;
        private System.Windows.Forms.Label FileNameLbl;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.SaveFileDialog saveFileDialog1;
        private System.Windows.Forms.Button CloseBtn;
        private System.Windows.Forms.Button SaveBtn;
        private System.Windows.Forms.Label resultLbl;
        private System.Windows.Forms.Button analizeBtn;
    }
}

