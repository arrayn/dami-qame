#include <Rcpp.h> 
using namespace Rcpp;

// [[Rcpp::export]]
List artoCppRuleCandidates(List fisets_list){
  Rcpp::List fisets_temp(fisets_list);
  std::vector<IntegerVector> antece_vec;
  std::vector<IntegerVector> conseq_vec;
  int N = fisets_temp.size();
  for(int h=0 ; h<N ; h++){
    IntegerVector indata = fisets_temp[h];
    int M = indata.size();
    for(int i=0 ; i<M ; i++){
      IntegerVector row;
      for(int j=0 ; j<M ; j++){
        if(i!=j){row.push_back(indata[j]);}
      }
      antece_vec.push_back(row);
      conseq_vec.push_back(IntegerVector::create(indata[i]));
    }
  }
  return Rcpp::List::create(_["antece.list"] = wrap(antece_vec),
                            _["conseq.list"] = wrap(conseq_vec));
}
