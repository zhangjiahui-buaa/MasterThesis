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

/// A mutator that generates new code at random positions in a program.
public class MethodInvocator: BaseInstructionMutator {
    private var deadCodeAnalyzer = DeadCodeAnalyzer()
    private var variableAnalyzer = VariableAnalyzer()
    private let minVisibleVariables = 3

    public init() {
        super.init(maxSimultaneousMutations: defaultMaxSimultaneousMutations)
    }

    public override func beginMutation(of program: Program) {
        deadCodeAnalyzer = DeadCodeAnalyzer()
        variableAnalyzer = VariableAnalyzer()
    }

    public override func canMutate(_ instr: Instruction) -> Bool {
        deadCodeAnalyzer.analyze(instr)
        variableAnalyzer.analyze(instr)
        // We can only generate code if there are some visible variables to use, and it only
        // makes sense to generate code if we're not currently in dead code.
        return variableAnalyzer.visibleVariables.count >= minVisibleVariables && !deadCodeAnalyzer.currentlyInDeadCode
    }

    public override func mutate(_ instr: Instruction, _ b: ProgramBuilder) {
        if(b.context == Context.javascript && instr.isSimple){
            b.trace("Method Invocator")
            // create method
            let randomFunction = b.randomVariable(ofType: .function())
            let f = randomFunction != nil && probability(0.5) ? randomFunction : 
                b.buildPlainFunction(with: b.randomParameters(), isStrict: probability(0.1)) { _ in
                    b.build(n:30)
                    b.doReturn(b.randomVariable())
                }
            // compute loop variable
            let visVar = b.randomVariable(ofType: .integer)
            let loopVar: Variable
            if(visVar != nil){
                var tmp = b.loadInt(Int64.random(in: 100...500))
                let condition = b.compare(tmp, with: visVar!, using: Comparator.greaterThan)
                loopVar = b.ternary(condition, tmp, visVar!)
            }else{
                loopVar = b.loadInt(Int64.random(in: 100...500))
            }

            // call method like this
            // for(...){
            //    f()
            // }
            // f()
            // random instr
            // for(...){
            //    f()
            //}
            b.buildForLoop(i: { b.loadInt(0) }, { i in b.compare(i, with: loopVar, using: .lessThan) }, { i in b.unary(.PostInc, i) }) { _ in
                b.build(n:buildSizeForJIT)
                b.callFunction(f!, withArgs: b.randomArguments(forCalling: f!))
                b.build(n:buildSizeForJIT)
            }
            b.callFunction(f!, withArgs: b.randomArguments(forCalling: f!))
            
            // trigger recompilation
            b.build(n:defaultCodeGenerationAmount)
            b.buildForLoop(i: { b.loadInt(0) }, { i in b.compare(i, with: loopVar, using: .lessThan) }, { i in b.unary(.PostInc, i) }) { _ in
                b.callFunction(f!, withArgs: b.randomArguments(forCalling: f!))
            } 
            //b.dumpCurrentProgram()
        }
        b.adopt(instr)
        //assert(b.numberOfVisibleVariables >= minVisibleVariables)
        //b.build(n: defaultCodeGenerationAmount, by: .generating)
    }
}

