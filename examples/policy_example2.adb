with Alog.Dst_Filter;
with Alog.Logger;
with Alog.Facilities.File_Descriptor;

use Alog;

--  Alog destination loglevel policy example.
procedure Policy_Example2 is
   Log : Logger.Instance (Init => True);

   Facility_Name : constant String := "Application_Errors";
   Errors        : constant Facilities.File_Descriptor.Handle
     := new Facilities.File_Descriptor.Instance;
begin
   --  Write all error messages to '/tmp/errors.log'.
   Errors.Set_Logfile (Path => "/tmp/errors.log");
   Errors.Set_Name (Name => Facility_Name);
   Errors.Toggle_Write_Loglevel (State => True);

   --  Set loglevel policy to 'Error' for destination 'Application_Errors'.
   Dst_Filter.Set_Loglevel (Name  => Facility_Name,
                            Level => Error);

   Log.Attach_Facility (Facility => Facilities.Handle (Errors));

   --  This message will appear on stdout, but not in the error logfile.
   Log.Log_Message (Level  => Info,
                    Msg    => "This is not an error");
   --  This message will also be written to the error logfile.
   Log.Log_Message (Level  => Error,
                    Msg    => "This is an error");

   --  Set global loglevel to only log messages with level higher than Warning
   --  if no facility-specific level is set.
   Dst_Filter.Set_Default_Level (Level => Warning);
   --  This message will be filtered out.
   Log.Log_Message (Level  => Info,
                    Msg    => "This message will be filtered");
   --  This message will appear on stdout, but not in the error logfile.
   Log.Log_Message (Level  => Warning,
                    Msg    => "This is a warning message");
end Policy_Example2;
