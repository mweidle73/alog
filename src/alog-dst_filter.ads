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

--  Destination filtering package implements logging policies for facilities.
package Alog.Dst_Filter is

   procedure Set_Default_Level (Level : Log_Level);
   --  Set given loglevel as default level.

   function Get_Default_Level return Log_Level;
   --  Return current default glevel.

   function Get_Loglevel (Identifier : String) return Log_Level;
   --  Return loglevel for given identifier string. Raises No_Ident_Loglevel
   --  exception if no entry for given identifier is found (exact match only,
   --  no wildcard lookup).

   procedure Set_Loglevel
     (Name  : String;
      Level : Log_Level);
   --  Set given loglevel for facility with specified name. If the identifier
   --  is already present the loglevel is updated. Name strings are
   --  case-sensitive.

   procedure Set_Loglevel (Names : Maps.Wildcard_Level_Map);
   --  Apply loglevels for names stored in map.

   procedure Reset;
   --  Reset the logging policy database to the initial state.

   function Lookup (Name : String) return Log_Level;
   --  Return loglevel for facility with given name string. If no associated
   --  loglevel is found, then the default loglevel is returned.

   function Accept_ID
     (Name  : String;
      Level : Log_Level)
      return Boolean;
   --  Returns True if the given loglevel is accepted for a facility with given
   --  name. If no match for the given identifier is found, it is compared to
   --  the default destination filter loglevel.

end Alog.Dst_Filter;
