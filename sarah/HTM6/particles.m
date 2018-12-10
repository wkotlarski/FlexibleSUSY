

ParticleDefinitions[GaugeES] = {
      {H0,  { 
                 PDG -> {0},
                 Width -> 0, 
                 Mass -> Automatic,
                 FeynArtsNr -> 1,
                 LaTeX -> "H^0",
                 OutputName -> "H0" }},                         
      
      
      {Hp,  {   
                 PDG -> {0},
                 Width -> 0, 
                 Mass -> Automatic,
                 FeynArtsNr -> 2,
                 LaTeX -> "H^+",
                 OutputName -> "Hp" }}, 

(*      {T0,  { 
		 FeynArtsNr -> 3,
                 LaTeX -> "T^0",
                 OutputName -> "T0" }},

      {Tp,  {   
		 FeynArtsNr -> 4,
                 LaTeX -> "H^+",
                 OutputName -> "Tp" }},
(*     {Tpp,{ 
     FeynArtsNr -> 6   (* auto generated FeynArts number *),  
     OutputName -> "tpp"   (* auto generated Output name *), 
     ElectricCharge -> 2, 
     Width -> Automatic}} ,  *)  

*)
                      
    

      {VB,   { Description -> "B-Boson"}},                                                   
      {VG,   { Description -> "Gluon"}},          
      {VWB,  { Description -> "W-Bosons"}},          
      {gB,   { Description -> "B-Boson Ghost"}},                                                   
      {gG,   { Description -> "Gluon Ghost" }},          
      {gWB,  { Description -> "W-Boson Ghost"}}
      
      };
      
      
      
      
  ParticleDefinitions[EWSB] = {
            
      
(*    {hh   ,  {  Description -> "Higgs",
                 PDG -> {25,35},
                 PDG.IX -> {101000001,101000002},
		 Mass -> {125, MHh} }}, 
                 
    {Ah,{ 
     Description -> "Pseudo-Scalar Higgs", 
     LaTeX -> "A^0", 
     Mass -> {0, MPs}, 
     OutputName -> "Ah", 
     PDG -> {0,36}, 
     ElectricCharge -> 0, 
     Width -> {0, Automatic}}},                      
      
      
     {Hpm,     { Description -> "Charged Higgs", 
                 PDG -> {0,37},
                 Width -> Automatic, 
                 Mass -> {0, MCh},
                 LaTeX -> "H^\\pm",
                 ElectricCharge -> 1,                 
                 OutputName -> "Hc"
                 }},   


(*     {Hpp,     { Description -> "Doubly charged Higgs", 
                 PDG -> 302,
		 FeynArtsNr -> 7,
                 Width -> Automatic, 
                 Mass -> Automatic,
                 LaTeX -> "H^{\\pm\\pm}",
                 ElectricCharge -> 2,                 
                 OutputName -> "Hcc"
                 }},
*)
*)
     {Tpp,     { Description -> "Doubly charged Higgs", 
                 PDG -> {302},
		 FeynArtsNr -> 6,
                 Width -> Automatic, 
                 Mass -> MCC,
                 LaTeX -> "H^{\\pm\\pm}",
                 ElectricCharge -> 2,                 
                 OutputName -> "Tpp"
                 }},        

     
            
    {hh   ,  {  Description -> "Higgs"}}, 
    {Ah   ,  {  Description -> "Pseudo-Scalar Higgs"}}, 
      
    {Hpm,     { Description -> "Charged Higgs"}},   


      
      
      {VP,   { Description -> "Photon"}}, 
      {VZ,   { Description -> "Z-Boson",
      			 Goldstone -> Ah[{1}] }}, 
      {VG,   { Description -> "Gluon" }},          
      {VWp,  { Description -> "W+ - Boson",
      			Goldstone -> Hpm[{1}] }},         
      {gP,   { Description -> "Photon Ghost"}},                                                   
      {gWp,  { Description -> "Positive W+ - Boson Ghost"}}, 
      {gWpC, { Description -> "Negative W+ - Boson Ghost" }}, 
      {gZ,   { Description -> "Z-Boson Ghost" }},
      {gG,   { Description -> "Gluon Ghost" }},          
                               
                 
      {Fd,   { Description -> "Down-Quarks"}},   
      {Fu,   { Description -> "Up-Quarks"}},   
      {Fe,   { Description -> "Leptons" }},
      {Fv,   { Description -> "Neutrinos"}}                                                              
     
        };    
        
        
        
 WeylFermionAndIndermediate = {
     
    {H,      { 
                 PDG -> {0},
                 Width -> 0, 
                 Mass -> Automatic,
                 LaTeX -> "H",
                 OutputName -> "" }},

    { H0, {LaTeX -> "H_0"} },
    { T0, {LaTeX -> "T_0"} },
    { Tp, {LaTeX -> "T^\\pm" } },
    { Tpp, {LaTeX -> "T^{\\pm\\pm}"} },
    { sigmaH, {LaTeX -> "\\sigma_H"} },
    { sigmaT, {LaTeX -> "\\sigma_T"} },
    { phiH, {LaTeX -> "\\phi_H"} },
    { phiT, {LaTeX -> "\\phi_T"} },

    { dR, {LaTeX -> "d_R" }},
    { eR, {LaTeX -> "e_R" }},
    { l,  {LaTeX -> "l"  }},
    { uR, {LaTeX -> "u_R" }},
    { q,  {LaTeX -> "q"  }},
    { eL, {LaTeX -> "e_L" }},
    { dL, {LaTeX -> "d_L" }},
    { uL, {LaTeX -> "u_L" }},
    { vL, {LaTeX -> "\\nu_L" }},

    { FDR, {LaTeX -> "D_R" }},
    { FER, {LaTeX -> "E_R" }},
    { FUR, {LaTeX -> "U_R" }},
    { FEL, {LaTeX -> "E_L" }},
    { FDL, {LaTeX -> "D_L" }},
    { FUL, {LaTeX -> "U_L" }}

        };       


