// -------------------------------------------------------------------------
//
// Autor: Szymon Skałka
// Temat: Program łączący dwa pliki graficzne.
// Opis: Program mnoży wartości bajtowe dwóch obrazów przez zmienną i oblicza wartość połączoną 
// Data: 11.02.2024 Semestr 5 Rok II Skałka Szymon
// Wersja 1.0
//
// This is the C# Windows Forms main function
//
// -------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Threading;
using System.Numerics;
using System.Diagnostics;


namespace JA_projekt
{
    public partial class Form1 : Form
    {
        public int ALPHA;
        public int THREADS;
        public List<Thread> threads;
        Mutex mut;
        int bytes;
        public byte[] imageByteArray1;
        public byte[] imageByteArray2;
        public byte[] imageByteArray3;
        public byte[] imageByteArray4;



        [DllImport("CppLib.dll", CallingConvention = CallingConvention.Cdecl)]
        unsafe public static extern void BlendImagesInCpp(byte* byteArray1First, byte* byteArray1Last,
                                                          byte* byteArray2First, byte* byteArray2Last,
                                                          int alpha);

        [DllImport("AsmLib.dll")]
        unsafe public static extern void BlendInAsm(byte* byteArray1First, byte* byteArray1Last,
                                                 byte* byteArray2First, byte* byteArray2Last,
                                                 int alpha);
        public byte[] ImageToByteArray(System.Drawing.Image imageIn)
        {
            using (MemoryStream memstr = new MemoryStream())
            {
                memstr.Position = 0;
                imageIn.Save(memstr, imageIn.RawFormat);
                return memstr.ToArray();
            }
        }

        public Image ByteArrayToImage(byte[] bytesArr)
        {
            using (MemoryStream memstr = new MemoryStream(bytesArr))
            {
                memstr.Position = 0;
                return Image.FromStream(memstr);
            }
        }

        public Form1()
        {
            InitializeComponent();
            ALPHA = 128;
            THREADS = 1;
            trackBar1.Value = 128;
            threads = new List<Thread>();
            mut = new Mutex();
            bytes = 0;
            imageByteArray1 = null;
            imageByteArray2 = null;
            imageByteArray3 = null;
            imageByteArray4 = null;
        }

        
        protected override void OnPaintBackground(PaintEventArgs e)
        {
            using (System.Drawing.Drawing2D.LinearGradientBrush brush = 
                new System.Drawing.Drawing2D.LinearGradientBrush(this.ClientRectangle,
                                                                       Color.Gray,
                                                                       Color.DarkGray,                                                                      
                                                                       45F))
            {
                e.Graphics.FillRectangle(brush, this.ClientRectangle);
            }
        }
        private void Form1_Resize(object sender, EventArgs e)
        {
            this.Invalidate();
        }
        private void Forms1_Load(object sender, EventArgs e)
        {
            this.CenterToScreen();
            pictureBox1.SizeMode = PictureBoxSizeMode.Zoom;
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {

        }

        private void linkLabel2_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void trackBar1_Scroll(object sender, EventArgs e)
        {
            ALPHA = trackBar1.Value;
            textBox3.Text = ("ALPHA: " + ALPHA);
        }

        private void linkLabel3_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
          
        }

        private void button1_Click(object sender, EventArgs e)
        {
            openFileDialog1.FileName = "";
            openFileDialog1.Filter = "Image files (*.bmp)| *.bmp";

            openFileDialog1.ShowDialog();
            if (!string.IsNullOrEmpty(openFileDialog1.FileName))
            {
                pictureBox1.Image = Image.FromFile(@openFileDialog1.FileName);
                pictureBox1.SizeMode = PictureBoxSizeMode.StretchImage;


                imageByteArray1 = ImageToByteArray(Image.FromFile(@openFileDialog1.FileName));

            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            openFileDialog2.FileName = "";
            openFileDialog2.Filter = "Image files (*.bmp)| *.bmp";

            openFileDialog2.ShowDialog();
            if (!string.IsNullOrEmpty(openFileDialog2.FileName))
            {
                pictureBox2.Image = Image.FromFile(@openFileDialog2.FileName);
                pictureBox2.SizeMode = PictureBoxSizeMode.StretchImage;
                imageByteArray2 = ImageToByteArray(Image.FromFile(@openFileDialog2.FileName));
            }
        }

        unsafe private void button3_Click(object sender, EventArgs e)
        {      
            if (!(imageByteArray1.Equals(null) || imageByteArray2.Equals(null)))
            {
                if (imageByteArray1.Length == imageByteArray2.Length)
                {
                    Stopwatch time = new Stopwatch();
                    time.Start();
                    imageByteArray3 = new byte[imageByteArray1.Length];
                    imageByteArray1.CopyTo(imageByteArray3, 0);

                    bytes = (int)Math.Floor((double)((imageByteArray3.Length-1) / THREADS));

                    threads.Clear();
                    List<int> index = new List<int>();
                    index.Add(0);               
                    for (int i = 0; i < THREADS-1; i++)
                    {                       
                        threads.Add(new Thread(new ParameterizedThreadStart(BlendInCppInThreadOneParamater)));
                        threads[i].Start(index[i]);
                        index.Add(index[i] + bytes + 1);                      
                    }
                                                                    
                    if (index.Last() + bytes > imageByteArray3.Length - 1)
                        index[index.Count-1] = imageByteArray3.Length - 1 - bytes;    
                    
                    threads.Add(new Thread(new ParameterizedThreadStart(BlendInCppInThreadOneParamater)));
                    threads.Last().Start(index.Last());
                   
                    foreach (Thread thr in threads)
                    {
                        thr.Join();
                        thr.Abort();
                    }
                    time.Stop();
                    textBox1.Text = ("C++ blending took " + time.ElapsedMilliseconds + "ms.");


                    pictureBox3.Image = ByteArrayToImage(imageByteArray3);
                    pictureBox3.SizeMode = PictureBoxSizeMode.StretchImage;
                }
                else
                {
                    //TODO: images formats not matching error message
                }
            }        
        }

      

        unsafe private void button4_Click(object sender, EventArgs e)
        {
            if (!(imageByteArray1.Equals(null) || imageByteArray2.Equals(null)))
            {
                if (imageByteArray1.Length == imageByteArray2.Length)
                {
                    Stopwatch time = new Stopwatch();
                    time.Start();
                    imageByteArray4 = new byte[imageByteArray1.Length];
                    imageByteArray1.CopyTo(imageByteArray4, 0);



                    bytes = (int)Math.Floor((double)((imageByteArray4.Length - 1) / THREADS));

                    threads.Clear();
                    List<int> index = new List<int>();
                    index.Add(0);
                    
                    for (int i = 0; i < THREADS - 1; i++)
                    {
                        threads.Add(new Thread(new ParameterizedThreadStart(BlendInAsmInThreadOneParamater)));
                        threads[i].Start(index[i]);
                        index.Add(index[i] + bytes + 1);
                    }

                    if (index.Last() + bytes > imageByteArray4.Length - 1)
                        index[index.Count - 1] = imageByteArray4.Length - 1 - bytes;

                    threads.Add(new Thread(new ParameterizedThreadStart(BlendInAsmInThreadOneParamater)));
                    threads.Last().Start(index.Last());

                    foreach (Thread thr in threads)
                    {
                        thr.Join();
                        thr.Abort();
                    }
                    time.Stop();
                    textBox2.Text = ("ASM blending took " + time.ElapsedMilliseconds + "ms.");

                   

                 

                   


                    
                    pictureBox3.Image = ByteArrayToImage(imageByteArray4);
                    pictureBox3.SizeMode = PictureBoxSizeMode.StretchImage;
                }
                else
                {
                    //TODO: images formats not matching error message
                }
            }
        }


        unsafe async private void BlendInCppInThreadOneParamater(object obj)
        {
            int i = (int)obj;
            //mut.WaitOne();
            //Monitor.Enter(imageByteArray3);
            byte* firstByte1;
            byte* lastByte1;
            fixed (byte* fb1 = &imageByteArray3[i]) { firstByte1 = fb1; };
            fixed (byte* lb1 = &imageByteArray3[i + bytes]) { lastByte1 = lb1; };
            //Monitor.Exit(imageByteArray3);

            byte* firstByte2;
            byte* lastByte2;

            //Monitor.Enter(imageByteArray2);
            fixed (byte* fb2 = &imageByteArray2[i]) { firstByte2 = fb2; };
            fixed (byte* lb2 = &imageByteArray2[i + bytes]) { lastByte2 = lb2; };
            BlendImagesInCpp(firstByte1, lastByte1, firstByte2, lastByte2, ALPHA);
            //Monitor.Exit(imageByteArray2);
            //mut.ReleaseMutex();
        }

        unsafe async private void BlendInAsmInThreadOneParamater(object obj)
        {
            int i = (int)obj;
            //mut.WaitOne();
            //Monitor.Enter(imageByteArray3);
            byte* firstByte1;
            byte* lastByte1;
            fixed (byte* fb1 = &imageByteArray4[i]) { firstByte1 = fb1; };
            fixed (byte* lb1 = &imageByteArray4[i + bytes]) { lastByte1 = lb1; };
            //Monitor.Exit(imageByteArray3);

            byte* firstByte2;
            byte* lastByte2;

            //Monitor.Enter(imageByteArray2);
            fixed (byte* fb2 = &imageByteArray2[i]) { firstByte2 = fb2; };
            fixed (byte* lb2 = &imageByteArray2[i + bytes]) { lastByte2 = lb2; };

            BlendInAsm(firstByte1, lastByte1, firstByte2, lastByte2, ALPHA);
            //Monitor.Exit(imageByteArray2);
            //mut.ReleaseMutex();
        }


       

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void pictureBox3_Click(object sender, EventArgs e)
        {

        }

        private void pictureBox5_Click(object sender, EventArgs e)
        {

        }

        private void trackBar2_Scroll(object sender, EventArgs e)
        {
            THREADS = trackBar2.Value;
            textBox4.Text = ("Number of threads: " + THREADS);
        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void button5_Click(object sender, EventArgs e)
        {
            if (!(imageByteArray1.Equals(null) || imageByteArray2.Equals(null)))
            {
                if (imageByteArray1.Length == imageByteArray2.Length)
                {
                    List<String> output = new List<String>();

                    output.Add(GenerateData(1));
                    output.Add(GenerateData(2));
                    output.Add(GenerateData(4));
                    output.Add(GenerateData(8));
                    output.Add(GenerateData(16));
                    output.Add(GenerateData(32));
                    output.Add(GenerateData(64));

                    string docPath =
                    Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
                    using (StreamWriter outputFile = new StreamWriter(Path.Combine(docPath, "data.txt")))
                    {
                        //text saved as nThreads asmTime cppTime
                        foreach (string line in output)
                            outputFile.WriteLine(line);
                    }




                }
                else
                {
                    //TODO: images formats not matching error message
                }
            }
        }

        private string GenerateData(int  threadAmount)
        {
            String data = "";
            Stopwatch time = new Stopwatch();
            time.Start();
            imageByteArray4 = new byte[imageByteArray1.Length];
            imageByteArray1.CopyTo(imageByteArray4, 0);

            bytes = (int)Math.Floor((double)((imageByteArray4.Length - 1) / threadAmount));

            threads.Clear();
            List<int> index = new List<int>();
            index.Add(0);

            for (int i = 0; i < threadAmount - 1; i++)
            {
                threads.Add(new Thread(new ParameterizedThreadStart(BlendInAsmInThreadOneParamater)));
                threads[i].Start(index[i]);
                index.Add(index[i] + bytes + 1);
            }

            if (index.Last() + bytes > imageByteArray4.Length - 1)
                index[index.Count - 1] = imageByteArray4.Length - 1 - bytes;

            threads.Add(new Thread(new ParameterizedThreadStart(BlendInAsmInThreadOneParamater)));
            threads.Last().Start(index.Last());

            foreach (Thread thr in threads)
            {
                thr.Join();
                thr.Abort();
            }
            time.Stop();

            data += (threadAmount + " " + time.ElapsedMilliseconds);


            time = new Stopwatch();
            time.Start();
            imageByteArray3 = new byte[imageByteArray1.Length];
            imageByteArray1.CopyTo(imageByteArray3, 0);

            bytes = (int)Math.Floor((double)((imageByteArray3.Length - 1) / threadAmount));

            threads.Clear();
            index = new List<int>();
            index.Add(0);

            for (int i = 0; i < threadAmount - 1; i++)
            {
                threads.Add(new Thread(new ParameterizedThreadStart(BlendInAsmInThreadOneParamater)));
                threads[i].Start(index[i]);
                index.Add(index[i] + bytes + 1);
            }

            if (index.Last() + bytes > imageByteArray3.Length - 1)
                index[index.Count - 1] = imageByteArray3.Length - 1 - bytes;

            threads.Add(new Thread(new ParameterizedThreadStart(BlendInCppInThreadOneParamater)));
            threads.Last().Start(index.Last());

            foreach (Thread thr in threads)
            {
                thr.Join();
                thr.Abort();
            }
            time.Stop();
            data += (" " + time.ElapsedMilliseconds);

            // SAVE TO FILE HERE
            return data;
        }

    }


}
