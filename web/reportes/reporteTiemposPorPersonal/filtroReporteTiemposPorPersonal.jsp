<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>




<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            function cancelar(){
                // alert(codigo);
                location='../personal_jsp/navegador_personal.jsf';
            }
            function cargarAlmacen(f){
                var codigo=f.codAreaEmpresa.value;
                location.href="filtroReporteExistencias.jsp?codArea="+codigo;
            }
        </script>

        <style type="text/css">
            .tituloCampo1{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                font-weight: bold;
            }
            .outputText3{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
            .inputText3{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
            .commandButtonR{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                width: 150px;
                height: 20px;
                background-repeat :repeat-x;

                background-image: url('../img/bar3.png');
            }
        </style>

        <style type="text/css">
            .tituloCampo1{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                font-weight: bold;
            }
            .outputText3{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
            .inputText3{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
            .commandButtonR{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                width: 150px;
                height: 20px;
                background-repeat :repeat-x;

                background-image: url('../img/bar3.png');
            }
        </style>

        <script >
            function ajaxPersonalArea(){
                
                var select=document.getElementById("codAreaEmpresa");
                var codAreaEmpresa=new Array();
                for(var i=0;i<select.options.length;i++)
                {
                    if(select.options[i].selected)
                    {
                        codAreaEmpresa.push(select.options[i].value)
                    }
                }
                
                ajax=creaAjax()
                ajax.open("GET","ajaxPersonalArea.jsf?codAreaEmpresa="+codAreaEmpresa+"&data="+(new Date()).getTime().toString(),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {

                        document.getElementById("codPersonalArea").innerHTML=ajax.responseText;
                    }
                };                
                ajax.send(null);
            }
            


       function enviarReporteTiempo()
       {
           var form=document.getElementById("form1");
           var codTipoReporte=parseInt(document.getElementById("codTipoReporte").value);
           var select=document.getElementById("codAreaEmpresa");
            var codAreaEmpresa=new Array();
            for(var i=0;i<select.options.length;i++)
            {
                if(select.options[i].selected)
                {
                    codAreaEmpresa.push(select.options[i].value)
                }
            }
            select=document.getElementById("codPersonal");
             var codPersonal=new Array();
            for(var i=0;i<select.options.length;i++)
            {
                if(select.options[i].selected)
                {
                    codPersonal.push(select.options[i].value)
                }
            }
            document.getElementById("codAreaEmpresaReporte").value=codAreaEmpresa;
            document.getElementById("codPersonalReporte").value=codPersonal;
                
           switch(codTipoReporte)
           {
               case 1:
               {
                   form.action="reporteTiemposPersonalDetallado.jsf";
                   break;
               }
               case 2:
               {
                   form.action="reporteTiemposPersonalResumido.jsf";
                   break;
               }
           }
        
            form.submit();
        }
        </script>



    </head>
    <body>
        <span class="outputTextTituloSistema">Reporte de Tiempos por Personal</span>

        <form method="post" action="reporteDeTiempos.jsp" target="_blank" style="top:1px" id="form1" name="form1">
            <div align="center">
                <table border="0"  border="0" cellpadding="0" cellspacing="0" class="tablaFiltroReporte" >
                    <thead>
                        <tr><td colspan="3">Introduzca los datos</td></tr>
                    </thead>
                    <%
                        Connection con=null;
                        try
                        {
                            con=Util.openConnection(con);
                            StringBuilder consulta=new StringBuilder("select distinct ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA");
                                                    consulta.append(" from PERSONAL_AREA_PRODUCCION pap");
                                                            consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=pap.COD_AREA_EMPRESA");
                                                    consulta.append(" where pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION=1");
                                                    consulta.append(" order by ae.NOMBRE_AREA_EMPRESA");
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet res=st.executeQuery(consulta.toString());
                            out.println("<tr>");
                                out.println("<td class='outputTextBold'>Area Personal</td>"); 
                                out.println("<td class='outputTextBold'>::</td>"); 
                                out.println("<td><select id='codAreaEmpresa' name='codAreaEmpresa' class='inputText' multiple=true size=6 onchange='ajaxPersonalArea(form1)'>");
                                while(res.next())
                                {
                                    out.println("<option value='"+res.getString("COD_AREA_EMPRESA")+"'>"+res.getString("NOMBRE_AREA_EMPRESA")+"</option>");
                                }
                                out.println("</select></td>");
                            out.println("</tr>");
                            out.println("<tr>");
                                out.println("<td class='outputTextBold'>Area Personal</td>"); 
                                out.println("<td class='outputTextBold'>::</td>"); 
                                out.println("<td id='codPersonalArea'><select></select></td>");
                            out.println("</tr>");
                        }
                        catch(SQLException ex)
                        {
                            ex.printStackTrace();
                        }
                        finally
                        {
                            con.close();
                        }
                        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                    %>
                    
                    <tr>
                        <td class="outputTextBold">De fecha de registro</td>
                        <td class="outputTextBold">::</td>
                        <td >
                            <input type="text"  size="12"  value="<%=(sdf.format(new Date()))%>" name="fecha_inicio" id="fecha_inicio" class="inputText">
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_inicio" click_element_id="imagenFecha1">
                             </DLCALENDAR>
                        </td>
                    </tr>

                    <tr>
                        <td class="outputTextBold">A fecha de Registro</td>
                        <td class="outputTextBold">::</td>
                        <td>
                            <input type="text"  size="12"  value="<%=(sdf.format(new Date()))%>" name="fecha_final" id="fecha_final" class="inputText">
                            <img id="imagenFecha2" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha_final" click_element_id="imagenFecha2">
                             </DLCALENDAR>
                        </td>
                    </tr>
                    <tr>
                        <td class="outputTextBold">Tipo de Reporte</td>
                        <td class="outputTextBold">::</td>
                        <td>
                            <select class="inputText" id="codTipoReporte">
                                <option value="1">DETALLADO</option>
                                <option value="2">RESUMIDO</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" align="center">
                            <button class="btn" onclick="enviarReporteTiempo()">Ver Reporte</button>
                        </td>
                    </tr>

                </table>

            </div>
            <input id="codPersonalReporte" name="codPersonalReporte" type="hidden"/>
            <input id="codAreaEmpresaReporte" name="codAreaEmpresaReporte" type="hidden"/>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>