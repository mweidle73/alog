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

with Alog.Policy_DB;

package body Alog.Dst_Filter is

   Instance : Policy_DB.Protected_Policy_DB;

   -------------------------------------------------------------------------

   function Accept_ID
     (Name  : String;
      Level : Log_Level)
      return Boolean is
   begin
      return Instance.Accept_ID (Identifier => Name, Level => Level);
   end Accept_ID;

   -------------------------------------------------------------------------

   function Get_Default_Level return Log_Level is
   begin
      return Instance.Get_Default_Loglevel;
   end Get_Default_Level;

   -------------------------------------------------------------------------

   function Get_Loglevel (Identifier : String) return Log_Level is
   begin
      return Instance.Get_Loglevel (Identifier => Identifier);
   end Get_Loglevel;

   -------------------------------------------------------------------------

   function Lookup (Name : String) return Log_Level
   is
   begin
      return Instance.Lookup (Identifier => Name);
   end Lookup;

   -------------------------------------------------------------------------

   procedure Reset is
   begin
      Instance.Reset;
   end Reset;

   -------------------------------------------------------------------------

   procedure Set_Default_Level (Level : Log_Level) is
   begin
      Instance.Set_Default_Loglevel (Level => Level);
   end Set_Default_Level;

   -------------------------------------------------------------------------

   procedure Set_Loglevel
     (Name  : String;
      Level : Log_Level) is
   begin
      Instance.Set_Loglevel (Identifier => Name, Level => Level);
   end Set_Loglevel;

   -------------------------------------------------------------------------

   procedure Set_Loglevel (Names : Maps.Wildcard_Level_Map) is
   begin
      Instance.Set_Loglevel (Identifiers => Names);
   end Set_Loglevel;

end Alog.Dst_Filter;
