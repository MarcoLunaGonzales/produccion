<%@page import="javax.faces.context.FacesContext"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page isErrorPage="true" import="java.io.*" contentType="text/html"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.StringWriter"%>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="<%=(request.getContextPath())%>/css/errorPages.css" /> 
        </head>
        <body>
            <%
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            %>
            <center>
                <h3 class="titulo">Error de Proceso</h3>
            </center>
            <p class="contenido">
                <b>Fecha de Excepción:</b><%=(sdf.format(new Date()))%>
                <br/><b>Dirección ip de acceso:</b><%=request.getRemoteAddr()%>
                </br></br>A ocurrido una excepción al momento de procesar su solicitud.
                <%
                    if(exception.toString().equals("java.lang.NullPointerException")){
                        out.println("<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Su sesión o el proceso en el cual se encuentra a superado el limite permitido");
                        out.println("<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vuelva a ingresar a la opción solicitada.");
                        out.println("<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Si el problema persiste, favor comunicarse con el departamento de sistema int. 306");
                    }
                    else{
                        out.println("<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;La solicitud a la cual hace refencia a sufrido una excepción");
                        out.println("<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vuelva a ingresar a la opción solicitada.");
                        out.println("<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Si el problema persiste, favor comunicarse con el departamento de sistema int. 306");
                    }
                %>
            </p>
            <p class="subTitulo">Causa</p>
                <p class="contenido"><%=(exception.toString().equals("java.lang.NullPointerException")?"session terminada":exception.toString())%></p>
            <p class="subTitulo">Detalle</p>
            <p class="contenido">
            <%
                StringWriter stringWriter = new StringWriter();
                PrintWriter printWriter = new PrintWriter(stringWriter);
                exception.printStackTrace(printWriter);
                out.println(stringWriter);
                printWriter.close();
                stringWriter.close();
            %>
            </p>
            
        </body>
    </html>


