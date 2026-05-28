let
  /*
  A collection of named destination routes.
  Each attribute represents a valid target function that processes a formatted message.
  */
  routerRegistry = {
    routeToServiceA = message: "Dispatched to Service A: ${message}";
    routeToServiceB = message: "Dispatched to Service B: ${message}";
  };

  /*
  Creates a higher-order router function that dynamically dispatches 
  a processed message to a named route.

  Type:
    createRouter :: AttrSet -> (a -> String) -> String -> a -> String

  Args:
    registry: An attribute set mapping route names to destination functions.
    transformMessage: A function that takes raw input and prepares the final message payload.
    destinationName: The string key of the target route inside the registry.
    rawInput: The initial data payload to be processed and routed.

  Returns:
    The output of the resolved destination function.
  */
  createRouter = registry: transformMessage: destinationName: rawInput:
    let
      # Dynamically resolve the destination function, failing fast if missing
      targetRoute = registry."${destinationName}" or (throw "Error: Route '${destinationName}' not found");
      
      # Transform the raw payload into its final message format
      finalMessage = transformMessage rawInput;
    in
    # Execute the resolved target route with the final message
    targetRoute finalMessage;

  /*
  A generic message transformer function.
  Converts a raw data attribute set into a standard string payload.

  Type:
    formatMessage :: AttrSet -> String
  */
  formatMessage = input: "ID_${toString input.id}_payload";

  /*
  A partially applied instance of createRouter.
  By locking in the registry and the formatting function, this becomes a 
  specialized utility waiting only for a destination name and raw input.
  */
  initiateRoute = createRouter routerRegistry formatMessage;

in
# === Example Execution ===
let
  # Fully curried edge functions for specific destinations
  dispatchToA = initiateRoute "routeToServiceA";
  dispatchToB = initiateRoute "routeToServiceB";
in
[
  # Example 1: Route to Service A
  (dispatchToA { id = 555; }) # Evaluates to: "Dispatched to Service A: ID_555_payload"
  
  # Example 2: Route to Service B
  (dispatchToB { id = 777; }) # Evaluates to: "Dispatched to Service B: ID_777_payload"
]
