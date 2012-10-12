create or replace package body osn_pkg as 
  
  --
  -- Constants
  c_wallet_path constant varchar2(100) := 'file:/u01/app/oracle/product/11.2.0/db_1/owm/wallets/osn';
  c_wallet_pwd  constant varchar2(50)  := 'WALLET PASSWORD';
  c_http_method constant varchar2(5)   := 'POST';
  --
                     
  --
  --
  procedure set_header (p_cookie   in varchar2, 
                        p_randomid in varchar2)
  as
    l_empty_headers apex_web_service.header_table;
  begin
    --
    apex_web_service.g_request_headers := l_empty_headers;
    --
      apex_web_service.g_request_headers(1).name := 'User-Agent';
      apex_web_service.g_request_headers(1).value := 'Mozilla/4.0';
      --  
      apex_web_service.g_request_headers(2).name := 'Content-Type';
      apex_web_service.g_request_headers(2).value := 'application/json;charset=UTF-8';
      --
      if p_cookie is not null
      then
      apex_web_service.g_request_headers(3).name := 'Cookie';
        apex_web_service.g_request_headers(3).value := p_cookie;
        --
        apex_web_service.g_request_headers(4).name := 'X-Waggle-RandomID';
        apex_web_service.g_request_headers(4).value := p_randomid;  
      end if;
      --  
  end set_header;
  --
    
  --
  --
  procedure connection (p_username in varchar2, 
                        p_password in varchar2, 
                        p_cookie   out varchar2, 
                        p_randomid out varchar2)
  as
    l_url      varchar2(100);
    l_body     varchar2(32767);
    l_resp     varchar2(32767);
    i          number;
    l_randomid varchar2(32767);
  begin            
    -- do request
    l_url  := 'https://ontrackeap.oracle.com/ack/social/api/v1/connections';
    l_body := '{"name":"' || p_username || '", "password":"' || p_password || '"}';
    l_resp := apex_web_service.make_rest_request(
                p_url         => l_url,
                p_http_method => c_http_method,
                p_wallet_path => c_wallet_path,
                p_wallet_pwd  => c_wallet_pwd,
                p_body        => l_body
              );
    -- parse response and set out parameters
    for i in 1.. apex_web_service.g_headers.count loop
      if apex_web_service.g_headers(i).name like '%Set-Cookie%' 
      then
        p_cookie := apex_web_service.g_headers(i).value;
      end if;
    end loop;
    --
    l_randomid := SUBSTR(l_resp, INSTR(l_resp, '"apiRandomID" : "')+17);
    p_randomid := SUBSTR(l_randomid, 1, INSTR(l_randomid, '"')-1);
    --        
  end connection;  
  --  
  
  --
  --
  procedure conversation (p_conversation   in varchar2, 
                          p_cookie         in varchar2, 
                          p_randomid       in varchar2, 
                          p_conversationid out number, 
                          p_folderid       out number)
  as
    l_url            varchar2(100);
    l_body           varchar2(32767);
    l_resp           varchar2(32767);
    l_conversationid varchar2(32767);
    l_folderid       varchar2(32767);
  begin            
    l_url  := 'https://ontrackeap.oracle.com/ack/social/api/v1/conversations';
    l_body := '{"name":"'|| p_conversation || '"}';
    l_resp := apex_web_service.make_rest_request(
                p_url         => l_url,
                p_http_method => c_http_method,
                p_wallet_path => c_wallet_path,
                p_wallet_pwd  => c_wallet_pwd,
                p_body        => l_body
              );
    --
    l_conversationid := SUBSTR(l_resp, INSTR(l_resp, '"id" : "')+8);
    p_conversationid := SUBSTR(l_conversationid, 1, INSTR(l_conversationid, '"')-1);
    --
    l_folderid := SUBSTR(l_resp, INSTR(l_resp, '"folderID" : "')+14);
    p_folderid := SUBSTR(l_folderid, 1, INSTR(l_folderid, '"')-1);
    --
  end conversation;  
  --
    
  --
  --
  procedure message (p_conversationid in number, 
                     p_message        in varchar2, 
                     p_cookie         in varchar2, 
                     p_randomid       in varchar2)
  as
    l_url  varchar2(100);
    l_body varchar2(32767);
    l_resp varchar2(32767);
  begin            
    l_url  := 'https://ontrackeap.oracle.com/ack/social/api/v1/conversations/' || p_conversationid || '/messages';
    l_body := '{"externalID":"", "message":"'|| p_message || '"}';
    l_resp := apex_web_service.make_rest_request(
                p_url         => l_url,
                p_http_method => c_http_method,
                p_wallet_path => c_wallet_path,
                p_wallet_pwd  => c_wallet_pwd,
                p_body        => l_body
              );
  end message;  
  --
      
  --
  --
  procedure document (p_folderid in number, 
                      p_name     in varchar2, 
                      p_document in blob, 
                      p_cookie   in varchar2, 
                      p_randomid in varchar2)
  as
    l_url  varchar2(100);
    l_resp varchar2(32767);
  begin            
    l_url  := 'https://ontrackeap.oracle.com/ack/social/api/v1/documents/' || to_char(p_folderid) || '/' || p_name;
    l_resp := apex_web_service.make_rest_request(
                p_url         => l_url,
                p_http_method => c_http_method,
                p_wallet_path => c_wallet_path,
                p_wallet_pwd  => c_wallet_pwd,
                p_body_blob   => p_document
              );
  end document;  

  --
  --
  procedure member (p_conversationid in number, 
                    p_member         in varchar2, 
                    p_cookie         in varchar2, 
                    p_randomid       in varchar2)
  as
    l_url  varchar2(100);
    l_body varchar2(32767);
    l_resp varchar2(32767);
  begin            
    l_url  := 'https://ontrackeap.oracle.com/ack/social/api/v1/conversations/' || to_char(p_conversationid) || '/members';
    l_body := '{"member":"'|| p_member || '"}';
    l_resp := apex_web_service.make_rest_request(
                p_url         => l_url,
                p_http_method => c_http_method,
                p_wallet_path => c_wallet_path,
                p_wallet_pwd  => c_wallet_pwd,
                p_body        => l_body
              );
  end member;  
  --
 
  -- procedure called from within the APEX application
  --
  procedure submit_osn (p_comment in varchar2, 
                                  p_type    in varchar2, 
                        p_file_id in varchar2)
  as
    l_username       varchar2(200) := 'YOUR USERNAME';
    l_password       varchar2(200) := 'YOUR PASSWORD';
    l_member         varchar2(500) := 'OTHER PEOPLE';
    l_cookie         varchar2(200);
    l_randomid       varchar2(200);
    l_blob           blob;
    l_name           varchar2(500);
    l_conversationid number;
    l_folderid       number;
  begin
    connection(p_username => l_username, 
               p_password => l_password, 
               p_cookie   => l_cookie, 
               p_randomid => l_randomid);
               
    set_header (p_cookie   => l_cookie, 
                p_randomid => l_randomid);
                                           
    conversation(p_conversation   => p_type || ': ' || to_char(sysdate,'DD-MON-YYYY HH24:MI:SS'), 
                 p_cookie         => l_cookie, 
                 p_randomid       => l_randomid,
                 p_conversationid => l_conversationid,
                 p_folderid       => l_folderid);
  
    member(p_conversationid => l_conversationid,
           p_member         => l_member,
           p_cookie         => l_cookie, 
           p_randomid       => l_randomid);

    message(p_conversationid => l_conversationid, 
            p_message        => p_comment, 
            p_cookie         => l_cookie, 
            p_randomid       => l_randomid);

    begin
      /*  -- used to illustrate with the sample app blobs/images             
          select filename, product_image
              into l_name, l_blob
               from demo_product_info
           where product_id = to_number(p_file_id);
      */
      select file_name, file_blob
        into l_name, l_blob
        from tfile
       where file_id = to_number(p_file_id);

      document(p_folderid => l_folderid, 
               p_name     => l_name, 
               p_document => l_blob, 
               p_cookie   => l_cookie, 
               p_randomid => l_randomid); 
    exception
    when no_data_found
    then
      -- no document added to message, so nothing to do
      null;
    end;    
  end submit_osn;  
  --
  
end osn_pkg;