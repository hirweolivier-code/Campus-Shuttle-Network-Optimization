$call GDXXRW.EXE Data.xlsx output=Data.gdx set=E rng=Edges!B2:AH34 dim=2 par=od rng=Demand!B2:AH34 dim=2 par=C rng=Usage_costs!B2:AH34 dim=2 par=f rng=Construction_costs!B2:AH34 dim=2 par=t rng=Travel_times!B2:AH34 dim=2

$title Line Network Planning: Minimising Travel Time

*model should calculate the optimal OFV (F)
*without the instruction the relative deviation between the calculated OFV and the optimal OFV can be up to 10 %
option   optcr = 0.0;

sets
*Insert the set of lines, the set of nodes and the set of node positions here.
L Set of lines /L1*L60/
v Set of nodes/N1*N32/
P Set of node positions/P1*P12/





EL(l,v,v)  Arc set of a direct journey from node i to node j with line l


LPV(L,P,V) node order of a line
                    /L1.  (P1.N1, P2.N23)
                     L2.  (P1.N1, P2.N23, P3.N18, P4.N31)
                     L3.  (P1.N1, P2.N23, P3.N18, P4.N31,P5.N16)
                     L4.  (P1.N1, P2.N23, P3.N18, P4.N31,P5.N16,P6.N6,P7.N27)
                     L5.  (P1.N1, P2.N23, P3.N18, P4.N31, P5.N28,P6.N7,P7.N15,P8.N24, P9.N13,P10.N12,P11.N14)
                     L6.  (P1.N1, P2.N23, P3.N18, P4.N31, P5.N28,P6.N7,P7.N15,P8.N24,P9.N13,P10.N12,P11.N14,P12.N8)
                     L7.  (P1.N1, P2.N23, P3.N25)
                     L8.  (P1.N2, P2.N19, P3.N32)
                     L9.  (P1.N2, P2.N21, P3.N7)
                     L10. (P1.N2, P2.N21, P3.N7, P4.N15,P5.N24,P6.N13,P7.N12,P8.N14)
                     L11. (P1.N2, P2.N21, P3.N7, P4.N15,P5.N24, P6.N13, P7.N12,P8.N14,P9.N8)
                     L12. (P1.N3, P2.N29, P3.N10)
                     L13. (P1.N3, P2.N29, P3.N10,P4.N21, P5.N20,P6.N5,P7.N4)
                     L14. (P1.N3, P2.N29, P3.N10, P4.N21, P5.N20,P6.N5,P7.N6)
                     L15. (P1.N3, P2.N29, P3.N32, P4.N9)
                     L16. (P1.N3, P2.N30, P3.N17, P4.N24,P5.N11)
                     L17. (P1.N3, P2.N30, P3.N17, P4.N24, P5.N13,P6.N23,P7.N25)
                     L18. (P1.N4, P2.N5)
                     L19. (P1.N4, P2.N5, P3.N6)
                     L20. (P1.N4, P2.N5, P3.N20, P4.N21)
                     L21. (P1.N4, P2.N5, P3.N20, P4.N21,P5.N7,P6.N15,P7.N24, P8.N13,P9.N12,P10.N14,P11.N8)
                     L22. (P1.N4, P2.N5, P3.N20, P4.N21, P5.N10,P6.N22,P7.N30)
                     L23. (P1.N4, P2.N5, P3.N20, P4.N21,P5.N10,P6.N26,P7.N17)
                     L24. (P1.N6, P2.N5, P3.N20, P4.N21)
                     L25. (P1.N6, P2.N5, P3.N20, P4.N21,P5.N7,P6.N15,P7.N24,P8.N13,P9.N12,P10.N14,P11.N8)
                     L26. (P1.N6, P2.N5, P3.N20, P4.N21,P5.N10,P6.N22,P7.N30)
                     L27. (P1.N6, P2.N5, P3.N20, P4.N21,P5.N10,P6.N26,P7.N17)
                     L28. (P1.N7, P2.N15,P3.N24, P4.N13, P5.N12, P6.N14)
                     L29. (P1.N7, P2.N21, P3.N2, P4.N27)
                     L30. (P1.N7, P2.N26, P3.N22)
                     L31. (P1.N7, P2.N26, P3.N10, P4.N29)
                     L32. (P1.N7, P2.N26, P3.N10, P4.N29, P5.N32)
                     L33. (P1.N7, P2.N26, P3.N10, P4.N29,P5.N32,P6.N9)
                     L34.  (P1.N8, P2.N14)
                     L35.  (P1.N8, P2.N14, P3.N12, P4.N13)
                     L36.  (P1.N8, P2.N14, P3.N12, P4.N13,P5.N24,P6.N15)
                     L37.  (P1.N8, P2.N14, P3.N12, P4.N13,P5.N24,P6.N15,P7.N7,P8.N28,P9.N31,P10.N16)
                     L38.  (P1.N9, P2.N32)
                     L39.  (P1.N9, P2.N32, P3.N29)
                     L40.  (P1.N9, P2.N32, P3.N19,P4.N2,P5.N27)
                     L41.  (P1.N9, P2.N32, P3.N19,P4.N2,P5.N27,P6.N6,P7.N16)
                     L42.  (P1.N11, P2.N24)
                     L43. (P1.N11, P2.N24, P3.N13,P4.N24, P5.N15,P6.N7,P7.N28,P8.N31)
                     L44. (P1.N11, P2.N24, P3.N13, P4.N23, P5.N25)
                     L45. (P1.N11, P2.N24, P3.N17,P4.N26,P5.N10,P6.N21,P7.N20)
                     L46. (P1.N13, P2.N12, P3.N14)
                     L47. (P1.N14, P2.N12, P3.N13,P4.N24, P5.N15)
                     L48. (P1.N14, P2.N12, P3.N13,P4.N24, P5.N15,P6.N7,P7.N21,P8.N2,P9.N27)
                     L49. (P1.N15, P2.N7, P3.N28)
                     L50. (P1.N16, P2.N6, P3.N27)
                     L51. (P1.N16, P2.N6,P3.N27,P4.N2,P5.N19,P6.N32)
                     L52. (P1.N16, P2.N31, P3.N18)
                     L53. (P1.N16, P2.N31, P3.N25)
                     L54. (P1.N17, P2.N26,P3.N7,P4.N28,P5.N31)
                     L55.(P1.N18, P2.N31,P3.N28)
                     L56. (P1.N20, P2.N21, P3.N10, P4.N22, P5.N30)
                     L57. (P1.N22, P2.N26,P3.N7,P4.N28,P5.N31)
                     L58. (P1.N25, P2.N23, P3.N13,P4.N24,P5.N15,P6.N7,P7.N28)
                     L59. (P1.N27, P2.N2, P3.N19, P4.N32)
                     L60. (P1.N28, P2.N31)/
;

*Define three more indices (u,i,j) for the set V here.
alias(v,u,i,j);

parameters
*Insert the od-matrix here.
od(v,V) Demand matrix


*Insert the operative line costs here.

K(L)   Operative Line Costs
       /L1 1800
        L2 7800
        L3  10700
        L4 15400
        L5 17300
        L6 18700
        L7 7700
        L8 5600
        L9 8800
        L10 15300
        L11 16700
        L12  3500
        L13 9700
        L14 10900
        L15 5100
        L16 7000
        L17 11200
        L18 800
        L19 2800
        L20 4500
        L21 15900
        L22 9900
        L23 11800
        L24  5700
        L25 17100
        L26 11100
        L27 13000
        L28 6500
        L29 10200
        L30  4400
        L31  5900
        L32 7600
        L33 9900
        L34 1400
        L35 2700
        L36 7100
        L37 13800
        L38 2300
        L39 4000
        L40 9300
        L41 14000
        L42 3500
        L43 12900 
        L44 11200
        L45 14200 
        L46 1300
        L47 5700
        L48 16700
        L49 2600
        L50 4700
        L51 11700
        L52 5300
        L53 5900
        L54 7500
        L55 3600
        L56 7700
        L57 7400
        L58 13500
        L59  7000
        L60 1200
            /


dE(V,V)  Duration of arcs
         /N1.N23 9
          N2.N19 8
          N2.N21 9
          N2.N27 5
          N3.N29 2
          N3.N30 3
          N4.N5  3
          N5.N6  5
          N5.N20 2
          N6.N16 17
          N6.N27 10
          N7.N15 3
          N7.N18 10
          N7.N21 7
          N7.N26 5
          N7.N28 3
          N8.N14 3
          N9.N32 23
          N10.N21 4
          N10.N22 5 
          N10.N26 7
          N10.N29 7
          N11.N24 1
          N12.N13 2
          N12.N14 3
          N13.N23 4
          N13.N24 3
          N15.N24 2 
          N16.N31 21
          N17.N24 1
          N17.N26 13 
          N17.N30 2
          N18.N23 10
          N18.N31 11
          N19.N32 6
          N20.N21 11
          N22.N26 1
          N22.N30 3
          N23.N25 8
          N25.N31 11
          N28.N31 6
          N29.N32 14
          
          /

d(l,i,j) Duration of a direct journey from node i to node j with line l
;

$gdxin Data.gdx
$load od
$gdxin

display od;


*The duration of arcs is valid in both directions, i.e. from i to j and from j to i.
dE(j,i)$dE(i,j) = dE(i,j) ;


*If you have only implemented half of the od-matrix,
*insert an instruction that defines the values for the other half of the od-matrix.


od(v,u)$od(u,V)=od(u,v);
*Another identifier for the set of node positions
alias(p,q);

*Value assignment for set EL
loop ((p,q)$(ord(p)<ord(q)),
         EL(l,i,j)$(LPV(l,p,i) and LPV(l,q,j)) = yes ;
);


scalar be, en;

*Calculation of d(l,i,j): duration of a direct journey from node i to node j with line l
*In this calculation, a transfer time of 2 minutes(2+ 0 from my pernultimte digit of my matriculation number) is considered.
*The transfer time has to be customised or removed depending on the task.
loop (EL(l,i,j),
         be = sum(p$LPV(l,p,i), ord(p)) ;
         en = sum(p$LPV(l,p,j), ord(p)) ;
         d(l,i,j) = 2 + sum((p,u,v)$(LPV(l,p,u) and LPV(l,p+1,v) and ord(p) >= be and ord(p) < en), dE(u,v)) ;
);



*The duration is valid in both directions.
d(l,j,i)$d(l,i,j) = d(l,i,j) ;


*If the arc (i,j) of line l is part of the set EL, then the arc (j,i) of line l has to be part of the set EL, too.
EL(l,j,i)$EL(l,i,j) = yes ;


display L, V, j, P, LPV, EL, d;



*Insert the budget here.
scalar KK  Budget /101700/;
           

*Insert the variables here.
Variable
F objective function value- total travel time
;
binary Variable
y(L) is 1 if line L is choosen (0 otherwise);

positive Variable
x(u,l,i,j)  number of passengers who start their trip in u and travel with line l from node i to node j
;



*Deklaration of equations
equations
obj              Calculation of total travel time
flow(u,v)        Flow preservation constraint
line(u,l,i,j)    Coupling constraint
budget           Budget constraint
;


*Definition of equations

*Objective function: Minimising travel time
obj..    F =E= sum((u,l,i,j)$EL(l,i,j), d(l,i,j) * x(u,l,i,j)) ;


*Flow preservation constraint
flow(u,v)$(ord(u) <> ord(v))..   sum((l,i)$EL(l,i,v), x(u,l,i,v)) - sum((l,j)$EL(l,v,j), x(u,l,v,j)) =E= od(u,v) ;


*Coupling constraint
line(u,l,i,j)$EL(l,i,j)..        sum(v, od(u,v)) * y(l) =G= x(u,l,i,j) ;


*Budget constraint
budget..                         sum(l, k(l) * y(l) ) =L= KK ;


*Add the instructions for declaring and solving the model here.

model lineNetwork /all/;
option reslim=3600;   

option optcr = 0.0;


lineNetwork.optfile = 1;
solve lineNetwork using mip minimizing F;

Scalar A Actuall used budget (=arising cost);
Scalar N number of implimented lines;
N= sum(L, y.l(L));
A = sum(l, K(l) * y.l(l));

*Display solution
display y.l, x.l, F.l,N,A;

*Display all variable values here.
***************************************************************************************************************************************************
*Creating the TeX File
***************************************************************************************************************************************************
*Declaration and definition of the sets ed and edl
 set
 ed(v,v) set of all edges in the network /N1.N23,N2.N19,N2.N21, N2.N27, N3.N29,N3.N30,N4.N5 ,N5.N6,  N5.N20,  N6.N16,  N6.N27, N7.N15, N7.N18,N7.N21,N7.N26, N7.N28,
 N8.N14,N9.N32, N10.N21,   N10.N22, N10.N26,  N10.N29, N11.N24, N12.N13, N12.N14,  N13.N23,   N13.N24,    N15.N24, N16.N31 , N17.N24,  N17.N26,   N17.N30,
N18.N23,N18.N31 ,N19.N32 ,  N20.N21 ,N22.N26 ,  N22.N30 , N23.N25 ,  N25.N31 ,   N28.N31 ,   N29.N32 
          /
 edl(l,v,v) set of arcs per line l
 ;
 


*Loop to assign values to the set edl
loop (p,
 edl(l,i,j)$(LPV(l,p,i) and LPV(l,p+1,j)) = yes;
 );


display edl;




table ab(v,*)    Allocation nodes - coordinates
      
          a        b
N1        -6       -8
N2         8        4
N3         8       -7
N4         4        3
N5         6        4
N6         7        6
N7         0       -4
N8        -2      -10
N9        12        2
N10        5       -3
N11        0       -9
N12       -3       -8
N13       -2       -7
N14       -4      -10
N15        0       -5
N16        3        5
N17        2       -7
N18       -5       -4
N19        9        2
N20        5        2
N21        4        0
N22        5       -5
N23       -4       -7
N24        0       -7
N25      -10       -7
N26        3       -5
N27       10        7
N28        0       -2
N29        7       -5
N30        5       -7
N31       -3        0
N32       11       -1

;

*Declaration and definition of the TeX File

 file network /network_latex.tex/ ;

put network ;

$onput
\documentclass{article}
\thispagestyle{empty}
\usepackage{pdflscape}
\usepackage[usenames, dvipsnames]{xcolor}
\usepackage{amsmath}
\usepackage{tikz}
\usetikzlibrary{arrows.meta}
\begin{document}
\begin{landscape}

\begin{figure}[h]
\scalebox{1}{
\begin{tikzpicture}
$offput


*Nodes
 loop(i,
 put '\node ('i.tl') at ('ab(i,'a'), ','ab(i,'b')')[circle, draw] {'i.tl'};' /;
 );



*Edges
network.nd=0 ;
 loop((i,j),
 put$(ed(i,j)) '\draw[-,thick]('i.tl' ) to ('j.tl'); '/ ;
 );


*Lines
 loop((l,i,j)$(y.L(l)>0.5),
 put$(edl(l,i,j)) '\draw[-{Latex},thick]('i.tl' ) to[bend right=10] ('j.tl'); '/ ;
 );



put      '\end{tikzpicture}'/ '}' /
         '\end{figure}'/
         '\end{landscape}'/
         '\end{document}'/;


