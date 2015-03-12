using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BlackBoxAnalizer
{
    class SequenceFinder
    {
        int inPinCount, lines;
        BoolStream[][] boolStreams;
        Sequence[] sequence;
        bool[] cary;
        Sequence[] minSequences;
        PIQueue[] seqPIQueue;
        int diffCounter;
        bool[] clockEnabled;

        public SequenceFinder(Pin[] pins)
        {
            inPinCount = pins.Length;
            lines = pins[0].ClockedPin.Lines;
            boolStreams = new BoolStream[inPinCount][];
            clockEnabled = new bool[inPinCount];
            for (int i = 0; i < inPinCount; i++)
                if (clockEnabled[i] = pins[i].ClockedPin.ClockEnabled) boolStreams[i] = pins[i].ClockedPin.BoolStream;

            cary = new bool[lines];
            sequence = new Sequence[lines];
        }

        public void GenerateSequence()
        {
            for (int l = 0; l < lines; l++)
            {
                int[] sort = bubleSegmentSort(l);
                BoolStream[] b = new BoolStream[inPinCount];
                for (int i = 0; i < inPinCount; i++)
                    if (clockEnabled[i]) b[i] = boolStreams[sort[i]][l];

                sequence[l] = new Sequence(b, cary[l], sort);
            }

            diffCounter = 1;
            int[] diffIndex = new int[lines];
            diffIndex[0] = 0;
            for (int l = 1; l < lines; l++)
            { 
                bool equal = false;
                for (int i = 0; i < diffCounter; i++)
                    equal |= (sequence[l] == sequence[diffIndex[i]]);
                if (equal == false) diffIndex[diffCounter++] = l;
            }

            minSequences = new Sequence[diffCounter];
            seqPIQueue = new PIQueue[diffCounter];
            for (int i = 0; i < diffCounter; i++)
            {
                minSequences[i] = sequence[diffIndex[i]];
                bool[] trueTable = new bool[lines];
                for (int l = 0; l < lines; l++)
                    if (minSequences[i] == sequence[l]) trueTable[l] = true;
                seqPIQueue[i] = new PIQueue(trueTable, true);
            }
        }

        int[] bubleSegmentSort(int l)
        {
            int[] sort = new int[inPinCount];
            int[] width = new int[inPinCount];
            int[] edges = new int[inPinCount];
            int[] dutys = new int[inPinCount];
            BoolStream b;

            for (int i = 0; i < inPinCount; i++)
            {
                if (!clockEnabled[i]) continue;
                b = boolStreams[i][l];
                sort[i] = i;
                width[i] = b.RepetitiveCount;
                edges[i] = b.Edge;
                dutys[i] = b.Duty;
            }

            for (int i = 0; i < inPinCount; i++)
                for (int j = 0; j < inPinCount - 1; j++)
                    if (width[sort[j]] > width[sort[j + 1]]) swap(ref sort, j);

            for (int i = 0; i < inPinCount; i++)
                for (int j = 0; j < inPinCount - 1; j++)
                    if ((width[sort[j]] == width[sort[j + 1]]) && (edges[sort[j]] < edges[sort[j + 1]])) swap(ref sort, j);

            for (int i = inPinCount - 1; i >= 0; i--)
                if ((edges[i] == 1) && (dutys[i] == 2))
                {
                    if (i != inPinCount - 1) swap(ref sort, i);
                    cary[l] = true;
                    break;
                }
            
            return sort;
        }
        private void swap(ref int[] sort, int j)
        {
            int temp = sort[j];
            sort[j] = sort[j + 1];
            sort[j + 1] = temp;
        }

        public override string ToString()
        {
            string s = "";

            for (int i = 0; i < diffCounter; i++)
            {
                s += "Sequence:" + minSequences[i] + " with bit order of ?";////////FIX IT???????????
                s += " is in this logic:" + seqPIQueue[i].ToPinString();
            }

            return s;
        }
    }

    class Sequence
    {
        bool cary;
        int[] seq;
        int[] sort;
        public int[] Sort { get { return sort; } }
        int length;
        int width;
        public int Width { get { return width; } }

        public Sequence(BoolStream[] boolStream, bool cary, int[] sort)
        {
            this.cary = cary;
            this.sort = sort;
            length = boolStream.Length;
            if (cary) length--;
            int maxWidth = 0;
            for (int i = 0; i < length; i++)
                if (maxWidth < boolStream[i].RepetitiveCount)
                    maxWidth = boolStream[i].RepetitiveCount;
            width = maxWidth;
            this.seq = new int[width];
            for (int j = 0; j < maxWidth; j++)
            {
                int t = 0;
                for (int i = 0; i < length; i++)
                {
                    if (boolStream[i].Rep[j % boolStream[i].RepetitiveCount]) t += 1 << i;
                }
                seq[j] = t;
            }
        }

        static public bool operator ==(Sequence a, Sequence b)
        {
            if (a.cary != b.cary) return false;
            if (a.width != b.width) return false;
            for (int i = 0; i < a.width; i++)
            {
                if (a.sort[i] != b.sort[i]) return false;
                if (a.seq[i] != b.seq[i]) return false;
            }
            return true;
        }

        static public bool operator !=(Sequence a, Sequence b)
        {
            if (a.cary != b.cary) return true;
            if (a.width != b.width) return true;
            for (int i = 0; i < a.width; i++)
            {
                if (a.sort[i] != b.sort[i]) return true;
                if (a.seq[i] != b.seq[i]) return true;
            }
            return false;
        }

        public override bool Equals(object obj)
        {
            return base.Equals(obj);
        }

        public override int GetHashCode()
        {
            return base.GetHashCode();
        }

        public override string ToString()
        {
            string s = "";
            for (int i = 0; i < width; i++)
                s += seq[i];
            return s;
        }
    }
}
