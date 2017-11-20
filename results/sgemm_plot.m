thisDirectory = If[TrueQ[StringQ[$InputFileName] && $InputFileName =!= "" && FileExistsQ[$InputFileName]],
  DirectoryName[$InputFileName],
  Directory[]
];

$rawDataFiles = <|
  "Minsky" -> <|
    "SMTAll" -> FileNameJoin[{thisDirectory, "raw_data", "minsky", "with_smt.json"}],
    (*"SMT16" -> FileNameJoin[{thisDirectory, "raw_data", "minsky", "with_smt_16.json"}],*)
    "NoSMTAll" -> FileNameJoin[{thisDirectory, "raw_data", "minsky", "without_smt.json"}]
    (*"NoSMT8" -> FileNameJoin[{thisDirectory, "raw_data", "minsky", "without_smt_8.json"}],*)
    (*"NoSMT16" -> FileNameJoin[{thisDirectory, "raw_data", "minsky", "without_smt_16.json"}]*)
  |>,
  "Whatever" -> <|
    "SMTAll" -> FileNameJoin[{thisDirectory, "raw_data", "whatever", "with_smt.json"}],
    "NoSMTAll" -> FileNameJoin[{thisDirectory, "raw_data", "whatever", "without_smt.json"}]
  |>
|>;

$rawMinskyDataFiles = $rawDataFiles["Minsky"];
$rawWhateverDataFiles = $rawDataFiles["Whatever"];

$machine = "Minsky";
$rawMachineDataFiles = $rawDataFiles[$machine];

data = Table[
  rawDataFile = $rawMachineDataFiles[key];
  Module[{info},
    info = Import[rawDataFile, "RAWJSON"];
    info["benchmarks"] = Append[#, "key" -> key]& /@ info["benchmarks"];
    Append[info, "name" -> key]
  ]
  ,
  {key, Keys[$rawMachineDataFiles]}
];

groupedData = GroupBy[
  Flatten[Lookup[data, "benchmarks"]],
  Lookup[{"K", "M", "N"}]
];

makeChart[data_] := BarChart[
  Association[
    SortBy[
      KeyValueMap[
        Function[{key, val},
          key -> AssociationThread[Lookup[val, "key"] -> Lookup[val, "cpu_time"] / 10^6]
        ],
        data
      ],
      Fold[Times, 1, First[#]] &
    ]
  ],
  ChartLabels -> {Placed[Keys[data], Automatic, Rotate[#, 90 Degree] &], None},
  ChartLegends -> Automatic,
  BarSpacing -> {Automatic, 1},
  PlotTheme -> "Grid",
  ScalingFunctions -> "Log"
];

Export[$machine <> "_plot.png", makeChart[Take[groupedData, UpTo[10]]], ImageSize->600]