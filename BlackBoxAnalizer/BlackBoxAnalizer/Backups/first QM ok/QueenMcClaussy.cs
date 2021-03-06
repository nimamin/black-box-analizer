﻿
namespace BlackBoxAnalizer
{
    class QueenMcClaussy
    {
        internal static string GetString(int[] minterms, int inPinCount)
        {
            PIQueue piQueue = new PIQueue(minterms, inPinCount);
            piQueue.Normalize();
            piQueue.Minimize(minterms);
            //return piQueue.ToString();
            return piQueue.GetAlphabetString();
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

        public int[] ChooseNextSet()
        {
            if (firstTime)
            {
                firstTime = false;
                indexs[0] = 0;
                for (int f = 1; f < h; f++)
                    indexs[f] = indexs[f - 1] + 1;
            }
            else
            {
                bool done = false;
                for (int f = h - 1; f >= 0; f--)
                {
                    if (indexs[f] + 1 < indexs[f + 1])
                    {
                        indexs[f]++;
                        while (++f < h)
                            indexs[f] = indexs[f - 1] + 1;
                        done = true;
                        break;
                    }
                }
                if (!done) return null;
            }

            return indexs;
        }
    }

    class PIQueue
    {
        PINode head;
        PINode tail;

        public int High
        {
            get
            {
                int i = 0;
                PINode p = head;
                while (p != null)
                {
                    i++;
                    p = p.Next;
                }
                return i;
            }
        }

        public PIQueue(int[] minterms, int inPinCount)
        {
            int length = minterms.Length;
            PrimeImplicant[] implicants = new PrimeImplicant[length];
            implicants[0] = new PrimeImplicant(minterms[0], inPinCount);
            for (int i = 1; i < minterms.Length; i++)
                implicants[i] = new PrimeImplicant(minterms[i]);
            for (int i = 0; i < minterms.Length; i++)
                this.Add(implicants[i]);
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
        void delete(int[] n)
        {
            int i = 0, c = 0, length = n.Length;
            PINode p = head;
            while (p != null)
            {
                if (c > length) break;
                if (i == n[c])
                {
                    p.Deleted = true;
                    c++;
                }
                else p.Deleted = false;
                i++;
                p = p.Next;
            }
        }
        void unDelete(int[] n)
        {
            int i = 0, c = 0, length = n.Length;
            PINode p = head;
            while (p != null)
            {
                if (c > length) break;
                if (i == n[c])
                {
                    p.Deleted = false;
                    c++;
                }
                else p.Deleted = true;
                i++;
                p = p.Next;
            }
        }
        void deleteAll()
        {
            PINode p = head;
            while (p != null)
            {
                p.Deleted = true;
                p = p.Next;
            }
        }
        void unDeleteAll()
        {
            PINode p = head;
            while (p != null)
            {
                p.Deleted = false;
                p = p.Next;
            }
        }
        public void Normalize()
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
        public void Minimize(int[] minterms)
        {
            Chooser chooser;
            int high = this.High;
            for (int h = 1; h < high; h++)
            {
                chooser = new Chooser(h, high);
                while (true)
                {
                    int[] n = chooser.ChooseNextSet();
                    if (n == null) break;
                    this.unDelete(n); // delet all but n.
                    if (isDeletingPossible(minterms))
                    {
                        PINode p = head;
                        while (p != null)
                        {
                            if (p.Deleted) Delete(ref p);
                            else p = p.Next;
                        }
                        return;
                    }
                }
            }
        }
        bool isDeletingPossible(int[] minterms)
        {
            PINode p;
            for (int i = 0; i < minterms.Length; i++)
            {
                p = head;
                while (p != null)
                {
                    if (!p.Deleted)
                    {
                        if (p.PI.Contain(minterms[i])) break;
                    }
                    p = p.Next;
                }
                if (p == null) return false;
            }
            return true;
        }
        public PrimeImplicant[] GetArray()
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
        public string GetAlphabetString()
        {
            PINode p = tail;
            string s = p.PI.GetAlphabetString();
            p = p.Previous;
            while (p != null)
            {
                s += " + " + p.PI.GetAlphabetString();
                p = p.Previous;
            }
            return s;
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
    }

    class PINode
    {
        PINode nextNode;
        public PINode Next { get { return nextNode; } set { nextNode = value; } }
        PINode previousNode;
        public PINode Previous { get { return previousNode; } set { previousNode = value; } }
        PrimeImplicant primeImplicant;
        public PrimeImplicant PI { get { return primeImplicant; } }
        bool deleted = false;
        public bool Deleted { get { return deleted; } set { deleted = value; } }

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

        public static PrimeImplicant Merge(PrimeImplicant p, PrimeImplicant q)
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
        public bool Contain(PrimeImplicant a)
        {
            for (int i = 0; i < count; i++)
            {
                if (literls[i].DontCare) continue;
                if (literls[i].Value != a.literls[i].Value) return false;
            }
            return true;
        }
        public bool Contain(int i)
        {
            PrimeImplicant pi = new PrimeImplicant(i);
            return this.Contain(pi);
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
        public string GetAlphabetString()
        {
            string s = "";
            for (int i = count - 1; i >= 0; i--)
                s += literls[i].GetAlphabetString(count - i - 1);

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

        public static int IsMergble(Literal a, Literal b)
        {
            if (a == b) return 0;
            if (a.dontCare ^ b.dontCare) return 2;
            return 1;
        }
    }
}
