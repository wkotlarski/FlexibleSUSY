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

BeginPackage["MuEGamma`", {"SARAH`", "TextFormatting`", "TreeMasses`", "Vertices`", "CXXDiagrams`"}];

MuEGammaCreateInterfaceFunctionForField::usage="";
MuEGammaContributingDiagramsForFieldAndGraph::usage="";
MuEGammaContributingGraphs::usage="";

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
   (*
vertexCorrectionGraph = {{0,0,0,1,0,0},
                         {0,0,0,0,1,0},
                         {0,0,0,0,0,1},
                         {1,0,0,0,1,1},
                         {0,1,0,1,0,1},
                         {0,0,1,1,1,0}};

MuEGammaContributingDiagramsForLeptonPairAndGraph[{inFermion_, outFermion_, spectator_}, graph_] :=
  Module[{diagrams},
    diagrams = CXXDiagrams`FeynmanDiagramsOfType[graph,
         {1 ->CXXDiagrams`LorentzConjugate[inFermion], 2 -> outFermion,
          3 -> CXXDiagrams`LorentzConjugate[spectator]}];

    Select[diagrams,IsDiagramSupported[inFermion,outFermion,spectator,graph,#] &]
 ]

IsDiagramSupported[inFermion_,outFermion_,spectator_,vertexCorrectionGraph,diagram_] :=
  Module[{photonEmitter,exchangeParticle},
    photonEmitter = CXXDiagrams`LorentzConjugate[diagram[[4,3]]]; (* Edge between vertices 4 and 6 (3rd edge of vertex 4) *)
    exchangeParticle = diagram[[4,2]]; (* Edge between vertices 4 and 5 (2nd edge of vertex 4) *)
    
    If[diagram[[6]] =!= {spectator,photonEmitter,CXXDiagrams`LorentzConjugate[photonEmitter]},
       Return["(unknown diagram)"]];
    If[TreeMasses`IsFermion[photonEmitter] && TreeMasses`IsScalar[exchangeParticle],
       Return[True]];
    If[TreeMasses`IsFermion[exchangeParticle] && TreeMasses`IsScalar[photonEmitter],
       Return[True]];
    
    Return[False];
  ]
*)
MuEGammaCreateInterfaceFunctionForLeptonPair[{inFermion_, outFermion_, spectator_}] :=
  Module[
    {prototype, definition, 
     numberOfIndices1 = CXXDiagrams`NumberOfFieldIndices[inFermion],
     numberOfIndices2 = CXXDiagrams`NumberOfFieldIndices[outFermion],
     numberOfIndices3 = CXXDiagrams`NumberOfFieldIndices[spectator]},
   
      prototype =
         "double calculate_" <> CXXNameOfField[inFermion] <> "_to_" <>
            CXXNameOfField[outFermion] <> "_" <> CXXNameOfField[spectator] <> "(" <>
            If[TreeMasses`GetDimension[inFermion] =!= 1,
               " int generationIndex1, ",
               " "
            ] <>
            If[TreeMasses`GetDimension[outFermion] =!= 1,
               " int generationIndex2, ",
               " "
            ] <>
            "const " <> FlexibleSUSY`FSModelName <> "_mass_eigenstates& model);";
                 
                 definition = 
            (* calculate observable using formfactors *)
            "double calculate_" <> CXXNameOfField[inFermion] <> "_to_" <> CXXNameOfField[outFermion] <> "_" <> CXXNameOfField[spectator] <> "(\n" <>
            If[TreeMasses`GetDimension[inFermion] =!= 1, "   int generationIndex1, ", " "] <>
            If[TreeMasses`GetDimension[outFermion] =!= 1, "int generationIndex2, ", " "] <>
            "const " <> FlexibleSUSY`FSModelName <> "_mass_eigenstates& model\n) {\n" <>
            (* choose which observable to compute from form factors *)
            Switch[inFermion && spectator, Fe && VP,
               (* write routine for mu to e gamma *)
               IndentText[
                  FlexibleSUSY`FSModelName <> "_mass_eigenstates model_ = model;\n" <>
                  "EvaluationContext context{ model_ };\n" <>
                  "std::array<int, " <> ToString @ numberOfIndices1 <>
                     "> indices1 = {" <>
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
                    "const auto form_factors = calculate_" <> CXXNameOfField[inFermion] <> "_"
                   <> CXXNameOfField[outFermion] <> "_" <> CXXNameOfField[spectator] <> "_form_factors "<>
                   "(" <> If[TreeMasses`GetDimension[inFermion] =!= 1,
                            " generationIndex1, ",
                            " "] <>
                         If[TreeMasses`GetDimension[outFermion] =!= 1,
                            " generationIndex2, ",
                            " "] <>
                  "model );\n" <>
                  "const auto leptonInMass = context.mass<" <> CXXNameOfField[inFermion] <> ">(indices1);\n" <> 
                  "const double width = pow(leptonInMass,5)/(16.0*Pi) * (std::norm(form_factors[2]) + std::norm(form_factors[3]));\n" <>
                  "return width;\n"
               ], Fd && VP,
               (* write routine for b -> s gamma *)
               IndentText[
                  FlexibleSUSY`FSModelName <> "_mass_eigenstates model_ = model;\n" <>
                  "EvaluationContext context{ model_ };\n" <>
                  "std::array<int, " <> ToString @ numberOfIndices1 <>
                     "> indices1 = {" <>
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
                    "const auto form_factors = calculate_" <> CXXNameOfField[inFermion] <> "_"
                   <> CXXNameOfField[outFermion] <> "_" <> CXXNameOfField[spectator] <> "_form_factors "<>
                   "(" <> If[TreeMasses`GetDimension[inFermion] =!= 1,
                            " generationIndex1, ",
                            " "] <>
                         If[TreeMasses`GetDimension[outFermion] =!= 1,
                            " generationIndex2, ",
                            " "] <>
                  "model );\n" <>
                  "std::valarray<std::complex<double>> c7NP {0.0, 0.0};\n" <>
                  "const double massW = context.mass<VWm>({}); \n" <>
                  "c7NP[0] = -1/(2*unit_charge(context)) * std::complex<double>(form_factors[3]);\n" <>
                  "c7NP[1] = -1/(2*unit_charge(context)) * std::complex<double>(form_factors[2]);\n" <>
                  "return std::real(c7NP[0]);\n"
               ], Fd && VG,
               (* write routine for b -> s gluon *)
               IndentText[
                  FlexibleSUSY`FSModelName <> "_mass_eigenstates model_ = model;\n" <>
                  "EvaluationContext context{ model_ };\n" <>
                  "std::array<int, " <> ToString @ numberOfIndices1 <>
                     "> indices1 = {" <>
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
                    "const auto form_factors = calculate_" <> CXXNameOfField[inFermion] <> "_"
                   <> CXXNameOfField[outFermion] <> "_" <> CXXNameOfField[spectator] <> "_form_factors "<>
                   "(" <> If[TreeMasses`GetDimension[inFermion] =!= 1,
                            " generationIndex1, ",
                            " "] <>
                         If[TreeMasses`GetDimension[outFermion] =!= 1,
                            " generationIndex2, ",
                            " "] <>
                  "model );\n" <>
                  "std::valarray<std::complex<double>> c8NP {0.0, 0.0};\n" <>
                  "const double massW = context.mass<VWm>({}); \n" <>
                  "const double g3 = strong_coupling(context); \n" <>
                  "c8NP[0] = -1/(2*g3) * std::complex<double>(form_factors[3]);\n" <>
                  "c8NP[1] = -1/(2*g3) * std::complex<double>(form_factors[2]);\n" <>
                  "return std::real(c8NP[0]);\n"
               ]
            ] <> "}";
    
    {prototype, definition}
  ];

EndPackage[];
