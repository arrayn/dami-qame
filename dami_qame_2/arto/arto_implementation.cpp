#include <Rcpp.h> 
using namespace Rcpp;



// [[Rcpp::export]]
List artoCppAprioriGen(const List Fk_1_list){
  std::vector<std::vector<int> > out_vec;
  int count_generated = 0;
  const int n = Fk_1_list.size();
  if(n<1) {return Rcpp::List::create(_["candidates"] = out_vec);}
  const IntegerVector sample = Fk_1_list[0];
  const int k_1 = sample.size(); 
  const int k_2 = k_1 - 1;
  const int k   = k_1 + 1;
  for(int h=0 ; h<n ; h++){
    // 1. combine with all that share k-2 prefix and lexicograph less
    const IntegerVector us = Fk_1_list[h];
    for(int th=0 ; th<n ;th++){
      const IntegerVector them = Fk_1_list[th];
      if(std::equal(us.begin(), us.begin()+k_2, them.begin()) 
         && them[k_2]>us[k_2]){
        auto candi = as<std::vector<int> >(us);
        candi.push_back(them[k_2]);
        count_generated++;
        // 2. pruning-step: split to (k-1)-subsets...
        auto sub_counter = 0;
        for(int i=0 ; i<k ; i++){
          std::vector<int> row;
          for(int j=0 ; j<k ; j++){
            if(i!=j){row.push_back(candi[j]);}
          }
          // ... and check that the (k-1)-subsets are frequent (in Fk_1)
          // brute force. Could try ordering
          for(int hhh=0 ; hhh<n ; hhh++){
            IntegerVector temp = Fk_1_list[hhh];
            if(equal(row.begin(), row.end(),  temp.begin())) sub_counter++;
          }
        }
        if(sub_counter==k) out_vec.push_back(candi);
      }
    }
  }
  return Rcpp::List::create(_["candidates"] = out_vec,
                            _["generated"] = count_generated);
}



// [[Rcpp::export]]
List artoCppRuleCandidates(List fisets_list){
  Rcpp::List fisets_temp(fisets_list);
  std::vector<std::vector<int> > antece_vec;
  std::vector<std::vector<int> > conseq_vec;
  int N = fisets_temp.size();
  for(int h=0 ; h<N ; h++){
    IntegerVector indata = fisets_temp[h];
    int M = indata.size();
    for(int i=0 ; i<M ; i++){
      std::vector<int> row;
      for(int j=0 ; j<M ; j++){
        if(i!=j){row.push_back(indata[j]);}
      }
      antece_vec.push_back(row);
      std::vector<int> conseq;
      conseq.push_back(indata[i]);
      conseq_vec.push_back(conseq);
    }
  }
  return Rcpp::List::create(_["antece.list"] = antece_vec,
                            _["conseq.list"] = conseq_vec);
}


