#include <iostream>

#include <string>
#include <vector>
#include <fst/fstlib.h>

using namespace std;
using namespace fst;
typedef StdArc::StateId StateId;
typedef StdArc::Weight  Weight;

void Usage(const char* progName){
   cerr << "Usage: " << progName << " input_fst n-std [output_fst]" << endl
      << "eg. " << progName << " input.fst 1.0" << endl
      << "Trim arcs from same state whose weight is larger than (ave - n*std)." << endl;
   exit(-1);
}

void trim(const StdFst &fst, double n, MutableFst<StdArc> &ofst);

int main(int argc, char** argv){
   if(argc != 3 && argc != 4) Usage(argv[0]);

   string in_name = strcmp(argv[1], "-") != 0 ? argv[1] : "";
   StdFst *fst = StdFst::Read(in_name);
   VectorFst<StdArc> ofst;

   if (!fst) Usage(argv[0]);

   double scale = atof(argv[2]);

   string ofile = (argc == 4) ? argv[3] : "";

   trim(*fst, scale, ofst);

   ofst.Write(ofile);
   
   return 0;
}

void trim(const StdFst &fst, double n, MutableFst<StdArc> &ofst){

   const StateId &start = fst.Start();

   for (StateIterator<StdFst> siter(fst); !siter.Done(); siter.Next()) {
      const StateId &s = siter.Value();
      while(s >= ofst.NumStates()) ofst.AddState();

      if(s == start) ofst.SetStart(s);
      if(!(fst.Final(s) == Weight::Zero()))
         ofst.SetFinal(s, fst.Final(s).Value());

      double sum = 0;
      double sqr = 0;
      int count  = 0;

      for(ArcIterator<StdFst> aiter(fst, s); !aiter.Done(); aiter.Next()){
         const StdArc& arc = aiter.Value();
         double value = arc.weight.Value();

         sum += value;
         sqr += value*value;
         count++;
      }

      double ave = sum/count;
      double thres = ave - n*sqrt(sqr/count - ave*ave);

      for(ArcIterator<StdFst> aiter(fst, s); !aiter.Done(); aiter.Next()){
         const StdArc& arc = aiter.Value();
         double value = arc.weight.Value();
         if(value <= thres)
            ofst.AddArc(s, arc);
      }
   }

}
