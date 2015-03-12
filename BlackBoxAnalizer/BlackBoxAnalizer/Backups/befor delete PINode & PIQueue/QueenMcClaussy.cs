
namespace BlackBoxAnalizer
{
    class QueenMcClaussy
    {

        internal static string GetString(int[] minterms, int inPinCount)
        {
            PIQueue piQueue = new PIQueue(minterms, inPinCount);
            return piQueue.normalaize();
        }

    }

    class PIQueue
    {
        PINode head;
        PINode tail;
        int count;

        public PIQueue(int[] minterms, int inPinCount)
        {
            count = inPinCount;
            PrimeImplicant pi = new PrimeImplicant(minterms[0], count);
            tail = head = new PINode(pi);
            for (int i = 1; i < minterms.Length; i++)
                tail = addQueue(minterms[i]);
        }

        PINode addQueue(int line)
        {
            PrimeImplicant pi = new PrimeImplicant(line, count);
            return new PINode(pi, tail);
        }

        internal string normalaize()
        {
            PINode[] groups = sort();
            if (merge(groups)) return normalaize();
            else
                return this.ToString();
        }

        private bool merge(PINode[] groups)
        {
            throw new System.NotImplementedException();
        }

        private PINode[] sort()
        {
            int length = this.Length;

            PINode p = head; PINode q = head;
            PINode[] pin = new PINode[count];
            
            for (int i = 0; i < count; i++)
            {
                while (p != null) if (p.TrueCounter != i) p = p.Next; else break;

                while (true)
                {
                    while (p != null) if (p.TrueCounter == i) p = p.Next; else break;

                    if (p == null) break;
                    q = p;

                    while (q != null) if (q.TrueCounter != i) q = q.Next; else break;

                    if (q == null) break;

                    q.Cut();
                    p.Insert(q);
                }

                if (p != null) pin[i] = p.Previous;
                else if (tail.TrueCounter == i) pin[i] = tail;
                else pin[i] = null;
            }            

            return pin;
        }

        public int Length 
        {
            get
            {
                int i = 1;
                PINode p = head;

                while ((p = p.Next) != null) i++;

                return i;
            }
        }

        public override string ToString()
        {
            PINode p = head;
            string s = p.ToString();
                
            while ((p = p.Next) != null) s += " + " + p.ToString();

            return s;
        }
    }

    class PINode
    {
        PrimeImplicant PI;
        PINode nextNode;
        PINode previousNode;

        public PINode(PrimeImplicant pi)
        {
            PI = pi;
            nextNode = null;
            previousNode = null;
        }

        public PINode(PrimeImplicant pi, PINode tail)
        {
            PI = pi;
            this.nextNode = null;
            this.previousNode = tail;
            tail.nextNode = this;            
        }

        public PINode Next { get { return nextNode; } }
        public PINode Previous { get { return previousNode; } }

        public int TrueCounter
        {
            get
            {
                return PI.TrueCounter;
            }
        }

        public int DontCareCounter
        {
            get
            {
                return PI.DontCareCounter;
            }
        }

        public override string ToString()
        {
            return PI.ToString();
        }

        public override int GetHashCode()
        {
            return PI.GetHashCode();
        }


        internal void Cut()
        {
            this.previousNode.nextNode = this.nextNode;
            this.nextNode.previousNode = this.previousNode;
        }

        internal void Insert(PINode q)
        {
            q.nextNode = this.nextNode;
            q.previousNode = this;
            this.nextNode = q;
        }
    }

    class PrimeImplicant
    {
        Literal[] minterm;
        int count;
        bool tik;

        public PrimeImplicant(int line, int inPinCount)
        {
            count = inPinCount;
            minterm = new Literal[count];

            for (int i = 0; i < count; i++)
            {
                minterm[i] = new Literal(line & (1 << i));
            }
        }

        public bool Tik { get { return tik; } set { tik = value; } }

        public int TrueCounter 
        { 
            get
            {
                int t = 0;
                for (int i = 0; i < count; i++)
                {
                    if (minterm[i].GetHashCode() == 1) t++;
                }
                return t;
            }
        }

        public int DontCareCounter
        {
            get 
            {
                int d = 0;
                for (int i = 0; i < count; i++)
                {
                    if (minterm[i].GetHashCode() == 3) d++;
                }
                return d;
            }
        }

        public override int GetHashCode()
        {
            int h = 0;
            int s = 1;
            for (int i = 0; i < count; i++)
            {
                h += i * s;
                s *= 3;
            }
            return h;
        }

        public override string ToString()
        {
            string s = "";

            for (int i = 1; i < count; i++)
                s += minterm[i].ToString(i);

            return s;
        }
    }

    class Literal
    {
        bool value;
        bool dontCare;

        public Literal(bool b)
        {
            value = b;
            dontCare = false;
        }

        public Literal(int i)
        {
            value = (i > 0);
            dontCare = false;
        }

        public Literal(bool a, bool b)
        {
            value = false;
            dontCare = true;
        }

        public static bool operator ==(Literal a, Literal b)
        {
            if (a.dontCare && b.dontCare) return true;
            else return (a.value == b.value);
        }

        public static bool operator !=(Literal a, Literal b)
        {
            return !(a == b);
        }
        
        public override int GetHashCode()
        {
            if (dontCare) return 2;
            else if (value) return 1;
            else return 0;
        }

        public override bool Equals(object obj)
        {
            return base.Equals(obj);
        }

        public string ToString(int i)
        {
            char[] chars = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R' };
            if (dontCare) return "";
            else if (value) return chars[i].ToString();
            else return (chars[i] + 'A' - 'a').ToString();
        }
    }
}
