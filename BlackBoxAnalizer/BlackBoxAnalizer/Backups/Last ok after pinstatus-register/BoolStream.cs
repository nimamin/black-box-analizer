namespace BlackBoxAnalizer
{
    class BoolStream
    {
        bool[] fix;
        bool[] repetitive;
        public bool[] Rep { get { return repetitive; } }

        int edge; public int Edge { get { return edge; } }
        int duty; public int Duty { get { return duty; } }

        PinStatus pinStatus;
        public PinStatus PinStatus { get { return pinStatus; } }

        bool pin1IsClock = false;
        public bool Pin1IsClock { get { return pin1IsClock; } }

        public bool IsFixPartNull { get { return (fix == null || fix.Length == 0); } }
        public bool IsRepetitivePartNull { get { return (repetitive == null || repetitive.Length == 0); } }
        public int FixedCount { get { if (IsFixPartNull) return 0; else return fix.Length; } }
        public int RepetitiveCount { get { if (IsRepetitivePartNull) return 0; else return repetitive.Length; } }

        public BoolStream(bool[] p)
        {
            fix = null;
            repetitive = null;

            int columns = p.Length;
            bool equalFlag = true;

            for (int f = 0; f < columns; f++)
            {
                // f starts from beginning to measure fixed part of the stream.
                int middle = f + (columns - f + 1) * 2 / 3; // for ending the comparision at the half of the stream.
                for (int i = f; i < middle; i++)
                {
                    // i starts from the end of the fixed part and is the end of the Repetitive part that mast be compared with remained stream after i.
                    int r = i - f + 1; // for measuring the length of the repetitive part.
                    for (int j = 1; j <= columns / r + 1; j++)
                    {
                        // j couts the number of correct maches after every compare.
                        if (f + j * r > columns - 1) break;
                        for (int k = 0; k < r; k++)
                        {
                            // for each compare we need k to comparing the field.
                            if (f + k + j * r > columns - 1) break;
                            if (p[f + k] != p[f + k + j * r])
                            {
                                equalFlag = false;
                                break;
                            }
                            else equalFlag = true;
                        }
                        if (equalFlag == false) break;
                    }

                    if (equalFlag == true)
                    {
                        repetitive = new bool[r];
                        for (int j = 0; j < r; j++)
                        {
                            repetitive[j] = p[f + j];
                        }
                        break;
                    }
                }

                if (equalFlag == true)
                {
                    fix = new bool[f];
                    for (int i = 0; i < f; i++)
                    {
                        fix[i] = p[i];
                    }
                    break;
                }
            }

            if (equalFlag == false)
            {
                repetitive = null;
                fix = new bool[columns];
                for (int i = 0; i < columns; i++)
                {
                    fix[i] = p[i];
                }
            }

            edge = 0; duty = 0;
            if (repetitive != null)
            {
                for (int i = 0; i < repetitive.Length - 1; i++)
                    if (!repetitive[i] && repetitive[i + 1]) edge++;
                for (int i = 0; i < repetitive.Length; i++)
                    if (repetitive[i]) duty++;
            }

            if ((fix == null) || (fix.Length == 0))
            {
                if ((repetitive == null) || (repetitive.Length == 0)) pinStatus = BlackBoxAnalizer.PinStatus.Null;
                else if (repetitive.Length == 1) pinStatus = BlackBoxAnalizer.PinStatus.Combinatorial;
                else if (repetitive.Length > 1) pinStatus = BlackBoxAnalizer.PinStatus.Counter;
            }
            else if (fix.Length == 1)
            {
                if ((repetitive == null) || (repetitive.Length == 0)) pinStatus = BlackBoxAnalizer.PinStatus.Combinatorial;
                else if (repetitive.Length == 1) pinStatus = BlackBoxAnalizer.PinStatus.Register;
            }
            else if ((repetitive == null) || (repetitive.Length == 0)) pinStatus = BlackBoxAnalizer.PinStatus.Combinatorial;

            if (repetitive != null)
            {
                if (repetitive.Length > 3) pin1IsClock = true;
                else if ((fix != null) && (fix.Length == 1)) pin1IsClock = true;
            }
        }

        public static bool IsEquivalent(BoolStream a, BoolStream b)
        {
            int length = a.RepetitiveCount;
            if (length != b.RepetitiveCount) return false;
            
            for (int i = 0; i < length; i++)
            {
                bool c = true;
                for (int j = 0; j <length; j++)
                {
                    int k = (i + j) % length;
                    c = c & (a.repetitive[j] != b.repetitive[j]);
                }
                if (c) return true;
            }

            return false;
        }

        public static bool operator ==(BoolStream a, BoolStream b)
        {
            if (a.FixedCount != b.FixedCount) return false;
            if (a.RepetitiveCount != b.RepetitiveCount) return false;
            for (int i = 0; i < a.FixedCount; i++)
                if (a.fix[i] != b.fix[i]) return false;
            for (int i = 0; i < a.RepetitiveCount; i++)
                if (a.repetitive[i] != b.repetitive[i]) return false;
            return true;
        }

        public static bool operator !=(BoolStream a, BoolStream b)
        {
            if (a.FixedCount == b.FixedCount) return false;
            if (a.RepetitiveCount == b.RepetitiveCount) return false;
            for (int i = 0; i < a.FixedCount; i++)
                if (a.fix[i] == b.fix[i]) return false;
            for (int i = 0; i < a.RepetitiveCount; i++)
                if (a.repetitive[i] == b.repetitive[i]) return false;
            return true;
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

            if (!IsFixPartNull)
            {
                s += "F: ";
                foreach (bool b in fix)
                    if (b) s += '1'; else s += '0';
                if (!IsRepetitivePartNull) s += ", ";
            }

            if (!IsRepetitivePartNull)
            {
                s += "R: ";
                foreach (bool b in repetitive)
                    if (b) s += '1'; else s += '0';
                //s += ", ";
            }

            //s += "E: " + edge + ", " + "D: " + duty;
            s += ", " + pinStatus.ToString();
            return s;
        }
    }

    enum PinStatus
    {
        Null,
        Combinatorial,
        Register,
        Counter
    }
}