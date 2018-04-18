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



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            function redondeo2decimales(numero)
                {
                var original=parseFloat(numero);
                var result=Math.round(original*100)/100 ;
                return result;
                }
        </script>
        <style>
            #tablaDetalle
            {
                border-top:1px solid black;
                border-left:1px solid black;
            }
            #tablaDetalle tr td
            {
                border-right:1px solid black;
                border-bottom:1px solid black;
                padding:0.5em;
            }
            #tablaDetalle  thead tr td
            {
                font-weight:bold;
            }
        </style>
    </head>
    <body>
        <form>
            <%
            int codCompProd=Integer.valueOf(request.getParameter("codComprod"));
                        String codProgramaProd=request.getParameter("codProg");
                        String nombreProgramaProd=request.getParameter("nombreProg");
                        String codLoteBuscar=request.getParameter("codLote");
            %>
            <table align="center" width="70%" class='outputText0'>
                <thead>
                <tr>
                    <td width="10%">
                        <img src="../../img/cofar.png">
                    </td>
                    <td  align="left"><b>Programa Producción:</b></td>
                                <td align="left"><%=(nombreProgramaProd)%></td>
                        
                </tr>
                </thead>
            </table>
            <center>
                <table cellpadding="0" cellspacing="0" id="tablaDetalle" >
                    <thead>
                        <tr>
                            <td>Producto</td>
                            <td>Lote</td>
                            <td>Fecha CC.</td>
                            <td>Fecha Acond.</td>
                            <td>Fecha Apt.</td>
                        </tr>
                    </thead>
                    <tbody>
    <%
                        try {
                            Connection con=null;
                            con=Util.openConnection(con);

                            String consulta="select ppp.NOMBRE_PROGRAMA_PROD,PP.COD_LOTE_PRODUCCION,PP.COD_COMPPROD,CPV.COD_FORMA,CPV.VIDA_UTIL,PP.COD_PROGRAMA_PROD,CPV.nombre_prod_semiterminado,CPV.COD_AREA_EMPRESA,"+
                                            " (select top 1 id.FECHA_VEN from INGRESOS_ACOND ia inner join INGRESOS_DETALLEACOND id on ia.COD_INGRESO_ACOND=id.COD_INGRESO_ACOND"+
                                            " where id.COD_LOTE_PRODUCCION=PP.COD_LOTE_PRODUCCION and id.COD_COMPPROD=PP.COD_COMPPROD order by id.FECHA_VEN desc"+
                                            " ) as fechaAcond,(select top 1 idv.FECHA_VENC from INGRESOS_VENTAS iv inner join INGRESOS_DETALLEVENTAS idv on iv.COD_INGRESOVENTAS=idv.COD_INGRESOVENTAS and iv.COD_AREA_EMPRESA=idv.COD_AREA_EMPRESA" +
                                            " inner join SALIDAS_ACOND sa1 on sa1.COD_SALIDA_ACOND=iv.COD_SALIDA_ACOND"+
                                            " inner join SALIDAS_DETALLEACOND sd1 on sa1.COD_SALIDA_ACOND=sd1.COD_SALIDA_ACOND"+
                                            " and idv.COD_LOTE_PRODUCCION=sd1.COD_LOTE_PRODUCCION collate traditional_spanish_CI_AI"+
                                            " where idv.COD_LOTE_PRODUCCION collate traditional_spanish_CI_AI =PP.COD_LOTE_PRODUCCION and sd1.COD_COMPPROD=PP.COD_COMPPROD and iv.COD_ALMACEN_VENTA<>32 order by idv.FECHA_VENC desc) as fechaAPT"+
                                            " from  PROGRAMA_PRODUCCION pp inner join PROGRAMA_PRODUCCION_PERIODO ppp"+
                                            " on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                                            " inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=pp.COD_COMPPROD"+
                                            " and cpv.COD_VERSION=pp.COD_COMPPROD_VERSION  "+
                                            " where ppp.COD_TIPO_PRODUCCION=1 and ppp.COD_ESTADO_PROGRAMA<>4"+
                                            (codProgramaProd.equals("")?"":" and pp.COD_PROGRAMA_PROD in ("+codProgramaProd+")")+
                                            (codLoteBuscar.equals("")?"":" and PP.cod_lote_PRODUCCION='"+codLoteBuscar+"'")+
                                            ( codCompProd>0?" and PP.COD_COMPPROD='"+codCompProd+"'":"")+
                                            " order by pp.COD_PROGRAMA_PROD,cpv.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION";
                                            System.out.println("consulta reporte "+consulta);
                               Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                               ResultSet res=st.executeQuery(consulta);
                               Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                               ResultSet resDetalle=null;
                               SimpleDateFormat sdf=new SimpleDateFormat("MM/yyyy");
                               String fechaVencimiento="";
                               String fechaAcond="";
                               String fechaApt="";
                               while(res.next())
                               {
                                   int vidaUtil=res.getInt("VIDA_UTIL");
                                   String codLote=res.getString("COD_LOTE_PRODUCCION");
                                   int codAreaEmpresa=res.getInt("COD_AREA_EMPRESA");
                                   fechaAcond=(res.getTimestamp("fechaAcond")!=null?sdf.format(res.getTimestamp("fechaAcond")):"Sin fecha");
                                   fechaApt=(res.getTimestamp("fechaAPT")!=null?sdf.format(res.getTimestamp("fechaAPT")):"Sin fecha");
                                   StringBuilder consulta1=new StringBuilder(" exec PAA_LISTAR_FECHA_VENCIMIENTO_LOTE")
                                                    .append("'").append(codLote).append("',")
                                                    .append(res.getInt("COD_PROGRAMA_PROD")).append(",")
                                                    .append(res.getInt("COD_COMPPROD")).append(",")
                                                    .append(res.getInt("COD_FORMA")).append(",")
                                                    .append("?,")//mensaje
                                                    .append("?,")//fecha vencimiento
                                                    .append("?");//fecha pesaje
                                    System.out.println("consulta obtener vida util producto "+consulta1.toString());
                                    CallableStatement callFechaVencimiento=con.prepareCall(consulta1.toString());
                                    callFechaVencimiento.registerOutParameter(1,java.sql.Types.VARCHAR);
                                    callFechaVencimiento.registerOutParameter(2,java.sql.Types.TIMESTAMP);
                                    callFechaVencimiento.registerOutParameter(3,java.sql.Types.TIMESTAMP);
                                    callFechaVencimiento.execute();
                                    SimpleDateFormat sdfMMYY=new SimpleDateFormat("MM/yyyy");
                                    fechaVencimiento=callFechaVencimiento.getString(1).length()>0?callFechaVencimiento.getString(1):sdfMMYY.format(callFechaVencimiento.getTimestamp(2));
                                    
                                   
                                      
                                   

                                   out.println("<tr>"+
                                           " <td>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td>" +
                                            " <td>"+res.getString("nombre_prod_semiterminado")+"</td>" +
                                              "<td>"+codLote+"</td><td>"+fechaVencimiento+"</td>" +
                                              "<td  "+(fechaVencimiento.equals(fechaAcond)?"":" bgcolor='red'")+" >"+fechaAcond+"</td>" +
                                              "<td "+(fechaVencimiento.equals(fechaApt)?"":" bgcolor='red'")+" >"+fechaApt+"</td></tr>");
                               }
                               res.close();
                               st.close();
                               con.close();
                        }
                        catch(SQLException ex)
                        {
                            ex.printStackTrace();
                        }

                        %>
                        </tbody>
                 </table>
             </center>
        </form>
    </body>
</html>
