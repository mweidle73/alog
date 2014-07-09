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

package body Alog.Policy_DB is

   Current_Default_Loglevel : Log_Level := Alog_Default_Level;
   --  Current default loglevel.

   protected type Protected_Policy_DB is

      procedure Set_Default_Loglevel (Level : Log_Level);
      --  Set given loglevel as default loglevel.

      function Get_Default_Loglevel return Log_Level;
      --  Return current default loglevel.

      procedure Set_Loglevel
        (Identifier : String;
         Level      : Log_Level);
      --  Set given loglevel for specified identifier string. If the identifier
      --  is already present the loglevel is updated. Identifier strings are
      --  case-sensitive.
      --
      --  Use wildcards to specify a loglevel for a range of identifiers.
      --  Identifier hierarchies are separated by dots, the wildcard is '*'.
      --  The following example sets a Debug loglevel for all log-identifiers
      --  in Foo.Bar (including Foo.Bar).
      --
      --  Example:
      --     Foo.Bar.* = Debug
      --
      --  Direct matches take precedence over wildcard matches. In the
      --  following example the loglevel for identifier 'Foo.Bar' is
      --  explicitly set to Info.
      --
      --  Example:
      --     Foo.Bar   = Info
      --     Foo.Bar.* = Debug

      procedure Set_Loglevel (Identifiers : Maps.Wildcard_Level_Map);
      --  Apply loglevels for identifiers stored in map.

      function Get_Loglevel (Identifier : String) return Log_Level;
      --  Return loglevel for given identifier string. Raises No_Ident_Loglevel
      --  exception if no entry for given identifier is found (exact match
      --  only, no wildcard lookup).

      function Lookup (Identifier : String) return Log_Level;
      --  Return loglevel for given identifier string. Returns the closest
      --  match, if no associated loglevel is found the default loglevel
      --  is returned.

      procedure Reset;
      --  Reset the logging policy database to the initial state.

      function Accept_Src
        (Identifier : String := "";
         Level      : Log_Level)
         return Boolean;
      --  Returns True if the given loglevel is accepted for a source
      --  identifier. If no identifier is given, the loglevel is verified
      --  against the default loglevel.

      function Accept_Dst
        (Identifier : String;
         Level      : Log_Level)
         return Boolean;
      --  Returns True if the given loglevel is accepted for a destination
      --  identifier. If no match for the given identifier is found True is
      --  returned.

   private

      Ident_Levels : Maps.Wildcard_Level_Map;
      --  Identifier based loglevels.

   end Protected_Policy_DB;

   protected body Protected_Policy_DB is

      -------------------------------------------------------------------------

      function Accept_Dst
        (Identifier : String;
         Level      : Log_Level)
         return Boolean
      is
         use type Alog.Maps.Cursor;
         Position : Maps.Cursor;
      begin
         Position := Ident_Levels.Lookup (Key => Identifier);

         if Position /= Maps.No_Element then
            return Level >= Maps.Element (Position => Position);
         end if;

         return True;
      end Accept_Dst;

      -------------------------------------------------------------------------

      function Accept_Src
        (Identifier : String := "";
         Level      : Log_Level)
         return Boolean
      is
      begin
         return Level >= Lookup (Identifier => Identifier);
      end Accept_Src;

      -------------------------------------------------------------------------

      function Get_Default_Loglevel return Log_Level is
      begin
         return Current_Default_Loglevel;
      end Get_Default_Loglevel;

      -------------------------------------------------------------------------

      function Get_Loglevel (Identifier : String) return Log_Level is
      begin
         return Ident_Levels.Element (Key => Identifier);

      exception
         when Constraint_Error =>
            raise No_Ident_Loglevel with
              "No loglevel for identifier '" & Identifier & "'";
      end Get_Loglevel;

      -------------------------------------------------------------------------

      function Lookup (Identifier : String) return Log_Level is
         use type Alog.Maps.Cursor;
         Position : Maps.Cursor;
      begin
         Position := Ident_Levels.Lookup (Key => Identifier);

         if Position /= Maps.No_Element then
            return Maps.Element (Position => Position);
         end if;

         return Current_Default_Loglevel;
      end Lookup;

      -------------------------------------------------------------------------

      procedure Reset is
      begin
         Current_Default_Loglevel := Alog_Default_Level;
         Ident_Levels.Clear;
      end Reset;

      -------------------------------------------------------------------------

      procedure Set_Default_Loglevel (Level : Log_Level) is
      begin
         Current_Default_Loglevel := Level;
      end Set_Default_Loglevel;

      -------------------------------------------------------------------------

      procedure Set_Loglevel
        (Identifier : String;
         Level      : Log_Level)
      is
      begin
         Ident_Levels.Insert (Key  => Identifier,
                            Item => Level);
      end Set_Loglevel;

      -------------------------------------------------------------------------

      procedure Set_Loglevel (Identifiers : Maps.Wildcard_Level_Map) is
      begin
         Ident_Levels := Identifiers;
      end Set_Loglevel;

   end Protected_Policy_DB;

   Instance : Protected_Policy_DB;

   -------------------------------------------------------------------------

   function Accept_Dst
     (Identifier : String;
      Level      : Log_Level)
      return Boolean is
   begin
      return Instance.Accept_Dst (Identifier => Identifier, Level => Level);
   end Accept_Dst;

   -------------------------------------------------------------------------

   function Accept_Src
     (Identifier : String := "";
      Level      : Log_Level)
      return Boolean is
   begin
      return Instance.Accept_Src (Identifier => Identifier, Level => Level);
   end Accept_Src;

   -------------------------------------------------------------------------

   function Get_Default_Loglevel return Log_Level is
   begin
      return Instance.Get_Default_Loglevel;
   end Get_Default_Loglevel;

   -------------------------------------------------------------------------

   function Get_Loglevel (Identifier : String) return Log_Level is
   begin
      return Instance.Get_Loglevel (Identifier => Identifier);
   end Get_Loglevel;

   -------------------------------------------------------------------------

   function Lookup (Identifier : String) return Log_Level is
   begin
      return Instance.Lookup (Identifier => Identifier);
   end Lookup;

   -------------------------------------------------------------------------

   procedure Reset is
   begin
      Instance.Reset;
   end Reset;

   -------------------------------------------------------------------------

   procedure Set_Default_Loglevel (Level : Log_Level) is
   begin
      Instance.Set_Default_Loglevel (Level => Level);
   end Set_Default_Loglevel;

   -------------------------------------------------------------------------

   procedure Set_Loglevel
     (Identifier : String;
      Level      : Log_Level) is
   begin
      Instance.Set_Loglevel (Identifier => Identifier, Level => Level);
   end Set_Loglevel;

   -------------------------------------------------------------------------

   procedure Set_Loglevel (Identifiers : Maps.Wildcard_Level_Map) is
   begin
      Instance.Set_Loglevel (Identifiers => Identifiers);
   end Set_Loglevel;

end Alog.Policy_DB;
