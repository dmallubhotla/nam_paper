(* Populates the figures directory as ../calc *)
calculatedDirectory = FileNameJoin[{
	ParentDirectory[
		DirectoryName[
			FileNameJoin[{
				Directory[],
				$ScriptCommandLine[[1]]
			}]
		]
	], "calc"
}];

calc[filename_] := FileNameJoin[{calculatedDirectory, filename}];

(* Populates the figures directory as ../figures *)
figuresDirectory = FileNameJoin[{
	ParentDirectory[
		DirectoryName[
			FileNameJoin[{
				Directory[],
				$ScriptCommandLine[[1]]
			}]
		]
	], "figures"
}];

figure[filename_] := FileNameJoin[{figuresDirectory, filename}];

(* 0.299792458 meters = 1 wavelength, and z is in units of wavelengths*)

label = AxesLabel -> {"z (\[Mu]m)", "T (nanosecond)"};
data = ToExpression[Import[calc["HighTempNam1.csv"]]];
scaledData = Map[{0.299792458 * 10^6 * #[[1]], 10^9 * #[[2]]} &, data, {2}];
plot1 = ListLogLogPlot[scaledData, ImageSize->Large, label, PlotLegends -> {"Nam .9", "Lindhard .9", "Nam .995", "Lindhard .995", "Nam .9995", "Lindhard .9995"}, Joined -> True, ImagePadding -> {{50, Automatic}, {Automatic, Automatic}}];
Export[figure["HighTempNam1.jpg"], plot1, ImageResolution -> 1200];
