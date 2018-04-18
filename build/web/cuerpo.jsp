<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import ="java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<f:view>
    <html>
        <head>
            <title></title>
            <link rel="STYLESHEET" type="text/css" href="css/ventas.css" /> 
            <script type="text/javascript" src="js/general.js" ></script> 
            <script>
                function cargarCumpleaneros(){
                    izquierda = (screen.width) ? (screen.width-300)/2 : 100 
                    arriba = (screen.height) ? (screen.height-400)/2 : 200 		
                    url='navegadorCumpleaneros.jsf';
                    opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,width=750,height=400,left='+izquierda+ ',top=' + arriba + '' 
                    window.open(url, 'popUp',opciones)

                    izquierda2 = (screen.width) ? (screen.width-200)/2 : 100 
                    arriba2 = (screen.height) ? (screen.height-300)/2 : 200 		
                    url2='navegadorFinalizacionContratos.jsf';			
                    opciones2='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,width=750,height=300,left='+izquierda2+ ',top=' + arriba2 + '' 
                    window.open(url2, 'popUp1',opciones2)   
                    
                    izquierda3 = (screen.width) ? (screen.width-200)/2 : 100 
                    arriba3 = (screen.height) ? (screen.height-300)/2 : 200 		
                    url3='navegadorRetrasos.jsf';			
                    opciones3='toolbar=0,location=0,directories=0,status=0,resizable=1,menubar=0,scrollbars=1,width=750,height=300,left='+izquierda2+ ',top=' + arriba2 + '' 
                    window.open(url3, 'popUp3',opciones3) 
                }
                                

            </script>
        </head>
        <body  >
<div align="center" style="position:absolute; filter:alpha(opacity=50); opacity:0.5;width:100%;height:100%;background-position:center; background-attachment:fixed;background-repeat:no-repeat;background-image:url('img/iconoInicio.png')">
    
</div>
 <%
    try
      {
        Connection con=null;
        con=Util.openConnection(con);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        String consulta="SELECT ms.DESCRIPCION FROM MENSAJES_SISTEMAS ms where ms.COD_ESTADO_REGISTRO=1 order by ms.FECHA_EMISION";
        System.out.println("consulta  "+consulta);
        ResultSet res=st.executeQuery(consulta);

        int cont=0;
        if(res.next())
        {
            out.println("<table  style='background-color:#ffffff;margin-left:25%;width:50%; position:absolute;border : solid #A9A9A9 1px;' cellpadding='0' cellspacing='0'  >");
        out.println("<tr class='headerClassACliente' >");
        out.println("<td style='border-bottom : solid #A9A9A9 1px;'align='center'><b>Mensaje Sistemas</b></td>");
        out.println("</tr>");
            cont++;
            out.println("<tr class='outputText2'>");
            out.println("<td style='border-bottom : solid #A9A9A9 1px;'><b>"+cont+"- "+res.getString("DESCRIPCION")+"</b></td>");

            out.println("</tr>");
        }
        while(res.next())
        {cont++;
            out.println("<tr class='outputText2'>");
            out.println("<td style='border-bottom : solid #A9A9A9 1px;'><b>"+cont+"- "+res.getString("DESCRIPCION")+"</b></td>");

            out.println("</tr>");
        }
        if(cont>0)out.println("<table> ");
        res.close();
        st.close();
        con.close();
    }
    catch(SQLException ex)
    {
        ex.printStackTrace();
    }

    %>

        </body>
    </html>
    
</f:view>

