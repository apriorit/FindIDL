using System;
using GreeterDLL;

namespace Samples
{
    class Program
    {
        public static void Main(string[] args)
        {
            GreeterClass obj = new GreeterClass();
            obj.greet();
            Console.WriteLine("");
        }
    }
}