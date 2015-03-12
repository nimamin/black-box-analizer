
namespace BlackBoxAnalizer
{
    class QueenMcClaussy
    {
        internal static string GetString(int[] minterms, int inPinCount)
        {
            int length = minterms.Length;
            PrimeImplicant[] implicants = new PrimeImplicant[length];
            implicants[0] = new PrimeImplicant(minterms[0], inPinCount);
            for (int i = 1; i < minterms.Length; i++)
            {
                implicants[i] = new PrimeImplicant(minterms[i]);
            }

            PIQueue piQueue = normalaize(implicants);
            PrimeImplicant[] normalazedImplicants = piQueue.GetArray();
            
            int high = normalazedImplicants.Length;
            bool[,] table = new bool[high, length];
            for (int j = 0; j < high; j++)
            {
                PrimeImplicant b = normalazedImplicants[j];
                for (int i = 0; i < length; i++)
                {
                    PrimeImplicant a = implicants[i];
                    if (b.Contain(a))
                        table[j, i] = true;
                }
            }

            int[] finalPIs = findMinimom(table);

            string s = "";
            for (int i = 0; i < finalPIs.Length; i++)
            {
                s += normalazedImplicants[finalPIs[i]].ToString();
            }
            return s;
        }

        private static int[] findMinimom(bool[,] table)
        {
            int high = table.GetLength(0);
            int length = table.GetLength(1);
            bool done = false;
            bool[,] tMask;
            bool[] hMask = new bool[0];

            for (int h = high - 1; h >= 0; h--)
            {
                Chooser chooser = new Chooser(h, high);
                while (!done)
                {
                    tMask = new bool[high, length];
                    hMask = chooser.ChooseNextSet();
                    if (hMask == null)
                    {
                        done = false;
                        break;
                    }

                    //look is deleting possible break. if not continue.
                    bool b = true;
                    for (int i = 0; i < length; i++)
                    {
                        bool a = false;
                        for (int j = 0; j < high; j++)
                        {
                            a = a & (table[j, i] & !tMask[j, i]);
                        }
                        b = b & a;
                    }
                    done = b;
                }
                //becouse h is count down so the first one is the best. then when find it break.
                if (done) break;
            }
            //convert the hmask to int[] and return.
            int counter = 0;
            for (int j = 0; j < high; j++)
                if (hMask[j]) counter++;
            int[] result = new int[counter];
            counter = 0;
            for (int j = 0; j < high; j++)
                if (hMask[j]) result[counter++] = j;

            return result;
        }

        private static PIQueue normalaize(PrimeImplicant[] implicants)
        {
            PIQueue piQueue = new PIQueue();

            for (int i = 0; i < implicants.Length; i++)
            {
                piQueue.Add(implicants[i]);
            }

            piQueue.Normalize();

            return piQueue;
        }
    }

    class Chooser
    {
        int high;
        int h;
        int[] indexs;
        bool firstTime = true;

        public Chooser(int h, int high)
        {
            this.high = high;
            this.h = h;
            indexs = new int[h+1];
            indexs[h] = high;
        }

        public bool[] ChooseNextSet()
        {
            bool[] mask = new bool[high];
            if (firstTime)
            {
                firstTime = false;
                indexs[0] = 0;
                for (int f = 1; f < h; f++)
                    indexs[f] = indexs[f - 1] + 1;
                for (int f = 0; f < h; f++)
                    mask[indexs[f]] = true;
                return mask;
            }

            bool done = false;
            for (int f = h - 1; f >= 0; f--)
            {
                if (indexs[f] + 1 < indexs[f+1])
                {
                    indexs[f]++;
                    while (++f < h)
                        indexs[f] = indexs[f - 1] + 1;
                    done = true;
                    break;
                }
            }

            if (!done) return null;

            for (int f = 0; f < h; f++)
                mask[indexs[f]] = true;

            return mask;
        }
    }

    class PIQueue
    {
        PINode head;
        PINode tail;

        public PIQueue()
        {
            tail = null;
            head = null;
        }

        public void Add(PrimeImplicant pi)
        {
            int newHash = pi.GetHashCode();
            PINode p = head;
            while (p != null)
            {
                if (newHash == p.PI.GetHashCode()) return;
                p = p.Next;
            }            

            PINode newNode = new PINode(pi);
                        
            if (tail == null)
            {
                head = tail = newNode;
            }
            else
            {
                newNode.Previous = tail;
                tail.Next = newNode;
                tail = newNode;
            }
        }

        internal void Normalize()
        {
            PrimeImplicant newPI;
            PINode p, q;
            int i = 0;

            p = head;
            while (p != null)
            {
                q = p.Next;
                while (q != null)
                {
                    if ((newPI = PrimeImplicant.Merge(p.PI, q.PI)) != null)
                        this.Add(newPI);
                    q = q.Next;
                    i++;
                }
                p = p.Next;
            }

            p = head;
            while (p != null)
            {
                if (p.PI.Tik) Delete(ref p);
                else p = p.Next;
            }
        }

        public void Delete(ref PINode p)
        {
            PINode next = p.Next;
            if (p == head)
            {
                head = p.Next;
                p.Next.Previous = null;
            }
            else if (p == tail)
            {
                tail = p.Previous;
                p.Previous.Next = null;
            }
            else
            {
                p.Previous.Next = p.Next;
                p.Next.Previous = p.Previous;
            }
            p = next;
        }

        internal PrimeImplicant[] GetArray()
        {
            int length = 0;
            PINode p = head;

            while (p != null)
            {
                p = p.Next;
                length++;
            }

            PrimeImplicant[] pis = new PrimeImplicant[length];
            p = head;

            for (int i = 0; i < length; i++)
            {
                pis[i] = p.PI;
                p = p.Next;
            }

            return pis;
        }

        public override string ToString()
        {
            PINode p = head;
            string s = p.ToString();
            p = p.Next;
            while (p != null)
            {
                s += " + " + p.ToString();
                p = p.Next;
            }
            return s;
        }

        public string GetAlphabetString()
        {
            PINode p = head;
            string s = p.PI.GetAlphabetString();
            p = p.Next;
            while (p != null)
            {
                s += " + " + p.PI.GetAlphabetString();
                p = p.Next;
            }
            return s;
        }
    }

    class PINode
    {
        PINode nextNode;
        public PINode Next { get { return nextNode; } set { nextNode = value; } }
        PINode previousNode;
        public PINode Previous { get { return previousNode; } set { previousNode = value; } }
        PrimeImplicant primeImplicant;
        public PrimeImplicant PI { get { return primeImplicant; } }

        public PINode(PrimeImplicant primeImplicant)
        {
            this.primeImplicant = primeImplicant;
            
            nextNode = null;
            previousNode = null;
        }

        public override string ToString()
        {
            return primeImplicant.ToString();
        }
    }

    class PrimeImplicant
    {
        static int count;

        Literal[] literls;
        bool tik = false;
        public bool Tik { get { return tik; } }

        public PrimeImplicant(int line, int inPinCount)
        {
            count = inPinCount;
            literls = new Literal[count];

            for (int i = 0; i < count; i++)
            {
                literls[i] = new Literal(line & (1 << i));
            }
        }
        public PrimeImplicant(int line)
        {
            literls = new Literal[count];

            for (int i = 0; i < count; i++)
            {
                literls[i] = new Literal(line & (1 << i));
            }
        }
        public PrimeImplicant()
        {
            literls = new Literal[count];
        }

        internal static PrimeImplicant Merge(PrimeImplicant p, PrimeImplicant q)
        {
            PrimeImplicant newPI = new PrimeImplicant();
            Literal qLit, pLit;
            int differenceCounter = 0;
            for (int i = 0; i < count; i++)
            {
                pLit = p.literls[i];
                qLit = q.literls[i];
                differenceCounter += Literal.IsMergble(pLit, qLit);
                if (differenceCounter > 1) return null;
                newPI.literls[i] = new Literal(p.literls[i], q.literls[i]);
            }
            p.tik = true;
            q.tik = true;
            return newPI;
        }
        internal bool Contain(PrimeImplicant a)
        {
            for (int i = 0; i < count; i++)
            {
                if (literls[i].DontCare) continue;
                if (literls[i].Value != a.literls[i].Value) return false;
            }
            return true;
        }

        public override int GetHashCode()
        {
            int h = 0;
            int s = 1;
            for (int i = 0; i < count; i++)
            {
                h += s * literls[i].GetHashCode();
                s *= 3;
            }
            return h;
        }
        public override string ToString()
        {
            string s = "";

            for (int i = count - 1; i >= 0; i--)
                s += literls[i].ToString();

            return s;
        }
        internal string GetAlphabetString()
        {
            string s = "";
            for (int i = count - 1; i >= 0; i--)
                s += literls[i].GetAlphabetString(i);

            return s;
        }
    }

    class Literal
    {
        bool binValue;
        public bool Value { get { return binValue; } set { binValue = value; } }
        bool dontCare;
        public bool DontCare { get { return dontCare; } set { dontCare = value; } }

        public Literal(bool b)
        {
            binValue = b;
            dontCare = false;
        }
        public Literal(int i)
        {
            binValue = (i > 0);
            dontCare = false;
        }
        public Literal(Literal a, Literal b)
        {
            if (a.dontCare) this.dontCare = true;
            else if (a.binValue ^ b.binValue) this.dontCare = true;
            else this.binValue = a.binValue;
        }

        public static bool operator ==(Literal a, Literal b)
        {
            if (a.dontCare != b.dontCare) return false;
            else return (a.binValue == b.binValue);
        }
        public static bool operator !=(Literal a, Literal b)
        {
            return !(a == b);
        }
        
        public override int GetHashCode()
        {
            if (dontCare) return 2;
            else if (binValue) return 1;
            else return 0;
        }
        public override bool Equals(object obj)
        {
            return base.Equals(obj);
        }
        public override string ToString()
        {
            if (dontCare) return "-";
            else if (binValue) return "1";
            else return "0";
        }
        public string GetAlphabetString(int i)
        {
            char[] cchars = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R' };
            char[] chars = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r' };
            if (dontCare) return "";
            else if (binValue) return cchars[i].ToString();
            else return (chars[i]).ToString();
        }

        internal static int IsMergble(Literal a, Literal b)
        {
            if (a == b) return 0;
            if (a.dontCare ^ b.dontCare) return 2;
            return 1;
        }
    }
}
