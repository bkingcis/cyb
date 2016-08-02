component {
  this.name = "cybatrol_pdk";
  this.sessionManagement = true;
  this.sessionTimeout = CreateTimeSpan(0, 1, 0, 0); //1 hour 
  
  function onApplicationStart() {
    application.dsn = "cybatrol";
    return true;
  }
  
  
  function onRequest( string targetPage ) {
   //   if ( not structKeyExists(application, "sslfix") ) {
   //     var abjSecurity = createObject("java", "java.security.Security");
   //     abjSecurity.removeProvider("JsafeJCE");
   //     application.sslfix = true;
   //   }
        
      try {
          include arguments.targetPage;
      } catch (any e) {
          writeDump(e);
      }

    }
}