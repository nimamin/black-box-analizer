namespace BlackBoxAnalizer
{
    class BoolStream
    {
        public bool[] Fix;
        public bool[] Repetitive;

        public bool IsFixPartNull { get { return (Fix == null || Fix.Length == 0); } }
        public bool IsRepetitivePartNull { get { return (Repetitive == null || Repetitive.Length == 0); } }
        public int FixedCount { get { if (IsFixPartNull) return 0; else return Fix.Length; } }
        public int RepetitiveCount { get { if (IsRepetitivePartNull) return 0; else return Repetitive.Length; } }

        public BoolStream(bool[] p)
        {
            Fix = null;
            Repetitive = null;

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
                        Repetitive = new bool[r];
                        for (int j = 0; j < r; j++)
                        {
                            Repetitive[j] = p[f + j];
                        }
                        break;
                    }
                }

                if (equalFlag == true)
                {
                    Fix = new bool[f];
                    for (int i = 0; i < f; i++)
                    {
                        Fix[i] = p[i];
                    }
                    break;
                }
            }

            if (equalFlag == false)
            {
                Repetitive = null;
                Fix = new bool[columns];
                for (int i = 0; i < columns; i++)
                {
                    Fix[i] = p[i];
                }
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
                    c = c & (a.Repetitive[j] != b.Repetitive[j]);
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
                if (a.Fix[i] != b.Fix[i]) return false;
            for (int i = 0; i < a.RepetitiveCount; i++)
                if (a.Repetitive[i] != b.Repetitive[i]) return false;
            return true;
        }

        public static bool operator !=(BoolStream a, BoolStream b)
        {
            if (a.FixedCount == b.FixedCount) return false;
            if (a.RepetitiveCount == b.RepetitiveCount) return false;
            for (int i = 0; i < a.FixedCount; i++)
                if (a.Fix[i] == b.Fix[i]) return false;
            for (int i = 0; i < a.RepetitiveCount; i++)
                if (a.Repetitive[i] == b.Repetitive[i]) return false;
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
            string s;

            s = "Fix part: ";
            if (!IsFixPartNull)
                foreach (bool b in Fix)
                    if (b) s += '1'; else s += '0';
            else s += "null";

            s += ", Repetitive part: ";
            if (!IsRepetitivePartNull)
                foreach (bool b in Repetitive)
                    if (b) s += '1'; else s += '0';
            else s += "null";

            return s;
        }
    }
}