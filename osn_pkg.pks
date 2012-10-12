create or replace package osn_pkg as 
  
  /*
     Package to integrate APEX with OSN 
       APEX: Oracle Application Express
       OSN:  Oracle Social Network
     Created by: Dimitri Gielis
     Created date: 2-OCT-2012
  */
  
  --
  --
  procedure set_header (p_cookie   in varchar2, 
                        p_randomid in varchar2);
  --
  
  --
  --
  procedure connection (p_username in varchar2, 
                        p_password in varchar2, 
                        p_cookie   out varchar2, 
                        p_randomid out varchar2);
  --

  --
  --
  procedure conversation (p_conversation   in varchar2, 
                          p_cookie         in varchar2, 
                          p_randomid       in varchar2, 
                          p_conversationid out number, 
                          p_folderid       out number);
  --
  
  --
  --
  procedure message (p_conversationid in number, 
                     p_message        in varchar2, 
                     p_cookie         in varchar2, 
                     p_randomid       in varchar2);
  --
  
  --
  --
  procedure document (p_folderid in number, 
                      p_name     in varchar2, 
                      p_document in blob, 
                      p_cookie   in varchar2, 
                      p_randomid in varchar2);
  --
  
  --
  --
  procedure member (p_conversationid in number, 
                    p_member         in varchar2, 
                    p_cookie         in varchar2, 
                    p_randomid       in varchar2);
  --

  -- procedure called from within the APEX application
  --
  procedure submit_osn (p_comment in varchar2, 
                        p_type    in varchar2, 
                        p_file_id in varchar2);
  --
  
end osn_pkg;