
<%@page import="com.cofar.util.Util"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.cofar.web.ManagedAccesoSistema"%>
<html>
    <head>
        <script type="text/javascript" src='../js/general.js' ></script> 
        <script type="text/javascript" src='../js/treeComponet.js' ></script>
        <link rel="STYLESHEET" type="text/css" href="../css/treeComponet.css" />
    </head>
    <body style="padding:0px">
        <%
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSession("ManagedAccesoSistema");
            out.println("<div id='mainContainer' style='width:100%'></div>");
            out.println("<div style='cursor:hand;position:absolute;top:0px;right:0px'><img src='../img/hideMenu.jpg' onclick='parent.hideShowMenu(this)'/></div>");
            out.println("<div id='main' style='margin-left:0px;top:0px;padding:0px;width:100%;height:95%;overflow:auto;'></div>");
            out.println("<script type='text/javascript'>");
                out.println("session='"+managed.getUsuarioModuloBean().getSession()+"';");
                out.println("parserXML();");
            out.println("</script>");
        %>
        
    </body>
</html>
