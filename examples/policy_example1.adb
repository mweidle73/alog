with Alog.Policy_DB;
with Alog.Logger;

use Alog;

--  Alog source loglevel policy example.
procedure Policy_Example1 is
   Src_Filter : Policy_DB.Protected_Policy_DB;
   Log        : Logger.Instance (Init => True);
begin
   --  Set default loglevel to 'Info'.
   Src_Filter.Set_Default_Loglevel (Level => Info);
   --  Set source specific loglevel for all 'Example' sources to 'Debug'.
   Src_Filter.Set_Loglevel (Identifier => "Example.*",
                            Level      => Debug);

   --  This message will be logged because it matches a source specific
   --  loglevel (Example.*).
   if Src_Filter.Accept_ID (Identifier => "Example.Source1",
                            Level      => Debug)
   then
      Log.Log_Message (Source => "Example.Source1",
                       Level  => Debug,
                       Msg    => "This is a test message");
   end if;

   --  This message will not be logged because of the configured default 'Info'
   --  loglevel. There's no configured source loglevel for 'Source2'.
   if Src_Filter.Accept_ID (Identifier => "Source2",
                            Level      => Debug)
   then
      Log.Log_Message (Source => "Source2",
                       Level  => Debug,
                       Msg    => "This will not be logged");
   end if;

   --  This message will be logged because of the configured default 'Info'
   --  loglevel. There's no configured source loglevel for 'Source2'.
   if Src_Filter.Accept_ID (Identifier => "Source2",
                            Level      => Info)
   then
      Log.Log_Message (Source => "Source2",
                       Level  => Info,
                       Msg    => "This is another test message");
   end if;
end Policy_Example1;
