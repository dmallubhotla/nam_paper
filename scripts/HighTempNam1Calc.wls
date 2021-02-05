Needs["ewjnNoise`"];

calcDirectory = FileNameJoin[{
	ParentDirectory[
		DirectoryName[
			FileNameJoin[{
				Directory[],
				$ScriptCommandLine[[1]]
			}]
		]
	], "calc"
}];

calc[filename_] := FileNameJoin[{calcDirectory, filename}];

Print[calc["HighTempNam1.csv"]]
rangespec = {zi, -9, -6, .1};
constants = namEwjnConstants;

(* Derived this in NB file, testing code *)
cutoff = 5.7860963238968725`*^9;

params1 = AssociateTo[namEwjnPbBasicParameters, {"TRel" -> .9, "omegaSI" -> 10^10}];

dataNam1 = ParallelTable[{10^zi, T1EzzNam[10^zi, cutoff, params1, constants]}, rangespec, DistributedContexts -> All];
dataLindhard1 = ParallelTable[{10^zi, T1EzzLin[10^zi, params1, constants]}, rangespec, DistributedContexts -> All];

params2 = AssociateTo[params1, "TRel" -> .995];

dataNam2 = ParallelTable[{10^zi, T1EzzNam[10^zi, cutoff, params2, constants]}, rangespec, DistributedContexts -> All];
dataLindhard2 = ParallelTable[{10^zi, T1EzzLin[10^zi, params2, constants]}, rangespec, DistributedContexts -> All];

params3 = AssociateTo[params2, "TRel" -> .9995];

dataNam3 = ParallelTable[{10^zi, T1EzzNam[10^zi, cutoff, params3, constants]}, rangespec, DistributedContexts -> All];
dataLindhard3 = ParallelTable[{10^zi, T1EzzLin[10^zi, params3, constants]}, rangespec, DistributedContexts -> All];

data = {dataNam1, dataLindhard1, dataNam2, dataLindhard2, dataNam3, dataLindhard3};
Print[data];
Export[calc["HighTempNam1.csv"], data];
