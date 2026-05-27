{ lib, ... }:
let
  /**
    Evaluates a worker function with the provided input data and stores the result
    under a dynamically named key in an attribute set.

    # Type
    ```
    evaluateAndStore :: String -> (AttrSet -> AttrSet) -> AttrSet -> AttrSet
    ```

    # Arguments
    - [name] The attribute name (string) under which the result will be stored.
    - [workerFunction] A function that accepts an attribute set and returns an attribute set.
    - [inputData] The seed metadata attribute set to pass to the worker function.

    # Example
    ```nix
    evaluateAndStore "myBuilder" (meta: { out = meta.val; }) { val = 42; }
    => { myBuilder = { out = 42; }; }
    ```
  */
  evaluateAndStore = name: workerFunction: inputData:
    # 1. Type check the 'name' argument
    assert lib.assertMsg (lib.isString name) 
      "evaluateAndStore: The 'name' argument must be a string, but got a ${builtins.typeOf name}.";

    # 2. Type check the 'workerFunction' argument
    assert lib.assertMsg (lib.isFunction workerFunction) 
      "evaluateAndStore: The 'workerFunction' argument must be a function, but got a ${builtins.typeOf workerFunction}.";

    # 3. Type check the 'inputData' argument
    assert lib.assertMsg (lib.isAttrs inputData) 
      "evaluateAndStore: The 'inputData' argument must be an attribute set, but got a ${builtins.typeOf inputData}.";

    let
      # Execute the function immediately
      evaluationResult = workerFunction inputData;
    in
      # 4. Optional Type check on the worker's output to catch errors early
      assert lib.assertMsg (lib.isAttrs evaluationResult)
        "evaluateAndStore: The workerFunction failed to return an attribute set. Got a ${builtins.typeOf evaluationResult}.";

      {
  # 1. Metadata about the evaluation type
  type = builtins.typeOf evaluationResult;

  # 2. Traceability: Exactly what was given to the evaluator
  inputs = {
    targetName = name;
    seedData = inputData;
  };

  # 3. The payload: Stored under the dynamic %{name}
  results = {
    "${name}" = evaluationResult;
  };
}

in {
  # Add to scope
  inherit evaluateAndStore;
}
