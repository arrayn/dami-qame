// // [[Rcpp::export]]
//List artoCppEclat(const List tidlists, const int minsup_abs){
//  // returns: frequent itemsets and their supports in "horizontal" format.
//  // input transactionID-lists is in "vertical" format.
//  
//  // step 1: form a new "index" of only frequent items
//  std::vector<int> muta_fitems;
//  for(int i=0 ; i<tidlists.size(); i++){
//    const IntegerVector temp = tidlists[i];
//    if(temp.size() >= minsup_abs) muta_fitems.push_back(i);
//  }
//  const std::vector<int> fitems(muta_fitems);
//  const int s_fitems = fitems.size();
//  
//  // step 2: Traverse the tree depth-first in lexigographical order
//  std::vector<std::vector<int> > fisets; //returned
//  std::vector<int> support_abs; // returned
//  std::vector<int> curs={0}; // cursor of indexes
//  std::vector<std::vector<int> > inters; // intersections stack
//  
//  while(!curs.empty()){
//    const int depth = curs.size(); // our depth now
//    const int us    = curs.back(); // our index now
//    
//    // are we over the rigth-end of index?
//    if(us >= s_fitems){ 
//      curs.pop_back(); // navigate back
//      if (!curs.empty()){
//        inters.pop_back(); // also pop the intersections stack
//        curs[depth-2] = curs[depth-2] + 1; // navigate right
//      } 
//      continue;
//    } 
//    
//    // create the candidate intersection
//    const IntegerVector our_tl = tidlists[fitems[us]]; // our tidlist
//    std::vector<int> candis; // candidate intersection
//    if(depth == 1){
//      candis = as<std::vector<int> >(our_tl);
//    }else{       // take intersect of us and the inters
//      const std::vector<int> old   = inters.back();
//      const std::vector<int> last  = as<std::vector<int> >(our_tl); // TODO: can this be removed too?
//      std::set_intersection(old.begin(), old.end(), last.begin(), last.end(), 
//                            std::back_inserter(candis));
//    }
//    
//    // does candidate intersection have enough support? (are we frequent?)
//    if(candis.size() >= minsup_abs){ // we are frequent
//      std::vector<int> temp;    // push frequent itemset...
//      for(int i=0;i<depth;i++){temp.push_back(fitems[curs[i]]+1);} // R indexes from 1
//      fisets.push_back(temp);
//      support_abs.push_back(candis.size()); // ...and its support
//      inters.push_back(candis); // update the candidate intersections stack
//      curs.push_back(us+1); // navigate deeper
//    }else{ // we are not frequent
//      curs[depth-1] = us+1; // navigate right
//    }
//    
//  }
//  
//  // return
//  return Rcpp::List::create(_["fisets"]  = fisets,
//                            _["support_abs"] = support_abs);
//}
