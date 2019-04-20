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

BeginPackage["NPointFunctions`",{"FeynArts`","FormCalc`","Utils`"}];
Utils`AssertWithMessage[
	MemberQ[$Packages, "FeynArts`"],
  "NPointFunctions`: Unable to load FeynArts` package"];
Utils`AssertWithMessage[
	MemberQ[$Packages, "FormCalc`"],
  "NPointFunctions`: Unable to load FormCalc` package"];

SetFAFCPaths::usage="Set the FeynArts and FormCalc paths.";

LoopLevel::usage="An integer option given to NPointFunctionFAFC[] that encodes the \
loop level at which to calculate amplitudes.";
Regularize::usage="An option given to NPointFunctionFAFC[] that encodes the \
regularization scheme to be used.";
DimensionalReduction::usage="A possible value for the Regularize option";
DimensionalRegularization::usage="A possible value for the Regularize option";
ZeroExternalMomenta::usage="An boolean option given to NPointFunctionFAFC[] that \
encodes whether to set the external momenta to zero or leave them undetermined.";
LoopFunctions::usage="Option that controls whether to use FlexibleSUSY or LoopTools for loop functions.";
UseCache::usage="Option to cache and reuse the expressions generated by FeynArts/FormCalc";
ExcludedTopologies::usage="Option to exclude specific topologies in FeynArts";
OneParticleReducible::usage="Possible value for ExcludedTopologies.";
ExceptBoxes::usage="Excude all topologies but box diagrams";
ExceptTriangles::usage="Exclude all topologies but triangle diagrams";
OnShellFlag::usage="Option to use on-shell external fields";

NPointFunctionFAFC::usage="Calculate the n-point correlation function for a set of \
incoming and a set of outgoing fields.";


GenericS::usage="A symbol that acts as a placeholder for any scalar field.";
GenericF::usage="A symbol that acts as a placeholder for any fermion field.";
GenericV::usage="A symbol that acts as a placeholder for any vector field.";
GenericU::usage="A symbol that acts as a placeholder for any ghost field.";
GenericT::usage="A symbol that acts as a placeholder for any tensor field.";

GenericSum::usage="Represent a sum over a set of generic fields.";
GenericIndex::usage="Represent an index of a generic field.";

LorentzIndex::usage="Represent a Lorentz index of a generic field.";
ltIndex::usage="A dummy Lorentz index";

subexpressionToFSRules::usage="A set of rules that aid translation between \
FeynArts and FlexibleSUSY language. They should be applied to subexpressions \
generated by FeynArts.";

Begin["`Private`"];

feynArtsDir = "";
formCalcDir = "";
feynArtsModel = "";
particleNamesFile = "";
substitutionsFile = "";
particleNamespaceFile = "";

(** \brief Set the FeynArts and FormCalc paths.
 * \param feynArtsDirS the directory designated for FeynArts output
 * \param formCalcDirS the directory designated for FormCalc output
 * \param feynArtsModelS the name of the FeynArts model file
 * \param particleNamesFileS the name of the SARAH-generated particle names file
 * \param substitutionsFileS the name of the SARAH-generated substitutions file
 * \param particleNamespaceFileS the name of the particle namespace file
 **)
SetFAFCPaths[feynArtsDirS_String, formCalcDirS_String, feynArtsModelS_String,
           particleNamesFileS_String, substitutionsFileS_String,
           particleNamespaceFileS_String] :=
  (feynArtsDir = feynArtsDirS;
   formCalcDir = formCalcDirS;
   feynArtsModel = feynArtsModelS;
   particleNamesFile = particleNamesFileS;
   substitutionsFile = substitutionsFileS;
   particleNamespaceFile = particleNamespaceFileS;

   SetFSConventionRules[];)

(** \brief Calculate the n-point correlation function for a set of
 * incoming and a set of outgoing fields.
 * \param inFields a list of incoming fields
 * \param outFields a list of outgoing fields
 * \param LoopLevel the loop level at which to perform the calculation
 * \param Regularize the regularization scheme to apply
 * \param UseCache whether to attempt to read and write the result
 * from and to the cache.
 * \param ZeroExternalMomenta whether to set the external momenta to
 * zero or leave them undetermined.
 * \param ExcludedTopologies a list or single symbol of topologies to
 * exclude when calculation the n-point correlation function
 * \returns the corresponding n-point correlation function
 * \note only a loop level of 1 is currently supported
 * \note the recognized regularization schemes are:
 * - DimensionalReduction
 * - DimensionalRegularization
 * \note when not setting the external momenta to zero you should use
 * LoopTools for the evaluation of the loop functions.
 **)
NPointFunctionFAFC[inFields_List,outFields_List,
    OptionsPattern[{LoopLevel -> 1,
                    Regularize -> DimensionalReduction,
                    ZeroExternalMomenta -> False,
                    ExcludedTopologies -> {},
                    OnShellFlag -> False}]]:=
  Module[{loopLevel = OptionValue[LoopLevel],
          regularizationScheme = OptionValue[Regularize],
          zeroExternalMomenta = OptionValue[ZeroExternalMomenta],
          onShellFlag = OptionValue[OnShellFlag],
          excludedTopologies,
          toFeynArtsTopologies,
          topologies, diagrams, amplitudes, genericInsertions,
          colourFactors, fsFields, fsInFields, fsOutFields,
          findColourIndex, externalMomentumRules, nPointFunction},
    toFeynArtsTopologies = {
            NPointFunctions`OneParticleReducible -> FeynArts`Internal,
            NPointFunctions`ExceptTriangles -> FeynArts`Loops[Except[3]],
            NPointFunctions`ExceptBoxes -> FeynArts`Loops[Except[4]]};
    Utils`AssertWithMessage[loopLevel === 1,
			"NPointFunctions`NPointFunctionFAFC[]: Only loop level 1 is supported"];
    Utils`AssertWithMessage[
			regularizationScheme === DimensionalReduction ||
      regularizationScheme === DimensionalRegularization,
			"NPointFunctions`NPointFunctionFAFC[]: Unknown regularization scheme: " <>
			ToString[regularizationScheme]];
    Utils`AssertWithMessage[BooleanQ[zeroExternalMomenta],
			"NPointFunctions`NPointFunctionFAFC[]: Option ZeroExternalMomenta must \
be either True or False"];

    Utils`AssertWithMessage[If[Head[OptionValue[ExcludedTopologies]] === List,
            And @@ (MemberQ[toFeynArtsTopologies[[All,1]], #] & /@ OptionValue[ExcludedTopologies]),
            MemberQ[toFeynArtsTopologies[[All,1]], OptionValue[ExcludedTopologies]]],
        "NPointFunctions`NPointFunctionFAFC[]: Option ExcludedTopologies: "
        <> ToString[OptionValue[ExcludedTopologies]] <> " is not valid."];
    excludedTopologies = OptionValue[ExcludedTopologies] /. toFeynArtsTopologies;
    Utils`AssertWithMessage[BooleanQ[onShellFlag],
        "NPointFunctions`NPointFunctionFAFC[]: Option OnShellFlag must be either \
True or False."];

    If[DirectoryQ[formCalcDir] === False,
       CreateDirectory[formCalcDir]];
    SetDirectory[formCalcDir];

    topologies = FeynArts`CreateTopologies[loopLevel,
      Length[inFields] -> Length[outFields],
      ExcludeTopologies -> excludedTopologies];

    diagrams = FeynArts`InsertFields[topologies,
      inFields -> outFields,
      InsertionLevel -> Classes,
      Model -> feynArtsModel];
    amplitudes = FeynArts`CreateFeynAmp[diagrams];

    (*Remove colour indices*)
    findColourIndex = Position[amplitudes, FeynArts`Index[Global`Colour, index_Integer]];
    amplitudes = Delete[amplitudes, findColourIndex];

    genericInsertions = Flatten[
      GenericInsertionsForDiagram /@ (List @@ diagrams), 1];
    colourFactors = Flatten[
      ColourFactorForDiagram /@ (List @@ diagrams), 1] //.
      fieldNameToFSRules;

    fsInFields = (List @@ Head[amplitudes][[1,2,1,All,1]]) //.
      fieldNameToFSRules;
    fsOutFields = (List @@ Head[amplitudes][[1,2,2,All,1]]) //.
      fieldNameToFSRules;

    fsFields = Join[fsInFields,fsOutFields];

    externalMomentumRules = {
      If[zeroExternalMomenta,
         SARAH`Mom[i_Integer, lorentzIndex_] :> 0,
         SARAH`Mom[i_Integer, lorentzIndex_] :> SARAH`Mom[fsFields[[i]], lorentzIndex]]
    };
    
    nPointFunction = {{fsInFields, fsOutFields},
      Insert[
        CalculateAmplitudes[amplitudes, genericInsertions,
          regularizationScheme, zeroExternalMomenta, OnShellFlag -> onShellFlag] /. externalMomentumRules,
        colourFactors,
        {1, -1}
      ]};
    
    ResetDirectory[];
    nPointFunction
  ]

(** \brief Remove particle indices from a given (possibley generic) field
 * \param field the given field
 * \returns the given field with all indices removed.
 **)
StripParticleIndices[Times[-1,field_]] := Times[-1, StripParticleIndices[field]]
StripParticleIndices[genericType_[classIndex_, ___]] := genericType[classIndex]

FindGenericInsertions[insertions_List,
    OptionsPattern[{KeepFieldNames -> False}]]:=
  Module[{toGenericIndexConventionRules, genericFields, genericInsertions},
    toGenericIndexConventionRules =
      Cases[insertions[[1]], Rule[FeynArts`Field[index_Integer],type_Symbol] :>
        Rule[FeynArts`Field[index], type[FeynArts`Index[Generic,index]]]];

    genericFields = toGenericIndexConventionRules[[All,1]];
    genericInsertions = Cases[#, (Rule[genericField_,classesField_] /;
        MemberQ[genericFields, genericField]) :>
      Rule[genericField, StripParticleIndices[classesField]]] &
      /@ insertions[[2]];

    If[OptionValue[KeepFieldNames],
      List @@ genericInsertions,
      (List @@ genericInsertions) /. toGenericIndexConventionRules
    ]
  ]

GenericInsertionsForDiagram[diagram_Rule,
    OptionsPattern[{KeepFieldNames -> False}]]:=
  List @@ (FindGenericInsertions[#,
    KeepFieldNames -> OptionValue[KeepFieldNames]] & /@ (List @@@ diagram[[2]]))

ColourFactorForDiagram[diagram_Rule]:=
  Module[{numberOfVertices, n, k, externalRules, externalFields,
      adjacencyMatrix, genericInsertions, field},
	  numberOfVertices = Max[Cases[diagram[[1]],
	    FeynArts`Vertex[_][n_Integer] :> n, Infinity]];
	  
	  adjacencyMatrix = Module[{vIndex1 = #},
	    Module[{vIndex2 = #, numberOfConnections},
	      numberOfConnections = Length[Cases[diagram[[1]],
	        FeynArts`Propagator[_][FeynArts`Vertex[_][vIndex1],
	          FeynArts`Vertex[_][vIndex2], _]
	      ]];
	      
	      numberOfConnections + If[vIndex1 === vIndex2,
	        0,
	         Length[Cases[diagram[[1]],
	          FeynArts`Propagator[_][FeynArts`Vertex[_][vIndex2],
	            FeynArts`Vertex[_][vIndex1], _]
	        ]]
	      ]
	    ] & /@ Table[k, {k, numberOfVertices}]
	  ] & /@ Table[k, {k, numberOfVertices}];
	  
    externalRules = Cases[List @@ diagram[[2, 1, 1]],
			HoldPattern[Rule[FeynArts`Field[_Integer], _Symbol[__]]]];
		externalFields = externalRules[[All, 1]];
	  
	  genericDiagram = Module[{vIndex1 = #, vertex},
	    vertex = Module[{vIndex2 = #, propagators},
	      propagators = Cases[diagram[[1]],
	        FeynArts`Propagator[_][FeynArts`Vertex[_][vIndex1],
	          FeynArts`Vertex[_][vIndex2], _] |
	        FeynArts`Propagator[_][FeynArts`Vertex[_][vIndex2],
	          FeynArts`Vertex[_][vIndex1], _]
	      ];
	      
	      Module[{propagator = #, fieldFactor = 1},
	        If[Position[propagator, FeynArts`Vertex[_][vIndex1], {1}] === {{2}},
	          fieldFactor = fieldFactor * -1];
	        If[vIndex1 =!= vIndex2,
	          fieldFactor * propagator[[3]],
	          {-fieldFactor * propagator[[3]], propagator[[3]]}]
	      ] & /@ propagators
      ] & /@ Table[k, {k, numberOfVertices}];
      
      Cases[Flatten[vertex], Except[{}]]
	  ] & /@ Table[k, {k, numberOfVertices}] /. Join[
	    {#} -> # & /@ externalFields,
	    {-#} -> -# & /@ externalFields
	  ];
    
    genericInsertions = GenericInsertionsForDiagram[diagram,
      KeepFieldNames -> True];
    
    Map[CXXDiagrams`ColourFactorForIndexedDiagramFromGraph[
      CXXDiagrams`IndexDiagramFromGraph[
        genericDiagram /. externalRules /. #, adjacencyMatrix],
      adjacencyMatrix] &, genericInsertions, {2}]
  ]

CombinatorialFactorsForAmplitudeInsertions[amplitude_FeynAmp]:=
  Module[{combinatorialPosition},
    combinatorialPosition = Position[amplitude[[-1,1]], FeynArts`RelativeCF][[1,1]];
    (List @@ amplitude[[-1, 2, All, combinatorialPosition]]) /.
      {FeynArts`SumOver[__] -> 1,
       FeynArts`IndexDelta[__] -> 1} (* FIXME: Can we really remove the IndexDelta? *)
  ]

(** \brief Repeatedly evaluate `Head[]` on the argument until it
 * satisfies `AtomQ[]` and return the result.
 * \param x the given argument
 * \returns the result of repeatedly evaluating `Head[]` on the
 * argument until it satisfies `AtomQ[]` and return the result.
 **)
AtomHead[x_] := If[AtomQ[x], x, AtomHead[Head[x]]]

(** \brief Calculate a given set of amplitudes.
 * \param classesAmplitudes A set of class level amplitudes as
 * generated by FeynArts`CreateFeynAmp[]
 * \param genericInsertions the list of generic insertions for the
 * amplitudes
 * \param regularizationScheme the regularization scheme in which to
 * perform the calculation
 * \param zeroExternalMomenta `True` if external momenta should be set
 * to zero and `False` otherwise
 * \returns a list of the format
 * `{fsAmplitudes, subexpressions}`
 * where `fsAmplitudes` denote the calculated amplitudes and 
 * `subexpressions` denote the subexpressions used to simplify the
 * expressions.
 **)
CalculateAmplitudes[classesAmplitudes_, genericInsertions_List,
    regularizationScheme_, zeroExternalMomenta_,
    OptionsPattern[OnShellFlag -> False]] :=
  Module[{genericAmplitudes,calculatedAmplitudes,
          abbreviations,subexpressions,combinatorialFactors,
          prefixRules, dimensionParameter, pairs, zeroedRules, pair,
          onShellFlag = OptionValue[OnShellFlag]},
    combinatorialFactors = CombinatorialFactorsForAmplitudeInsertions /@
      (List @@ classesAmplitudes);
    genericAmplitudes = FeynArts`PickLevel[Generic][classesAmplitudes];

    dimensionParameter = Switch[regularizationScheme,
      DimensionalReduction, 4,
      DimensionalRegularization, D];

    genericAmplitudes = If[zeroExternalMomenta,
      Evaluate @ FormCalc`OffShell[genericAmplitudes, Sequence @@ Table[k -> 0, {k,
        Total[Length /@ Head[genericAmplitudes][[1,2]]]}]],
      genericAmplitudes];

    calculatedAmplitudes =
      (FormCalc`CalcFeynAmp[Head[genericAmplitudes][#],
                            FormCalc`Dimension -> dimensionParameter,
                            FormCalc`OnShell -> onShellFlag,
                            FormCalc`FermionChains -> Chiral,
                            FormCalc`Invariants -> False] & /@
        genericAmplitudes) //. FormCalc`GenericList[];

    calculatedAmplitudes = SumOverAllFieldIndices /@ (List @@ calculatedAmplitudes);

    pairs = If[zeroExternalMomenta,
      Cases[Select[FormCalc`Abbr[],
              StringMatchQ[ToString @ #[[1]], "Pair"~~__] &],
            Rule[_, Pattern[pair, FormCalc`Pair[FormCalc`k[_], FormCalc`k[_]]]] :> pair],
      {}];
    zeroedRules = (Rule[#, 0] & /@ pairs);

    abbreviations = Complement[FormCalc`Abbr[], pairs] //. FormCalc`GenericList[];
    subexpressions = FormCalc`Subexpr[] //. FormCalc`GenericList[];

    {abbreviations, zeroedRules} = RecursivelyZeroRules[abbreviations, zeroedRules];
    {subexpressions, zeroedRules} = RecursivelyZeroRules[subexpressions, zeroedRules];

    calculatedAmplitudes = calculatedAmplitudes /. zeroedRules;

    FCAmplitudesToFSConvention[
        {calculatedAmplitudes, genericInsertions, combinatorialFactors},
      abbreviations, subexpressions]
  ]

(** \brief Given a set of rules that map to zero and a set that does
 * not map to zero, apply the zero rules to the non-zero ones
 * recursively until the non-zero rules do not change anymore.
 * \param nonzeroRules the list of nonzero rules
 * \param zeroRules the list of zero rules
 * \returns a list of rules that map the same expressions as the
 * initial rules. The return value is of the form
 * `{nonzeroRules, zeroRules}`
 * where the nonzero rules do not map to zero even if one applies
 * the zero rules to the mapped expressions.
 **)
RecursivelyZeroRules[nonzeroRules_List, zeroRules_List] :=
  Module[{nextNonzero, nextZero},
    nextNonzero = Rule @@@ Transpose[
      {nonzeroRules[[All,1]], nonzeroRules[[All,2]] /. zeroRules}];

    If[nextNonzero === nonzeroRules,
       Return[{nonzeroRules, zeroRules}]];

    nextZero = Join[zeroRules, Cases[nextNonzero, HoldPattern[Rule[_, 0]]]];
    nextNonzero = Complement[nextNonzero, nextZero];

    RecursivelyZeroRules[nextNonzero, nextZero]
  ]

(** \brief Given a generic amplitude, determine the generic fields
 * over which it needs to be summed and return a corresponding
 * GenericSum[] object.
 * \param genericAmplitude the given generic amplitude
 * \returns `GenericSum[genericAmplitude[[1]], genericIndices]`
 * where `genericindices` is replaced with the appropriate generic
 * indices.
 **)
SumOverAllFieldIndices[genericAmplitude_] :=
  Module[{genericIndices, fieldType, genericRules},
    Utils`AssertWithMessage[Length[genericAmplitude] === 1,
      "NPointFunctions`SumOverAllFieldIndices[]: \
Length of generic amplitude != 1 not implemented (incompatible FormCalc change?)"];

    genericIndices = DeleteDuplicates[
      Cases[List @@ genericAmplitude,
            Pattern[fieldType,Alternatives[
							FeynArts`S, FeynArts`F, FeynArts`V, FeynArts`U, FeynArts`T]][
								FeynArts`Index[Generic,number_Integer]] :> {fieldType,number},
						Infinity]];
    GenericSum[genericAmplitude[[1]], genericIndices]
  ]

(** \brief Tranlate a list of FormCalc amplitudes and their
 * abbreviations and subexpressions into FlexibleSUSY language.
 * \param amplitudes the given list of amplitudes
 * \param abbreviations the generated list of abbreviations
 * \param aubexpressions the generated list of subexpressions
 * \returns a list of the form
 * `{fsAmplitudes, Join[fsAbbreviations,fsSubexpressions]}`
 * where all FlexibleSUSY conventions have been applied.
 **)
FCAmplitudesToFSConvention[amplitudes_, abbreviations_, subexpressions_] :=
  Module[{fsAmplitudes, fsAbbreviations, fsSubexpressions},
    fsAmplitudes = amplitudes //. amplitudeToFSRules;
    fsAbbreviations = abbreviations //. subexpressionToFSRules;
    fsSubexpressions = subexpressions //. subexpressionToFSRules;

    {fsAmplitudes, Join[fsAbbreviations,fsSubexpressions]}
  ]

subexpressionToFSRules = {};

(** \brief Set the translation rules from FeynArts/FormCalc
 * to FlexibleSUSY language
 *)
SetFSConventionRules[] :=
  Module[{lines, indexRules, field, ltIndex,
          fieldsHandle, fieldContents, fieldNames, massRules,
          fieldNamespaces, couplingRules, generalFCRules, fieldType, diracChainRules},
    lines = Utils`ReadLinesInFile[particleNamesFile];

    fieldNames = Cases[lines,
                       line_String /; (Length[StringSplit[line,": "]] == 2) :> 
                         StringSplit[line,": "]];
    fieldNamespaces = Get[particleNamespaceFile];
    
    fieldNames = 
      {Cases[fieldNamespaces, {#[[1]], _}][[1,2]] <>
       #[[1]], #[[2]]} & /@ fieldNames;
       
    massRules = Join[
      (Symbol["Mass" <> ToString[ToSymbol[#]]][indices_] :>
       SARAH`Mass[ToExpression[#][{Symbol["SARAH`gt" <> StringTake[SymbolName[indices], -1]]}]]) & /@ fieldNames[[All,1]],
      (Symbol["Mass" <> ToString[ToSymbol[#]]][indices__] :>
       SARAH`Mass[ToExpression[#][{indices}]]) & /@ fieldNames[[All,1]],
      (Symbol["Mass" <> ToString[ToSymbol[#]]] ->
       SARAH`Mass[ToExpression[#]]) & /@ fieldNames[[All,1]],
      {FeynArts`Mass[field_,faSpec_ : Null] :> SARAH`Mass[field]}
    ];

    couplingRules = {
        FeynArts`G[_][0][fields__][1] :> SARAH`Cp[fields][1],
        FeynArts`G[_][0][fields__][1] :> SARAH`Cp[fields][1],
        FeynArts`G[_][0][fields__][
            FeynArts`NonCommutative[Global`ChiralityProjector[-1]]] :>
          SARAH`Cp[fields][SARAH`PL],
        FeynArts`G[_][0][fields__][
            FeynArts`NonCommutative[Global`ChiralityProjector[1]]] :>
          SARAH`Cp[fields][SARAH`PR],
        FeynArts`G[_][0][fields__][
            FeynArts`NonCommutative[Global`DiracMatrix[FeynArts`KI1[3]],Global`ChiralityProjector[-1]]] :>
          SARAH`Cp[fields][SARAH`PL],
        FeynArts`G[_][0][fields__][
            FeynArts`NonCommutative[Global`DiracMatrix[FeynArts`KI1[3]],Global`ChiralityProjector[1]]] :>
          SARAH`Cp[fields][SARAH`PR],
        FeynArts`G[_][0][fields__][
            Global`MetricTensor[KI1[i1_Integer],KI1[i2_Integer]]] :>
          SARAH`Cp[fields][SARAH`g[LorentzIndex[{fields}[[i1]]],
                                   LorentzIndex[{fields}[[i2]]]]],
        FeynArts`G[_][0][fields__][
            FeynArts`Mom[i1_Integer] - FeynArts`Mom[i2_Integer]] :>
          SARAH`Cp[fields][SARAH`Mom[{fields}[[i1]]] - SARAH`Mom[{fields}[[i2]]]],
        (*Since FormCalc-9.7*)
        FeynArts`G[_][0][fields__][Global`FourVector[
            FeynArts`Mom[i1_Integer] - FeynArts`Mom[i2_Integer], FeynArts`KI1[3]]] :>
          SARAH`Cp[fields][SARAH`Mom[{fields}[[i1]]] - SARAH`Mom[{fields}[[i2]]]],
        (*VVV couplings*)
        FeynArts`G[_][0][fields__][
             Global`FourVector[-FeynArts`Mom[i1_Integer] + FeynArts`Mom[i2_Integer], FeynArts`KI1[i3_Integer]]*
               Global`MetricTensor[FeynArts`KI1[i1_Integer], FeynArts`KI1[i2_Integer]] +
              Global`FourVector[FeynArts`Mom[i1_Integer] - FeynArts`Mom[i3_Integer], FeynArts`KI1[i2_Integer]]*
               Global`MetricTensor[FeynArts`KI1[i1_Integer], FeynArts`KI1[i3_Integer]] +
              Global`FourVector[-FeynArts`Mom[i2_Integer] + FeynArts`Mom[i3_Integer], FeynArts`KI1[i1_Integer]]*
               Global`MetricTensor[FeynArts`KI1[i2_Integer], FeynArts`KI1[i3_Integer]]] :>
          SARAH`Cp[fields][(SARAH`Mom[{fields}[[i2]], LorentzIndex[{fields}[[i3]]]] - SARAH`Mom[{fields}[[i1]], LorentzIndex[{fields}[[i3]]]]) *
            SARAH`g[LorentzIndex[{fields}[[i1]]], LorentzIndex[{fields}[[i2]]]], (SARAH`Mom[{fields}[[i1]], LorentzIndex[{fields}[[i2]]]] - SARAH`Mom[{fields}[[i3]], LorentzIndex[{fields}[[i2]]]]) *
            SARAH`g[LorentzIndex[{fields}[[i1]]], LorentzIndex[{fields}[[i3]]]], (SARAH`Mom[{fields}[[i3]], LorentzIndex[{fields}[[i1]]]] - SARAH`Mom[{fields}[[i2]], LorentzIndex[{fields}[[i1]]]]) *
            SARAH`g[LorentzIndex[{fields}[[i2]]], LorentzIndex[{fields}[[i3]]]]
          ]

    };

    ltIndex = Unique["lt"];
    generalFCRules = {
        FormCalc`Finite -> 1,
        FormCalc`Den[a_,b_] :> 1/(a - b),
        FormCalc`Pair[a_,b_] :> SARAH`sum[ltIndex, 1, 4,
          SARAH`g[ltIndex, ltIndex] * Append[a, ltIndex] * Append[b, ltIndex]],
        Pattern[fieldType,Alternatives[FeynArts`S, FeynArts`F,
					FeynArts`V, FeynArts`U, FeynArts`T]][
          FeynArts`Index[Generic,number_Integer]] :>  
            fieldType[GenericIndex[number]],
        FormCalc`k[i_Integer, index___] :> SARAH`Mom[i, index]
    };

    (* These index rules are specific to SARAH generated FeynArts
     * model files. Are these index rules always injective?
     *)
    indexRules = {
      FeynArts`Index[generationName_, index_Integer] :> 
				Symbol["SARAH`gt" <> ToString[index]] /;
				StringMatchQ[SymbolName[generationName], "I"~~___~~"Gen"],
      FeynArts`Index[Global`Colour, index_Integer] :>
                Symbol["SARAH`ct" <> ToString[index]],
      FeynArts`Index[Global`Gluon, index_Integer] :> 
				Symbol["SARAH`ct" <> ToString[index]]
    };

    fieldNameToFSRules = Join[
      Rule @@@ Transpose[
        {Append[#,{indices___}] & /@ (ToExpression /@ fieldNames[[All,2]]),
         Through[(ToExpression /@ fieldNames[[All,1]])[{indices}]]}],
      Rule @@@ Transpose[
        {ToExpression /@ fieldNames[[All,2]], ToExpression /@ fieldNames[[All,1]]}],
      {FeynArts`S -> GenericS, FeynArts`F -> GenericF, FeynArts`V -> GenericV,
       FeynArts`U -> GenericU, FeynArts`T -> GenericT},
      {
        Times[-1, field_GenericS | field_GenericV] :>
           Susyno`LieGroups`conj[field],
        Times[-1, field_GenericF | field_GenericU] :>
           SARAH`bar[field]
      },
      (Times[-1, Pattern[field, # | Blank[#]]] :> 
           CXXDiagrams`LorentzConjugate[field]) & /@
         (ToExpression /@ fieldNames[[All,1]]),
      indexRules
    ];

    (*These symbols cause an overshadowing with Susyno`LieGroups*)
    diracChainRules = (Symbol["F" <> ToString[#]] :> Unique[diracChain] & /@ Range[Length[fieldNames]]);

    subexpressionToFSRules = Join[
      massRules,
      fieldNameToFSRules,
      couplingRules,
      generalFCRules,
      diracChainRules
    ];
    amplitudeToFSRules = Join[
      subexpressionToFSRules,
      sumOverRules,
      {FeynArts`IndexSum -> Sum}
    ];
  ]

(** \brief A set of rules that translate FeynArts sums to SARAH sums **)
sumOverRules = {
  FeynArts`SumOver[_,_,FeynArts`External] :> Sequence[],
  Times[expr_,FeynArts`SumOver[index_,max_Integer]]
    :> SARAH`sum[index,1,max,expr],
  Times[expr_,FeynArts`SumOver[index_,{min_Integer,max_Integer}]]
    :> SARAH`sum[index,min,max,expr],
  SARAH`sum[index_,min_Integer,max_Integer,FeynArts`SumOver[_,max2_Integer]]
    :> SARAH`sum[index,1,max,max2],
  SARAH`sum[index_,min_Integer,max_Integer,
      FeynArts`SumOver[_,{min2_Integer,max2_Integer}]]
    :> SARAH`sum[index,1,max,max2-min2]
};

End[];
EndPackage[];
