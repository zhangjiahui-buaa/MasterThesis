// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Fuzzilli

let chakraProfile = Profile(
    /*getProcessArguments: { (randomizingArguments: Bool) -> [String] in
        var args = [
            "--maxinterpretcount=10",
            // No need to call functions thousands of times before they are JIT compiled
            "--maxsimplejitruncount=100",
            "--bgjit",
            "--oopjit",
            "--reprl",
            "fuzzcode.js"]

        return args
    },*/
  processArgs: { randomize in
        ["--reprl"]
    },
    processEnv: ["UBSAN_OPTIONS":"handle_segv=0"],

    maxExecsBeforeRespawn: 1000,

    timeout: 250,
    codePrefix: """
                """,

    codeSuffix: """
                """,
	ecmaVersion: ECMAScriptVersion.es6,
    startupTests: [
        // Check that the fuzzilli integration is available.
        ("fuzzilli('FUZZILLI_PRINT', 'test')", .shouldSucceed),

        // Check that common crash types are detected.
        ("fuzzilli('FUZZILLI_CRASH', 0)", .shouldCrash),
        ("fuzzilli('FUZZILLI_CRASH', 1)", .shouldCrash),
    ],
    additionalCodeGenerators: [],

    additionalProgramTemplates: WeightedList<ProgramTemplate>([]),

    disabledCodeGenerators: [],
    disabledMutators: [],
    additionalBuiltins: [
        "CollectGarbage"            : .function([] => .undefined),
    ],
    additionalObjectGroups: [],

    optionalPostProcessor: nil

)