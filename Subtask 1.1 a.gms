$call GDXXRW.EXE Data.xlsx output=Data.gdx set=E rng=Edges!B2:AH34 dim=2 par=od rng=Demand!B2:AH34 dim=2 par=C rng=Usage_costs!B2:AH34 dim=2 par=f rng=Construction_costs!B2:AH34 dim=2 par=t rng=Travel_times!B2:AH34 dim=2


* Declaration and definition of sets
*If  nodes(stops) 31 and 32 inserted, the set of node must be changed from  30 to  31 or 32 .
Set
    V set of nodes (stops) /1*30/
    E(v,v) existing edges 
    k bus types /small, medium, large/;
    

* Further identification of the set V
alias(V,u,i,j);

* Declaration and definition of the parameters
Parameters
    od(u,v) Demand(Passengers per day)
    f(i,j) Construction costs(fixed cost)
    c(i,j) usage costs (variable cost)
    B(u) sufficiently large number
    Bus_capacity(k) / small 31000,medium 45000, large 63000 /;

* Load network data (edges, demand, costs, lines, travel times)
$gdxin Data.gdx
$load E,od,c,f
$gdxin

*Set E only contains the edges thay are valued with the annual fixed costs.
e(i,j)=f(i,j);
*The edges from j to i are valued with the same opportunity costs as the edges from i to j.
*We only take the edges that are a part of the set E ($-condition).
c(j,i)$e(i,j)=c(i,j);
*the parameter B(u) is calculated:
B(u)=sum(v, od(u,v));

*Use a displat instruction to check for correct set and paramater values
Display E,od,c,f,B,V,Bus_capacity,i;

*Declaration of variables
variables G total costs(objective function value);

binary variables y(i,j) is 1 if the edge [ij] is installed (o otherwise);
positive variables x(u,i,j) passengers travelling from i to j with journey start at node u;

*declaration of objective functions and constraints

equations
totalcosts calculations of usage costs and construction costs
deployment(u,i,j) deployment of route segment
flows(u,v)  Flow preservation constraint (Arriving)
capacity_small(i,j) Bus capacity constraints
capacity_medium(i,j) Bus capacity constraints
capacity_large(i,j) Bus capacity constraints;

totalcosts..G=E=sum((i,j)$e(i,j),f(i,j)*y(i,j))+ sum((u,i,j)$e(i,j),c(i,j)*(x(u,i,j)+x(u,j,i)));




            
deployment(u,i,j)$e(i,j)..x(u,i,j)+x(u,j,i)-B(u)*y(i,j)=L=0;


flows(u,v)$od(u,v)..sum(e(i,v),x(u,i,v)-x(u,v,i))-sum(e(v,j),x(u,v,j)-x(u,j,v))=E=od(u,v);

Capacity_small(i,j)$(e(i,j) or e(j,i))..  sum(u, x(u,i,j))=l= Bus_capacity("small");
Capacity_medium(i,j)$(e(i,j) or e(j,i)).. sum(u, x(u,i,j))=l= Bus_capacity("medium");
capacity_large(i,j)$(e(i,j) or e(j,i))..      sum(u, x(u,i,j))=l=Bus_capacity("large");


positive variable
x1(u,i,j) , x2(u,i,j), x3(u,i,j);

binary variable
y1(i,j) , y2(i,j),y3(i,j);

variable
G1,G2,G3;

model Routenetwork_small /totalcosts, deployment,capacity_small, flows/;
option optcr = 0.0;
Routenetwork_small.optfile = 1;
solve Routenetwork_small minimizing G using MIP;

*storing the value of G in G1
G1.L = G.L ;



*storing the value of X in x1

loop((u,i,j)$(x.L(u,i,j)>0),
x1.L(u,i,j) = x.L(u,i,j) ;
);

loop((i,j)$(y.L(i,j) > 0.5),
y1.L(i,j) = y.L(i,j) ;
);
model Routenetwork_medium /totalcosts, deployment, flows, Capacity_medium/;
option optcr = 0.0;
Routenetwork_medium.optfile = 1
solve Routenetwork_medium minimizing G using mip;

*storing the value of G in G2
G2.L = G.L ;



*storing the value of X in x2

loop((u,i,j)$(x.L(u,i,j)>0),
x2.L(u,i,j) = x.L(u,i,j) ;
);

loop((i,j)$(y.L(i,j) > 0.5),
y2.L(i,j) = y.L(i,j) ;
);

model Routenetwork_large /totalcosts, deployment, flows, Capacity_large/;
option optcr = 0.0;
Routenetwork_large.optfile = 1
solve Routenetwork_large minimizing G using mip;
*storing the value of G in G3
G3.L = G.L ;



*storing the value of X in x3

loop((u,i,j)$(x.L(u,i,j)>0),
x3.L(u,i,j) = x.L(u,i,j) ;
);

loop((i,j)$(y.L(i,j) > 0.5),
y3.L(i,j) = y.L(i,j) ;
);

display G1.L,G2.L,G3.L,y1.L, y2.L,y3.L, x1.L,x2.L,x3.L ;

***************************************************************************************************************************************************
*CASE 1: text file for the first model run
***************************************************************************************************************************************************
*Declaration and definition of the text files
file out1 /Results1.txt/ ;

*Everything that follows is written in the file out1
put out1 ;

put "Total costs: " G1.L:12:2 /;

put "Construction costs(fixed cost): " (sum(e(i,j), f(i,j)*y1.l(i,j))):12:2 /;

put "usage costs (variable cost): " (sum((u,e(i,j)), c(i,j)*(x1.l(u,i,j) + x1.l(u,j,i)))):12:2 /;

*/=line break
put /;


put "Installed edges" /;
put "-----------------" /;

loop(e(i,j)$y1.L(e),
put "from " i.tl:8 " to " j.tl:8 /;
);

put /;


put "Edges loadings" /;
put "-----------------" /;

loop(e(i,j)$y1.L(e),
put "from " i.tl:8 " to " j.tl:8 ( sum(u, x1.L(u,i,j)) ):6:0 /;

);

put /;

put "Origin-related traffic flows" /;
put "------------------------------" /;

loop((u,i,j)$x1.L(u,i,j),
put "starting in " u.tl:8 " from " i.tl:8 " to " j.tl:8 x1.L(u,i,j):6:0 /;
);



***************************************************************************************************************************************************
*CASE 2: text file
***************************************************************************************************************************************************
*Declaration and definition of the text files
file out2 /Results2.txt/ ;

*Everything that follows is written in the file out1
put out2 ;

put "Total costs: " G2.L:12:2 /;

put "Construction costs(fixed cost): " (sum(e(i,j), f(i,j)*y2.l(i,j))):12:2 /;

put "usage costs (variable cost): " (sum((u,e(i,j)), c(i,j)*(x2.l(u,i,j) + x2.l(u,j,i)))):12:2 /;


*/=line break
put /;


put "Installed edges" /;
put "-----------------" /;

loop(e(i,j)$y2.L(e),
put "from " i.tl:8 " to " j.tl:8 /;
);

put /;


put "Edges loadings" /;
put "-----------------" /;

loop(e(i,j)$y2.L(e),
put "from " i.tl:8 " to " j.tl:8 ( sum(u, x2.L(u,i,j)) ):6:0 /;
);

put /;

put "Origin-related traffic flows" /;
put "------------------------------" /;

loop((u,i,j)$x2.L(u,i,j),
put "starting in " u.tl:8 " from " i.tl:8 " to " j.tl:8 x2.L(u,i,j):6:0 /;
);

***************************************************************************************************************************************************
*CASE 3: text file
***************************************************************************************************************************************************
*Declaration and definition of the text files
file out3 /Results3.txt/ ;

*Everything that follows is written in the file out1
put out3 ;

put "Total costs: " G3.L:12:2 /;

put "Construction costs(fixed cost): " (sum(e(i,j), f(i,j)*y3.l(i,j))):12:2 /;

put "usage costs (variable cost): " (sum((u,e(i,j)), c(i,j)*(x3.l(u,i,j) + x3.l(u,j,i)))):12:2 /;

*/=line break
put /;


put "Installed edges" /;
put "-----------------" /;

loop(e(i,j)$y3.L(e),
put "from " i.tl:8 " to " j.tl:8 /;
);

put /;


put "Edges loadings" /;
put "-----------------" /;

loop(e(i,j)$y3.L(e),
put "from " i.tl:8 " to " j.tl:8 ( sum(u, x3.L(u,i,j)) ):6:0 /;

);

put /;

put "Origin-related traffic flows" /;
put "------------------------------" /;

loop((u,i,j)$x3.L(u,i,j),
put "starting in " u.tl:8 " from " i.tl:8 " to " j.tl:8 x3.L(u,i,j):6:0 /;
);

*incase nodes 31 and 32 are considered, the asterisk is removed and they are inserted in the code.

table ab(v,*) Allocation nodes-coordinates

          a        b
1        -6       -8
2         8        4
3         8       -7
4         4        3
5         6        4
6         7        6
7         0       -4
8        -2      -10
9        12        2
10        5       -3
11        0       -9
12       -3       -8
13       -2       -7
14       -4      -10
15        0       -5
16        3        5
17        2       -7
18       -5       -4
19        9        2
20        5        2
21        4        0
22        5       -5
23       -4       -7
24        0       -7
25      -10       -7
26        3       -5
27       10        7
28        0       -2
29        7       -5
30        5       -7
*31       -3        0
*32       11       -1

;
File network_large /Route_for_large_bus.tex/ ;
put network_large;

$onput
\documentclass{article}
 \usepackage{pdflscape}
 \usepackage{amsmath}
 \usepackage{tikz}
 \begin{document}
 \begin{landscape}
\begin{figure}[H]
\centering
\resizebox{\textwidth}{!}{%
\begin{tikzpicture}

$offput

loop(i,
put '\node ('i.tl') at ('ab(i,'a'), ','
ab(i,'b')')[circle, draw] {'i.tl'};' /;
);

network_large.nd=0 ;
loop((i,j),
put$(y.L(i,j) > 0.5) '\draw[-,thick]('i.tl' ) to node[fill=white, font=\scriptsize]{'sum(u, x.L(u,i,j))'} ('j.tl'); '/;
);




put '\end{tikzpicture}'/ '}' /
'\end{figure}'/
'\end{landscape}'/
'\end{document}'/;