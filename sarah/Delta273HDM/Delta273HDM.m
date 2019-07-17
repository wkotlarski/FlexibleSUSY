(* :Copyright:

   ====================================================================
   This file is part of FlexibleSUSY.

   FlexibleSUSY is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published
   by the Free Software Foundation, either version 3 of the License,
   or (at your option) any later version.

   FlexibleSUSY is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with FlexibleSUSY.  If not, see
   <http://www.gnu.org/licenses/>.
   ====================================================================

*)

Off[General::spell]

Model`Name = "Delta273HDM";
Model`NameLaTeX ="Tree Higgs Doublet Model with Delta(27) symmetry";
Model`Authors = "J. Kalinowski, W. Kotlarski, I. de Medeiros Varzielas, Rebello";
Model`Date = "2019-07-19";

(*-------------------------------------------*)
(*   Particle Content*)
(*-------------------------------------------*)

(* Gauge fields *)

Gauge[[1]] = {B,   U[1], hypercharge, g1, False};
Gauge[[2]] = {WB, SU[2], left,        g2, True};
Gauge[[3]] = {G,  SU[3], color,       g3, False};


(* Matter fields *)

FermionFields[[1]] = {q1, 1, {uL1, dL1},     1/6, 2, 3};  
FermionFields[[2]] = {l1, 1, {vL1, eL1},    -1/2, 2, 1};
FermionFields[[3]] = {d1, 1, conj[dR1],   1/3, 1, -3};
FermionFields[[4]] = {u1, 1, conj[uR1],  -2/3, 1, -3};
FermionFields[[5]] = {e1, 1, conj[eR1],     1, 1,  1};

FermionFields[[6]] = {q2, 1, {uL2, dL2},     1/6, 2, 3};  
FermionFields[[7]] = {l2, 1, {vL2, eL2},    -1/2, 2, 1};
FermionFields[[8]] = {d2, 1, conj[dR2],   1/3, 1, -3};
FermionFields[[9]] = {u2, 1, conj[uR2],  -2/3, 1, -3};
FermionFields[[10]] = {e2, 1, conj[eR2],     1, 1,  1};

FermionFields[[11]] = {q3, 1, {uL3, dL3},     1/6, 2, 3};  
FermionFields[[12]] = {l3, 1, {vL3, eL3},    -1/2, 2, 1};
FermionFields[[13]] = {d3, 1, conj[dR3],   1/3, 1, -3};
FermionFields[[14]] = {u3, 1, conj[uR3],  -2/3, 1, -3};
FermionFields[[15]] = {e3, 1, conj[eR3],     1, 1,  1};

ScalarFields[[1]] =  {H1, 1, {H1p, H10}, 1/2, 2, 1};
ScalarFields[[2]] =  {H2, 1, {H2p, H20}, 1/2, 2, 1};
ScalarFields[[3]] =  {H3, 1, {H3p, H30}, 1/2, 2, 1};

(*----------------------------------------------*)
(*   DEFINITION                                 *)
(*----------------------------------------------*)

NameOfStates = {GaugeES, EWSB};

(* ----- Before EWSB ----- *)

DEFINITION[GaugeES][Additional] = {
   {LagHC, {AddHC->True}},
	{LagNoHC, {AddHC->False}}
};

(*
*)

(*
V = -msq (H1d.H1 + H2d.H2 + H3d.H3) +
   l1 ((H1d.H1)^2 + (H2d.H2)^2 + (H3d.H3)^2) +
   l2 (2 H1d.H1 H2d.H2 + 2 H1d.H1 H3d.H3 + 2 H2d.H2 H3d.H3) +
   l3 (2 H1d.H2 H2d.H1 + 2 H1d.H3 H3d.H1 + 2 H2d.H3 H3d.H2) +
   l4t ((H1d.H2) (H1d.H3) + (H2d.H3) (H2d.H1) + (H3d.H1) (H3d.H2)) +
   l4td ((H1.H2d) (H1.H3d) + (H2.H3d) (H2.H1d) + (H3.H1d) (H3.H2d)) \
/. {H1 -> {h1, h2}, H2 -> {h3, h4}, H3 -> {h5, h6}, H1d -> {h1b, h2b},
    H2d -> {h3b, h4b}, H3d -> {h5b, h6b}}
*)
LagNoHC = -(
   - M2 (conj[H1].H1 + conj[H2].H2 + conj[H3].H3)
   + Lambdas ( conj[H1].H1.conj[H1].H1 + conj[H2].H2.conj[H2].H2 + conj[H3].H3.conj[H3].H3)
   + Lambdar1 (
      conj[H1].H1.conj[H1].H1 + conj[H2].H2.conj[H2].H2 + conj[H3].H3.conj[H3].H3 
      + 2 conj[H1].H1.conj[H2].H2 + 2 conj[H1].H1.conj[H3].H3 + 2 conj[H2].H2.conj[H3].H3
   )
   + Lambdar2 (
      conj[H1].H1.conj[H1].H1 + conj[H2].H2.conj[H2].H2 + conj[H3].H3.conj[H3].H3
      + 2 conj[H1].H2.conj[H2].H1 + 2 conj[H1].H3.conj[H3].H1 + 2 conj[H2].H3.conj[H3].H2
   )
);

LagHC = - (
   LambdadConj (conj[H1].H2.conj[H1].H3 + conj[H2].H3.conj[H2].H1 + conj[H3].H1.conj[H3].H2) 
   + Yd1 (conj[H1].d1.q1 + conj[H2].d2.q1 + conj[H3].d3.q1)
   + Yd2 (conj[H1].d2.q2 + conj[H2].d3.q2 + conj[H3].d1.q2)
   + Yd3 (conj[H1].d3.q3 + conj[H2].d1.q3 + conj[H3].d2.q3)

   + Ye1 (conj[H1].e1.l1 + conj[H2].e2.l1 + conj[H3].e3.l1)
   + Ye2 (conj[H1].e2.l2 + conj[H2].e3.l2 + conj[H3].e1.l2)
   + Ye3 (conj[H1].e3.l3 + conj[H2].e1.l3 + conj[H3].e2.l3)

   - Yu1 (H1.u1.q1 + H2.u2.q1 + H3.u3.q1)
   - Yu2 (H1.u3.q2 + H2.u1.q2 + H3.u2.q2)
   - Yu3 (H1.u2.q3 + H2.u3.q3 + H3.u1.q3)
);

(* Gauge Sector *)

DEFINITION[EWSB][GaugeSector] = { 
  {{VB, VWB[3]},     {VP,VZ}, ZZ},
  {{VWB[1], VWB[2]}, {VWm,conj[VWm]}, ZW}
};     

(* ----- VEVs ---- *)

DEFINITION[EWSB][VEVs] = {    
   {H10, {v1, 1/Sqrt[2]}, {sigma1, \[ImaginaryI]/Sqrt[2]}, {phi1, 1/Sqrt[2]}},     
   {H20, {v2, 1/Sqrt[2]}, {sigma2, \[ImaginaryI]/Sqrt[2]}, {phi2, 1/Sqrt[2]}},     
   {H30, {v3, 1/Sqrt[2]}, {sigma3, \[ImaginaryI]/Sqrt[2]}, {phi3, 1/Sqrt[2]}}
};
 

DEFINITION[EWSB][MatterSector] = { 
   {{phi1, phi2, phi3}, {hh, ZH}},
   {{sigma1, sigma2, sigma3}, {Ah, ZA}},
   {{conj[H1p], conj[H2p], conj[H3p]}, {Hm, ZP}},
   {{{dL1, dL2, dL3}, {conj[dR1], conj[dR2], conj[dR3]}}, {{DL, Vd}, {DR, Ud}}},
   {{{uL1, uL2, uL3}, {conj[uR1], conj[uR2], conj[uR3]}}, {{UL, Vu}, {UR, Uu}}},
   {{{eL1, eL2, eL3}, {conj[eR1], conj[eR2], conj[eR3]}}, {{EL, Ve}, {ER, Ue}}}
};  


(*------------------------------------------------------*)
(* Dirac-Spinors *)
(*------------------------------------------------------*)

DEFINITION[EWSB][DiracSpinors] = {
   Fd ->{DL, conj[DR]},
   Fe ->{EL, conj[ER]},
   Fu ->{UL, conj[UR]}
};

DEFINITION[EWSB][GaugeES] = {
   Fd1 ->{FdL, 0},
   Fd2 ->{0, FdR},
   Fu1 ->{Fu1, 0},
   Fu2 ->{0, Fu2},
   Fe1 ->{Fe1, 0},
   Fe2 ->{0, Fe2}
};

