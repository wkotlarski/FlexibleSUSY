ParameterDefinitions = { 

{g1,        { Description -> "Hypercharge-Coupling"}},
{g2,        { Description -> "Left-Coupling"}},
{g3,        { Description -> "Strong-Coupling"}},    
{AlphaS,    {Description -> "Alpha Strong"}},	
{e,         { Description -> "electric charge"}}, 

{Gf,        { Description -> "Fermi's constant"}},
{aEWinv,    { Description -> "inverse weak coupling constant at mZ"}},

{Yu,        { Description -> "Up-Yukawa-Coupling",
			 DependenceNum ->  Sqrt[2]/vd* {{Mass[Fu,1],0,0},
             									{0, Mass[Fu,2],0},
             									{0, 0, Mass[Fu,3]}}}}, 
             									
{Yd,        { Description -> "Down-Yukawa-Coupling",
			  DependenceNum ->  Sqrt[2]/vd* {{Mass[Fd,1],0,0},
             									{0, Mass[Fd,2],0},
             									{0, 0, Mass[Fd,3]}}}},
             									
{Ye,        { Description -> "Lepton-Yukawa-Coupling",
			  DependenceNum ->  Sqrt[2]/vd* {{Mass[Fe,1],0,0},
             									{0, Mass[Fe,2],0},
             									{0, 0, Mass[Fe,3]}}}}, 
                                                                            
                                                                           
{mu2,         { Description -> "SM Mu Parameter",
        LesHouches -> {HMIX,2}}},                                        

{LH,  { Description -> "SM Higgs Selfcouplings",
(*	DependenceNum -> Mass[hh]^2/(v^2),*)
        LesHouches -> {HMIX,1} }},

{v,          { Description -> "EW-VEV",
(*               DependenceNum -> Sqrt[4*Mass[VWp]^2/(g2^2)]*)
		DependenceSPheno -> Sqrt[vd^2+2*vT^2]
(*               DependenceSPheno -> None,*)
(*	       OutputName -> v *) }},


{vd,          { Description -> "Down-VEV",
	       Real -> True,
(*               DependenceNum -> Sqrt[v^2-2*vT^2],*)
(*               DependenceNum -> Sqrt[4*Mass[VWp]^2/(g2^2)],*)
(*               DependenceSPheno -> None,*)
	       OutputName -> vd  }},

{vT,  {  Description -> "Up-VEV",
	 LaTeX -> "v_T",
        Real -> True,
        OutputName -> vT }},

{MT,  { LaTeX -> "\\mu_T",
        OutputName -> MT,
	Real -> True,
        LesHouches -> {HMIX,15} }},

{KHT,  { LaTeX -> "\\kappa",
	Real -> True,
        OutputName -> Kap,
        LesHouches -> {HMIX,20} }},

{LT,  { LaTeX -> "\\lambda_T",
	Real -> True,
        OutputName -> LT,
        LesHouches -> {HMIX,17} }},

{LT2,  { LaTeX -> "{\\lambda'}_T",
	Real -> True,
        OutputName -> LT2,
        LesHouches -> {HMIX,18} }},        

{LHT,  { LaTeX -> "\\lambda_{HT}",
	Real -> True,
        OutputName -> LHT,
        LesHouches -> {HMIX,19} }},        

{LHT2,  { LaTeX -> "\\lambda_{HT'}",
	Real -> True,
        OutputName -> LHT2,
        LesHouches -> {HMIX,21} }},        
        
{ThetaW,    { Description -> "Weinberg-Angle",
              Real -> True
(*	      DependenceNum -> ArcSin[Sqrt[1 - Mass[VWp]^2/Mass[VZ]^2]]*) }},


(*{alpha, {
	LaTeX -> "\\alpha",
	Real -> True,
(*	DependenceNum -> ArcSin[2*vT/v],*)
	OutputName -> alpha
	}},*)

{\[Alpha], { Description -> "Scalar mixing angle"}},
{\[Beta],  { Description -> "Charged Scalar Mixing Angle"}},
{TanBeta, {Description -> "Tan Beta"}},

(*{betap, {
	LaTeX -> "\\betap",
	Real -> True,
(*	DependenceNum -> ArcSin[Sqrt[2]*vT/v],*)
	OutputName -> betap
	}},*)

{betap, {
        Description -> "Pseudo Scalar mixing angle",
	LaTeX -> "\\beta_p",
	Real -> True,
(*	DependenceNum -> ArcSin[2*vT/Sqrt[v^2+4*vT^2]],*)
	OutputName -> betap
	}},

{ZZ, {Description -> "Photon-Z Mixing Matrix",
       Dependence -> {{Cos[ThetaW],-Sin[ThetaW]},{Sin[ThetaW],Cos[ThetaW]}}   }},

{ZW, {Description -> "W Mixing Matrix",
       Dependence ->   1/Sqrt[2] {{1, 1},
                  {\[ImaginaryI],-\[ImaginaryI]}} }},

{ZH,  { Description->"Scalar-Mixing-Matrix",
        Real->True,
        LesHouches -> ZH,
        OutputName -> ZH,
        LaTeX->"Z^H" 
(*        DependenceSPheno -> {{Cos[\[Alpha]],-Sin[\[Alpha]]},{Sin[\[Alpha]],Cos[\[Alpha]]}}*)
(*        DependenceOptional -> None,
        DependenceNum -> None *) }},
        
{ZA,         { Description->"Pseudo-Scalar-Mixing-Matrix", 
               LaTeX -> "Z^A",
               Real -> True,
               LesHouches -> PSEUDOSCALARMIX,
               OutputName-> ZA 
(*        DependenceSPheno -> {{Cos[betap],-Sin[betap]},{Sin[betap],Cos[betap]}}*)
(*        DependenceOptional -> None,
        DependenceNum -> None  *)    }},        

{ZP,        { Description->"Charged-Mixing-Matrix", 
                Dependence -> {{Cos[\[Beta]],-Sin[\[Beta]]},{Sin[\[Beta]],Cos[\[Beta]]}}
(*               DependenceOptional -> None,
               DependenceNum -> None *) }}, 



{Vu,        {Description ->"Left-Up-Mixing-Matrix"}},
{Vd,        {Description ->"Left-Down-Mixing-Matrix"}},
{Uu,        {Description ->"Right-Up-Mixing-Matrix"}},
{Ud,        {Description ->"Right-Down-Mixing-Matrix"}}, 
{Ve,        {Description ->"Left-Lepton-Mixing-Matrix"}},
{Ue,        {Description ->"Right-Lepton-Mixing-Matrix"}},

{Ynu,        { Description -> "Neutrino-Yukawa-Coupling",
		DependenceNum -> {{0,0,0},{0,0,0},{0,0,0}},
		OutputName -> "Ynu" }}

(*
(*

(*c kord*)             									
{PMNS,        { Description -> "PMNS matrix",
			  DependenceNum -> {{0.823233, 0.54793,-0.0873014+0.12016*I},
             					{-0.323302+0.0733699*I, 0.601312+0.0488338*I,0.725349},
             					{0.455804+0.0679905*I, -0.577723+0.0452533*I,0.672167}}}}, 
                                                                            
{Dv,        { Description -> "Neutrino mass diagonal matrix",
			  DependenceNum ->  1/2*{{mv1,0,0},
             					{0, mv2,0},
             					{0, 0, mv3}}}}, 

{Ynu,        { Description -> "Lepton-Yukawa-Coupling",
			  DependenceNum ->  (Sqrt[2]/(2*vT))*{{
	mv1*conj[PMNS[1,1]]*conj[PMNS[1,1]]+mv2*conj[PMNS[1,2]]*conj[PMNS[1,2]]+mv3*conj[PMNS[1,3]]*conj[PMNS[1,3]],
	mv1*conj[PMNS[1,1]]*conj[PMNS[2,1]]+mv2*conj[PMNS[1,2]]*conj[PMNS[2,2]]+mv3*conj[PMNS[1,3]]*conj[PMNS[2,3]],
	mv1*conj[PMNS[1,1]]*conj[PMNS[3,1]]+mv2*conj[PMNS[1,2]]*conj[PMNS[3,2]]+mv3*conj[PMNS[1,3]]*conj[PMNS[3,3]]},
       {mv1*conj[PMNS[1,1]]*conj[PMNS[2,1]]+mv2*conj[PMNS[1,2]]*conj[PMNS[2,2]]+mv3*conj[PMNS[1,3]]*conj[PMNS[2,3]],
      	mv1*conj[PMNS[2,1]]*conj[PMNS[2,1]]+mv2*conj[PMNS[2,2]]*conj[PMNS[2,2]]+mv3*conj[PMNS[2,3]]*conj[PMNS[2,3]],
	mv1*conj[PMNS[2,1]]*conj[PMNS[3,1]]+mv2*conj[PMNS[2,2]]*conj[PMNS[3,2]]+mv3*conj[PMNS[2,3]]*conj[PMNS[3,3]]},
       {mv1*conj[PMNS[1,1]]*conj[PMNS[3,1]]+mv2*conj[PMNS[1,2]]*conj[PMNS[3,2]]+mv3*conj[PMNS[1,3]]*conj[PMNS[3,3]],
	mv1*conj[PMNS[2,1]]*conj[PMNS[3,1]]+mv2*conj[PMNS[2,2]]*conj[PMNS[3,2]]+mv3*conj[PMNS[2,3]]*conj[PMNS[3,3]],
	mv1*conj[PMNS[3,1]]*conj[PMNS[3,1]]+mv2*conj[PMNS[3,2]]*conj[PMNS[3,2]]+mv3*conj[PMNS[3,3]]*conj[PMNS[3,3]]
	}},
	OutputName -> "Ynu"
	}},

 
{MCC, {
	LaTeX -> "M_{H^{\\pm\\pm}}",
	Real -> True,
	DependenceNum -> 700,
	OutputName -> MCC
	}},


{MHl, {
	LaTeX -> "M_h",
	Real -> True,
	DependenceNum -> 125,
	OutputName -> MHl
	}},

{MHh, {
	LaTeX -> "M_{H^0}",
	Real -> True,
	DependenceNum -> 700,
	OutputName -> MHh
	}},

{MPs, {
	LaTeX -> "M_{A^0}",
	Real -> True,
	DependenceNum -> Sqrt[((v^2 + 4 vT^2)(Cos[alpha]^2 MHh^2 + MHl^2 Sin[alpha]^2 - vT^2))/v^2],
	OutputName -> MPs
	}},


{MCh, {
	LaTeX -> "M_{H^\\pm}",
	Real -> True,
	DependenceNum -> Sqrt[((v^2 + 2 vT^2)(MCC^2 - v^2 + (MPs^2 v^2)/(v^2 + 4 vT^2)))/v^2]/Sqrt[2],
	OutputName -> MCh
	}},


{lph, {
	LaTeX -> "\\lambda_{\\phi}",
	Real -> True,
	DependenceNum -> 2(Cos[alpha]^2 MHl^2 + MHh^2 Sin[alpha]^2)/(v^2),
	OutputName -> lph
	}},

{mtri, {
	LaTeX -> "\\mu",
	Real -> True,
	DependenceNum -> (MPs^2 vT Sqrt[2])/(v^2 + 4 vT^2),
	OutputName -> mtri
	}},

{l1, {
	LaTeX -> "\\lambda_1",
	Real -> True,
	DependenceNum -> (Cos[alpha] (-MHh^2 + MHl^2)*Sin[alpha])/(v vT) + (4*MCh^2)/(v^2 + 2 vT^2) - (2 MPs^2)/(v^2 + 4 vT^2),
	OutputName -> l1
	}},

{l2, {
	LaTeX -> "\\lambda_2",
	Real -> True,
	DependenceNum -> (MCC^2 + (Cos[alpha]^2 MHh^2 + MHl^2 Sin[alpha]^2)/2 - (2 MCh^2 v^2)/(v^2 + 2 vT^2) + (MPs^2 v^2)/(2 (v^2 + 4 vT^2)))/vT^2,
	OutputName -> l2
	}},

{l3, {
	LaTeX -> "\\lambda_3",
	Real -> True,
	DependenceNum -> (-MCC^2 + (2 MCh^2 v^2)/(v^2 + 2 vT^2) - (MPs^2 v^2)/(v^2 + 4 vT^2))/vT^2,
	OutputName -> l3
	}},

{l4, {
	LaTeX -> "\\lambda_4",
	Real -> True,
	DependenceNum -> (-4 MCh^2)/(v^2 + 2 vT^2) + (4 MPs^2)/(v^2 + 4 vT^2),
	OutputName -> l4
	}},

{mchi, {
	LaTeX -> "\\text{m$\\chi $}^2",
	Real -> True,
	DependenceNum -> -(2 (l2+l3) vT^3 + v^2 ((l1+l4)vT - mtri Sqrt[2]))/(2 vT),
	OutputName -> mchi
	}},

{mph, {
	LaTeX -> "\\text{m$\\phi $}^2",
	Real -> True,
	DependenceNum -> (lph v^2 + 2 vT ((l1+l4) vT - 2 mtri Sqrt[2]))/4,
	OutputName -> mph
	}},


{mv0, {
	Description -> "Lower neutrino mass (in eV)",
	LaTeX -> "m_{\\nu_0}",
	Real -> True,
	DependenceNum -> 1,
	OutputName -> mv0
	}},


(* Normal hierarchy*)


{Dv21, {
	Real -> True,
	DependenceNum -> 7.40*10^-5,
	OutputName -> Dv21
	}},


{Dv31, {
	Real -> True,
	DependenceNum -> 2.494*10^-3,
	OutputName -> Dv31
	}},


{mv1, {
	LaTeX -> "m_{\\nu_1}",
	Real -> True,
	DependenceNum -> mv0*10^-9,
	OutputName -> mv1
	}},

{mv2, {
	LaTeX -> "m_{\\nu_2}",
	Real -> True,
	DependenceNum -> (Sqrt[mv0^2+Dv21])*10^-9,
	OutputName -> mv2
	}},

{mv3, {
	LaTeX -> "m_{\\nu_3}",
	Real -> True,
	DependenceNum -> (Sqrt[mv0+Dv31])*10*-9,
	OutputName -> mv3
	}}

*)
*)

(* ### *)

 }; 
 

