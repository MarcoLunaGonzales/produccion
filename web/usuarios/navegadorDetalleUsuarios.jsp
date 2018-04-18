<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>


<f:view>
    
    
    <html>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <link rel="STYLESHEET" type="text/css" href="../css/treeComponet.css" />
            <script src="../js/general.js"></script>
            <script type="text/javascript" src='../js/treeComponet.js' ></script>
            
        </head>
        <body onLoad="parserXMLUsuariosCronos('<%=request.getParameter("codigo")%>');">
            <%--input type="button" class="btn" onclick="location='../usuarios/navegador_usuarios.jsp'"  value="<-- Atrás" --%>
            <div align="center">
                <h:outputText value="Opciones Habilitadas en CRONOS a:" styleClass="tituloCabeceraRRHH"   />
                <h:outputText value=" #{param['nombre']} " styleClass="tituloCabeceraRRHH"   />
            </div>
            <div id="main" style='margin-left:200px;padding:0px;overflow:auto;margin-top:10px' >
                
            </div>
            
        </body>
    </html>
</f:view>
