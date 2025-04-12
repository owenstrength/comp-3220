with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
with Ada.Integer_Text_IO;

package body Assgn is
   -- Set up a generator for random binary digits
   package Random_Binary is new Ada.Numerics.Discrete_Random(BINARY_NUMBER);
   Gen : Random_Binary.Generator;

   -- Initialize binary array with random values
   procedure Init_Array (Arr: in out BINARY_ARRAY) is
   begin
      Random_Binary.Reset(Gen); -- Initialize the random generator
      for I in Arr'Range loop
         Arr(I) := Random_Binary.Random(Gen);
      end loop;
   end Init_Array;

   -- Print a binary array
   procedure Print_Bin_Arr (Arr : in BINARY_ARRAY) is
   begin
      for I in Arr'Range loop
         Ada.Integer_Text_IO.Put(Arr(I), 1);
      end loop;
      Ada.Text_IO.New_Line;
   end Print_Bin_Arr;

   -- Reverse a binary array
   procedure Reverse_Bin_Arr (Arr : in out BINARY_ARRAY) is
      Temp : BINARY_NUMBER;
   begin
      for I in 1 .. Arr'Length/2 loop
         Temp := Arr(I);
         Arr(I) := Arr(Arr'Last - I + 1);
         Arr(Arr'Last - I + 1) := Temp;
      end loop;
   end Reverse_Bin_Arr;

   -- Convert Integer to Binary Array
   function Int_To_Bin(Num : in INTEGER) return BINARY_ARRAY is
      Result : BINARY_ARRAY := (others => 0);
      Temp   : INTEGER := Num;
   begin
      -- Convert decimal to binary by division and remainder
      for I in reverse Result'Range loop
         Result(I) := Temp mod 2;
         Temp := Temp / 2;
         exit when Temp = 0;
      end loop;
      
      return Result;
   end Int_To_Bin;

   -- Convert Binary Array to Integer
   function Bin_To_Int (Arr : in BINARY_ARRAY) return INTEGER is
      Result : INTEGER := 0;
      Power  : INTEGER := 1;
   begin
      -- Convert binary to decimal using powers of 2
      for I in reverse Arr'Range loop
         Result := Result + (Arr(I) * Power);
         Power := Power * 2;
      end loop;
      
      return Result;
   end Bin_To_Int;

   -- Binary addition helper function
   function Binary_Add(Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
      Result : BINARY_ARRAY := (others => 0);
      Carry  : BINARY_NUMBER := 0;
      Sum    : INTEGER;
   begin
      for I in reverse Result'Range loop
         Sum := Left(I) + Right(I) + Carry;
         
         case Sum is
            when 0 =>
               Result(I) := 0;
               Carry := 0;
            when 1 =>
               Result(I) := 1;
               Carry := 0;
            when 2 =>
               Result(I) := 0;
               Carry := 1;
            when 3 =>
               Result(I) := 1;
               Carry := 1;
            when others =>
               null; -- This shouldn't happen with binary digits
         end case;
      end loop;
      
      -- Note: If there's a final carry, we're ignoring it (potential overflow)
      return Result;
   end Binary_Add;

   -- Binary subtraction helper function
   function Binary_Sub(Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
      Result    : BINARY_ARRAY := (others => 0);
      Borrow    : BINARY_NUMBER := 0;
      Diff      : INTEGER;
   begin
      for I in reverse Result'Range loop
         Diff := Left(I) - Right(I) - Borrow;
         
         case Diff is
            when 0 =>
               Result(I) := 0;
               Borrow := 0;
            when 1 =>
               Result(I) := 1;
               Borrow := 0;
            when -1 =>
               Result(I) := 1;
               Borrow := 1;
            when -2 =>
               Result(I) := 0;
               Borrow := 1;
            when others =>
               null; -- This shouldn't happen with binary digits
         end case;
      end loop;
      
      -- Note: If there's a final borrow, the result is negative,
      -- but we're returning the magnitude only
      return Result;
   end Binary_Sub;

   -- Overloaded + operator for two binary arrays
   function "+" (Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
   begin
      return Binary_Add(Left, Right);
   end "+";

   -- Overloaded + operator for integer and binary array
   function "+" (Left : in INTEGER;
                 Right : in BINARY_ARRAY) return BINARY_ARRAY is
   begin
      return Binary_Add(Int_To_Bin(Left), Right);
   end "+";

   -- Overloaded - operator for two binary arrays
   function "-" (Left, Right : in BINARY_ARRAY) return BINARY_ARRAY is
   begin
      return Binary_Sub(Left, Right);
   end "-";

   -- Overloaded - operator for integer and binary array
   function "-" (Left : in INTEGER;
                 Right : in BINARY_ARRAY) return BINARY_ARRAY is
   begin
      return Binary_Sub(Int_To_Bin(Left), Right);
   end "-";

end Assgn;