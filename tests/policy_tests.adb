--
--  Copyright (c) 2009,
--  Reto Buerki, Adrian-Ken Rueegsegger
--
--  This file is part of Alog.
--
--  Alog is free software; you can redistribute it and/or modify
--  it under the terms of the GNU Lesser General Public License as published
--  by the Free Software Foundation; either version 2.1 of the License, or
--  (at your option) any later version.
--
--  Alog is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Lesser General Public License for more details.
--
--  You should have received a copy of the GNU Lesser General Public License
--  along with Alog; if not, write to the Free Software
--  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
--  MA  02110-1301  USA
--

with Ahven;

with Alog.Dst_Filter;
with Alog.Maps;
with Alog.Policy_DB;

package body Policy_Tests is

   use Ahven;
   use Alog;

   package DF renames Alog.Dst_Filter;

   -------------------------------------------------------------------------

   procedure Default_Loglevel_Handling is
      Before    : constant Log_Level := DF.Get_Default_Level;
      New_Level : constant Log_Level := Critical;
   begin
      DF.Set_Default_Level (Level => New_Level);
      Assert (Condition => DF.Get_Default_Level = New_Level,
              Message   => "Default level mismatch");

      DF.Set_Default_Level (Level => Before);
   end Default_Loglevel_Handling;

   -------------------------------------------------------------------------

   procedure Finalize (T : in out Testcase) is
      pragma Unreferenced (T);
   begin
      DF.Reset;
   end Finalize;

   -------------------------------------------------------------------------

   procedure Ident_Loglevel_Handling is
   begin
      DF.Set_Loglevel (Name  => "Foo",
                       Level => Info);
      Assert (Condition => DF.Get_Loglevel (Identifier => "Foo") = Info,
              Message   => "Ident loglevel mismatch");

      DF.Set_Loglevel (Name  => "Foo",
                       Level => Error);
      Assert (Condition => DF.Get_Loglevel (Identifier => "Foo") = Error,
              Message   => "Unable to update identifier loglevel");

      declare
         Level : Log_Level;
         pragma Unreferenced (Level);
      begin
         Level := DF.Get_Loglevel (Identifier => "Bar");
         Fail (Message => "Expected No_Ident_Loglevel");

      exception
         when Policy_DB.No_Ident_Loglevel =>
            null;
      end;
   end Ident_Loglevel_Handling;

   -------------------------------------------------------------------------

   procedure Initialize (T : in out Testcase) is
   begin
      T.Set_Name (Name => "Tests for the logging policy database");
      T.Add_Test_Routine
        (Routine => Reset_Policy_DB'Access,
         Name    => "reset policy database");
      T.Add_Test_Routine
        (Routine => Default_Loglevel_Handling'Access,
         Name    => "default loglevel handling");
      T.Add_Test_Routine
        (Routine => Ident_Loglevel_Handling'Access,
         Name    => "identifier based loglevel handling");
      T.Add_Test_Routine
        (Routine => Set_Identifier_Map'Access,
         Name    => "set identifier loglevel map");
      T.Add_Test_Routine
        (Routine => Verify_Accept_ID'Access,
         Name    => "accept identifier");
      T.Add_Test_Routine
        (Routine => Lookup_Ident'Access,
         Name    => "lookup identifier");
   end Initialize;

   -------------------------------------------------------------------------

   procedure Lookup_Ident is
   begin
      DF.Set_Default_Level (Level => Error);
      DF.Set_Loglevel (Name  => "Lookup.*",
                       Level => Warning);

      Assert (Condition => DF.Lookup (Name => "Lookup") = Warning,
              Message   => "Lookup mismatch");
      Assert (Condition => DF.Lookup (Name => "Nonexistent") = Error,
              Message   => "Nonexistent mismatch");
   end Lookup_Ident;

   -------------------------------------------------------------------------

   procedure Reset_Policy_DB is
   begin
      DF.Set_Default_Level (Level => Error);
      DF.Set_Loglevel (Name  => "Foo",
                       Level => Warning);

      DF.Reset;

      Assert (Condition => DF.Get_Default_Level = Log_Level'First,
              Message   => "Default loglevel mismatch");

      declare
         Level : Log_Level;
         pragma Unreferenced (Level);
      begin
         Level := DF.Get_Loglevel (Identifier => "Foo");
         Fail (Message => "Levels not reset");

      exception
         when Policy_DB.No_Ident_Loglevel =>
            null;
      end;
   end Reset_Policy_DB;

   -------------------------------------------------------------------------

   procedure Set_Identifier_Map is
      Map : Maps.Wildcard_Level_Map;
   begin
      Map.Insert (Key  => "Foo",
                  Item => Notice);
      Map.Insert (Key  => "Bar",
                  Item => Warning);

      DF.Set_Loglevel (Names => Map);

      Assert (Condition => DF.Get_Loglevel (Identifier => "Foo") = Notice,
              Message   => "Foo identifier loglevel mismatch");
      Assert (Condition => DF.Get_Loglevel (Identifier => "Bar") = Warning,
              Message   => "Bar identifier loglevel mismatch");
   end Set_Identifier_Map;

   -------------------------------------------------------------------------

   procedure Verify_Accept_ID is
   begin
      DF.Reset;
      Assert (Condition => DF.Accept_ID (Name => "", Level => Debug),
              Message   => "Debug not accepted by default");
      DF.Set_Default_Level (Level => Info);

      Assert (Condition => not DF.Accept_ID (Name  => "", Level => Debug),
              Message   => "Debug accepted");
      Assert (Condition => DF.Accept_ID (Name  => "", Level => Warning),
              Message   => "Warning not accepted");

      DF.Set_Loglevel (Name  => "Foo.*",
                       Level => Error);
      Assert (Condition => not DF.Accept_ID
              (Name  => "Foo",
               Level => Debug),
              Message   => "ID debug accepted");
      Assert (Condition => DF.Accept_ID
              (Name  => "Foo",
               Level => Critical),
              Message   => "ID critical not accepted");
      Assert (Condition => DF.Accept_ID
              (Name  => "Bar",
               Level => Info),
              Message   => "Src bar not accepted");

      DF.Set_Loglevel (Name   => "Foobar.*",
                       Level      => Debug);
      Assert (Condition => DF.Accept_ID
              (Name  => "Foobar",
               Level => Debug),
              Message   => "ID foobar not accepted");
   end Verify_Accept_ID;

end Policy_Tests;
