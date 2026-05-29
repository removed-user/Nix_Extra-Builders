rec {
  # A church encoded `Either a b` is a function of type
  # `(a -> r) -> (b -> r) -> r`,
  # which simply calls the left or right higher order
  # function argument depending on if it's a `Left` or a `Right`
  mkLeft = x: left: right: left x;
  mkRight = x: left: right: right x;

  # An `Applicative` instance can be represented
  # with an explicit dictionary.
  eitherApplicative = {
    pure = mkRight;
    liftA2 = f: x: y: left: right:
      x left (xRight: y left (yRight: right (f xRight yRight)));
  };

  traverseList = applicativeDict: f: xs:
    builtins.foldl'
      (acc: x: applicativeDict.liftA2 (ys: y: ys ++ [y]) acc (f x))
      (applicativeDict.pure [])
      xs;

  fmap = applicativeDict: f: x:
    applicativeDict.liftA2
      (_: y: f y)
      (applicativeDict.pure null)
      x;

  # This example will return `Left x`, where `x` is the first even number
  # Or it will return `Right (sum xs)` if there are no evens.
  example = xs: let
    isEven = x: builtins.bitAnd 1 x == 0;
    sum = builtins.foldl' (acc: x: acc + x) 0;
    odds = traverseList
      eitherApplicative
      (x: if isEven x then mkLeft x else mkRight x)
      xs;
  in fmap eitherApplicative sum odds;
}
