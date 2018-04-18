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
    <%! 
    Statement stDetalle=null;
        ResultSet resDetalle=null;
    String mostrarDetalle(String codLote,String codTipo,String codProgProd,String codCompProd,String codForm,String codPersonal,Connection con1)
    {
          NumberFormat n = NumberFormat.getNumberInstance(Locale.ENGLISH);
          DecimalFormat f = (DecimalFormat) n;
          f.applyPattern("####.##;(####.##)");
        String HTML="";
        try
        {
           String detalle="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombrePersonal"+
                                                " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp "+
                                                " inner join ACTIVIDADES_FORMULA_MAESTRA afm on sppp.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA"+
                                                " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD"+
                                                " and ap.COD_ACTIVIDAD in (29,40,157) inner join personal p on sppp.COD_PERSONAL=p.COD_PERSONAL"+
                                                " where sppp.COD_COMPPROD='"+codCompProd+"'"+
                                                " and sppp.COD_FORMULA_MAESTRA='"+codForm+"'"+
                                                " and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                                                " and sppp.COD_PROGRAMA_PROD='"+codProgProd+"'"+
                                                " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipo+"'" +
                                                " group by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA" +
                                                " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA";
           System.out.println("consulta detalle "+detalle);
           resDetalle=stDetalle.executeQuery(detalle);
           HTML+="<div><table width='70%' align='center' class='outputTextNormal' style='border : solid #D8D8D8 0px;' cellpadding='0' cellspacing='0' >";
           HTML+="<tr>";
           HTML+="<th class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='20%' align='center' ><b>Defectos</b></th>";
           Statement st1=con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet res1=null;
           String consulta="";
           List<String> rowsData=new ArrayList<String>();
           boolean primeraVez=true;
           int cont=0;
           while(resDetalle.next())
           {
                
                HTML+="<th class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' width='20%' align='center' ><b>"+resDetalle.getString("nombrePersonal")+"</b></th>";
                consulta="select de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE,ISNULL(depp.CANTIDAD_DEFECTOS_ENCONTRADOS,0) as CANTIDAD_DEFECTOS_ENCONTRADOS"+
                         " from DEFECTOS_ENVASE de left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp"+
                         " on de.COD_DEFECTO_ENVASE=depp.COD_DEFECTO_ENVASE "+
                         " and depp.COD_FORMULA_MAESTRA='"+codForm+"'"+
                        " and depp.COD_COMPPROD='"+codCompProd+"'"+
                        " and depp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                        " and depp.COD_PERSONAL='"+codPersonal+"'"+
                        " and depp.COD_PROGRAMA_PROD='"+codProgProd+"'"+
                        " and depp.COD_TIPO_PROGRAMA_PROD='"+codTipo+"'" +
                        " and depp.COD_PERSONAL_OPERARIO='"+resDetalle.getString("COD_PERSONAL")+"'"+
                        " and de.cod_estado_registro=1 order by de.ORDEN";
                System.out.println("consulta buscar defectos por personal "+consulta);
                res1=st1.executeQuery(consulta);
                cont=0;
                double suma=0d;
                while(res1.next())
                {
                    if(primeraVez)
                    {
                        rowsData.add("<tr><th  class='border' style='border : solid #D8D8D8 1px;font-weight:normal'  width='20%' align='center'>"+res1.getString("NOMBRE_DEFECTO_ENVASE")+"</th>" +
                                "<th  class='border' style='border : solid #D8D8D8 1px;font-weight:normal;'  width='20%' align='center'>"+f.format(res1.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS"))+"</th>");
                        suma+=res1.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS");
                    }
                    else
                    {
                        rowsData.set(cont,(rowsData.get(cont)+"<th  class='border' style='border : solid #D8D8D8 1px;font-weight:normal;'  width='20%' align='center'>"+f.format(res1.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS"))+"</th>"));
                        suma+=res1.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS");
                        cont++;
                    }
                }
                if(primeraVez)
                {
                    rowsData.add("<tr><th  class='border' style='border : solid #D8D8D8 1px;font-weight:normal'  width='20%' align='center'><b>TOTALES: </b></th>" +
                                "<th  class='border' style='border : solid #D8D8D8 1px;font-weight:normal;'  width='20%' align='center'>"+f.format(suma)+"</th>");
                }
                else
                {
                    rowsData.set(cont,(rowsData.get(cont)+"<th  class='border' style='border : solid #D8D8D8 1px;font-weight:normal;'  width='20%' align='center'>"+f.format(suma)+"</th>"));
                }
                res1.close();
                primeraVez=false;
           }
           st1.close();
           HTML+="</tr>";
           for(String var:rowsData)
           {
               HTML+=var+"<tr>";
           }
           HTML+="</table></div>";
           resDetalle.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }

        return HTML;
    }
    %>
    <body>
      
        <form>

            <h4 align="center" class="outputText5"><b>Reporte Detallado de Defectos</b></h4>

            <%
                        String codProgramaProdPeriodo=request.getParameter("codProgramaProduccionPeriodo")==null?"''":request.getParameter("codProgramaProduccionPeriodo");
                        String arrayCodCompProd =request.getParameter("codCompProdArray")==null?"''":request.getParameter("codCompProdArray");
                        String nombreProgramaProduccionPeriodo = request.getParameter("nombreProgramaProduccionPeriodo")==null?"''":request.getParameter("nombreProgramaProduccionPeriodo");
                        arrayCodCompProd = arrayCodCompProd + (arrayCodCompProd.length()==0?"' '":"");
                        String[] valores=arrayCodCompProd.split(",");
                        String arrayCodAreaEmpresa= request.getParameter("codAreaEmpresaP");
                        String arrayNombreAreaEmpresa= request.getParameter("nombreAreaEmpresaP");
                        String codAreaEmpresaAct=request.getParameter("codAreaEmpresaActividad");
                        String codEstadoProgramaProduccion=request.getParameter("codEstadoPrograma");
                        String arrayProgram=request.getParameter("codProgramaProdArray");

                        String fechaInicioPersonal=request.getParameter("fecha_inicio");
                        String fechaFinalPersonal=request.getParameter("fecha_final");
                        boolean reporteConFechas=request.getParameter("reporteconfechas").equals("1");
                        String arrayNombres=request.getParameter("nombreProgramaProd");
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
                    <th  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Personal</b></th>
                    <th  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Detalle</b></th>
                </tr>
                    <%
                      NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("####.##;(####.##)");
                        String[] array=fechaInicioPersonal.split("/");
                        fechaInicioPersonal=array[2]+"/"+array[1]+"/"+array[0];
                        array=fechaFinalPersonal.split("/");
                        fechaFinalPersonal=array[2]+"/"+array[1]+"/"+array[0];
                        SimpleDateFormat format=new SimpleDateFormat("dd/MM/yyyy");
                        

                        String consulta=" select depp.COD_COMPPROD,depp.COD_PERSONAL,depp.COD_FORMULA_MAESTRA,depp.COD_PROGRAMA_PROD,depp.COD_TIPO_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD,depp.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,"+
                                        " tpp.NOMBRE_TIPO_PROGRAMA_PROD,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombrePersonal"+
                                        " from DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp"+
                                        " inner join COMPONENTES_PROD cp ON depp.COD_COMPPROD = cp.COD_COMPPROD"+
                                        " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD ="+
                                        " depp.COD_TIPO_PROGRAMA_PROD"+
                                        " inner join PROGRAMA_PRODUCCION_PERIODO ppp on depp.COD_PROGRAMA_PROD ="+
                                        " ppp.COD_PROGRAMA_PROD"+
                                        " inner join PERSONAL p on depp.COD_PERSONAL=p.COD_PERSONAL"+
                                        " where depp.COD_PROGRAMA_PROD in ("+arrayProgram+") and"+
                                        " depp.COD_LOTE_PRODUCCION + '' + CAST (depp.COD_COMPPROD AS VARCHAR (20))"+
                                        " + '' + cast (depp.COD_TIPO_PROGRAMA_PROD as varchar (20)) IN ("+arrayCodCompProd+")";

                                        if(reporteConFechas)
                                        {
                                            consulta+=" and p.COD_PERSONAL IN(select spp.COD_PERSONAL from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp"+
                                                      " where spp.FECHA_INICIO BETWEEN '"+fechaInicioPersonal+" 00:00' and '"+fechaFinalPersonal+" 23:59'  and " +
                                                      " spp.FECHA_FINAL BETWEEN '"+fechaInicioPersonal+" 00:00' and '"+fechaFinalPersonal+" 23:59'  and " +
                                                      " spp.COD_PROGRAMA_PROD =depp.COD_PROGRAMA_PROD and"+
                                                      " spp.COD_LOTE_PRODUCCION=depp.COD_LOTE_PRODUCCION and "+
                                                      " spp.COD_COMPPROD =depp.COD_COMPPROD and "+
                                                      " spp.COD_TIPO_PROGRAMA_PROD =depp.COD_TIPO_PROGRAMA_PROD)";
                                        }
                                        consulta+=" group by depp.COD_COMPPROD,depp.COD_PERSONAL,depp.COD_FORMULA_MAESTRA,depp.COD_PROGRAMA_PROD,depp.COD_TIPO_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD,"+
                                        " depp.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,"+
                                        " p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA"+
                                        " order by ppp.NOMBRE_PROGRAMA_PROD,depp.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,"+
                                        " tpp.NOMBRE_TIPO_PROGRAMA_PROD,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA" ;
                                System.out.println("consulta buscar personal"+consulta);
                                con=Util.openConnection(con);
                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet res=st.executeQuery(consulta);
                                stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet resDetalle=null;
                                String mostrar="";
                                int cont=0;
                                String cabecera="";
                                String datoLote="";
                                String codCompProd="";
                                String codLote="";
                                String codTipoProg="";
                                String codForm="";
                                String codProgProd="";
                                while(res.next())
                                {
                                    codCompProd=res.getString("COD_COMPPROD");
                                    codLote=res.getString("COD_LOTE_PRODUCCION");
                                    codTipoProg=res.getString("COD_TIPO_PROGRAMA_PROD");
                                    codForm=res.getString("COD_FORMULA_MAESTRA");
                                    codProgProd=res.getString("COD_PROGRAMA_PROD");
                                    datoLote=res.getString("COD_LOTE_PRODUCCION")+"<br>"+res.getString("NOMBRE_PROGRAMA_PROD")+"<br>"+res.getString("nombre_prod_semiterminado")+"<br>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD");

                                    if(!cabecera.equals(datoLote))
                                    {   
                                        out.println(mostrar.equals("")?"":"<tr><th rowspan='"+cont+"'"+mostrar);
                                        cont=0;
                                        
                                        mostrar="class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal;'>"+datoLote+"</th>"+
                                        "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal;'>"+res.getString("nombrePersonal")+"</th>"+
                                        "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal;' align='center'>" ;
                                        mostrar+=this.mostrarDetalle(codLote, codTipoProg, codProgProd, codCompProd, codForm,res.getString("COD_PERSONAL"),con)+"</th></tr>";
                                        cabecera=datoLote;
                                        cont++;
                                                                               
                                    }
                                    else
                                    {
                                        mostrar+="<tr><th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal;'>"+res.getString("nombrePersonal")+"</th>"+
                                        "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal;' align='center'>";
                                        mostrar+=this.mostrarDetalle(codLote, codTipoProg, codProgProd, codCompProd, codForm,res.getString("COD_PERSONAL"),con)+"</th></tr>";
                                        cont++;
                                        
                                    }
                                                                       
                                }
                                out.println("<tr><th rowspan='"+cont+"'"+mostrar);
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