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



// [[Rcpp::export]]
List artoCppClosedItemsets(const List fisets_ranked, const NumericVector supports_ranked){
  // process the frequent itemset ranked by support
  // go one support-equal block at a time
  // then go one itemset at a time and check if any of the equals are immediate superset
  // if is, then we are NOT a closed itemset, otherwise we are closed
  std::vector<IntegerVector> closed_fisets;
  std::vector<double> closed_supports;
  const int m = fisets_ranked.size();
  int begeq = 0, endeq=0; // begin, end of index of equal-support-block
  double equsup = -1.0; // support of the equal-support-block
  for(int h=0 ; h<m ; h++){
    const IntegerVector us = fisets_ranked[h];
    if (h == endeq) { // new equ-block started
      begeq = h, endeq = h+1, equsup = supports_ranked[h];
      while(endeq < m && supports_ranked[endeq]==equsup){endeq++;}
    }
    // test if any of the equ-block-friends is a superset of us
    bool closed = true;
    for(int hh=begeq ; hh<endeq ; hh++){
      const IntegerVector them = fisets_ranked[hh];
      if(h!=hh && std::includes(them.begin(), them.end(), us.begin(), us.end())){
        closed = false;
        break;
      }
    }
    if(closed){
      closed_fisets.push_back(us);
      closed_supports.push_back(equsup);
    }
  }
  return Rcpp::List::create(_["closed_fisets"] = closed_fisets,
                            _["support"] = closed_supports);
}



// [[Rcpp::export]]
List artoCppEclat(const List tidlists, const int minsup_abs){
  // returns: frequent itemsets and their supports in "horizontal" format.
  // input transactionID-lists is in "vertical" format.
  std::vector<int> scounter;
  // convert he input tidlist to cpp format // seems to be a little faster
  const int n_tidlists = tidlists.size();
  std::vector<std::vector<int> > tidlists_cpp;
  for(int i=0; i<n_tidlists; i++){
    const IntegerVector temp1 = tidlists[i];
    std::vector<int> temp2 = as<std::vector<int> >(temp1);
    tidlists_cpp.push_back(temp2);
  }
  
  // step 1: form a new "index" of only frequent items
  std::vector<int> muta_fitems;
  for(int i=0 ; i<n_tidlists; i++){
    if(tidlists_cpp[i].size() >= minsup_abs) muta_fitems.push_back(i);
  }
  const std::vector<int> fitems(muta_fitems);
  const int s_fitems = fitems.size();
  
  // step 2: Traverse the tree depth-first in lexigographical order
  std::vector<std::vector<int> > fisets; //returned
  std::vector<int> support_abs; // returned
  std::vector<int> curs={0}; // cursor of indexes
  std::vector<std::vector<int> > inters; // intersections stack
  
  while(!curs.empty()){
    const int depth = curs.size(); // our depth now
    const int us    = curs.back(); // our index now
    
    // are we over the rigth-end of index?
    if(us >= s_fitems){ 
      curs.pop_back(); // navigate back
      if (!curs.empty()){
        inters.pop_back(); // also pop the intersections stack
        curs[depth-2] = curs[depth-2] + 1; // navigate right
      } 
      continue;
    } 
    
    // create the candidate intersection
    const std::vector<int> our_tl = tidlists_cpp[fitems[us]]; // our tidlist
    std::vector<int> candis; // candidate intersection
    if(depth == 1){
      candis = our_tl;
    }else{       // take intersect of us and the inters
      const std::vector<int> old   = inters.back();
      std::set_intersection(old.begin(), old.end(), our_tl.begin(), our_tl.end(), 
                            std::back_inserter(candis));
      if(scounter.size() < depth) scounter.push_back(0);
      scounter[depth-1]++;
    }
    
    // does candidate intersection have enough support? (are we frequent?)
    if(candis.size() >= minsup_abs){ // we are frequent
      std::vector<int> temp;    // push frequent itemset...
      for(int i=0;i<depth;i++){temp.push_back(fitems[curs[i]]+1);} // R indexes from 1
      fisets.push_back(temp);
      support_abs.push_back(candis.size()); // ...and its support
      inters.push_back(candis); // update the candidate intersections stack
      curs.push_back(us+1); // navigate deeper
    }else{ // we are not frequent
      curs[depth-1] = us+1; // navigate right
    }
    
  }
  
  // return
  return Rcpp::List::create(_["fisets"]  = fisets,
                            _["support_abs"] = support_abs,
                            _["eclat_supports"] = scounter);
}



