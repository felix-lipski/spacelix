{ lib, ... }:
rec {
  compose = f: g: x: f(g x);
  
  # pow 2 3 -> 8
  pow = x: y: lib.lists.foldr (a: b: a * b) 1 (builtins.genList (z: x) y);
  
  # sum [1 2 3] -> 6
  sum = lib.lists.foldr (a: b: a + b) 0;
  
  concatLines = lib.lists.foldr (a: b: a + "\n" + b) "";

  # floatToInt 3.14 -> 3
  floatToInt = x: lib.strings.toInt (builtins.elemAt (builtins.split "[.]" (builtins.toString x)) 0);

  # justr "foo" 5 "a" -> "aafoo"
  justr = (leng: char: str:
    (lib.lists.foldr (a: b: a + b) "" (builtins.genList (x: char) (leng - builtins.stringLength str)) + str)
  );

  # hexToInt "c5" -> 197
  hexToInt = (str: 
    let
      hexMap = builtins.listToAttrs (map (x: {name = builtins.toString x; value = x;}) (lib.lists.range 0 9)) // {
        "a"=10;"b"=11;"c"=12;"d"=13;"e"=14;"f"=15;};
      list = lib.lists.reverseList (lib.strings.stringToCharacters str);
    in 
    sum (builtins.genList 
      (ind: (pow 16 ind) * 
        hexMap."${ builtins.elemAt list ind }")
      (builtins.length list)
    )
  );

  # hexStrToRGB "#1234ff" -> [ 18 52 255 ]
  hexStrToRGB = (str:
    let
      at = builtins.elemAt (lib.lists.reverseList (lib.strings.stringToCharacters str));
    in
    map hexToInt [(at 5 + at 4) (at 3 + at 2) (at 1 + at 0)]
  );

  # RGBToHexStr [ 18 52 255 ] -> "#1234ff"
  RGBToHexStr = (rgb:
    "#" + lib.lists.foldr (a: b: a + b) "" (map (compose (justr 2 "0") lib.trivial.toHexString) rgb)
  );

  # lightenRGB 0.5 [0 0 0] -> [127 127 127]
  lightenRGB = (coeff: rgb:
    let
      rgb' = map (x: x + 1) rgb;
      max = lib.lists.foldr (a: b: if a > b then a else b) 0 rgb';
      remain = 256 - max;
      addToMax = coeff * remain;
      ratio = addToMax / max;
    in
    map (x: -1 + floatToInt (x * (1.0 + ratio))) rgb'
  );
  
  # darkenRGB 0.5 [50 40 30] -> [25 20 15]
  darkenRGB = (coeff: rgb:
    let
      rgb' = map (x: x + 1) rgb;
    in
    map (x: floatToInt (x * (1.0 - coeff))) rgb'
  );

  hexMap = (func: hex:
    RGBToHexStr (func (hexStrToRGB hex))
  );

  lightenHex = coeff: hexMap (lightenRGB coeff);

  darkenHex = coeff: hexMap (darkenRGB coeff);
  
  # replaces the "#x" in string with the vallue of the x attribute of the palette
  interpolateColors = (palette: builtins.replaceStrings 
    (map (x: "#" + x) (builtins.attrNames palette))
    (builtins.attrValues palette)
  );
}
