OPENFST = /home_local/speech/Cluster-client-script/kaldi-trunk/tools/openfst
CXX     = g++
CXXFLAGS= -g $(OPENFST)/lib/libfst.a
LIBS    = -ldl
INCS    = -I$(OPENFST)/include
PROG    = fstprintallpath fstscale fsttrim

all: $(PROG)

%: %.cpp
	$(CXX) $< $(CXXFLAGS) $(LIBS) $(INCS) -o $@ 

clean:
	rm -f $(PROG)
