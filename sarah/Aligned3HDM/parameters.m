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

ParameterDefinitions = { 

{g1,        { Description -> "Hypercharge-Coupling"}},
{g2,        { Description -> "Left-Coupling"}},
{g3,        { Description -> "Strong-Coupling"}},    
{AlphaS,    {Description -> "Alpha Strong"}},	
{e,         { Description -> "electric charge"}}, 

{Gf,        { Description -> "Fermi's constant"}},
{aEWinv,    { Description -> "inverse weak coupling constant at mZ"}},

{Yu,        { Description -> "Up-Yukawa-Coupling",
			 DependenceNum ->  Sqrt[2]/v2* {{Mass[Fu,1],0,0},
             									{0, Mass[Fu,2],0},
             									{0, 0, Mass[Fu,3]}}}}, 
             									
{Yd,        { Description -> "Down-Yukawa-Coupling",
			  DependenceNum ->  Sqrt[2]/v1* {{Mass[Fd,1],0,0},
             									{0, Mass[Fd,2],0},
             									{0, 0, Mass[Fd,3]}}}},
             									
{Ye,        { Description -> "Lepton-Yukawa-Coupling",
			  DependenceNum ->  Sqrt[2]/v1* {{Mass[Fe,1],0,0},
             									{0, Mass[Fe,2],0},
             									{0, 0, Mass[Fe,3]}}}}, 
                                                                            
{Etau,        { Description -> "Up-Eta-Coupling",
   LesHouches -> Etau,
   OutputName -> Etau,
			 DependenceNum ->  Sqrt[2]/v2* {{Mass[Fu,1],0,0},
             									{0, Mass[Fu,2],0},
             									{0, 0, Mass[Fu,3]}}}}, 
             									
{Etad,        { Description -> "Down-Eta-Coupling",
   LesHouches -> Etad,
   OutputName -> Etad,
			  DependenceNum ->  Sqrt[2]/v1* {{Mass[Fd,1],0,0},
             									{0, Mass[Fd,2],0},
             									{0, 0, Mass[Fd,3]}}}},
             									
{Etae,        { Description -> "Lepton-Eta-Coupling",
   LesHouches -> Etae,
   OutputName -> Etae,
			  DependenceNum ->  Sqrt[2]/v1* {{Mass[Fe,1],0,0},
             									{0, Mass[Fe,2],0},
             									{0, 0, Mass[Fe,3]}}}}, 
                                                                           
{Lambda1,    { LaTeX -> "\\lambda_1",
               OutputName -> Lam1,
               LesHouches -> {HMIX,31}}},
{Lambda2,    { LaTeX -> "\\lambda_2",
               OutputName -> Lam2,
               LesHouches -> {HMIX,32}}},
{Lambda3,    { LaTeX -> "\\lambda_3",
               OutputName -> Lam3,
               LesHouches -> {HMIX,33}}},
{Lambda11,    { LaTeX -> "\\lambda_{11}",
               OutputName -> Lam11,
               LesHouches -> {HMIX,34}}},
{Lambda22,    { LaTeX -> "\\lambda_{22}",
               OutputName -> Lam22,
               LesHouches -> {HMIX,35}}},

{Lambda33,    { LaTeX -> "\\lambda_{33}",
               OutputName -> Lam33,
               LesHouches -> {HMIX,36}}},

{Lambda12,    { LaTeX -> "\\lambda_{12}",
               OutputName -> Lam12,
               LesHouches -> {HMIX,37}}},

{Lambda23,    { LaTeX -> "\\lambda_{23}",
               OutputName -> Lam23,
               LesHouches -> {HMIX,38}}},

{Lambda31,    { LaTeX -> "\\lambda_{31}",
               OutputName -> Lam31,
               LesHouches -> {HMIX,39}}},
               
{LambdaP12,    { LaTeX -> "\\lambda'_{12}",
               OutputName -> LamP12,
               LesHouches -> {HMIX,40}}},

{LambdaP23,    { LaTeX -> "\\lambda'_{23}",
               OutputName -> LamP23,
               LesHouches -> {HMIX,41}}},

{LambdaP31,    { LaTeX -> "\\lambda'_{31}",
               OutputName -> LamP31,
               LesHouches -> {HMIX,42}}},

{M12,    {    LaTeX -> "m^2_1",
               OutputName -> M12,
               LesHouches -> {HMIX,20}}},


{M22,    {    LaTeX -> "m^2_2",
               OutputName -> M22,
               LesHouches -> {HMIX,21}}},

{M32,    {    LaTeX -> "m^3_2",
               OutputName -> M32,
               LesHouches -> {HMIX,22}}},

{M122,    {    LaTeX -> "m^2_{12}",
               OutputName -> M122,
               LesHouches -> {HMIX,23}}},


{v1,        { Description -> "Down-VEV", LaTeX -> "v_1"}}, 
{v2,        { Description -> "Up-VEV", LaTeX -> "v_2"}},       
{v3,        { Description -> "Whatever-VEV", LaTeX -> "v_3"}},       
{v,         { Description -> "EW-VEV", DependenceSPheno -> Sqrt[v1^2 + v2^2 + v3^2] }},
             
{\[Beta],   { Description -> "Pseudo Scalar mixing angle"  }},             
{TanBeta,   { Description -> "Tan Beta" }},              
{\[Alpha],  { Description -> "Scalar mixing angle" }},  

{ZH,        { Description->"Scalar-Mixing-Matrix", DependenceOptional -> None}},
{ZA,        { Description->"Pseudo-Scalar-Mixing-Matrix", DependenceOptional -> None}},
{ZP,        { Description->"Charged-Mixing-Matrix", DependenceOptional -> None}},  


{ThetaW,    { Description -> "Weinberg-Angle"}}, 

{ZZ, {Description ->   "Photon-Z Mixing Matrix"}},
{ZW, {Description -> "W Mixing Matrix" }},


{Vu,        {Description ->"Left-Up-Mixing-Matrix"}},
{Vd,        {Description ->"Left-Down-Mixing-Matrix"}},
{Uu,        {Description ->"Right-Up-Mixing-Matrix"}},
{Ud,        {Description ->"Right-Down-Mixing-Matrix"}}, 
{Ve,        {Description ->"Left-Lepton-Mixing-Matrix"}},
{Ue,        {Description ->"Right-Lepton-Mixing-Matrix"}}

 }; 
 

