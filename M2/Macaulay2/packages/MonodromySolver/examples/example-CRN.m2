needsPackage "MonodromySolver"
needsPackage "ReactionNetworks"

FF = CC

-- creates a polynomial system from a chemical reaction network
createPolySystem = method()
createPolySystem (ReactionNetwork, InexactFieldFamily):= (Rn, FF) -> (
    S := createRing(Rn, FF);
    createPolySystem(Rn,FF,toList(length Rn.ConcentrationRates : 1_FF))
    )
createPolySystem'overdetermined = (Rn, FF, L) -> (
    S := createRing(Rn, FF);
    CEforms := matrix{conservationEquations(Rn,FF)};
    SubList := toList(apply(0..length Rn.ConcentrationRates-1, i -> 
	    value(Rn.ConcentrationRates#i) => L#i));
    CE := sub(CEforms, SubList) - CEforms;    
    SSE := steadyStateEquations Rn;
    R := CC[Rn.ReactionRates][Rn.ConcentrationRates];	       	   
    M := sub((transpose CE || SSE), R);
    polySystem M
    )
createPolySystem (ReactionNetwork, InexactFieldFamily, List) := (Rn, FF, L) -> (
    squareUp createPolySystem'overdetermined(Rn,FF,L)
    )

TEST ///
CRN = reactionNetwork "A <--> 2B, A+C<-->D, B+E-->A+C, D-->B+E"
createPolySystem(CRN, FF)
///

-- example from Elizabeth's talk
CRN = reactionNetwork "A <--> 2B, A+C<-->D, B+E-->A+C, D-->B+E"
G = createPolySystem(CRN, FF)

-- example of a motif
F = twoSiteModificationF()
G' = createPolySystem(F, FF)

-- example of a motif
C = clusterModelCellDeath()
GC = createPolySystem(C, FF)

-- random example to test number of solutions
Q = reactionNetwork "A <--> 2B, A+3C<-->D, B+4E-->A+3C, A+3C-->D, D-->B+4E"
GQ = createPolySystem(Q, FF)

-- 5 copies of oneSiteModificationA
A = oneSiteModificationA();
A' = sub(oneSiteModificationA(), {"S_0" => "S_1", "S_1" => "S_2"});
A'' = sub(oneSiteModificationA(), {"S_0" => "S_2", "S_1" => "S_3"});
A'''=sub(oneSiteModificationA(), {"S_0" => "S_3", "S_1" => "S_4"});
B = sub(oneSiteModificationA(), {"S_0" => "S_4", "S_1" => "S_5"});
C'' = glue(A,A');
C' = glue(C'',A'');
D = glue (C',A''');
J = glue(D,B)
H = createPolySystem(J, FF)

-- experiment 
X = reactionNetwork "A+B <--> C, X <--> 2A+D, 2A+D <--> Y, D <--> C+W, B+D <--> Z"
XS = createPolySystem(X, FF)

X' = reactionNetwork ({"A+B <--> C", "X <--> 2A+D", "2A+D <--> Y", 
    "D <--> C+W", "B+D <--> Z", "0 <--> A", "0 <--> B", "0 <--> C", 
    "0 <--> D", "0 <--> W", "0 <--> X", "0 <--> Y", "0 <--> Z"}, NullSymbol => "0")
X'S = createPolySystem(X', FF) --not working

end ---------------------------------

restart
load "example-CRN.m2"

setRandomSeed 0
-- system for example from Elizabeth's talk
(p0, x0) = createSeedPair(G,"initial parameters" => "one")  
elapsedTime (V,npaths) = monodromySolve(G,p0,{x0}, NumberOfEdges => 4, EdgesSaturated=>true)
assert(length V.PartialSols == 4)

-- system for motif twoSiteModificationF
(p0, x0) = createSeedPair(G',"initial parameters" => "one")
elapsedTime (V,npaths) = monodromySolve(G',p0,{x0},NumberOfEdges => 5)
assert(length V.PartialSols == 6)

-- system for 5 copies of oneSiteModificationA
(p0, x0) = createSeedPair(H,"initial parameters" => "one")
elapsedTime (V,npaths) = monodromySolve(G',p0,{x0},NumberOfEdges => 5)

-- system for wnt signaling pathway
W = wnt()
setRandomSeed 0
L = apply(numgens createRing(W,FF), i->random FF)
F = createPolySystem(W, FF, L)
(p0, x0) = createSeedPair(F,L)
elapsedTime (V,npaths) = monodromySolve(F,p0,{x0},
    GraphInitFunction=>completeGraphInit,
    NumberOfEdges=>5,
--    TargetSolutionCount => 9,
    "new tracking routine"=>false,
    Verbose=>true)
assert(length V.PartialSols == 9)

-- wnt via Bertini
specPolys = specializeSystem (p0,createPolySystem'overdetemined(W,FF,L));
R = CC[x_1..x_(numgens ring first specPolys)]
toR = map(R,ring first specPolys,vars R)
elapsedTime NV := numericalIrreducibleDecomposition(ideal (specPolys/toR),Software=>BERTINI)
assert(#NV#0 == 9)

-- system for random example
(p0, x0) = createSeedPair(GQ, "initial parameters" => "one")
elapsedTime (V,npaths) = monodromySolve(GQ,p0,{x0}, NumberOfEdges => 1, NumberOfNodes => 5)

-- affine trace test for Wnt
G = V.Graph
sys = polySystem specializeSystem(V.BasePoint, G.Family)
sols = points V.PartialSols
computeTrace = L -> sum apply(L, t -> matrix t)
params = gens coefficientRing ring G.Family
lastB = last params
traces = {transpose(computeTrace sols | matrix {{last coordinates p0}})}
linearSlice = apply(flatten entries G.Family.PolyMap, F -> sub(sub(F, ring G.Family), toList apply(0..(length params -2), i -> params#i => (p0.Coordinates)#i)));
setRandomSeed 0
for i from 0 to 2 do (
    b = random(RR);
    sys' = polySystem apply(linearSlice, F->sub(F, lastB => b));
    T = track(sys, sys', sols);
    -- print (T/matrix/transpose , transpose computeTrace T);
    traces = append(traces, transpose (computeTrace T | matrix{{b}}))
    );
first SVD(traces#3-traces#1|traces#2-traces#1)
first SVD(traces#2-traces#0|traces#1-traces#0)









