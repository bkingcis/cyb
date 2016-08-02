<cfscript>
  apName="cybatrol";
  datasource="cybatrol";//<!--- cybatro_pg --->
  request.dsn="cybatrol";//<!--- cybatro_pg --->

  BaseURL = "https://secure.cybatrol.com";
  BasePath = "c:\external\cybatrol\";
  session.sessionbaseurl = 'https://#Replace(CGI.HTTP_HOST,".cybatrol.com","","ALL")#.cybatrol.com';

  LibraryURL = "https://secure.cybatrol.com/library";
  LibraryUpload = "E:\hshome\cybatrol\cybatrol.com\library/";

  IntUpload = BasePath & "\uploadimages";
  ImageURL = BaseURL & "/uploadimages/";
  
  // Default data labels (users,visitors,docuements,requests)
  labels = {};
    labels.Community = 'Community';
    labels.Visitor = 'Visitor';
    labels.Resident = 'Resident';
    labels.Staff = 'Personnel';
    labels.other_users = 'Users'; //(users, admins, managers, roommates etc.)
    labels.permanent_visitor = 'Express Pass'; // 24/7 
    labels.special_event = 'Special Event';
    labels.mail_parcel = 'Parcel/Package';
    labels.downloads = 'Useful Files'; //'Documents'
    labels.communications = 'Maintenance Request'; //'Maintenance Requests'
</cfscript>
