--
--  Copyright (c) 2019,
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

with Alog.Maps;

--  Logging policy database package. This package provides type definitions to
--  implement identifier-based filtering.
package Alog.Policy_DB is

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
      --  Return loglevel for given identifier string or the closest wildcard
      --  match. If no associated loglevel is found the default loglevel is
      --  returned.

      procedure Reset;
      --  Reset the logging policy database to the initial state.

      function Accept_ID
        (Identifier : String := "";
         Level      : Log_Level)
         return Boolean;
      --  Returns True if the given loglevel is accepted for a specified
      --  identifier. The loglevel is compared against the default loglevel if
      --  no match for the given identifier is found.

   private

      Ident_Levels : Maps.Wildcard_Level_Map;
      --  Identifier based loglevels.

      Current_Default_Loglevel : Log_Level := Log_Level'First;
      --  Current default loglevel.
   end Protected_Policy_DB;

   No_Ident_Loglevel : exception;
   --  Will be raised if loglevel is not found for a requested identifier.

end Alog.Policy_DB;
