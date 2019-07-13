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


ParticleDefinitions[GaugeES] = {
      {H0,  {    PDG -> {0},
                 Width -> 0, 
                 Mass -> Automatic,
                 FeynArtsNr -> 1,
                 LaTeX -> "H^0",
                 OutputName -> "H0" }},                         
      
      
      {Hp,  {             PDG -> {0},
                 Width -> 0, 
                 Mass -> Automatic,
                 FeynArtsNr -> 2,
                 LaTeX -> "H^+",
                 OutputName -> "Hp" }}, 
                 
               
    
      {VB,   { Description -> "B-Boson"}},                                                   
      {VG,   { Description -> "Gluon"}},          
      {VWB,  { Description -> "W-Bosons"}},          
      {gB,   { Description -> "B-Boson Ghost"}},                                                   
      {gG,   { Description -> "Gluon Ghost" }},          
      {gWB,  { Description -> "W-Boson Ghost"}}
      
      };
      
      
      
      
  ParticleDefinitions[EWSB] = {
     (* --------------------------------------- Higgs -----------------------------------------*)     
     
    {hh, {   Description -> "Higgs",
                PDG -> {25, 35, 45}, 
                PDG.IX ->{101000001,101000002, 101000003},
                Mass -> LesHouches,
                FeynArtsNr -> 1,
                LaTeX -> "h", 
                ElectricCharge -> 0,
                LHPC -> {1, "gold"},
                OutputName -> "h" }},  
     
     {Ah, {   Description -> "Pseudo-Scalar Higgs",
                 PDG -> {0, 36, 46}, 
                 PDG.IX ->{0,102000001, 102000002},
                 Width -> {0, External},
                 Mass -> {0, LesHouches},
                 FeynArtsNr -> 2,
                 LaTeX -> "A^0",
                 ElectricCharge -> 0,
                 LHPC -> {1, "gold"},
                 OutputName -> "Ah" }},     
     
    {Hm, {   Description -> "Charged Higgs", 
                 PDG -> {0, -37, -47},
                 PDG.IX ->{0, -100000601, -100000602},
                 Width -> {0, External}, 
                 Mass -> {0, LesHouches},
                 FeynArtsNr -> 3,
                 LaTeX -> {"H^-","H^+"},
                 LHPC -> {2, "orange-red"},
                 ElectricCharge -> -1,
                 OutputName -> {"Hm","Hp"} }},
      
      {VP,   { Description -> "Photon"}}, 
      {VZ,   { Description -> "Z-Boson"}}, 
      {VG,   { Description -> "Gluon" }},          
      {VWm,  { Description -> "W-Boson",
               Goldstone -> Hm[{1}] }},         
      {gP,   { Description -> "Photon Ghost"}},                                                   
      {gWm,  { Description -> "Negative W-Boson Ghost"}}, 
      {gWmC, { Description -> "Positive W-Boson Ghost" }}, 
      {gZ,   { Description -> "Z-Boson Ghost" }},
      {gG,   { Description -> "Gluon Ghost" }},             
                               
                 
      {Fd,   { Description -> "Down-Quarks"}},   
      {Fu,   { Description -> "Up-Quarks"}},   
      {Fe,   { Description -> "Leptons" }},
      {Fv,   { Description -> "Neutrinos" }}                                                              
     
        };    
        
        
        
 WeylFermionAndIndermediate = {
     
    {H,      {   PDG -> {0},
                 Width -> 0, 
                 Mass -> Automatic,
                 LaTeX -> "H",
                 OutputName -> "" }},

   {H10, {LaTeX -> "H_1^0"}},
   {H20, {LaTeX -> "H_2^0"}},
   {H1p, {LaTeX -> "H_1^+"}},
   {H2p, {LaTeX -> "H_2^+"}},

   {sigma1, {LaTeX -> "\\sigma_1"}},
   {sigma2, {LaTeX -> "\\sigma_2"}},

   {phi1, {LaTeX -> "\\phi_1"}},
   {phi2, {LaTeX -> "\\phi_2"}},


   {dR,     {LaTeX -> "d_R" }},
   {eR,     {LaTeX -> "e_R" }},
   {lep,     {LaTeX -> "l" }},
   {uR,     {LaTeX -> "u_R" }},
   {q,     {LaTeX -> "q" }},
   {eL,     {LaTeX -> "e_L" }},
   {dL,     {LaTeX -> "d_L" }},
   {uL,     {LaTeX -> "u_L" }},
   {vL,     {LaTeX -> "\\nu_L" }},

   {DR,     {LaTeX -> "D_R" }},
   {ER,     {LaTeX -> "E_R" }},
   {UR,     {LaTeX -> "U_R" }},
   {EL,     {LaTeX -> "E_L" }},
   {DL,     {LaTeX -> "D_L" }},
   {UL,     {LaTeX -> "U_L" }}
        };       


