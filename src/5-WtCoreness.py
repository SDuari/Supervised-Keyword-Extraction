from __future__ import division
from igraph import *
import sys
import copy
import random
import numpy as np
import numpy.random as nprnd
import pandas as pd
from os import *


outputdirectory = '/path/to/directory/WtCoreness/' #'../IterativeOutput/Experiments/'


def SortedRankedToFile(graphname, vnames,centrality, measurename):
       #directory = inputdirectory+ graphname + "/"
       directory = outputdirectory
       #if not os.path.exists(directory):
           #os.makedirs(directory)
       n = len(vnames)
       data = zip(vnames,centrality)
       pddata =  pd.DataFrame(data, index=range(0,n), columns=["Name",measurename])
       #pddata.to_csv(directory + graphname +"."+measurename+".txt",index=False) 
       sortedcol = pddata.sort_values(by=measurename, ascending=False)
       sortedcol[measurename+'DenseRank'] = sortedcol[measurename].rank(method='dense',ascending=False)
       sortedcol[measurename+'MinRank'] = sortedcol[measurename].rank(method='min',ascending=False)
       outputfile = directory + graphname +".sortedranked."+measurename+".txt"
       print(outputfile)
       sortedcol.to_csv(outputfile,index=False) 
       return


def getInfluence(g) :
       graphname = g.split('/')[-1].split('.')[0]
       print(g)
       directory = outputdirectory+ graphname + "/"
       #if not os.path.exists(directory):
           #os.makedirs(directory)
 
       timingoutputfile = directory + graphname +".InfluenceTiming"
       #os.remove(timingoutputfile) if os.path.exists(timingoutputfile) else None 
       
 
       #graph = Graph.Read_Ncol(g,directed=True,weights=True)
       graph = Graph.Read_Ncol(g,directed=False,weights=True)
       graph.vs.select(_degree = 0).delete()
       #graph= graph.simplify()
       graph.es['weight'] = [1.0] * graph.ecount() 
       
       strength = graph.strength(weights = graph.es['weight'])
       if (sum(strength) == 0.0):
          graph.es['weight'] = [1.0] * graph.ecount()     #assign weight 1 to each edge
          strength = graph.strength(weights = graph.es['weight'])
       
       n = graph.vcount()
       
       print('Num Vertices:',n)
       graph.vs.select(_degree = 0).delete()
       print('After dropping isolates graph n,m: ', len(graph.vs), len(graph.es))
      
       #graph.simplify(combine_edges={"weight": "sum"})		# collapse multiple edges and sum their weights
       n = graph.vcount()
       m = graph.ecount()
       print('weighted graph n,m: ', len(graph.vs), len(graph.es))
       
       vnames = [v["name"] for v in graph.vs]
       vindices = [v.index for v in graph.vs]
       	
       print('Computing Coreness Centrality')
       kc =  GraphBase.coreness(graph)   
       SortedRankedToFile(graphname,vnames,kc,'KC' )
       
       return    


if __name__=='__main__':

    mysrcdir = sys.argv[1]
    myfiles = listdir(mysrcdir)
    for f in myfiles:
    	graphfile = mysrcdir + '/' + f
    	getInfluence(graphfile)