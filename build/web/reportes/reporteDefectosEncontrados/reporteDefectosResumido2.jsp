<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>


<%! Connection con = null;

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <style>
            .outputTextNormal{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 9px;
                font-weight: normal;
            }
        </style>
        
    </head>
    <body>
      
        <form>
            <h4 align="center" class="outputText5"><b>Reporte Resumido de Defectos</b></h4>
            <%
            NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("####.##;(####.##)");

                        String codProgramaProdPeriodo=request.getParameter("codProgramaProduccionPeriodo")==null?"''":request.getParameter("codProgramaProduccionPeriodo");

                        String arrayCodCompProd =request.getParameter("codCompProdArray")==null?"''":request.getParameter("codCompProdArray");

                        String nombreProgramaProduccionPeriodo = request.getParameter("nombreProgramaProduccionPeriodo")==null?"''":request.getParameter("nombreProgramaProduccionPeriodo");

                        arrayCodCompProd = arrayCodCompProd + (arrayCodCompProd.length()==0?"' '":"");
                        String[] valores=arrayCodCompProd.split(",");
                        System.out.println(arrayCodCompProd);
                        System.out.println("los datos de peticion para el reporte : "+request.getParameter("codAreaEmpresaP"));
                        System.out.println(request.getParameter("nombreAreaEmpresaP"));
                        String arrayCodAreaEmpresa= request.getParameter("codAreaEmpresaP");
                        String arrayNombreAreaEmpresa= request.getParameter("nombreAreaEmpresaP");
                        String codAreaEmpresaAct=request.getParameter("codAreaEmpresaActividad");
                        String codEstadoProgramaProduccion=request.getParameter("codEstadoPrograma");
                        String arrayProgram=request.getParameter("codProgramaProdArray");
                        String arrayNombres=request.getParameter("nombreProgramaProd");
                        SimpleDateFormat format=new SimpleDateFormat("dd/MM/yyyy");
                        boolean reporteConFechas=request.getParameter("reporteconfechas").equals("1");
                        String fechaInicioPersonal=request.getParameter("fecha_inicio");
                        String fechaFinalPersonal=request.getParameter("fecha_final");
            %>
            <center>
                    <table align="center" width="70%" class='outputText0'>
                <tr>
                    <td width="10%">
                        <img src="../../img/cofar.png">
                    </td>
                    <td align="center" width="80%">
                        <table class="outputTextNormal">
                            <tr>
                                <td align="left"><b>Programa Producción:</b></td>
                                <td align="left"><%=arrayNombres%></td>
                            </tr>
                            <tr>
                                <td align="left"><b>Area Empresa:</b></td>
                                <td align="left"><%=arrayNombreAreaEmpresa%></td>
                            </tr>
                            
                            <%
                            if(reporteConFechas)
                            {
                                out.println("<tr>"+
                                "<td align='left' colspan='2'><b>Reporte con fechas de personal</b></td></tr>"+
                                "<tr><td align='left'><b>Fecha de Ingreso Personal:</b></td><td align='left'>"+fechaInicioPersonal+"</td></tr>"+
                                "<tr><td align='left'><b>Fecha de Salida Personal:</b></td><td align='left'>"+fechaFinalPersonal+"</td></tr>"+
                                "</tr>");
                            }
                            
                            %>
                            </table>
                            </tr>
                        </table>
                        </center>

            <br>
            <table width="70%" align="center" class="outputTextNormal" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >

                <tr class="">
                    <th  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center"><b>Lote</b></th>
                    <th  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Defecto</b></th>
                    <th  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Cantidad Defectos Encontrados</b></th>
                </tr>
                    <%
                      
                          String[] array=fechaInicioPersonal.split("/");
                        fechaInicioPersonal=array[2]+"/"+array[1]+"/"+array[0];
                        array=fechaFinalPersonal.split("/");
                        fechaFinalPersonal=array[2]+"/"+array[1]+"/"+array[0];

                        String consulta="select ppp.NOMBRE_PROGRAMA_PROD,depp.COD_LOTE_PRODUCCION,"+
                                        " cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,de.NOMBRE_DEFECTO_ENVASE,"+
                                        " sum(depp.CANTIDAD_DEFECTOS_ENCONTRADOS) as cantidadDefectos"+
                                        " from DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp inner join COMPONENTES_PROD cp ON"+
                                        " depp.COD_COMPPROD=cp.COD_COMPPROD inner join TIPOS_PROGRAMA_PRODUCCION tpp"+
                                        " on tpp.COD_TIPO_PROGRAMA_PROD=depp.COD_TIPO_PROGRAMA_PROD "+
                                        " inner join PROGRAMA_PRODUCCION_PERIODO ppp on depp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                                        " inner join DEFECTOS_ENVASE de on de.COD_DEFECTO_ENVASE=depp.COD_DEFECTO_ENVASE"+
                                        " where depp.COD_PROGRAMA_PROD in ("+arrayProgram+") and"+
                                        " depp.COD_LOTE_PRODUCCION +''+ CAST(depp.COD_COMPPROD  AS VARCHAR(20))+''+cast( depp.COD_TIPO_PROGRAMA_PROD as varchar(20))"+
                                        " IN("+arrayCodCompProd+")";
                                        if(reporteConFechas)
                                        {
                                            consulta+=" and depp.COD_PERSONAL in (select distinct sppp.COD_PERSONAL from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp"+
                                                      " where sppp.FECHA_INICIO BETWEEN '"+fechaInicioPersonal+" 00:00' and '"+fechaFinalPersonal+" 23:59'" +
                                                      " and sppp.FECHA_FINAL BETWEEN '"+fechaInicioPersonal+" 00:00' and '"+fechaFinalPersonal+" 23:59' and " +
                                                      " sppp.COD_PROGRAMA_PROD =depp.COD_PROGRAMA_PROD and"+
                                                      " sppp.COD_LOTE_PRODUCCION=depp.COD_LOTE_PRODUCCION and "+
                                                      " sppp.COD_COMPPROD =depp.COD_COMPPROD and "+
                                                      "  sppp.COD_TIPO_PROGRAMA_PROD =depp.COD_TIPO_PROGRAMA_PROD)";
                                        }
                                        consulta+=" group by  ppp.NOMBRE_PROGRAMA_PROD,depp.COD_LOTE_PRODUCCION,"+
                                        " cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,de.NOMBRE_DEFECTO_ENVASE,de.orden"+
                                        " order by ppp.NOMBRE_PROGRAMA_PROD,depp.COD_LOTE_PRODUCCION,"+
                                        "cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,de.orden";
                                System.out.println("consulta buscar defectos "+consulta);
                                con=Util.openConnection(con);
                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet res=st.executeQuery(consulta);
                                
                                String mostrar="";
                                //<th rowspan=
                                int cont=0;
                                String cabecera="";
                                String datoLote="";
                                double contDefectos=0d;
                                while(res.next())
                                {
                                    datoLote=res.getString("COD_LOTE_PRODUCCION")+"<br>"+res.getString("NOMBRE_PROGRAMA_PROD")+"<br>"+res.getString("nombre_prod_semiterminado")+"<br>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD");

                                    if(!cabecera.equals(datoLote))
                                    {   
                                        out.println(mostrar.equals("")?"":"<tr><th rowspan='"+cont+"'"+mostrar+"<tr><th class='outputText2' style='border : solid #D8D8D8 1px' colspan='2' align='right'><b>TOTAL   </b></th><th class='outputText2' style='border : solid #D8D8D8 1px' align='right'><b>"+formato.format(contDefectos)+"</b></th></tr>" );
                                        cont=0;
                                        contDefectos=0;
                                        mostrar="class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal;'>"+datoLote+"</th>"+
                                        "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal;'>"+res.getString("NOMBRE_DEFECTO_ENVASE")+"</th>"+
                                        "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal;' align='right'>"+formato.format(res.getDouble("cantidadDefectos"))+"</th></tr>";
                                        cont++;
                                        contDefectos+=res.getDouble("cantidadDefectos");
                                        cabecera=datoLote;
                                    }
                                    else
                                    {
                                        mostrar+="<tr><th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal;'>"+res.getString("NOMBRE_DEFECTO_ENVASE")+"</th>"+
                                      "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal;' align='right'>"+formato.format(res.getDouble("cantidadDefectos"))+"</th></tr>";
                                        cont++;
                                        contDefectos+=res.getDouble("cantidadDefectos");
                                    }
                                                                       
                                }
                                out.println("<tr><th rowspan='"+cont+"'"+mostrar +"<tr><th class='outputText2' style='border : solid #D8D8D8 1px' colspan='2' align='right'><b>TOTAL   </b></th><th class='outputText2' style='border : solid #D8D8D8 1px' align='right'><b>"+formato.format(contDefectos)+"</b></th></tr>");
                            %>
<th >
               </table>

              
            <br>

            <br>
            <div align="center">
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>