(* ::Package:: *)

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

BeginPackage["FFVFormFactors`", {"SARAH`", "TextFormatting`", "TreeMasses`", "Vertices`", "CXXDiagrams`"}];

FFVFormFactorsCreateInterfaceFunctionForField::usage="";
FFVFormFactorsContributingDiagramsForFieldAndGraph::usage="";
FFVFormFactorsContributingGraphs::usage="";

(* TODO: uncomment this in the end *)
(*Begin["Private`"];*)

(* The graphs that contribute to the EDM are precisely those with three
   external lines given by the field in question, its Lorentz conjugate
   and a photon.
   They are given as a List of undirected adjacency matrices where
    1 is the field itself
    2 is its Lorentz conjugate
    3 is the photon
   and all other indices unspecified. *)
vertexCorrectionGraph = {{0,0,0,1,0,0},
                         {0,0,0,0,1,0},
                         {0,0,0,0,0,1},
                         {1,0,0,0,1,1},
                         {0,1,0,1,0,1},
                         {0,0,1,1,1,0}};
contributingGraphs = {vertexCorrectionGraph};

FFVFormFactorsContributingGraphs[] := contributingGraphs

FFVFormFactorsContributingDiagramsForLeptonPairAndGraph[{inFermion_, outFermion_, spectator_}, graph_] :=
  Module[{diagrams},
    diagrams = CXXDiagrams`FeynmanDiagramsOfType[graph,
         {1 ->CXXDiagrams`LorentzConjugate[inFermion], 2 -> outFermion,
          3 -> CXXDiagrams`LorentzConjugate[spectator]}];

    Select[diagrams,IsDiagramSupported[inFermion,outFermion,spectator,graph,#] &]
 ]

IsDiagramSupported[inFermion_,outFermion_,spectator_,vertexCorrectionGraph,diagram_] :=
  Module[{Emitter,exchangeParticle},
    Emitter = CXXDiagrams`LorentzConjugate[diagram[[4,3]]]; (* Edge between vertices 4 and 6 (3rd edge of vertex 4) *)
    exchangeParticle = diagram[[4,2]]; (* Edge between vertices 4 and 5 (2nd edge of vertex 4) *)
    
    If[diagram[[6]] =!= {spectator,Emitter,CXXDiagrams`LorentzConjugate[Emitter]},
       Return["(unknown diagram)"]];
    If[TreeMasses`IsFermion[Emitter] && TreeMasses`IsScalar[exchangeParticle],
       Return[True]];
    If[TreeMasses`IsFermion[exchangeParticle] && TreeMasses`IsScalar[Emitter],
       Return[True]];
    
    Return[False];
  ]

FFVFormFactorsCreateInterfaceFunctionForLeptonPair[{inFermion_, outFermion_, spectator_}, gTaggedDiagrams_List] :=
   Module[
      {prototype, definition, numberOfIndices1 = CXXDiagrams`NumberOfFieldIndices[inFermion],
         numberOfIndices2 = CXXDiagrams`NumberOfFieldIndices[outFermion],
         numberOfIndices3 = CXXDiagrams`NumberOfFieldIndices[spectator]
      },
   
      prototype =
         "std::valarray<std::complex<double>> calculate_" <> CXXNameOfField[inFermion] <>
            "_" <> CXXNameOfField[outFermion] <> "_" <> CXXNameOfField[spectator] <> "_form_factors" <>
            " (\n" <>
            If[TreeMasses`GetDimension[inFermion] =!= 1,
               "   int generationIndex1, ",
               " "
            ] <>
            If[TreeMasses`GetDimension[outFermion] =!= 1,
               " int generationIndex2, ",
               " "
            ] <>
            "const " <> FlexibleSUSY`FSModelName <> "_mass_eigenstates& model );\n";
                 
      definition =
         (* calculate form factors A1L, A2L, etc *)
         "std::valarray<std::complex<double>> calculate_" <> CXXNameOfField[inFermion] <>
            "_" <> CXXNameOfField[outFermion] <> "_" <> CXXNameOfField[spectator] <> "_form_factors" <>
            " (\n" <>
            If[TreeMasses`GetDimension[inFermion] =!= 1,
               "   int generationIndex1, ",
               " "
            ] <>
            If[TreeMasses`GetDimension[outFermion] =!= 1,
               " int generationIndex2, ",
               " "
            ] <>
            "const " <> FlexibleSUSY`FSModelName <> "_mass_eigenstates& model )\n" <>
            "{\n" <>
            IndentText[
               FlexibleSUSY`FSModelName <> "_mass_eigenstates model_ = model;\n" <>
               "EvaluationContext context{ model_ };\n" <>
               "std::array<int, " <> ToString @ numberOfIndices1 <> "> indices1 = {" <>
                     (* TODO: Specify indices correctly *)
                       If[TreeMasses`GetDimension[inFermion] =!= 1,
                          " generationIndex1" <>
                          If[numberOfIndices1 =!= 1,
                             StringJoin @ Table[", 0", {numberOfIndices1-1}],
                             ""] <> " ",
                          If[numberOfIndices1 =!= 0,
                             StringJoin @ Riffle[Table[" 0", {numberOfIndices1}], ","] <> " ",
                             ""]
                         ] <> "};\n" <>
                   "std::array<int, " <> ToString @ numberOfIndices2 <>
                     "> indices2 = {" <>
                       If[TreeMasses`GetDimension[outFermion] =!= 1,
                          " generationIndex2" <>
                          If[numberOfIndices2 =!= 1,
                             StringJoin @ Table[", 0", {numberOfIndices2-1}],
                             ""] <> " ",
                          If[numberOfIndices2 =!= 0,
                             StringJoin @ Riffle[Table[" 0", {numberOfIndices2}], ","] <> " ",
                             ""]
                         ] <> "};\n\n" <>

               "std::valarray<std::complex<double>> val {0.0, 0.0, 0.0, 0.0};\n\n" <>
               
               StringJoin @ Riffle[("val += " <> ToString @ # <> "::value(indices1, indices2, context);") & /@
                     Flatten[CXXEvaluatorsForLeptonPairAndDiagramsFromGraph[{inFermion, outFermion, spectator},#[[2]],#[[1]]] & /@ gTaggedDiagrams],
                                       "\n"] <> "\n\n" <>
               "return val;"
                  (*"return width/(width + sm_width(generationIndex1, generationIndex2, model));"*)
            ] <> "\n}\n\n";
    
    {prototype, definition}
  ];

(* evaluate multiple diagrams *)
CXXEvaluatorsForLeptonPairAndDiagramsFromGraph[{inFermion_, outFermion_, spectator_}, diagrams_, graph_] :=
   CXXEvaluatorsForLeptonPairAndDiagramFromGraph[inFermion, outFermion, spectator, #, graph] & /@ diagrams;

(* evaluate single diagram *)
CXXEvaluatorsForLeptonPairAndDiagramFromGraph[inFermion_, outFermion_, spectator_, diagram_, vertexCorrectionGraph] := 
   Module[{Emitter, exchangeParticle, colorFactor, colorFactorStr},
      Emitter = CXXDiagrams`LorentzConjugate[diagram[[4,3]]]; (* Edge between vertices 4 and 6 (3rd edge of vertex 4) *)
      exchangeParticle = diagram[[4,2]]; (* Edge between vertices 4 and 5 (2nd edge of vertex 4) *)
    
      colorFactor = getChargeFactor[
 {
  {
   Cp[inFermion, exchangeParticle, AntiField[Emitter]],
   Cp[spectator, Emitter, AntiField[Emitter]],
   Cp[AntiField[outFermion], AntiField[exchangeParticle], 
    Emitter]
   },
  {
   External[1] -> inFermion, External[2] -> AntiField[outFermion], 
   External[3] -> spectator,
   Internal[1] -> Emitter, Internal[2] -> exchangeParticle, 
   Internal[3] -> AntiField[Emitter]
   }
  },
 {
  {{inFermion, ex1}, {exchangeParticle, 
    in2}, {AntiField[Emitter], in1}},
  {{spectator, ex3}, {AntiField[Emitter], in3}, {Emitter, in1}},
  {{AntiField[outFermion], ex2}, {AntiField[exchangeParticle], 
    in2}, {Emitter, in3}}
  }
 ];
 Print[inFermion, " ", outFermion, " ", Emitter, " ", exchangeParticle, " ", colorFactor];
    
    colorFactorStr = "std::complex<double> " <> 
       ToString @ (N[#, 16]& /@ (ReIm[colorFactor]/EvaluateColorStruct[Emitter, exchangeParticle]));
    If[TreeMasses`IsFermion[Emitter] && TreeMasses`IsScalar[exchangeParticle],
       Return[colorFactorStr <> " * " <> CXXEvaluatorFS[inFermion,outFermion,spectator,Emitter,exchangeParticle]]];
    If[TreeMasses`IsFermion[exchangeParticle] && TreeMasses`IsScalar[Emitter],
       Return[colorFactorStr <> " * " <> CXXEvaluatorSF[inFermion,outFermion,spectator,Emitter,exchangeParticle]]];
    
    (* TODO: add switch for remaining topologies *)
    Return["(unknown diagram)"];
  ]

(* loop diagrams *)

CXXEvaluatorFS[inFermion_,outFermion_,spectator_,Emitter_,exchangeParticle_] :=
   "EDMVertexCorrectionFS<" <> CXXDiagrams`CXXNameOfField[inFermion] <> ", " <>
   CXXDiagrams`CXXNameOfField[outFermion] <> ", " <>
   CXXDiagrams`CXXNameOfField[spectator] <> ", " <>
   CXXDiagrams`CXXNameOfField[Emitter] <> ", " <>
   CXXDiagrams`CXXNameOfField[exchangeParticle] <> ">"

CXXEvaluatorSF[inFermion_,outFermion_,spectator_,Emitter_,exchangeParticle_] :=
   "EDMVertexCorrectionSF<" <> CXXDiagrams`CXXNameOfField[inFermion] <> ", " <>
   CXXDiagrams`CXXNameOfField[outFermion] <> ", " <>
   CXXDiagrams`CXXNameOfField[spectator] <> ", " <>
   CXXDiagrams`CXXNameOfField[Emitter] <> ", " <>
   CXXDiagrams`CXXNameOfField[exchangeParticle] <> ">"

(* Divide by this factor because we some over color indices. *)
EvaluateColorStruct[Emitter_, exchangeParticle_] := 
 Switch[getColorRep[Emitter] && getColorRep[exchangeParticle], T && T, 3*3, 
  T && O, 3*8, O && T, 8*3, O && O, 8*8, _, 1]

(* TODO: add other topologies? *)

(*End[];*)
EndPackage[];
