#include <iostream>

#include <string>
#include <math.h>
#include <vector>
#include <fst/fstlib.h>

using namespace std;
using namespace fst;
typedef StdArc::StateId StateId;
typedef StdArc::Weight  Weight;

void Usage(const char* progName){
   cerr << "Usage: " << progName << " input_fst scale [output_fst]" << endl
      << "eg. " << progName << " input.fst 2.4" << endl
      << "rescale all weights in a fst." << endl;
   exit(-1);
}

void rescale(const StdFst &fst, double scale, MutableFst<StdArc> &ofst);

int main(int argc, char** argv){
   if(argc != 3 && argc != 4) Usage(argv[0]);

   string in_name = strcmp(argv[1], "-") != 0 ? argv[1] : "";
   StdFst *fst = StdFst::Read(in_name);
   VectorFst<StdArc> ofst;

   if (!fst) Usage(argv[0]);

   double scale = atof(argv[2]);

   string ofile = (argc == 4) ? argv[3] : "";

   rescale(*fst, scale, ofst);

   ofst.Write(ofile);
   
   return 0;
}

void rescale(const StdFst &fst, double scale, MutableFst<StdArc> &ofst){

   const StateId &start = fst.Start();

   for (StateIterator<StdFst> siter(fst); !siter.Done(); siter.Next()) {
      const StateId &s = siter.Value();
      while(s >= ofst.NumStates()) ofst.AddState();

      if(s == start) ofst.SetStart(s);
      if(!(fst.Final(s) == Weight::Zero()))
         ofst.SetFinal(s, fst.Final(s).Value() * scale);

      for(ArcIterator<StdFst> aiter(fst, s); !aiter.Done(); aiter.Next()){
         const StdArc& arc = aiter.Value();
         StdArc tmp(arc.ilabel, arc.olabel, 
               arc.weight.Value()*scale,  arc.nextstate);

         ofst.AddArc(s, tmp);
      }
   }

}
